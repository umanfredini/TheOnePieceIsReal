package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartItemDAO {
    private final Connection connection;

    public CartItemDAO(Connection connection) {
        this.connection = connection;
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
            while (rs.next()) {
                items.add(new CartItem(
                    rs.getInt("id"),
                    rs.getInt("cart_id"),
                    rs.getInt("product_id"),
                    rs.getObject("variant_id") != null ? rs.getInt("variant_id") : null,
                    rs.getInt("quantity"),
                    rs.getTimestamp("added_at")
                ));
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
}
