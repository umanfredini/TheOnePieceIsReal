package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderItemDAO {
    private final Connection connection;

    public OrderItemDAO(Connection connection) {
        this.connection = connection;
    }

    public void add(OrderItem item) throws SQLException {
        String sql = "INSERT INTO order_items (order_id, product_id, variant_id, variant_name, unit_price, quantity) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, item.getOrderId());
            stmt.setInt(2, item.getProductId());
            if (item.getVariantId() != null) {
                stmt.setInt(3, item.getVariantId());
            } else {
                stmt.setNull(3, Types.INTEGER);
            }
            stmt.setString(4, item.getVariantName());
            stmt.setBigDecimal(5, item.getUnitPrice());
            stmt.setInt(6, item.getQuantity());
            stmt.executeUpdate();
        }
    }

    public List<OrderItem> findByOrderId(int orderId) throws SQLException {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT * FROM order_items WHERE order_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, orderId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                items.add(new OrderItem(
                    rs.getInt("id"),
                    rs.getInt("order_id"),
                    rs.getInt("product_id"),
                    rs.getObject("variant_id") != null ? rs.getInt("variant_id") : null,
                    rs.getString("variant_name"),
                    rs.getBigDecimal("unit_price"),
                    rs.getInt("quantity")
                ));
            }
        }
        return items;
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM order_items WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }
}
