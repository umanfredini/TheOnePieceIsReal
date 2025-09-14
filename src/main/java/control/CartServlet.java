package control;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.ArrayList;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import dao.ProductDAO;
import dao.CartDAO;
import dao.CartItemDAO;
import model.CartItem;
import model.Cart;
import model.Product;
import model.User;
import java.util.logging.Logger;
import java.util.List;

//@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(CartServlet.class.getName());
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User utente = (User) session.getAttribute("utente");
        
        Map<Integer, CartItem> carrello = new HashMap<>();
        
        try {
            if (utente != null) {
                // Utente registrato: carica carrello dal database
                carrello = loadCartFromDatabase(utente.getId());
            } else {
                // Utente guest: carica carrello dalla sessione
                @SuppressWarnings("unchecked")
                Map<Integer, CartItem> sessionCart = (Map<Integer, CartItem>) session.getAttribute("carrello");
                if (sessionCart != null) {
                    carrello = sessionCart;
                }
            }
            
            // Crea un oggetto Cart per la JSP
            Cart cart = new Cart();
            cart.setItems(new ArrayList<>(carrello.values()));
            
            // Calcola il totale
            double total = 0.0;
            for (CartItem item : carrello.values()) {
                if (item.getProduct() != null) {
                    total += item.getProduct().getPrice().doubleValue() * item.getQuantity();
                }
            }
            cart.setTotal(total);
            
            request.setAttribute("cart", cart);
            request.setAttribute("carrello", carrello);
            
        } catch (Exception e) {
            logger.severe("Errore nel caricamento del carrello: " + e.getMessage());
            // Fallback: usa carrello vuoto
            Cart cart = new Cart();
            cart.setItems(new ArrayList<>());
            cart.setTotal(0.0);
            request.setAttribute("cart", cart);
            request.setAttribute("carrello", new HashMap<>());
        }
        
        request.getRequestDispatcher("/jsp/cart.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Validazione CSRF Token
        if (!isValidCSRFToken(request)) {
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("application/json");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"error\": \"Token CSRF non valido\"}");
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Token CSRF non valido");
            }
            return;
        }
        
        String action = request.getParameter("action");
        
        // Se action è null, prova a determinare l'azione dai parametri
        if (action == null) {
            if (request.getParameter("productId") != null) {
                action = "add"; // Se c'è productId, probabilmente è un'aggiunta
            } else {
                action = ""; // Default vuoto
            }
        }
        
        HttpSession session = request.getSession();
        
        @SuppressWarnings("unchecked")
        Map<Integer, CartItem> carrello = (Map<Integer, CartItem>) session.getAttribute("carrello");
        if (carrello == null) {
            carrello = new HashMap<>();
            session.setAttribute("carrello", carrello);
        }
        
        try {
        logger.info("Azione ricevuta: " + action);
        logger.info("Parametri ricevuti: productId=" + request.getParameter("productId") + 
                   ", prodottoId=" + request.getParameter("prodottoId") + 
                   ", quantita=" + request.getParameter("quantita") +
                   ", quantity=" + request.getParameter("quantity"));
        
        // Debug parametri solo per update
        if ("update".equals(action)) {
            logger.info("=== DEBUG PARAMETRI UPDATE ===");
            request.getParameterMap().forEach((key, values) -> {
                logger.info("Parametro: " + key + " = " + String.join(", ", values));
            });
            logger.info("=== FINE DEBUG PARAMETRI ===");
        }
            
            switch (action) {
                case "add":
                    int cartId = session.getAttribute("cartId") != null ? (int) session.getAttribute("cartId") : 1;
                    addToCart(request, carrello, cartId);
                    break;
                case "update":
                    updateCart(request, carrello);
                    logger.info("Carrello aggiornato, dimensione: " + carrello.size());
                    break;
                case "remove":
                    removeFromCart(request, carrello);
                    break;
                case "clear":
                    carrello.clear();
                    break;
                default:
                    throw new Exception("Azione non valida: " + action);
            }
            
            // Salva il carrello
            User utente = (User) session.getAttribute("utente");
            if (utente != null) {
                // Utente registrato: salva nel database
                saveCartToDatabase(utente.getId(), carrello);
            } else {
                // Utente guest: salva in sessione
                session.setAttribute("carrello", carrello);
            }
            
            // AJAX response
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("application/json");
                
                // Calcola prima il totale del carrello
                double cartTotal = 0.0;
                for (CartItem item : carrello.values()) {
                    cartTotal += item.getProduct().getPrice().doubleValue() * item.getQuantity();
                }
                int itemsCount = carrello.size();
                
                StringBuilder jsonResponse = new StringBuilder();
                jsonResponse.append("{");
                jsonResponse.append("\"success\": true,");
                jsonResponse.append("\"cartTotal\": ").append(cartTotal).append(",");
                jsonResponse.append("\"itemsCount\": ").append(itemsCount).append(",");
                jsonResponse.append("\"cartSize\": ").append(carrello.size());
                
                // Se è un'azione di update, aggiungi anche il totale dell'item specifico
                if ("update".equals(action)) {
                    String productIdStr = request.getParameter("productId");
                    if (productIdStr == null) {
                        productIdStr = request.getParameter("prodottoId");
                    }
                    if (productIdStr != null) {
                        try {
                            int prodottoId = Integer.parseInt(productIdStr);
                            CartItem item = carrello.get(prodottoId);
                            if (item != null) {
                                double itemTotal = item.getProduct().getPrice().doubleValue() * item.getQuantity();
                                jsonResponse.append(",\"itemTotal\": ").append(itemTotal);
                            }
                        } catch (NumberFormatException e) {
                            logger.warning("Errore nel parsing dell'ID prodotto: " + productIdStr);
                        }
                    }
                }
                
                jsonResponse.append("}");
                String finalResponse = jsonResponse.toString();
                logger.info("Risposta JSON inviata: " + finalResponse);
                response.getWriter().write(finalResponse);
            } else {
                response.sendRedirect("CartServlet");
            }
        } catch (Exception e) {
            logger.severe("Errore nel CartServlet: " + e.getMessage());
            System.err.println("Errore in CartServlet: " + e.getMessage());
            
            String errorMessage = "Errore durante l'operazione";
            if (e.getMessage() != null) {
                if (e.getMessage().contains("Errore nel recupero del prodotto")) {
                    errorMessage = "Errore di connessione al database. Verifica che il database sia attivo.";
                } else if (e.getMessage().contains("Communications link failure")) {
                    errorMessage = "Impossibile connettersi al database. Verifica che MySQL sia in esecuzione.";
                } else {
                    errorMessage = e.getMessage();
                }
            }
            
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("application/json");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"error\": \"" + errorMessage.replace("\"", "\\\"") + "\"}");
            } else {
                request.setAttribute("errorMessage", errorMessage);
                request.getRequestDispatcher("/jsp/error.jsp").forward(request, response);
            }
        }
    }

    private void addToCart(HttpServletRequest request, Map<Integer, CartItem> carrello, int cartId) throws Exception {
        // Validazione parametri - supporta entrambi i formati
        String productIdStr = request.getParameter("productId");
        if (productIdStr == null) {
            productIdStr = request.getParameter("prodottoId"); // Fallback per compatibilità
        }
        
        String quantityStr = request.getParameter("quantity");
        if (quantityStr == null) {
            quantityStr = request.getParameter("quantita"); // Fallback per compatibilità
        }
        
        String variantId = request.getParameter("variantId");
        // Se variantId è null, vuoto o contiene solo spazi, impostalo a null
        if (variantId == null || variantId.trim().isEmpty()) {
            variantId = null;
        }
        
        if (productIdStr == null || productIdStr.trim().isEmpty()) {
            throw new Exception("ID prodotto mancante");
        }
        
        if (quantityStr == null || quantityStr.trim().isEmpty()) {
            throw new Exception("Quantità mancante");
        }
        
        int prodottoId;
        int quantita;
        
        try {
            prodottoId = Integer.parseInt(productIdStr.trim());
            quantita = Integer.parseInt(quantityStr.trim());
        } catch (NumberFormatException e) {
            throw new Exception("Parametri numerici non validi");
        }
        
        if (quantita <= 0) {
            throw new Exception("Quantità deve essere maggiore di zero");
        }

        ProductDAO prodottoDAO = new ProductDAO();
        Product prodotto = prodottoDAO.findByProductId(prodottoId);

        if (prodotto != null) {
            // Controlla disponibilità
            if (prodotto.getStockQuantity() >= quantita) {
                CartItem item = carrello.get(prodottoId);
                if (item != null) {
                    // Aggiorna quantità esistente
                    int newQuantity = item.getQuantity() + quantita;
                    if (newQuantity <= prodotto.getStockQuantity()) {
                        item.setQuantity(newQuantity);
                    } else {
                        throw new Exception("Quantità totale non disponibile");
                    }
                } else {
                    // Crea nuovo item
                    int cartItemId = carrello.size() + 1; // ID temporaneo
                    if (variantId != null && !variantId.trim().isEmpty()) {
                        item = new CartItem(cartItemId, cartId, prodotto, quantita, variantId);
                    } else {
                        item = new CartItem(cartItemId, cartId, prodotto, quantita, (Integer) null);
                    }
                    carrello.put(prodottoId, item);
                }
            } else {
                throw new Exception("Quantità non disponibile. Disponibile: " + prodotto.getStockQuantity());
            }
        } else {
            throw new Exception("Prodotto non trovato con ID: " + prodottoId);
        }
    }
    
    private void updateCart(HttpServletRequest request, Map<Integer, CartItem> carrello) {
        String productIdStr = request.getParameter("productId");
        if (productIdStr == null) {
            productIdStr = request.getParameter("prodottoId");
        }
        
        String quantityStr = request.getParameter("quantita");
        if (quantityStr == null) {
            quantityStr = request.getParameter("quantity");
        }
        
        logger.info("updateCart - productId: " + productIdStr + ", quantita: " + quantityStr);
        
        // Validazione parametri
        if (productIdStr == null || productIdStr.trim().isEmpty()) {
            throw new IllegalArgumentException("productId non può essere vuoto");
        }
        if (quantityStr == null || quantityStr.trim().isEmpty()) {
            throw new IllegalArgumentException("quantita non può essere vuota");
        }
        
        int prodottoId = Integer.parseInt(productIdStr);
        int quantita = Integer.parseInt(quantityStr);
        
        logger.info("updateCart - prodottoId: " + prodottoId + ", quantita: " + quantita);
        
        if (quantita <= 0) {
            carrello.remove(prodottoId);
            logger.info("Prodotto rimosso dal carrello: " + prodottoId);
        } else {
            CartItem item = carrello.get(prodottoId);
            if (item != null) {
                logger.info("Quantità aggiornata da " + item.getQuantity() + " a " + quantita);
                item.setQuantity(quantita);
            } else {
                logger.warning("Item non trovato nel carrello per prodottoId: " + prodottoId);
            }
        }
    }
    
    private void removeFromCart(HttpServletRequest request, Map<Integer, CartItem> carrello) {
        String productIdStr = request.getParameter("productId");
        if (productIdStr == null) {
            productIdStr = request.getParameter("prodottoId");
        }
        
        int prodottoId = Integer.parseInt(productIdStr);
        carrello.remove(prodottoId);
    }
    
    /**
     * Carica il carrello dal database per un utente registrato
     */
    private Map<Integer, CartItem> loadCartFromDatabase(int userId) throws Exception {
        Map<Integer, CartItem> carrello = new HashMap<>();
        
        CartDAO cartDAO = new CartDAO();
        CartItemDAO cartItemDAO = new CartItemDAO();
        ProductDAO productDAO = new ProductDAO();
        
        // Crea carrello se non esiste
        cartDAO.createIfNotExists(userId);
        
        // Trova il carrello dell'utente
        Cart cart = cartDAO.findByUserId(userId);
        if (cart != null) {
            // Carica gli elementi del carrello
            List<CartItem> items = cartItemDAO.findByCartId(cart.getId());
            for (CartItem item : items) {
                // Carica i dettagli del prodotto
                Product product = productDAO.findByProductId(item.getProductId());
                if (product != null && product.isActive()) {
                    item.setProduct(product);
                    carrello.put(item.getProductId(), item);
                }
            }
        }
        
        return carrello;
    }
    
    /**
     * Salva il carrello nel database per un utente registrato
     */
    private void saveCartToDatabase(int userId, Map<Integer, CartItem> carrello) throws Exception {
        CartDAO cartDAO = new CartDAO();
        CartItemDAO cartItemDAO = new CartItemDAO();
        
        // Crea carrello se non esiste
        cartDAO.createIfNotExists(userId);
        
        // Trova il carrello dell'utente
        Cart cart = cartDAO.findByUserId(userId);
        if (cart != null) {
            // Svuota il carrello esistente
            cartDAO.clear(cart.getId());
            
            // Aggiungi i nuovi elementi
            for (CartItem item : carrello.values()) {
                item.setCartId(cart.getId());
                cartItemDAO.add(item);
            }
        }
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
        
        // Se non c'è token nella sessione, non è valido
        if (sessionToken == null) {
            return false;
        }
        
        // Se non c'è token nella richiesta, non è valido
        if (requestToken == null || requestToken.trim().isEmpty()) {
            return false;
        }
        
        // Confronta i token
        return sessionToken.equals(requestToken.trim());
    }
}