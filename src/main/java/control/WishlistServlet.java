package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import dao.WishlistDAO;
import model.User;
import model.Product;
import java.util.logging.Logger;

import java.io.IOException;
import java.util.List;

// @WebServlet("/WishlistServlet")
public class WishlistServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(WishlistServlet.class.getName());

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        if (!isUserLoggedIn(session)) {
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"error\": \"Non autenticato\"}");
            } else {
                // Mostra avviso e reindirizza alla pagina di login
                session.setAttribute("warningMessage", "Per accedere alla wishlist devi essere loggato");
                response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            }
            return;
        }

        try {
            User utente = (User) session.getAttribute("utente");
            logger.info("WishlistServlet - Utente: " + (utente != null ? utente.getEmail() : "null"));
            logger.info("WishlistServlet - User ID: " + (utente != null ? utente.getId() : "null"));
            
            if (utente == null) {
                logger.warning("WishlistServlet - Utente non trovato in sessione");
                if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                    response.setContentType("application/json");
                    response.getWriter().write("{\"success\": false, \"error\": \"Sessione scaduta\"}");
                } else {
                    session.setAttribute("errorMessage", "Sessione scaduta. Effettua nuovamente il login.");
                    response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
                }
                return;
            }
            
            WishlistDAO wishlistDAO = new WishlistDAO();
            List<Product> wishlist = wishlistDAO.findProductsByUserId(utente.getId());
            logger.info("WishlistServlet - Prodotti trovati: " + wishlist.size());

            // Se è una richiesta AJAX, restituisci JSON
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                
                // Serializzazione JSON manuale
                StringBuilder json = new StringBuilder();
                json.append("{\"success\": true, \"wishlist\": [");
                
                for (int i = 0; i < wishlist.size(); i++) {
                    Product product = wishlist.get(i);
                    if (i > 0) json.append(",");
                    json.append("{");
                    json.append("\"id\": ").append(product.getId()).append(",");
                    json.append("\"name\": \"").append(escapeJson(product.getName())).append("\",");
                    json.append("\"price\": ").append(product.getPrice()).append(",");
                    json.append("\"imageUrl\": \"").append(escapeJson(product.getImageUrl())).append("\",");
                    json.append("\"category\": \"").append(escapeJson(product.getCategory())).append("\"");
                    json.append("}");
                }
                
                json.append("]}");
                response.getWriter().write(json.toString());
            } else {
                // Altrimenti forward alla pagina JSP
                request.setAttribute("wishlist", wishlist);
                request.getRequestDispatcher("/jsp/wishlist.jsp").forward(request, response);
            }
        } catch (Exception e) {
            logger.severe("Errore nel caricamento della wishlist: " + e.getMessage());
            e.printStackTrace();
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"error\": \"Errore nel caricamento della wishlist\"}");
            } else {
                request.setAttribute("errorMessage", "Errore nel caricamento della wishlist: " + e.getMessage());
                request.getRequestDispatcher("/jsp/error.jsp").forward(request, response);
            }
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        if (!isUserLoggedIn(session)) {
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"error\": \"Per accedere alla wishlist devi essere loggato\"}");
            } else {
                session.setAttribute("warningMessage", "Per accedere alla wishlist devi essere loggato");
                response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            }
            return;
        }

        try {
            User utente = (User) session.getAttribute("utente");
            
            // Controllo aggiuntivo per admin - gli admin non possono usare la wishlist
            Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
            if (isAdmin != null && isAdmin) {
                if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                    response.setContentType("application/json");
                    response.getWriter().write("{\"success\": false, \"error\": \"Gli amministratori non possono utilizzare la wishlist\"}");
                } else {
                    response.sendRedirect(request.getContextPath() + "/jsp/error.jsp?message=Gli amministratori non possono utilizzare la wishlist");
                }
                return;
            }
            
            // Supporta entrambi i formati di parametro
            String productIdStr = request.getParameter("productId");
            if (productIdStr == null) {
                productIdStr = request.getParameter("prodottoId");
            }
            
            int prodottoId = Integer.parseInt(productIdStr);
            String action = request.getParameter("action");

            WishlistDAO wishlistDAO = new WishlistDAO();

            if ("add".equals(action)) {
                wishlistDAO.add(utente.getId(), prodottoId);
            } else if ("remove".equals(action)) {
                wishlistDAO.remove(utente.getId(), prodottoId);
            } else if ("toggle".equals(action)) {
                // Controlla se il prodotto è già nella wishlist
                boolean isInWishlist = wishlistDAO.exists(utente.getId(), prodottoId);
                if (isInWishlist) {
                    wishlistDAO.remove(utente.getId(), prodottoId);
                } else {
                    wishlistDAO.add(utente.getId(), prodottoId);
                }
                
                if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write("{\"success\": true, \"inWishlist\": " + !isInWishlist + "}");
                    return;
                }
            }

            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\": true}");
            } else {
                response.sendRedirect("WishlistServlet");
            }
        } catch (Exception e) {
            logger.severe("Errore nella modifica della wishlist: " + e.getMessage());
            logger.severe("Errore nel WishlistServlet: " + e.getMessage());
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"success\": false, \"error\": \"" + e.getMessage() + "\"}");
            } else {
            	request.getRequestDispatcher("/jsp/error.jsp").forward(request, response);
            }
        }
    }

    private boolean isUserLoggedIn(HttpSession session) {
        User utente = (User) session.getAttribute("utente");
        return utente != null;
    }
    
    private String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\b", "\\b")
                   .replace("\f", "\\f")
                   .replace("\n", "\\n")
                   .replace("\r", "\\r")
                   .replace("\t", "\\t");
    }
}
