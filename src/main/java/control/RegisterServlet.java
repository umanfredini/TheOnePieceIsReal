package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import dao.UserDAO;
import model.User;
import java.util.logging.Logger;
import java.io.IOException;
import java.security.MessageDigest;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(RegisterServlet.class.getName());

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/jsp/register.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String nome = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String indirizzo = request.getParameter("indirizzo");
        
        try {
            UserDAO utenteDAO = new UserDAO();

            if (utenteDAO.emailExists(email)) {
                request.setAttribute("errorMessage", "Email già registrata!");
                request.getRequestDispatcher("/WEB-INF/jsp/register.jsp").forward(request, response);
                return;
            }

            User utente = new User();
            utente.setUsername(nome);
            utente.setEmail(email);
            utente.setPasswordHash(hashPassword(password));
            utente.setShippingAddress(indirizzo);

            boolean success = utenteDAO.create(utente);

            if (success) {
            	if (success) {
            	    HttpSession session = request.getSession();
            	    session.setAttribute("utente", utente);
            	    session.setAttribute("isLoggedIn", true);
            	    session.setAttribute("isAdmin", false);
            	    session.setAttribute("token", generateToken());
            	    request.getRequestDispatcher("/WEB-INF/jsp/profile.jsp").forward(request, response);
            	}
            } else {
                request.setAttribute("errorMessage", "Errore durante la registrazione");
                request.getRequestDispatcher("/WEB-INF/jsp/register.jsp").forward(request, response);
            }
        } catch (Exception e) {
            logger.severe("Errore durante la registrazione" + e.getMessage());
            request.setAttribute("errorMessage", "Errore interno del server");
            request.getRequestDispatcher("/WEB-INF/jsp/register.jsp").forward(request, response);
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
        return java.util.UUID.randomUUID().toString();
    }

}
