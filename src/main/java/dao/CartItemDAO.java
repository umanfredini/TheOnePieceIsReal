package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import model.CartItem;
import model.Product;
import util.DBConnection;

public class CartItemDAO {
    private final Connection connection;

    public CartItemDAO(Connection connection) {
        this.connection = connection;
    }
    

    public CartItemDAO() throws SQLException {
    	this.connection = DBConnection.getConnection();
    }


    public void add(CartItem item) throws SQLException {
        String sql = "INSERT INTO cart_items (cart_id, product_id, variant_id, quantity) VALUES (?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, item.getCartId());
            stmt.setInt(2, item.getProductId());
            if (item.getVariantId() != null) {
                stmt.setInt(3, item.getVariantId());
            } else {
                stmt.setNull(3, Types.INTEGER);
            }
            stmt.setInt(4, item.getQuantity());
            stmt.executeUpdate();
        }
    }


    public List<CartItem> findByCartId(int cartId) throws SQLException {
        List<CartItem> items = new ArrayList<>();
        String sql = "SELECT * FROM cart_items WHERE cart_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, cartId);
            ResultSet rs = stmt.executeQuery();
            ProductDAO productDAO = new ProductDAO(connection);
            while (rs.next()) {
                int productId = rs.getInt("product_id");
                Product product = productDAO.findByProductId(productId);
                CartItem item = new CartItem(
                    rs.getInt("id"),
                    rs.getInt("cart_id"),
                    productId,
                    rs.getObject("variant_id") != null ? rs.getInt("variant_id") : null,
                    rs.getInt("quantity"),
                    rs.getTimestamp("added_at"),
                    null
                );
                item.setProduct(product);
                items.add(item);
            }
        }
        return items;
    }



    public void update(CartItem item) throws SQLException {
        String sql = "UPDATE cart_items SET quantity = ? WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, item.getQuantity());
            stmt.setInt(2, item.getId());
            stmt.executeUpdate();
        }
    }

    public void remove(int id) throws SQLException {
        String sql = "DELETE FROM cart_items WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    public boolean exists(int cartId, int productId, Integer variantId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM cart_items WHERE cart_id = ? AND product_id = ? AND (variant_id = ? OR (? IS NULL AND variant_id IS NULL))";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, cartId);
            stmt.setInt(2, productId);
            if (variantId != null) {
                stmt.setInt(3, variantId);
                stmt.setInt(4, variantId);
            } else {
                stmt.setNull(3, Types.INTEGER);
                stmt.setNull(4, Types.INTEGER);
            }
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    public void removeByCartId(int cartId) throws SQLException {
        String sql = "DELETE FROM cart_items WHERE cart_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, cartId);
            stmt.executeUpdate();
        }
    }

}
