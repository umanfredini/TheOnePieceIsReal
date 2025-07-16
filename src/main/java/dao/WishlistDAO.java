package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import model.Product;
import util.DBConnection;

public class WishlistDAO {
    private final Connection connection;

    public WishlistDAO(Connection connection) {
        this.connection = connection;
    }
    
    public WishlistDAO() throws SQLException {
    	this.connection = DBConnection.getConnection();
    }

    public void add(int userId, int productId) throws SQLException {
        String sql = "INSERT INTO wishlist (user_id, product_id) VALUES (?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, productId);
            stmt.executeUpdate();
        }
    }

    public List<Product> findProductsByUserId(int userId) throws SQLException {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.* FROM wishlist w JOIN products p ON w.product_id = p.id WHERE w.user_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setName(rs.getString("name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getBigDecimal("price"));
                product.setImageUrl(rs.getString("image_url"));
                product.setCategory(rs.getString("category"));
                product.setPersonaggi(rs.getString("personaggi"));
                product.setStockQuantity(rs.getInt("stock_quantity"));
                product.setActive(rs.getBoolean("active"));
                product.setFeatured(rs.getBoolean("featured"));
                product.setCreatedAt(rs.getTimestamp("created_at"));
                product.setUpdatedAt(rs.getTimestamp("updated_at"));

                products.add(product);
            }
        }

        return products;
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
