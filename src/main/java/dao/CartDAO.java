package dao;

import java.sql.*;

import model.Cart;
import util.DBConnection;

public class CartDAO {
    private final Connection connection;

    public CartDAO(Connection connection) {
        this.connection = connection;
    }
    

    public CartDAO() throws SQLException {
    	this.connection = DBConnection.getConnection();
	}


    public void create(Cart cart) throws SQLException {
        String sql = "INSERT INTO carts (user_id) VALUES (?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, cart.getUserId());
            stmt.executeUpdate();
        }
    }

    public Cart findByUserId(int userId) throws SQLException {
        String sql = "SELECT * FROM carts WHERE user_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                // Gestione sicura dei timestamp
                java.sql.Timestamp createdAt = null;
                java.sql.Timestamp modifiedAt = null;
                
                try {
                    createdAt = rs.getTimestamp("created_at");
                } catch (SQLException e) {
                    System.out.println("Warning: created_at timestamp non valido, impostato a null");
                }
                
                try {
                    modifiedAt = rs.getTimestamp("modified_at");
                } catch (SQLException e) {
                    System.out.println("Warning: modified_at timestamp non valido, impostato a null");
                }
                
                return new Cart(
                    rs.getInt("id"),
                    rs.getInt("user_id"),
                    createdAt,
                    modifiedAt
                );
            }
        }
        return null;
    }

    public void clear(int cartId) throws SQLException {
        String sql = "DELETE FROM cart_items WHERE cart_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, cartId);
            stmt.executeUpdate();
        }
    }

    public void createIfNotExists(int userId) throws SQLException {
        String sql = "INSERT INTO carts (user_id) SELECT ? WHERE NOT EXISTS (SELECT 1 FROM carts WHERE user_id = ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, userId);
            stmt.executeUpdate();
        }
    }

    public void delete(int cartId) throws SQLException {
        String sql = "DELETE FROM carts WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, cartId);
            stmt.executeUpdate();
        }
    }

}
