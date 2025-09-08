package dao;

import model.Product;
import model.ProductVariant;
import util.DBConnection;
import util.CharacterManager;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.logging.Logger;
import java.util.Map;
import java.util.HashMap;

public class ProductDAO {
    
    private static final Logger logger = Logger.getLogger(ProductDAO.class.getName());
    private CharacterManager characterManager = new CharacterManager();
    
    // Metodi base per prodotti
    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE deleted_at IS NULL AND active = TRUE ORDER BY name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            logger.severe("Errore nel metodo: " + e.getMessage());
        }
        return products;
    }
    
    public Optional<Product> getProductById(int id) {
        String sql = "SELECT * FROM products WHERE id = ? AND deleted_at IS NULL AND active = TRUE";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return Optional.of(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            System.err.println("Errore SQL nel recupero prodotto ID " + id + ": " + e.getMessage());
            logger.severe("Errore nel metodo: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("Errore generico nel recupero prodotto ID " + id + ": " + e.getMessage());
            logger.severe("Errore nel metodo: " + e.getMessage());
        }
        return Optional.empty();
    }
    
    public List<Product> getProductsByCategory(String category) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE category = ? AND deleted_at IS NULL AND active = TRUE ORDER BY name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, category);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            logger.severe("Errore nel metodo: " + e.getMessage());
        }
        return products;
    }
    
    // Metodi per gestione personaggi nel campo is_featured
    public List<Product> getFeaturedProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE is_featured IS NOT NULL AND is_featured != '' AND deleted_at IS NULL AND active = TRUE ORDER BY name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            logger.severe("Errore nel metodo: " + e.getMessage());
        }
        return products;
    }

    // AGGIUNTA: versione con limite
    public List<Product> getFeaturedProducts(int limit) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE is_featured IS NOT NULL AND is_featured != '' AND deleted_at IS NULL AND active = TRUE ORDER BY name LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            logger.severe("Errore nel metodo: " + e.getMessage());
        }
        return products;
    }
    
    public List<Product> getProductsByCharacter(String characterName) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE is_featured LIKE ? AND deleted_at IS NULL AND active = TRUE ORDER BY name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, "%" + characterName + "%");
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            logger.severe("Errore nel metodo: " + e.getMessage());
        }
        return products;
    }
    
    public List<Product> getProductsByCharacterCount(int minCharacters) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE is_featured IS NOT NULL AND is_featured != '' AND deleted_at IS NULL AND active = TRUE ORDER BY name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Product product = mapResultSetToProduct(rs);
                if (product.getIsFeatured() != null) {
                    List<String> characters = characterManager.parseCharacterNames(product.getIsFeatured());
                    if (characters.size() >= minCharacters) {
                        products.add(product);
                    }
                }
            }
        } catch (SQLException e) {
            logger.severe("Errore nel metodo: " + e.getMessage());
        }
        return products;
    }
    
    public List<Product> getRelatedProducts(int productId, int limit) {
        List<Product> products = new ArrayList<>();
        String sql = """
            SELECT p.* FROM products p
            INNER JOIN products current ON current.id = ?
            WHERE p.id != ? 
            AND p.deleted_at IS NULL 
            AND p.active = TRUE
            AND (
                p.category = current.category
                OR (p.is_featured IS NOT NULL AND current.is_featured IS NOT NULL 
                    AND p.is_featured LIKE CONCAT('%', SUBSTRING_INDEX(current.is_featured, ',', 1), '%'))
            )
            ORDER BY p.name
            LIMIT ?
            """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, productId);
            stmt.setInt(2, productId);
            stmt.setInt(3, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            logger.severe("Errore nel metodo: " + e.getMessage());
        }
        return products;
    }
    
    // Metodi per gestione varianti
    public List<ProductVariant> getProductVariants(int productId) {
        List<ProductVariant> variants = new ArrayList<>();
        String sql = "SELECT * FROM product_variants WHERE product_id = ? ORDER BY variant_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, productId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                variants.add(mapResultSetToProductVariant(rs));
            }
        } catch (SQLException e) {
            logger.severe("Errore nel metodo: " + e.getMessage());
        }
        return variants;
    }
    
    public Optional<ProductVariant> getVariantById(int variantId) {
        String sql = "SELECT * FROM product_variants WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, variantId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return Optional.of(mapResultSetToProductVariant(rs));
            }
        } catch (SQLException e) {
            logger.severe("Errore nel metodo: " + e.getMessage());
        }
        return Optional.empty();
    }
    
    public List<ProductVariant> getVariantsByType(int productId, String variantType) {
        List<ProductVariant> variants = new ArrayList<>();
        String sql = "SELECT * FROM product_variants WHERE product_id = ? AND variant_type = ? ORDER BY variant_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, productId);
            stmt.setString(2, variantType);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                variants.add(mapResultSetToProductVariant(rs));
            }
        } catch (SQLException e) {
            logger.severe("Errore nel metodo: " + e.getMessage());
        }
        return variants;
    }
    
    public boolean updateVariantStock(int variantId, int quantity) {
        String sql = "UPDATE product_variants SET stock_quantity = stock_quantity - ? WHERE id = ? AND stock_quantity >= ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, quantity);
            stmt.setInt(2, variantId);
            stmt.setInt(3, quantity);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.severe("Errore nel metodo: " + e.getMessage());
            return false;
        }
    }
    
    public boolean updateProductStock(int productId, int quantity) {
        String sql = "UPDATE products SET stock_quantity = stock_quantity - ? WHERE id = ? AND stock_quantity >= ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, quantity);
            stmt.setInt(2, productId);
            stmt.setInt(3, quantity);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.severe("Errore nel metodo: " + e.getMessage());
            return false;
        }
    }
    
    // Metodi per ricerca
    public List<Product> searchProducts(String searchTerm) {
        List<Product> products = new ArrayList<>();
        String sql = """
            SELECT * FROM products 
            WHERE (name LIKE ? OR description LIKE ? OR is_featured LIKE ?) 
            AND deleted_at IS NULL AND active = TRUE 
            ORDER BY name
            """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + searchTerm + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            logger.severe("Errore nel metodo: " + e.getMessage());
        }
        return products;
    }
    
    // Metodi per gestione admin
    public boolean addProduct(Product product) {
        String sql = """
            INSERT INTO products (name, description, price, image_url, category, stock_quantity, is_featured) 
            VALUES (?, ?, ?, ?, ?, ?, ?)
            """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, product.getName());
            stmt.setString(2, product.getDescription());
            stmt.setBigDecimal(3, product.getPrice());
            stmt.setString(4, product.getImageUrl());
            stmt.setString(5, product.getCategory());
            stmt.setInt(6, product.getStockQuantity());
            stmt.setString(7, product.getIsFeatured());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    product.setId(rs.getInt(1));
                    return true;
                }
            }
        } catch (SQLException e) {
            logger.severe("Errore nel metodo: " + e.getMessage());
        }
        return false;
    }
    
    public boolean updateProduct(Product product) {
        String sql = """
            UPDATE products 
            SET name = ?, description = ?, price = ?, image_url = ?, category = ?, 
                stock_quantity = ?, is_featured = ?, active = ?
            WHERE id = ?
            """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, product.getName());
            stmt.setString(2, product.getDescription());
            stmt.setBigDecimal(3, product.getPrice());
            stmt.setString(4, product.getImageUrl());
            stmt.setString(5, product.getCategory());
            stmt.setInt(6, product.getStockQuantity());
            stmt.setString(7, product.getIsFeatured());
            stmt.setBoolean(8, product.isActive());
            stmt.setInt(9, product.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.severe("Errore nel metodo: " + e.getMessage());
            return false;
        }
    }
    
    public boolean addVariant(ProductVariant variant) {
        String sql = """
            INSERT INTO product_variants (product_id, variant_name, variant_type, stock_quantity, price_modifier) 
            VALUES (?, ?, ?, ?, ?)
            """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, variant.getProductId());
            stmt.setString(2, variant.getVariantName());
            stmt.setString(3, variant.getVariantType());
            stmt.setInt(4, variant.getStockQuantity());
            stmt.setBigDecimal(5, variant.getPriceModifier());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    variant.setId(rs.getInt(1));
                    return true;
                }
            }
        } catch (SQLException e) {
            logger.severe("Errore nel metodo: " + e.getMessage());
        }
        return false;
    }
    
    public boolean updateVariant(ProductVariant variant) {
        String sql = """
            UPDATE product_variants 
            SET variant_name = ?, variant_type = ?, stock_quantity = ?, price_modifier = ?
            WHERE id = ?
            """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, variant.getVariantName());
            stmt.setString(2, variant.getVariantType());
            stmt.setInt(3, variant.getStockQuantity());
            stmt.setBigDecimal(4, variant.getPriceModifier());
            stmt.setInt(5, variant.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.severe("Errore nel metodo: " + e.getMessage());
            return false;
        }
    }
    
    public boolean deleteVariant(int variantId) {
        String sql = "DELETE FROM product_variants WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, variantId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.severe("Errore nel metodo: " + e.getMessage());
            return false;
        }
    }
    
    // Metodi di utilità
    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        try {
            Product product = new Product();
            product.setId(rs.getInt("id"));
            product.setName(rs.getString("name"));
            product.setDescription(rs.getString("description"));
            product.setPrice(rs.getBigDecimal("price"));
            
            // Gestione path immagine
            String imageUrl = rs.getString("image_url");
            product.setImageUrl(formatImageUrl(imageUrl));
            
            product.setCategory(rs.getString("category"));
            product.setActive(rs.getBoolean("active"));
            product.setStockQuantity(rs.getInt("stock_quantity"));
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
            
            try {
                product.setDeletedAt(rs.getTimestamp("deleted_at"));
            } catch (SQLException e) {
                logger.warning("Warning: deleted_at timestamp non valido, impostato a null");
                product.setDeletedAt(null);
            }
            
            return product;
        } catch (Exception e) {
            logger.severe("Errore nel mapping del prodotto: " + e.getMessage());
            throw e;
        }
    }
    
    /**
     * Formatta l'URL dell'immagine per assicurarsi che sia corretto
     * @param imageUrl URL dell'immagine dal database
     * @return URL formattato correttamente
     */
    private String formatImageUrl(String imageUrl) {
        if (imageUrl == null || imageUrl.trim().isEmpty()) {
            return "avatar_default.jpg"; // Immagine di default
        }
        
        // Rimuovi spazi extra
        imageUrl = imageUrl.trim();
        
        // Se l'URL inizia con '/images/', rimuovi il prefisso
        if (imageUrl.startsWith("/images/")) {
            imageUrl = imageUrl.substring(8); // Rimuovi '/images/'
        }
        
        // Se l'URL inizia con 'images/', rimuovi il prefisso
        if (imageUrl.startsWith("images/")) {
            imageUrl = imageUrl.substring(7); // Rimuovi 'images/'
        }
        
        // Se l'URL inizia con 'styles/images/prodotti/', rimuovi il prefisso
        if (imageUrl.startsWith("styles/images/prodotti/")) {
            imageUrl = imageUrl.substring(23); // Rimuovi 'styles/images/prodotti/'
        }
        
        // Se l'URL inizia con '/styles/images/prodotti/', rimuovi il prefisso
        if (imageUrl.startsWith("/styles/images/prodotti/")) {
            imageUrl = imageUrl.substring(24); // Rimuovi '/styles/images/prodotti/'
        }
        
        // Assicurati che l'URL non sia vuoto dopo la pulizia
        if (imageUrl.isEmpty()) {
            return "avatar_default.jpg";
        }
        
        return imageUrl;
    }
    
    private ProductVariant mapResultSetToProductVariant(ResultSet rs) throws SQLException {
        ProductVariant variant = new ProductVariant();
        variant.setId(rs.getInt("id"));
        variant.setProductId(rs.getInt("product_id"));
        variant.setVariantName(rs.getString("variant_name"));
        variant.setVariantType(rs.getString("variant_type"));
        variant.setStockQuantity(rs.getInt("stock_quantity"));
        variant.setPriceModifier(rs.getBigDecimal("price_modifier"));
        return variant;
    }

    public List<String> findAllCategories() {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT DISTINCT category FROM products WHERE category IS NOT NULL AND category != '' ORDER BY category";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                categories.add(rs.getString("category"));
            }
        } catch (SQLException e) {
            logger.severe("Errore nel metodo: " + e.getMessage());
        }
        return categories;
    }

    public List<Product> findAll() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE deleted_at IS NULL AND active = TRUE ORDER BY name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            logger.severe("Errore SQL in findAll: " + e.getMessage());
            logger.severe("Errore nel metodo: " + e.getMessage());
        } catch (Exception e) {
            logger.severe("Errore generico in findAll: " + e.getMessage());
            logger.severe("Errore nel metodo: " + e.getMessage());
        }
        return products;
    }
    
    public List<Product> findByPersonaggio(String personaggio) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE is_featured LIKE ? AND deleted_at IS NULL AND active = TRUE ORDER BY name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, "%" + personaggio + "%");
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            logger.severe("Errore nel metodo: " + e.getMessage());
        }
        return products;
    }
    
    public List<Product> findByCategoria(String categoria) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE category = ? AND deleted_at IS NULL AND active = TRUE ORDER BY name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, categoria);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            logger.severe("Errore nel metodo: " + e.getMessage());
        }
        return products;
    }
    
    public List<Product> findBySearch(String searchTerm) {
        List<Product> products = new ArrayList<>();
        String sql = """
            SELECT * FROM products 
            WHERE (name LIKE ? OR description LIKE ? OR is_featured LIKE ?) 
            AND deleted_at IS NULL AND active = TRUE 
            ORDER BY name
            """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + searchTerm + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            logger.severe("Errore nel metodo: " + e.getMessage());
        }
        return products;
    }
    
    public List<Product> findProductsWithMultipleCharacters() {
        return getProductsByCharacterCount(2);
    }
    
    public Product findByProductId(int id) {
        String sql = "SELECT * FROM products WHERE id = ? AND deleted_at IS NULL";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Product product = mapResultSetToProduct(rs);
                return product;
            }
        } catch (SQLException e) {
            System.err.println("ERRORE SQL nel recupero prodotto ID " + id + ": " + e.getMessage());
            logger.severe("Errore nel metodo: " + e.getMessage());
            throw new RuntimeException("Errore nel recupero del prodotto con ID " + id + ": " + e.getMessage(), e);
        }
        return null;
    }
    
    // Metodi per paginazione
    public List<Product> getProductsWithPagination(int page, int pageSize, String category, String personaggio, String search, Double maxPrice) {
        List<Product> products = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM products WHERE deleted_at IS NULL AND active = TRUE");
        List<Object> parameters = new ArrayList<>();
        int paramIndex = 1;
        
        // Aggiungi filtri
        if (category != null && !category.isEmpty()) {
            sql.append(" AND category = ?");
            parameters.add(category);
            paramIndex++;
        }
        
        if (personaggio != null && !personaggio.isEmpty()) {
            sql.append(" AND is_featured LIKE ?");
            parameters.add("%" + personaggio + "%");
            paramIndex++;
        }
        
        if (search != null && !search.isEmpty()) {
            sql.append(" AND (name LIKE ? OR description LIKE ? OR is_featured LIKE ?)");
            String searchPattern = "%" + search + "%";
            parameters.add(searchPattern);
            parameters.add(searchPattern);
            parameters.add(searchPattern);
            paramIndex += 3;
        }
        
        if (maxPrice != null) {
            sql.append(" AND price <= ?");
            parameters.add(maxPrice);
            paramIndex++;
        }
        
        // Aggiungi ordinamento e paginazione
        sql.append(" ORDER BY name LIMIT ? OFFSET ?");
        parameters.add(pageSize);
        parameters.add((page - 1) * pageSize);
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            // Imposta i parametri
            for (int i = 0; i < parameters.size(); i++) {
                Object param = parameters.get(i);
                if (param instanceof String) {
                    stmt.setString(i + 1, (String) param);
                } else if (param instanceof Double) {
                    stmt.setDouble(i + 1, (Double) param);
                } else if (param instanceof Integer) {
                    stmt.setInt(i + 1, (Integer) param);
                }
            }
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                products.add(mapResultSetToProduct(rs));
            }
        } catch (SQLException e) {
            logger.severe("Errore nel metodo: " + e.getMessage());
        }
        return products;
    }
    
    public int getTotalProductsCount(String category, String personaggio, String search, Double maxPrice) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM products WHERE deleted_at IS NULL AND active = TRUE");
        List<Object> params = new ArrayList<>();
        int paramIndex = 1;
        
        if (category != null && !category.trim().isEmpty()) {
            sql.append(" AND category = ?");
            params.add(category);
        }
        
        if (personaggio != null && !personaggio.trim().isEmpty()) {
            sql.append(" AND is_featured LIKE ?");
            params.add("%" + personaggio + "%");
        }
        
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (name LIKE ? OR description LIKE ?)");
            params.add("%" + search + "%");
            params.add("%" + search + "%");
        }
        
        if (maxPrice != null && maxPrice > 0) {
            sql.append(" AND price <= ?");
            params.add(maxPrice);
        }
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            logger.severe("Errore nel conteggio prodotti: " + e.getMessage());
            logger.severe("Errore nel metodo: " + e.getMessage());
        }
        return 0;
    }
    
    /**
     * Conta tutti i prodotti attivi
     */
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM products WHERE deleted_at IS NULL AND active = TRUE";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            logger.severe("Errore nel conteggio prodotti: " + e.getMessage());
            logger.severe("Errore nel metodo: " + e.getMessage());
        }
        return 0;
    }
    
    /**
     * Ottiene i prodotti più venduti basandosi sugli ordini
     */
    public List<Map<String, Object>> getTopSellingProducts(int limit) {
        List<Map<String, Object>> topProducts = new ArrayList<>();
        
        // Prima prova con la query completa che include gli ordini
        String sql = """
            SELECT p.id, p.name, p.price, p.image_url, p.category,
                   COALESCE(SUM(oi.quantity), 0) as total_sold
            FROM products p
            LEFT JOIN order_items oi ON p.id = oi.product_id
            LEFT JOIN orders o ON oi.order_id = o.id
            WHERE p.deleted_at IS NULL AND p.active = TRUE
            AND (o.status IS NULL OR o.status != 'cancelled')
            GROUP BY p.id, p.name, p.price, p.image_url, p.category
            ORDER BY total_sold DESC
            LIMIT ?
        """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> product = new HashMap<>();
                product.put("id", rs.getInt("id"));
                product.put("name", rs.getString("name"));
                product.put("price", rs.getDouble("price"));
                product.put("imageUrl", rs.getString("image_url"));
                product.put("category", rs.getString("category"));
                product.put("totalSold", rs.getInt("total_sold"));
                topProducts.add(product);
            }
            
            // Se abbiamo risultati, li restituiamo
            if (!topProducts.isEmpty()) {
                return topProducts;
            }
            
        } catch (SQLException e) {
            logger.warning("Errore nella query prodotti più venduti con ordini: " + e.getMessage());
        }
        
        // Fallback: restituisce i prodotti più recenti se la query con ordini fallisce
        String fallbackSql = """
            SELECT id, name, price, image_url, category, 0 as total_sold
            FROM products 
            WHERE deleted_at IS NULL AND active = TRUE
            ORDER BY id DESC
            LIMIT ?
        """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(fallbackSql)) {
            
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> product = new HashMap<>();
                product.put("id", rs.getInt("id"));
                product.put("name", rs.getString("name"));
                product.put("price", rs.getDouble("price"));
                product.put("imageUrl", rs.getString("image_url"));
                product.put("category", rs.getString("category"));
                product.put("totalSold", 0); // Nessun dato di vendita disponibile
                topProducts.add(product);
            }
            
        } catch (SQLException e) {
            logger.severe("Errore anche nel fallback prodotti più venduti: " + e.getMessage());
            logger.severe("Errore nel metodo: " + e.getMessage());
        }
        
        return topProducts;
    }
    
    /**
     * Elimina un prodotto (soft delete)
     */
    public boolean delete(int productId) {
        String sql = "UPDATE products SET deleted_at = CURRENT_TIMESTAMP, active = FALSE WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, productId);
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                logger.info("Prodotto ID " + productId + " eliminato con successo");
                return true;
            } else {
                logger.warning("Nessun prodotto trovato con ID " + productId);
                return false;
            }
            
        } catch (SQLException e) {
            logger.severe("Errore nell'eliminazione del prodotto ID " + productId + ": " + e.getMessage());
            logger.severe("Errore nel metodo: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Elimina definitivamente un prodotto (hard delete)
     */
    public boolean hardDelete(int productId) {
        String sql = "DELETE FROM products WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, productId);
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                logger.info("Prodotto ID " + productId + " eliminato definitivamente");
                return true;
            } else {
                logger.warning("Nessun prodotto trovato con ID " + productId);
                return false;
            }
            
        } catch (SQLException e) {
            logger.severe("Errore nell'eliminazione definitiva del prodotto ID " + productId + ": " + e.getMessage());
            logger.severe("Errore nel metodo: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Riattiva un prodotto eliminato
     */
    public boolean restore(int productId) {
        String sql = "UPDATE products SET deleted_at = NULL, active = TRUE WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, productId);
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                logger.info("Prodotto ID " + productId + " riattivato con successo");
                return true;
            } else {
                logger.warning("Nessun prodotto trovato con ID " + productId);
                return false;
            }
            
        } catch (SQLException e) {
            logger.severe("Errore nella riattivazione del prodotto ID " + productId + ": " + e.getMessage());
            logger.severe("Errore nel metodo: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Crea un nuovo prodotto
     */
    public boolean create(Product product) {
        String sql = """
            INSERT INTO products (name, description, price, stock_quantity, category, image_url, is_featured, active, created_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)
        """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, product.getName());
            stmt.setString(2, product.getDescription());
            stmt.setBigDecimal(3, product.getPrice());
            stmt.setInt(4, product.getStockQuantity());
            stmt.setString(5, product.getCategory());
            stmt.setString(6, product.getImageUrl());
            
            // Gestione del campo is_featured che potrebbe essere null
            String isFeatured = product.getIsFeatured();
            if (isFeatured != null && !isFeatured.trim().isEmpty()) {
                stmt.setString(7, isFeatured);
            } else {
                stmt.setNull(7, Types.VARCHAR);
            }
            
            stmt.setBoolean(8, product.isActive());
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                // Ottieni l'ID generato
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    product.setId(rs.getInt(1));
                }
                logger.info("Prodotto creato con successo: " + product.getName());
                return true;
            } else {
                logger.warning("Nessuna riga inserita per il prodotto: " + product.getName());
                return false;
            }
            
        } catch (SQLException e) {
            logger.severe("Errore nella creazione del prodotto: " + e.getMessage());
            logger.severe("Errore nel metodo: " + e.getMessage());
            return false;
        }
    }
}
