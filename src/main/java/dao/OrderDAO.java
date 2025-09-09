package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import model.Order;
import model.OrderItem;
import util.DBConnection;

public class OrderDAO {
    private final Connection connection;

    public OrderDAO(Connection connection) {
        this.connection = connection;
    }
    

    public OrderDAO() {
    	try {
    		this.connection = DBConnection.getConnection();
    	} catch (SQLException e) {
    		throw new RuntimeException("Errore nella connessione al database", e);
    	}
    }


    public void create(Order order) throws SQLException {
        String sql = "INSERT INTO orders (user_id, total_price, order_date, shipping_address, payment_method, status, tracking_number, notes) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, order.getUserId());
            stmt.setBigDecimal(2, order.getTotalPrice());
            stmt.setTimestamp(3, order.getOrderDate());
            stmt.setString(4, order.getShippingAddress());
            stmt.setString(5, order.getPaymentMethod());
            stmt.setString(6, order.getStatus());
            stmt.setString(7, order.getTrackingNumber());
            stmt.setString(8, order.getNotes());
            stmt.executeUpdate();
            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                order.setId(rs.getInt(1));
            }
        }
    }

    public Order read(int id) throws SQLException {
        String sql = "SELECT o.*, u.email FROM orders o LEFT JOIN users u ON o.user_id = u.id WHERE o.id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return extractOrder(rs);
            }
        }
        return null;
    }
    
    public Order findByOrderId(int orderId) throws SQLException {
        String sql = "SELECT o.*, u.email FROM orders o LEFT JOIN users u ON o.user_id = u.id WHERE o.id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, orderId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractOrder(rs);
                }
            }
        }
        return null;
    }

    public List<Order> findByUserId(int userId) throws SQLException {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.email FROM orders o LEFT JOIN users u ON o.user_id = u.id WHERE o.user_id = ?";
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
        String sql = "SELECT o.*, u.email FROM orders o LEFT JOIN users u ON o.user_id = u.id WHERE o.order_date BETWEEN ? AND ?";
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

        // Gestione sicura del timestamp
        java.sql.Timestamp orderDate = null;
        try {
            orderDate = rs.getTimestamp("order_date");
        } catch (SQLException e) {
            // Warning: order_date timestamp non valido, impostato a null
        }
        
        return new Order(
            orderId,
            rs.getInt("user_id"),
            rs.getString("email"), // userEmail dalla JOIN
            rs.getBigDecimal("total_price"),
            rs.getString("shipping_address"),
            rs.getString("payment_method"),
            rs.getString("status"),
            rs.getString("tracking_number"),
            rs.getString("notes"),
            orderDate,
            items
        );
    }


    public List<Order> findAll() throws SQLException {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.email FROM orders o LEFT JOIN users u ON o.user_id = u.id";
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
        // Validazione del nuovo stato
        String[] statiValidi = {"pending", "processing", "shipped", "delivered", "cancelled"};
        boolean statoValido = false;
        for (String stato : statiValidi) {
            if (stato.equalsIgnoreCase(nuovoStato)) {
                nuovoStato = stato; // Normalizza il case
                statoValido = true;
                break;
            }
        }
        
        if (!statoValido) {
            throw new SQLException("Stato non valido: " + nuovoStato + ". Stati validi: pending, processing, shipped, delivered, cancelled");
        }
        
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
        String sql = "SELECT COALESCE(SUM(total_price), 0) FROM orders WHERE status != 'cancelled'";
        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            // Fallback: prova a contare solo gli ordini completati
            String fallbackSql = "SELECT COALESCE(SUM(total_price), 0) FROM orders";
            try (PreparedStatement stmt = connection.prepareStatement(fallbackSql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble(1);
                }
            } catch (SQLException e2) {
                // Se anche il fallback fallisce, restituisci 0
                System.err.println("Errore nel calcolo revenue: " + e2.getMessage());
            }
        }
        return 0.0;
    }

    public List<Order> getRecentOrders(int limit) throws SQLException {
    	List<Order> orders = new ArrayList<>();
    	String sql = "SELECT o.*, u.email FROM orders o LEFT JOIN users u ON o.user_id = u.id ORDER BY o.order_date DESC LIMIT ?";
    	try (PreparedStatement stmt = connection.prepareStatement(sql)) {
    		stmt.setInt(1, limit);
    		ResultSet rs = stmt.executeQuery();
    		while (rs.next()) {
    			orders.add(extractOrder(rs));
    		}
    	}
    	return orders;
    	}
    
    /**
     * Trova un ordine per tracking number
     */
    public Order findByTrackingNumber(String trackingNumber) throws Exception {
        String sql = "SELECT o.*, u.email FROM orders o LEFT JOIN users u ON o.user_id = u.id WHERE o.tracking_number = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, trackingNumber);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return extractOrder(rs);
            }
        }
        return null;
    }

}
