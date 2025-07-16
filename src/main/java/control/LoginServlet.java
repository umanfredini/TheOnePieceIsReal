package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.User;
import dao.UserDAO;
import java.util.logging.Logger;

import java.io.IOException;
import java.security.MessageDigest;
import java.util.UUID;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(LoginServlet.class.getName());

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            UserDAO utenteDAO = new UserDAO();
            User utente = utenteDAO.findByEmailPassword(email, hashPassword(password));

            if (utente != null) {
                HttpSession session = request.getSession();
                String token = generateToken();

                session.setAttribute("utente", utente);
                session.setAttribute("token", token);
                session.setAttribute("isLoggedIn", true);

                if (utente.isAdmin()) {
                    session.setAttribute("isAdmin", true);
                    response.sendRedirect("/WEB-INF/jsp/adminDashboard.jsp");
                } else {
                    response.sendRedirect("/WEB-INF/jsp/profilo.jsp");
                }
            } else {
                request.setAttribute("errorMessage", "Email o password non corretti!");
                request.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            logger.severe("Errore durante il login" + e.getMessage());
            request.setAttribute("errorMessage", "Errore interno del server");
            request.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(request, response);
        }
    }

    private String hashPassword(String password) throws Exception {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hash = md.digest(password.getBytes("UTF-8"));
        StringBuilder sb = new StringBuilder();
        for (byte b : hash) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }

    private String generateToken() {
        return UUID.randomUUID().toString();
    }
}
