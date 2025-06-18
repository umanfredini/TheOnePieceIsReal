package model;

import java.sql.*;

public class CartDAO {
    private final Connection connection;

    public CartDAO(Connection connection) {
        this.connection = connection;
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
                return new Cart(
                    rs.getInt("id"),
                    rs.getInt("user_id"),
                    rs.getTimestamp("created_at"),
                    rs.getTimestamp("modified_at")
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
}
