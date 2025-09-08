package control;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Product;
import model.ProductVariant;
import model.CartItem;
import dao.ProductDAO;
import dao.ProductVariantDAO;
import util.CharacterManager;

// @WebServlet("/ProductServlet")
public class ProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(ProductServlet.class.getName());
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String personaggio = request.getParameter("personaggio");
        String categoria = request.getParameter("category");
        String search = request.getParameter("search");
        
        try {
            ProductDAO prodottoDAO = new ProductDAO();
            CharacterManager characterManager = new CharacterManager();
            
            if ("detail".equals(action)) {
                String idParam = request.getParameter("id");
                
                int id = -1;
                try {
                    id = Integer.parseInt(idParam);
                } catch (Exception ex) {
                    request.setAttribute("errorMessage", "ID prodotto non valido o mancante.");
                    request.getRequestDispatcher("/jsp/error.jsp").forward(request, response);
                    return;
                }
                
                Product prodotto = prodottoDAO.findByProductId(id);
                
                if (prodotto == null) {
                    // Prodotto non trovato: redirect a 404
                    request.getRequestDispatcher("/jsp/404.jsp").forward(request, response);
                    return;
                }
                request.setAttribute("product", prodotto);
                
                // Ottieni i personaggi del prodotto
                List<String> productCharacters = new ArrayList<>();
                if (prodotto.getIsFeatured() != null && !prodotto.getIsFeatured().isEmpty()) {
                    productCharacters = characterManager.parseCharacterNames(prodotto.getIsFeatured());
                }
                request.setAttribute("productCharacters", productCharacters);
                
                try {
                    ProductVariantDAO variantDAO = new ProductVariantDAO();
                    List<ProductVariant> variants = variantDAO.findAllByProductId(id);
                    request.setAttribute("variants", variants);
                } catch (Exception e) {
                    logger.warning("Errore nel caricamento varianti: " + e.getMessage());
                    request.setAttribute("variants", new ArrayList<>());
                }
                request.getRequestDispatcher("/jsp/product-detail.jsp").forward(request, response);
            } else {
                List<Product> prodotti;
                
                // Ottieni tutti i personaggi per i filtri (ora gestiti tramite is_featured)
                List<String> allCharacters = characterManager.getAllCharacterNames();
                request.setAttribute("characters", allCharacters);
                
                // Ottieni tutte le categorie per il filtro
                List<String> allCategories = prodottoDAO.findAllCategories();
                request.setAttribute("categories", allCategories);
                
                // Gestione filtri
                String maxPrice = request.getParameter("maxPrice");
                String[] characters = request.getParameterValues("characters");
                String inStock = request.getParameter("inStock");
                String featured = request.getParameter("featured");
                String sort = request.getParameter("sort");
                
                // Gestione paginazione
                int page = 1;
                int pageSize = 12; // Prodotti per pagina
                try {
                    String pageParam = request.getParameter("page");
                    if (pageParam != null && !pageParam.isEmpty()) {
                        page = Integer.parseInt(pageParam);
                        if (page < 1) page = 1;
                    }
                } catch (NumberFormatException e) {
                    page = 1;
                }
                
                // Prepara parametri per la paginazione
                Double maxPriceValue = null;
                if (maxPrice != null && !maxPrice.isEmpty()) {
                    try {
                        maxPriceValue = Double.parseDouble(maxPrice);
                    } catch (NumberFormatException e) {
                        // Ignora il filtro se il prezzo non è valido
                    }
                }
                
                // Recupera prodotti con paginazione
                prodotti = prodottoDAO.getProductsWithPagination(page, pageSize, categoria, personaggio, search, maxPriceValue);
                
                // Calcola informazioni paginazione
                int totalProducts = prodottoDAO.getTotalProductsCount(categoria, personaggio, search, maxPriceValue);
                int totalPages = (int) Math.ceil((double) totalProducts / pageSize);
                
                // Assicurati che la pagina corrente sia valida
                if (page > totalPages && totalPages > 0) {
                    page = totalPages;
                    // Ricarica i prodotti per la pagina corretta
                    prodotti = prodottoDAO.getProductsWithPagination(page, pageSize, categoria, personaggio, search, maxPriceValue);
                }
                
                // Ottieni i personaggi per ogni prodotto (ora gestiti tramite is_featured)
                Map<Integer, List<String>> productCharacters = new HashMap<>();
                for (Product product : prodotti) {
                    if (product.getIsFeatured() != null && !product.getIsFeatured().isEmpty()) {
                        List<String> productChars = characterManager.parseCharacterNames(product.getIsFeatured());
                        productCharacters.put(product.getId(), productChars);
                    } else {
                        productCharacters.put(product.getId(), new ArrayList<>());
                    }
                }
                
                request.setAttribute("products", prodotti);
                request.setAttribute("prodotti", prodotti); // Mantieni compatibilità
                request.setAttribute("productCharacters", productCharacters);
                request.setAttribute("categoryName", categoria != null ? categoria : "Tutti i prodotti");
                
                // Informazioni paginazione
                request.setAttribute("currentPage", page);
                request.setAttribute("totalPages", totalPages);
                request.setAttribute("totalProducts", totalProducts);
                request.setAttribute("pageSize", pageSize);
                request.setAttribute("hasNextPage", page < totalPages);
                request.setAttribute("hasPrevPage", page > 1);
                request.getRequestDispatcher("/jsp/catalog.jsp").forward(request, response);
            }
        } catch (Exception e) {
            logger.severe("Errore nel ProductServlet: " + e.getMessage());
            request.setAttribute("errorMessage", "Errore nel caricamento del prodotto. Prodotto non trovato.");
            request.getRequestDispatcher("/jsp/error.jsp").forward(request, response);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Validazione CSRF Token
        if (!isValidCSRFToken(request)) {
            logger.warning("Token CSRF non valido - Session: " + (request.getSession(false) != null) + 
                          ", SessionToken: " + (request.getSession(false) != null ? request.getSession(false).getAttribute("csrfToken") : "null") +
                          ", RequestToken: " + request.getParameter("csrfToken"));
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Token CSRF non valido");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            // Gestisci aggiunta al carrello
            try {
                addToCart(request, response);
            } catch (Exception e) {
                logger.severe("Errore nell'aggiunta al carrello: " + e.getMessage());
                String errorMessage = "Errore nell'aggiunta al carrello.";
                
                // Controlla se è un errore di database
                if (e.getMessage() != null && e.getMessage().contains("Could not create connection")) {
                    errorMessage = "Database non disponibile. Verificare che MySQL sia in esecuzione.";
                    logger.severe("Errore di connessione al database durante l'aggiunta al carrello");
                }
                
                request.setAttribute("errorMessage", errorMessage);
                request.getRequestDispatcher("/jsp/error.jsp").forward(request, response);
            }
        } else {
            // Azione non riconosciuta
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Azione non valida");
        }
    }
    
    private void addToCart(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession();
        
        // Validazione parametri
        String productIdStr = request.getParameter("productId");
        String quantityStr = request.getParameter("quantity");
        String variantIdStr = request.getParameter("variantId");
        
        if (productIdStr == null || productIdStr.trim().isEmpty()) {
            throw new IllegalArgumentException("ID prodotto mancante");
        }
        
        int productId = Integer.parseInt(productIdStr);
        int quantity = 1; // Default
        
        if (quantityStr != null && !quantityStr.trim().isEmpty()) {
            try {
                quantity = Integer.parseInt(quantityStr);
                if (quantity <= 0) quantity = 1;
            } catch (NumberFormatException e) {
                quantity = 1;
            }
        }
        
        // Ottieni il carrello dalla sessione
        @SuppressWarnings("unchecked")
        Map<Integer, CartItem> carrello = (Map<Integer, CartItem>) session.getAttribute("carrello");
        if (carrello == null) {
            carrello = new HashMap<>();
            session.setAttribute("carrello", carrello);
        }
        
        // Ottieni il prodotto
        ProductDAO productDAO = new ProductDAO();
        Product product = productDAO.findByProductId(productId);
        
        if (product == null) {
            throw new IllegalArgumentException("Prodotto non trovato");
        }
        
        // Crea o aggiorna l'item del carrello
        CartItem existingItem = carrello.get(productId);
        if (existingItem != null) {
            existingItem.setQuantity(existingItem.getQuantity() + quantity);
        } else {
            CartItem newItem = new CartItem();
            newItem.setProduct(product);
            newItem.setQuantity(quantity);
            newItem.setAddedAt(new java.sql.Timestamp(System.currentTimeMillis()));
            
            // Gestisci variante se presente
            if (variantIdStr != null && !variantIdStr.trim().isEmpty()) {
                try {
                    int variantId = Integer.parseInt(variantIdStr);
                    ProductVariantDAO variantDAO = new ProductVariantDAO();
                    ProductVariant variant = variantDAO.findByVariantId(variantId);
                    if (variant != null) {
                        newItem.setVariant(variant);
                    }
                } catch (NumberFormatException e) {
                    logger.warning("ID variante non valido: " + variantIdStr);
                }
            }
            
            carrello.put(productId, newItem);
        }
        
        // Redirect alla pagina del prodotto con messaggio di successo
        response.sendRedirect(request.getContextPath() + "/ProductServlet?action=detail&id=" + productId + "&added=true");
    }
    
    /**
     * Valida il token CSRF della richiesta
     */
    private boolean isValidCSRFToken(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }
        
        String sessionToken = (String) session.getAttribute("csrfToken");
        String requestToken = request.getParameter("csrfToken");
        
        if (sessionToken == null || requestToken == null || requestToken.trim().isEmpty()) {
            return false;
        }
        
        return sessionToken.equals(requestToken);
    }
    
}