package control;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.ArrayList;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import dao.ProductDAO;
import model.CartItem;
import model.Cart;
import model.Product;

//@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        @SuppressWarnings("unchecked")
        Map<Integer, CartItem> carrello = (Map<Integer, CartItem>) session.getAttribute("carrello");
        
        if (carrello == null) {
            carrello = new HashMap<>();
            session.setAttribute("carrello", carrello);
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
            switch (action) {
                case "add":
                    int cartId = session.getAttribute("cartId") != null ? (int) session.getAttribute("cartId") : 1;
                    addToCart(request, carrello, cartId);
                    break;
                case "update":
                    updateCart(request, carrello);
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
            
            session.setAttribute("carrello", carrello);
            
            // AJAX response
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("application/json");
                String jsonResponse = "{\"success\": true, \"cartSize\": " + carrello.size() + "}";
                response.getWriter().write(jsonResponse);
            } else {
                response.sendRedirect("CartServlet");
            }
        } catch (Exception e) {
            e.printStackTrace();
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
        
        String quantityStr = request.getParameter("quantity");
        if (quantityStr == null) {
            quantityStr = request.getParameter("quantita");
        }
        
        int prodottoId = Integer.parseInt(productIdStr);
        int quantita = Integer.parseInt(quantityStr);
        
        if (quantita <= 0) {
            carrello.remove(prodottoId);
        } else {
            CartItem item = carrello.get(prodottoId);
            if (item != null) {
                item.setQuantity(quantita);
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