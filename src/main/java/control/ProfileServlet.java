package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.User;
import dao.UserDAO;
import java.util.logging.Logger;

import java.io.IOException;

@WebServlet("/ProfileServlet")
public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(ProfileServlet.class.getName());

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (!isUserLoggedIn(session)) {
            response.sendRedirect("login.jsp");
            return;
        }

        request.getRequestDispatcher("profilo.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (!isValidToken(request, session)) {
            response.sendRedirect("error.jsp");
            return;
        }

        if (!isUserLoggedIn(session)) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            User utente = (User) session.getAttribute("utente");

            utente.setUsername(request.getParameter("nome"));
            utente.setShippingAddress(request.getParameter("indirizzo"));
            String avatar = request.getParameter("avatar");
            if (avatar != null && !avatar.isEmpty()) {
                utente.setAvatar(avatar);
            }

            UserDAO utenteDAO = new UserDAO();
            boolean success = utenteDAO.update(utente);

            if (success) {
                session.setAttribute("utente", utente);
                request.setAttribute("successMessage", "Profilo aggiornato con successo!");
            } else {
                request.setAttribute("errorMessage", "Errore durante l'aggiornamento del profilo");
            }

            request.getRequestDispatcher("profilo.jsp").forward(request, response);
        } catch (Exception e) {
            logger.severe("Errore durante l'aggiornamento del profilo" + e.getMessage());
            request.setAttribute("errorMessage", "Errore interno del server");
            request.getRequestDispatcher("profilo.jsp").forward(request, response);
        }
    }

    private boolean isUserLoggedIn(HttpSession session) {
        Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
        return isLoggedIn != null && isLoggedIn;
    }

    private boolean isValidToken(HttpServletRequest request, HttpSession session) {
        String sessionToken = (String) session.getAttribute("token");
        String requestToken = request.getParameter("token");
        return sessionToken != null && sessionToken.equals(requestToken);
    }
}
