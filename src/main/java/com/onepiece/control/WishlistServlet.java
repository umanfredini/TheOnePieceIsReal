package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.dao.WishlistDAO;
import model.bean.Utente;
import model.bean.Prodotto;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.List;

@WebServlet("/WishlistServlet")
public class WishlistServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = LoggerFactory.getLogger(WishlistServlet.class);

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        if (!isUserLoggedIn(session)) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            Utente utente = (Utente) session.getAttribute("utente");
            WishlistDAO wishlistDAO = new WishlistDAO();
            List<Prodotto> wishlist = wishlistDAO.doRetrieveByUtente(utente.getId());

            request.setAttribute("wishlist", wishlist);
            request.getRequestDispatcher("wishlist.jsp").forward(request, response);
        } catch (Exception e) {
            logger.error("Errore nel caricamento della wishlist", e);
            response.sendRedirect("error.jsp");
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
                response.sendRedirect("login.jsp");
            }
            return;
        }

        try {
            Utente utente = (Utente) session.getAttribute("utente");
            int prodottoId = Integer.parseInt(request.getParameter("prodottoId"));
            String action = request.getParameter("action");

            WishlistDAO wishlistDAO = new WishlistDAO();

            if ("add".equals(action)) {
                wishlistDAO.addToWishlist(utente.getId(), prodottoId);
            } else if ("remove".equals(action)) {
                wishlistDAO.removeFromWishlist(utente.getId(), prodottoId);
            }

            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": true}");
            } else {
                response.sendRedirect("WishlistServlet");
            }
        } catch (Exception e) {
            logger.error("Errore nella modifica della wishlist", e);
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"error\": \"Errore interno\"}");
            } else {
                response.sendRedirect("error.jsp");
            }
        }
    }

    private boolean isUserLoggedIn(HttpSession session) {
        Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
        return isLoggedIn != null && isLoggedIn;
    }
}
