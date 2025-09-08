package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

import model.Product;
import util.DBConnection;

public class WishlistDAO {
    private final Connection connection;
    private static final Logger logger = Logger.getLogger(WishlistDAO.class.getName());

    public WishlistDAO(Connection connection) {
        this.connection = connection;
    }
    
    public WishlistDAO() {
    	try {
    		this.connection = DBConnection.getConnection();
    	} catch (SQLException e) {
    		throw new RuntimeException("Errore nella connessione al database", e);
    	}
    }

    public void add(int userId, int productId) {
        String sql = "INSERT INTO wishlist (user_id, product_id) VALUES (?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, productId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Errore nell'aggiunta alla wishlist", e);
        }
    }

    public List<Product> findProductsByUserId(int userId) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.* FROM wishlist w JOIN products p ON w.product_id = p.id WHERE w.user_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setName(rs.getString("name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getBigDecimal("price"));
                product.setImageUrl(rs.getString("image_url"));
                product.setCategory(rs.getString("category"));
    
                product.setStockQuantity(rs.getInt("stock_quantity"));
                product.setActive(rs.getBoolean("active"));
                product.setIsFeatured(rs.getString("is_featured"));
                
                // Gestione sicura dei timestamp
                try {
                    product.setCreatedAt(rs.getTimestamp("created_at"));
                } catch (SQLException e) {
                    logger.warning("Warning: created_at timestamp non valido, impostato a null");
                    product.setCreatedAt(null);
                }
                
                try {
                    product.setUpdatedAt(rs.getTimestamp("updated_at"));
                } catch (SQLException e) {
                    logger.warning("Warning: updated_at timestamp non valido, impostato a null");
                    product.setUpdatedAt(null);
                }

                products.add(product);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Errore nel recupero della wishlist", e);
        }

        return products;
    }


    public void remove(int userId, int productId) {
        String sql = "DELETE FROM wishlist WHERE user_id = ? AND product_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, productId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Errore nella rimozione dalla wishlist", e);
        }
    }

    public void clearByUserId(int userId) {
        String sql = "DELETE FROM wishlist WHERE user_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Errore nella pulizia della wishlist", e);
        }
    }

    public boolean exists(int userId, int productId) {
        String sql = "SELECT COUNT(*) FROM wishlist WHERE user_id = ? AND product_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, productId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Errore nel controllo esistenza wishlist", e);
        }
        return false;
    }

}
