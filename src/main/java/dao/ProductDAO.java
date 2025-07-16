package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import model.Product;
import util.DBConnection;

public class ProductDAO {
    private final Connection connection;

    public ProductDAO(Connection connection) {
        this.connection = connection;
    }
    
    public ProductDAO() throws SQLException {
    	this.connection = DBConnection.getConnection();
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

    public Product findByProductId(int id) throws SQLException {
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
            rs.getBoolean("is_active"),
            rs.getBoolean("is_featured"),
            rs.getTimestamp("created_at"),
            rs.getTimestamp("updated_at"),
            rs.getString("image_url")
        );
    }
    
    public int countAll() throws SQLException {
        String sql = "SELECT COUNT(*) FROM products";
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public List<Map<String, Object>> getTopSellingProducts(int limit) throws SQLException {
        List<Map<String, Object>> result = new ArrayList<>();
        String sql = "SELECT p.id, p.name, SUM(oi.quantity) AS total_sold " +
                     "FROM products p " +
                     "JOIN order_items oi ON p.id = oi.product_id " +
                     "GROUP BY p.id, p.name " +
                     "ORDER BY total_sold DESC " +
                     "LIMIT ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("id", rs.getInt("id"));
                row.put("name", rs.getString("name"));
                row.put("total_sold", rs.getInt("total_sold"));
                result.add(row);
            }
        }
        return result;
    }

    public List<Product> findBySearch(String query) throws SQLException {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE " +
                     "(name LIKE ? OR description LIKE ? OR category LIKE ? OR personaggi LIKE ?) " +
                     "AND active = TRUE";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            String wildcardQuery = "%" + query + "%";
            for (int i = 1; i <= 4; i++) {
                stmt.setString(i, wildcardQuery);
            }

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Product product = extractProduct(rs);
                products.add(product);
            }
        }

        return products;
    }

    public List<Product> findByPersonaggio(String personaggio) throws SQLException {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE personaggi LIKE ? AND active = TRUE";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, "%" + personaggio + "%");
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                products.add(extractProduct(rs));
            }
        }

        return products;
    }

    public List<Product> findByCategoria(String categoria) throws SQLException {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE category LIKE ? AND active = TRUE";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, "%" + categoria + "%");
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                products.add(extractProduct(rs));
            }
        }

        return products;
    }

}
