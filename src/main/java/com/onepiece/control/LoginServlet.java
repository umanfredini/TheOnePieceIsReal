package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.dao.UtenteDAO;
import model.bean.Utente;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.security.MessageDigest;
import java.util.UUID;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = LoggerFactory.getLogger(LoginServlet.class);

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            UtenteDAO utenteDAO = new UtenteDAO();
            Utente utente = utenteDAO.doRetrieveByEmailPassword(email, hashPassword(password));

            if (utente != null) {
                HttpSession session = request.getSession();
                String token = generateToken();

                session.setAttribute("utente", utente);
                session.setAttribute("token", token);
                session.setAttribute("isLoggedIn", true);

                if (utente.isAdmin()) {
                    session.setAttribute("isAdmin", true);
                    response.sendRedirect("admin/dashboard.jsp");
                } else {
                    response.sendRedirect("profilo.jsp");
                }
            } else {
                request.setAttribute("errorMessage", "Email o password non corretti!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            logger.error("Errore durante il login", e);
            request.setAttribute("errorMessage", "Errore interno del server");
            request.getRequestDispatcher("login.jsp").forward(request, response);
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
