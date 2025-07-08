package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import model.Order;
import model.OrderItem;

public class OrderDAO {
    private final Connection connection;

    public OrderDAO(Connection connection) {
        this.connection = connection;
    }
    
    public OrderDAO() {
    	this.connection = null;
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


    private Order extractOrder(ResultSet rs) throws SQLException {
        int orderId = rs.getInt("id");

        OrderItemDAO itemDAO = new OrderItemDAO(connection);
        List<OrderItem> items = itemDAO.findByOrderId(orderId);

        return new Order(
            orderId,
            rs.getInt("user_id"),
            rs.getBigDecimal("total_price"),
            rs.getString("shipping_address"),
            rs.getString("payment_method"),
            rs.getString("status"),
            rs.getString("tracking_number"),
            rs.getString("notes"),
            rs.getTimestamp("order_date"),
            items
        );
    }


    public List<Order> findAll() throws SQLException {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                orders.add(extractOrder(rs));
            }
        }
        return orders;
    }

    public boolean delete(int id) throws SQLException {
        String checkSql = "SELECT status FROM orders WHERE id = ?";
        try (PreparedStatement checkStmt = connection.prepareStatement(checkSql)) {
            checkStmt.setInt(1, id);
            ResultSet rs = checkStmt.executeQuery();
            if (rs.next()) {
                String status = rs.getString("status");
                if ("shipped".equalsIgnoreCase(status) || "delivered".equalsIgnoreCase(status)) {
                    return false; // non cancellabile
                }
            }
        }

        String deleteSql = "DELETE FROM orders WHERE id = ?";
        try (PreparedStatement deleteStmt = connection.prepareStatement(deleteSql)) {
            deleteStmt.setInt(1, id);
            deleteStmt.executeUpdate();
            return true;
        }
    }

    public void updateStato(int ordineId, String nuovoStato) throws SQLException {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, nuovoStato);
            stmt.setInt(2, ordineId);
            stmt.executeUpdate();
        }
    }
    
    public int countAll() throws SQLException {
    	String sql = "SELECT COUNT(*) FROM orders";
    	try (PreparedStatement stmt = connection.prepareStatement(sql);
    			ResultSet rs = stmt.executeQuery()) {
    			if (rs.next()) {
    				return rs.getInt(1);
    			}
    	}
		return 0;
	}

    public double getTotalRevenue() throws SQLException {
    	String sql = "SELECT SUM(total_price) FROM orders";
    	try (PreparedStatement stmt = connection.prepareStatement(sql);
    			ResultSet rs = stmt.executeQuery()) {
    			if (rs.next()) {
    				return rs.getDouble(1);
    			}
    	}
    	return 0.0;
    }

    public List<Order> getRecentOrders(int limit) throws SQLException {
    	List<Order> orders = new ArrayList<>();
    	String sql = "SELECT * FROM orders ORDER BY order_date DESC LIMIT ?";
    	try (PreparedStatement stmt = connection.prepareStatement(sql)) {
    		stmt.setInt(1, limit);
    		ResultSet rs = stmt.executeQuery();
    		while (rs.next()) {
    			orders.add(extractOrder(rs));
    		}
    	}
    	return orders;
    	}

}
