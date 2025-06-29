package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.dao.UtenteDAO;
import model.bean.Utente;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

@WebServlet("/ProfileServlet")
public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = LoggerFactory.getLogger(ProfileServlet.class);

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
            Utente utente = (Utente) session.getAttribute("utente");

            utente.setNome(request.getParameter("nome"));
            utente.setCognome(request.getParameter("cognome"));
            utente.setTelefono(request.getParameter("telefono"));
            utente.setIndirizzo(request.getParameter("indirizzo"));
            utente.setCitta(request.getParameter("citta"));
            utente.setCap(request.getParameter("cap"));

            String avatar = request.getParameter("avatar");
            if (avatar != null && !avatar.isEmpty()) {
                utente.setAvatar(avatar);
            }

            UtenteDAO utenteDAO = new UtenteDAO();
            boolean success = utenteDAO.doUpdate(utente);

            if (success) {
                session.setAttribute("utente", utente);
                request.setAttribute("successMessage", "Profilo aggiornato con successo!");
            } else {
                request.setAttribute("errorMessage", "Errore durante l'aggiornamento del profilo");
            }

            request.getRequestDispatcher("profilo.jsp").forward(request, response);
        } catch (Exception e) {
            logger.error("Errore durante l'aggiornamento del profilo", e);
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
