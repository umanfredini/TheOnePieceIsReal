package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {
    private final Connection connection;

    public ProductDAO(Connection connection) {
        this.connection = connection;
    }

    public void create(Product product) throws SQLException {
        String sql = "INSERT INTO products (name, description, price, image_url, category, personaggi, stock_quantity, active, featured) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, product.getName());
            stmt.setString(2, product.getDescription());
            stmt.setBigDecimal(3, product.getPrice());
            stmt.setString(4, product.getImageUrl());
            stmt.setString(5, product.getCategory());
            stmt.setString(6, product.getPersonaggi());
            stmt.setInt(7, product.getStockQuantity());
            stmt.setBoolean(8, product.isActive());
            stmt.setBoolean(9, product.isFeatured());
            stmt.executeUpdate();
        }
    }

    public Product read(int id) throws SQLException {
        String sql = "SELECT * FROM products WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return extractProduct(rs);
            }
        }
        return null;
    }

    public void update(Product product) throws SQLException {
        String sql = "UPDATE products SET name = ?, description = ?, price = ?, image_url = ?, category = ?, personaggi = ?, stock_quantity = ?, active = ?, featured = ? WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, product.getName());
            stmt.setString(2, product.getDescription());
            stmt.setBigDecimal(3, product.getPrice());
            stmt.setString(4, product.getImageUrl());
            stmt.setString(5, product.getCategory());
            stmt.setString(6, product.getPersonaggi());
            stmt.setInt(7, product.getStockQuantity());
            stmt.setBoolean(8, product.isActive());
            stmt.setBoolean(9, product.isFeatured());
            stmt.setInt(10, product.getId());
            stmt.executeUpdate();
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "UPDATE products SET active = FALSE WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    public List<Product> findAll() throws SQLException {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products";
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                products.add(extractProduct(rs));
            }
        }
        return products;
    }

    private Product extractProduct(ResultSet rs) throws SQLException {
        return new Product(
            rs.getInt("id"),
            rs.getString("name"),
            rs.getString("description"),
            rs.getBigDecimal("price"),
            rs.getString("image_url"),
            rs.getString("category"),
            rs.getString("personaggi"),
            rs.getInt("stock_quantity"),
            rs.getBoolean("active"),
            rs.getBoolean("featured"),
            rs.getTimestamp("created_at"),
            rs.getTimestamp("updated_at")
        );
    }
}
