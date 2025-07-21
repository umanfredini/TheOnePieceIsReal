package dao;

import model.GuestCartItem;
import model.Product;
import model.ProductVariant;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class GuestCartItemDAO {
    private final Connection connection;

    public GuestCartItemDAO(Connection connection) {
        this.connection = connection;
    }
    
    public GuestCartItemDAO() throws SQLException {
        this.connection = DBConnection.getConnection();
    }

    public void add(int guestCartId, int productId, Integer productVariantId, int quantity) throws SQLException {
        // Controlla se l'item esiste già
        GuestCartItem existingItem = findByCartAndProduct(guestCartId, productId, productVariantId);
        
        if (existingItem != null) {
            // Aggiorna la quantità
            updateQuantity(existingItem.getId(), existingItem.getQuantity() + quantity);
        } else {
            // Inserisce nuovo item
            String sql = "INSERT INTO guest_cart_items (guest_cart_id, product_id, product_variant_id, quantity) VALUES (?, ?, ?, ?)";
            try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                stmt.setInt(1, guestCartId);
                stmt.setInt(2, productId);
                if (productVariantId != null) {
                    stmt.setInt(3, productVariantId);
                } else {
                    stmt.setNull(3, Types.INTEGER);
                }
                stmt.setInt(4, quantity);
                stmt.executeUpdate();
            }
        }
    }

    public void updateQuantity(int itemId, int quantity) throws SQLException {
        if (quantity <= 0) {
            delete(itemId);
        } else {
            String sql = "UPDATE guest_cart_items SET quantity = ? WHERE id = ?";
            try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                stmt.setInt(1, quantity);
                stmt.setInt(2, itemId);
                stmt.executeUpdate();
            }
        }
    }

    public void delete(int itemId) throws SQLException {
        String sql = "DELETE FROM guest_cart_items WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, itemId);
            stmt.executeUpdate();
        }
    }

    public void deleteByCartId(int guestCartId) throws SQLException {
        String sql = "DELETE FROM guest_cart_items WHERE guest_cart_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, guestCartId);
            stmt.executeUpdate();
        }
    }

    public GuestCartItem findByCartAndProduct(int guestCartId, int productId, Integer productVariantId) throws SQLException {
        String sql = "SELECT * FROM guest_cart_items WHERE guest_cart_id = ? AND product_id = ? AND product_variant_id ";
        if (productVariantId != null) {
            sql += "= ?";
        } else {
            sql += "IS NULL";
        }
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, guestCartId);
            stmt.setInt(2, productId);
            if (productVariantId != null) {
                stmt.setInt(3, productVariantId);
            }
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return extractGuestCartItem(rs);
            }
        }
        return null;
    }

    public List<GuestCartItem> findByCartId(int guestCartId) throws SQLException {
        List<GuestCartItem> items = new ArrayList<>();
        String sql = "SELECT gci.id as gci_id, gci.guest_cart_id, gci.product_id, gci.product_variant_id, " +
                     "gci.quantity, gci.created_at as gci_created_at, gci.updated_at as gci_updated_at, " +
                     "p.id as p_id, p.name, p.description, p.price, p.image_url, p.category, " +
                     "p.stock_quantity, p.active, p.is_featured, p.created_at as p_created_at, " +
                     "p.updated_at as p_updated_at, p.deleted_at, " +
                     "pv.id as pv_id, pv.product_id as pv_product_id, pv.variant_name, pv.variant_value, " +
                     "pv.price_modifier, pv.stock_quantity as pv_stock_quantity, pv.active as pv_active, " +
                     "pv.created_at as pv_created_at, pv.updated_at as pv_updated_at " +
                     "FROM guest_cart_items gci " +
                     "JOIN products p ON gci.product_id = p.id " +
                     "LEFT JOIN product_variants pv ON gci.product_variant_id = pv.id " +
                     "WHERE gci.guest_cart_id = ? AND p.deleted_at IS NULL " +
                     "ORDER BY gci.created_at DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, guestCartId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                GuestCartItem item = extractGuestCartItemWithAliases(rs);
                item.setProduct(extractProductWithAliases(rs));
                if (rs.getObject("product_variant_id") != null) {
                    item.setProductVariant(extractProductVariant(rs));
                }
                items.add(item);
            }
        }
        return items;
    }

    public int getCartItemCount(int guestCartId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM guest_cart_items WHERE guest_cart_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, guestCartId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    private GuestCartItem extractGuestCartItem(ResultSet rs) throws SQLException {
        // Gestione sicura dei timestamp
        java.sql.Timestamp createdAt = null;
        java.sql.Timestamp updatedAt = null;
        
        try {
            createdAt = rs.getTimestamp("created_at");
        } catch (SQLException e) {
            System.out.println("Warning: created_at timestamp non valido, impostato a null");
        }
        
        try {
            updatedAt = rs.getTimestamp("updated_at");
        } catch (SQLException e) {
            System.out.println("Warning: updated_at timestamp non valido, impostato a null");
        }
        
        return new GuestCartItem(
            rs.getInt("id"),
            rs.getInt("guest_cart_id"),
            rs.getInt("product_id"),
            rs.getObject("product_variant_id") != null ? rs.getInt("product_variant_id") : null,
            rs.getInt("quantity"),
            createdAt,
            updatedAt
        );
    }

    private Product extractProduct(ResultSet rs) throws SQLException {
        // Gestione sicura dei timestamp
        java.sql.Timestamp createdAt = null;
        java.sql.Timestamp updatedAt = null;
        java.sql.Timestamp deletedAt = null;
        
        try {
            createdAt = rs.getTimestamp("created_at");
        } catch (SQLException e) {
            System.out.println("Warning: created_at timestamp non valido, impostato a null");
        }
        
        try {
            updatedAt = rs.getTimestamp("updated_at");
        } catch (SQLException e) {
            System.out.println("Warning: updated_at timestamp non valido, impostato a null");
        }
        
        try {
            deletedAt = rs.getTimestamp("deleted_at");
        } catch (SQLException e) {
            System.out.println("Warning: deleted_at timestamp non valido, impostato a null");
        }
        
        return new Product(
            rs.getInt("product_id"),
            rs.getString("name"),
            rs.getString("description"),
            rs.getBigDecimal("price"),
            rs.getString("image_url"),
            rs.getString("category"),
            rs.getInt("stock_quantity"),
            rs.getBoolean("active"),
            rs.getString("is_featured"),
            createdAt,
            updatedAt,
            deletedAt
        );
    }

    private ProductVariant extractProductVariant(ResultSet rs) throws SQLException {
        return new ProductVariant(
        	    rs.getInt("product_variant_id"),
        	    rs.getInt("product_id"),
        	    rs.getString("variant_name"),
        	    rs.getInt("stock_quantity")
        	);
    }
    
    private GuestCartItem extractGuestCartItemWithAliases(ResultSet rs) throws SQLException {
        // Gestione sicura dei timestamp
        java.sql.Timestamp gciCreatedAt = null;
        java.sql.Timestamp gciUpdatedAt = null;
        
        try {
            gciCreatedAt = rs.getTimestamp("gci_created_at");
        } catch (SQLException e) {
            System.out.println("Warning: gci_created_at timestamp non valido, impostato a null");
        }
        
        try {
            gciUpdatedAt = rs.getTimestamp("gci_updated_at");
        } catch (SQLException e) {
            System.out.println("Warning: gci_updated_at timestamp non valido, impostato a null");
        }
        
        return new GuestCartItem(
            rs.getInt("gci_id"),
            rs.getInt("guest_cart_id"),
            rs.getInt("product_id"),
            rs.getObject("product_variant_id") != null ? rs.getInt("product_variant_id") : null,
            rs.getInt("quantity"),
            gciCreatedAt,
            gciUpdatedAt
        );
    }

    private Product extractProductWithAliases(ResultSet rs) throws SQLException {
        // Gestione sicura dei timestamp
        java.sql.Timestamp pCreatedAt = null;
        java.sql.Timestamp pUpdatedAt = null;
        java.sql.Timestamp deletedAt = null;
        
        try {
            pCreatedAt = rs.getTimestamp("p_created_at");
        } catch (SQLException e) {
            System.out.println("Warning: p_created_at timestamp non valido, impostato a null");
        }
        
        try {
            pUpdatedAt = rs.getTimestamp("p_updated_at");
        } catch (SQLException e) {
            System.out.println("Warning: p_updated_at timestamp non valido, impostato a null");
        }
        
        try {
            deletedAt = rs.getTimestamp("deleted_at");
        } catch (SQLException e) {
            System.out.println("Warning: deleted_at timestamp non valido, impostato a null");
        }
        
        return new Product(
            rs.getInt("p_id"),
            rs.getString("name"),
            rs.getString("description"),
            rs.getBigDecimal("price"),
            rs.getString("image_url"),
            rs.getString("category"),
            rs.getInt("stock_quantity"),
            rs.getBoolean("active"),
            rs.getString("is_featured"),
            pCreatedAt,
            pUpdatedAt,
            deletedAt
        );
    }
} 