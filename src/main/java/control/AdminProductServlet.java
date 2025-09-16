package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Product;
import dao.ProductDAO;
import java.util.logging.Logger;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

public class AdminProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(AdminProductServlet.class.getName());

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (!isAdminLoggedIn(session)) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        // Assicurati che il token CSRF sia presente nella sessione
        String existingToken = (String) session.getAttribute("csrfToken");
        logger.info("=== DEBUG TOKEN CSRF doGet ===");
        logger.info("Token CSRF esistente: " + existingToken);
        
        if (existingToken == null) {
            String csrfToken = java.util.UUID.randomUUID().toString();
            session.setAttribute("csrfToken", csrfToken);
            logger.info("Token CSRF generato nel doGet: " + csrfToken);
        } else {
            logger.info("Token CSRF già presente: " + existingToken);
        }
        logger.info("=== FINE DEBUG TOKEN CSRF doGet ===");

        String action = request.getParameter("action");

        try {
            ProductDAO prodottoDAO = new ProductDAO();

            // Carica sempre la lista dei prodotti per la pagina di gestione
            List<Product> prodotti = prodottoDAO.findAll();
            request.setAttribute("products", prodotti);
            request.getRequestDispatcher("/jsp/adminProducts.jsp").forward(request, response);
        } catch (Exception e) {
            logger.severe("Errore nella gestione prodotti admin" + e.getMessage());
            request.setAttribute("errorMessage", "Errore nella gestione dei prodotti. Riprova.");
            request.getRequestDispatcher("/jsp/error.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        logger.info("=== AdminProductServlet doPost INIZIO ===");
        HttpSession session = request.getSession(false);
        
        logger.info("Session: " + (session != null ? "presente" : "null"));
        if (session != null) {
            logger.info("Session ID: " + session.getId());
            logger.info("isAdmin: " + session.getAttribute("isAdmin"));
            logger.info("isLoggedIn: " + session.getAttribute("isLoggedIn"));
        }

        if (!isValidToken(request, session)) {
            // Se è una richiesta AJAX, restituisci JSON
            String action = request.getParameter("action");
            if (action != null && (action.equals("updateStock") || action.equals("delete") || action.equals("add"))) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\": false, \"error\": \"Token di sicurezza non valido\"}");
                return;
            }
            request.setAttribute("errorMessage", "Token di sicurezza non valido. Riprova.");
            request.getRequestDispatcher("/jsp/error.jsp").forward(request, response);
            return;
        }

        if (!isAdminLoggedIn(session)) {
            // Se è una richiesta AJAX, restituisci JSON
            String action = request.getParameter("action");
            if (action != null && (action.equals("updateStock") || action.equals("delete") || action.equals("add"))) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\": false, \"error\": \"Sessione non valida\"}");
                return;
            }
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        String action = request.getParameter("action");
        logger.info("AdminProductServlet doPost - Action: " + action);
        logger.info("Parametri ricevuti:");
        logger.info("- productId: " + request.getParameter("productId"));
        logger.info("- name: " + request.getParameter("name"));
        logger.info("- price: " + request.getParameter("price"));
        logger.info("- stockQuantity: " + request.getParameter("stockQuantity"));
        logger.info("- category: " + request.getParameter("category"));
        logger.info("- description: " + request.getParameter("description"));
        logger.info("- csrfToken: " + request.getParameter("csrfToken"));
        
        // Debug: mostra tutti i parametri
        logger.info("=== TUTTI I PARAMETRI RICEVUTI ===");
        java.util.Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();
            String paramValue = request.getParameter(paramName);
            logger.info("Parametro: " + paramName + " = " + paramValue);
        }
        logger.info("=== FINE PARAMETRI ===");
        
        try {
            ProductDAO prodottoDAO = new ProductDAO();
            
            if ("add".equals(action)) {
                // Aggiungi nuovo prodotto
                Product prodotto = new Product();
                prodotto.setName(request.getParameter("name"));
                prodotto.setDescription(request.getParameter("description"));
                prodotto.setPrice(new BigDecimal(request.getParameter("price")));
                prodotto.setStockQuantity(Integer.parseInt(request.getParameter("stockQuantity")));
                prodotto.setCategory(request.getParameter("category"));
                prodotto.setImageUrl(request.getParameter("image"));
                prodotto.setActive(true);
                
                prodottoDAO.create(prodotto);
                request.setAttribute("successMessage", "Prodotto aggiunto correttamente.");
                
            } else if ("update".equals(action)) {
                // Aggiorna prodotto esistente
                int productId = Integer.parseInt(request.getParameter("productId"));
                Product prodotto = prodottoDAO.findByProductId(productId);
                
                if (prodotto != null) {
                    prodotto.setName(request.getParameter("name"));
                    prodotto.setDescription(request.getParameter("description"));
                    prodotto.setPrice(new BigDecimal(request.getParameter("price")));
                    prodotto.setStockQuantity(Integer.parseInt(request.getParameter("stockQuantity")));
                    prodotto.setCategory(request.getParameter("category"));
                    
                    // Gestisci immagine solo se fornita
                    String imageUrl = request.getParameter("image");
                    if (imageUrl != null && !imageUrl.trim().isEmpty()) {
                        prodotto.setImageUrl(imageUrl);
                    }
                    
                    prodottoDAO.updateProduct(prodotto);
                    request.setAttribute("successMessage", "Prodotto aggiornato correttamente.");
                }
                
            } else if ("updateStock".equals(action)) {
                // Aggiorna solo lo stock
                int productId = Integer.parseInt(request.getParameter("productId"));
                int newStock = Integer.parseInt(request.getParameter("stockQuantity"));
                
                Product prodotto = prodottoDAO.findByProductId(productId);
                if (prodotto != null) {
                    prodotto.setStockQuantity(newStock);
                    prodottoDAO.updateProduct(prodotto);
                    
                    // Risposta JSON per AJAX
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write("{\"success\": true, \"message\": \"Stock aggiornato correttamente.\"}");
                    return;
                } else {
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write("{\"success\": false, \"error\": \"Prodotto non trovato.\"}");
                    return;
                }
                
            } else if ("delete".equals(action)) {
                // Elimina prodotto
                int productId = Integer.parseInt(request.getParameter("productId"));
                prodottoDAO.delete(productId);
                
                // Risposta JSON per AJAX
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\": true, \"message\": \"Prodotto eliminato correttamente.\"}");
                return;
            }

            response.sendRedirect("AdminProductServlet");
        } catch (Exception e) {
            logger.severe("Errore durante l'operazione sul prodotto: " + e.getMessage());
            
            // Se è una richiesta AJAX, restituisci JSON
            if (action != null && (action.equals("updateStock") || action.equals("delete") || action.equals("add"))) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\": false, \"error\": \"Errore durante l'operazione sul prodotto\"}");
                return;
            }
            
            request.setAttribute("errorMessage", "Errore durante l'operazione sul prodotto");
            request.getRequestDispatcher("/jsp/error.jsp").forward(request, response);
        }
    }

    private boolean isAdminLoggedIn(HttpSession session) {
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
        return isAdmin != null && isAdmin && isLoggedIn != null && isLoggedIn;
    }

    private boolean isValidToken(HttpServletRequest request, HttpSession session) {
        String sessionToken = (String) session.getAttribute("csrfToken");
        String requestToken = request.getParameter("csrfToken");
        
        logger.info("=== DEBUG CSRF TOKEN ===");
        logger.info("Session ID: " + (session != null ? session.getId() : "null"));
        logger.info("Session Token: " + sessionToken);
        logger.info("Request Token: " + requestToken);
        logger.info("Session is new: " + (session != null ? session.isNew() : "null"));
        logger.info("Session creation time: " + (session != null ? new java.util.Date(session.getCreationTime()) : "null"));
        logger.info("Session last accessed: " + (session != null ? new java.util.Date(session.getLastAccessedTime()) : "null"));
        logger.info("Session max inactive interval: " + (session != null ? session.getMaxInactiveInterval() : "null"));
        
        // Se non c'è token nella sessione, proviamo a generarlo
        if (sessionToken == null && session != null) {
            logger.warning("Token CSRF mancante nella sessione, generazione nuovo token");
            String newToken = java.util.UUID.randomUUID().toString();
            session.setAttribute("csrfToken", newToken);
            sessionToken = newToken;
            logger.info("Nuovo token generato: " + newToken);
        }
        
        boolean isValid = sessionToken != null && sessionToken.equals(requestToken);
        logger.info("Token CSRF valido: " + isValid);
        logger.info("=== FINE DEBUG CSRF TOKEN ===");
        
        return isValid;
    }
}
