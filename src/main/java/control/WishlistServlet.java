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

@WebServlet("/WishlistServlet")
public class WishlistServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(WishlistServlet.class.getName());

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        if (!isUserLoggedIn(session)) {
            response.sendRedirect("/WEB-INF/jsp/login.jsp");
            return;
        }

        try {
            User utente = (User) session.getAttribute("utente");
            WishlistDAO wishlistDAO = new WishlistDAO();
            List<Product> wishlist = wishlistDAO.findProductsByUserId(utente.getId());

            request.setAttribute("wishlist", wishlist);
            request.getRequestDispatcher("/WEB-INF/jsp/wishlist.jsp").forward(request, response);
        } catch (Exception e) {
            logger.severe("Errore nel caricamento della wishlist" + e.getMessage());
            response.sendRedirect("/WEB-INF/jsp/error.jsp");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        if (!isUserLoggedIn(session)) {
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"error\": \"Non autenticato\"}");
            } else {
                response.sendRedirect("/WEB-INF/jsp/login.jsp");
            }
            return;
        }

        try {
            User utente = (User) session.getAttribute("utente");
            int prodottoId = Integer.parseInt(request.getParameter("prodottoId"));
            String action = request.getParameter("action");

            WishlistDAO wishlistDAO = new WishlistDAO();

            if ("add".equals(action)) {
                wishlistDAO.add(utente.getId(), prodottoId);
            } else if ("remove".equals(action)) {
                wishlistDAO.remove(utente.getId(), prodottoId);
            }

            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": true}");
            } else {
                response.sendRedirect("WishlistServlet");
            }
        } catch (Exception e) {
            logger.severe("Errore nella modifica della wishlist" + e.getMessage());
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"error\": \"Errore interno\"}");
            } else {
            	request.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(request, response);
            }
        }
    }

    private boolean isUserLoggedIn(HttpSession session) {
        Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
        return isLoggedIn != null && isLoggedIn;
    }
}
