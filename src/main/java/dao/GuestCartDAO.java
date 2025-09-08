package dao;

import model.GuestCart;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class GuestCartDAO {
    private final Connection connection;
    private static final Logger logger = Logger.getLogger(GuestCartDAO.class.getName());

    public GuestCartDAO(Connection connection) {
        this.connection = connection;
    }
    
    public GuestCartDAO() {
        try {
            this.connection = DBConnection.getConnection();
        } catch (SQLException e) {
            throw new RuntimeException("Errore nella connessione al database", e);
        }
    }

    public GuestCart create(String sessionId) throws SQLException {
        String sql = "INSERT INTO guest_carts (session_id) VALUES (?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, sessionId);
            stmt.executeUpdate();
            
            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                int id = rs.getInt(1);
                return findBySessionId(sessionId);
            }
        }
        return null;
    }

    public GuestCart findBySessionId(String sessionId) throws SQLException {
        String sql = "SELECT * FROM guest_carts WHERE session_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, sessionId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return extractGuestCart(rs);
            }
        }
        return null;
    }

    public GuestCart findOrCreate(String sessionId) throws SQLException {
        GuestCart cart = findBySessionId(sessionId);
        if (cart == null) {
            cart = create(sessionId);
        }
        return cart;
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM guest_carts WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    public void deleteBySessionId(String sessionId) throws SQLException {
        String sql = "DELETE FROM guest_carts WHERE session_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, sessionId);
            stmt.executeUpdate();
        }
    }

    public List<GuestCart> findAll() throws SQLException {
        List<GuestCart> carts = new ArrayList<>();
        String sql = "SELECT * FROM guest_carts ORDER BY created_at DESC";
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                carts.add(extractGuestCart(rs));
            }
        }
        return carts;
    }

    public void cleanupOldCarts(int daysOld) throws SQLException {
        String sql = "DELETE FROM guest_carts WHERE created_at < DATE_SUB(NOW(), INTERVAL ? DAY)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, daysOld);
            stmt.executeUpdate();
        }
    }

    private GuestCart extractGuestCart(ResultSet rs) throws SQLException {
        // Gestione sicura dei timestamp
        java.sql.Timestamp createdAt = null;
        java.sql.Timestamp updatedAt = null;
        
        try {
            createdAt = rs.getTimestamp("created_at");
        } catch (SQLException e) {
            logger.warning("Warning: created_at timestamp non valido, impostato a null");
        }
        
        try {
            updatedAt = rs.getTimestamp("updated_at");
        } catch (SQLException e) {
            logger.warning("Warning: updated_at timestamp non valido, impostato a null");
        }
        
        return new GuestCart(
            rs.getInt("id"),
            rs.getString("session_id"),
            createdAt,
            updatedAt
        );
    }
} 