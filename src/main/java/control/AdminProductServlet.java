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
            response.sendRedirect("LoginServlet");
            return;
        }

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
        HttpSession session = request.getSession(false);

        if (!isValidToken(request, session)) {
            // Se è una richiesta AJAX, restituisci JSON
            String action = request.getParameter("action");
            if (action != null && (action.equals("updateStock") || action.equals("delete"))) {
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
            if (action != null && (action.equals("updateStock") || action.equals("delete"))) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\": false, \"error\": \"Sessione non valida\"}");
                return;
            }
            response.sendRedirect("LoginServlet");
            return;
        }

        String action = request.getParameter("action");
        logger.info("AdminProductServlet doPost - Action: " + action);
        
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
            if (action != null && (action.equals("updateStock") || action.equals("delete"))) {
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
        return sessionToken != null && sessionToken.equals(requestToken);
    }
}
