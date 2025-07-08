package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import model.User;

public class UserDAO {
    private final Connection connection;

    public UserDAO(Connection connection) {
        this.connection = connection;
    }
    
    public UserDAO() {
        this.connection = null;
    }

    public boolean create(User user) throws SQLException {
        String sql = "INSERT INTO users (email, password_hash, username, role, is_active, shipping_address) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, user.getEmail());
            stmt.setString(2, user.getPasswordHash());
            stmt.setString(3, user.getUsername());
            stmt.setBoolean(4, user.isAdmin());
            stmt.setBoolean(5, user.isActive());
            stmt.setString(6, user.getShippingAddress());
            int rowsInserted = stmt.executeUpdate();
            return rowsInserted > 0;
        }
    }


    public User read(int id) throws SQLException {
        String sql = "SELECT * FROM users WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return extractUser(rs);
            }
        }
        return null;
    }

    public User findByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return extractUser(rs);
            }
        }
        return null;
    }

    public boolean update(User user) throws SQLException {
        String sql = "UPDATE users SET email = ?, password_hash = ?, username = ?, role = ?, is_active = ?, shipping_address = ? WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, user.getEmail());
            stmt.setString(2, user.getPasswordHash());
            stmt.setString(3, user.getUsername());
            stmt.setBoolean(4, user.isAdmin());
            stmt.setBoolean(5, user.isActive());
            stmt.setString(6, user.getShippingAddress());
            stmt.setInt(7, user.getId());
            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "UPDATE products SET active = FALSE WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    public List<User> findAll() throws SQLException {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users";
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                users.add(extractUser(rs));
            }
        }
        return users;
    }

    private User extractUser(ResultSet rs) throws SQLException {
        return new User(
            rs.getInt("id"),
            rs.getString("email"),
            rs.getString("password_hash"),
            rs.getString("username"),
            rs.getBoolean("is_admin"),
            rs.getBoolean("is_active"),
            rs.getString("shipping_address"),
            rs.getTimestamp("created_at"),
            rs.getTimestamp("last_login"),
            rs.getString("avatar")
        );
    }

    public void updateLastLogin(int id) throws SQLException {
        String sql = "UPDATE users SET last_login = CURRENT_TIMESTAMP WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    public User findByUserId(int id) throws SQLException {
        String sql = "SELECT * FROM users WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return extractUser(rs); // Assicurati che esista questo metodo
            }
        }
        return null;
    }

    public void toggleUserStatus(int id) throws SQLException {
        String sql = "UPDATE users SET active = NOT active WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }
    
    public int countAll() throws SQLException {
        String sql = "SELECT COUNT(*) FROM users";
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public User findByEmailPassword(String email, String hashedPassword) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, email);
            stmt.setString(2, hashedPassword);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractUser(rs);
                }
            }
        }
        return null;
    }

    public boolean emailExists(String email) throws SQLException {
        String sql = "SELECT 1 FROM users WHERE email = ? LIMIT 1";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next(); // true se esiste almeno una riga
            }
        }
    }

}
