package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {
    private final Connection connection;

    public OrderDAO(Connection connection) {
        this.connection = connection;
    }

    public void create(Order order) throws SQLException {
        String sql = "INSERT INTO orders (user_id, total_price, shipping_address, payment_method, status, tracking_number, notes) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, order.getUserId());
            stmt.setBigDecimal(2, order.getTotalPrice());
            stmt.setString(3, order.getShippingAddress());
            stmt.setString(4, order.getPaymentMethod());
            stmt.setString(5, order.getStatus());
            stmt.setString(6, order.getTrackingNumber());
            stmt.setString(7, order.getNotes());
            stmt.executeUpdate();
            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                order.setId(rs.getInt(1));
            }
        }
    }

    public Order read(int id) throws SQLException {
        String sql = "SELECT * FROM orders WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return extractOrder(rs);
            }
        }
        return null;
    }

    public List<Order> findByUserId(int userId) throws SQLException {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                orders.add(extractOrder(rs));
            }
        }
        return orders;
    }

    public List<Order> findByDateRange(Date from, Date to) throws SQLException {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE order_date BETWEEN ? AND ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setDate(1, from);
            stmt.setDate(2, to);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                orders.add(extractOrder(rs));
            }
        }
        return orders;
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM orders WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    private Order extractOrder(ResultSet rs) throws SQLException {
        return new Order(
            rs.getInt("id"),
            rs.getInt("user_id"),
            rs.getBigDecimal("total_price"),
            rs.getTimestamp("order_date"),
            rs.getString("shipping_address"),
            rs.getString("payment_method"),
            rs.getString("status"),
            rs.getString("tracking_number"),
            rs.getString("notes")
        );
    }
}
