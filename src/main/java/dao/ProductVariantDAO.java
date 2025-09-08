package dao;

import java.sql.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import model.ProductVariant;
import util.DBConnection;

public class ProductVariantDAO {
    private final Connection connection;

    public ProductVariantDAO(Connection connection) {
        this.connection = connection;
    }
    
    public ProductVariantDAO() {
    	try {
    		this.connection = DBConnection.getConnection();
    	} catch (SQLException e) {
    		throw new RuntimeException("Errore nella connessione al database", e);
    	}
    }

    public void create(ProductVariant variant) throws SQLException {
        String sql = "INSERT INTO product_variants (product_id, variant_name, variant_type, stock_quantity, price_modifier) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, variant.getProductId());
            stmt.setString(2, variant.getVariantName());
            stmt.setString(3, variant.getVariantType());
            stmt.setInt(4, variant.getStockQuantity());
            stmt.setBigDecimal(5, variant.getPriceModifier());
            stmt.executeUpdate();
        }
    }

    public ProductVariant read(int id) throws SQLException {
        String sql = "SELECT * FROM product_variants WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return extractVariant(rs);
            }
        }
        return null;
    }

    public void update(ProductVariant variant) throws SQLException {
        String sql = "UPDATE product_variants SET product_id = ?, variant_name = ?, variant_type = ?, stock_quantity = ?, price_modifier = ? WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, variant.getProductId());
            stmt.setString(2, variant.getVariantName());
            stmt.setString(3, variant.getVariantType());
            stmt.setInt(4, variant.getStockQuantity());
            stmt.setBigDecimal(5, variant.getPriceModifier());
            stmt.setInt(6, variant.getId());
            stmt.executeUpdate();
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM product_variants WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    public List<ProductVariant> findAllByProductId(int productId) throws SQLException {
        List<ProductVariant> variants = new ArrayList<>();
        String sql = "SELECT * FROM product_variants WHERE product_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                variants.add(extractVariant(rs));
            }
        }
        return variants;
    }

    public ProductVariant findByIdAndProductId(int id, int productId) throws SQLException {
        String sql = "SELECT * FROM product_variants WHERE id = ? AND product_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.setInt(2, productId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return extractVariant(rs);
            }
        }
        return null;
    }
    
    private ProductVariant extractVariant(ResultSet rs) throws SQLException{
        BigDecimal priceModifier = rs.getBigDecimal("price_modifier");
        if (priceModifier == null) {
            priceModifier = BigDecimal.ZERO;
        }
        
        String variantType = rs.getString("variant_type");
        if (variantType == null) {
            variantType = "size"; // Default per compatibilità
        }
        
        return new ProductVariant(
                rs.getInt("id"),
                rs.getInt("product_id"),
                rs.getString("variant_name"),
                variantType,
                rs.getInt("stock_quantity"),
                priceModifier
                );
    }
}