package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class WishlistDAO {
    private final Connection connection;

    public WishlistDAO(Connection connection) {
        this.connection = connection;
    }

    public void add(int userId, int productId) throws SQLException {
        String sql = "INSERT INTO wishlist (user_id, product_id) VALUES (?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, productId);
            stmt.executeUpdate();
        }
    }

    public List<Integer> findProductIdsByUserId(int userId) throws SQLException {
        List<Integer> productIds = new ArrayList<>();
        String sql = "SELECT product_id FROM wishlist WHERE user_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                productIds.add(rs.getInt("product_id"));
            }
        }
        return productIds;
    }

    public void remove(int userId, int productId) throws SQLException {
        String sql = "DELETE FROM wishlist WHERE user_id = ? AND product_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, productId);
            stmt.executeUpdate();
        }
    }

    public void clearByUserId(int userId) throws SQLException {
        String sql = "DELETE FROM wishlist WHERE user_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.executeUpdate();
        }
    }

    public boolean exists(int userId, int productId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM wishlist WHERE user_id = ? AND product_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, productId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

}
