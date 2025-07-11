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
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String nome = request.getParameter("nome");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String indirizzo = request.getParameter("indirizzo");
        
        try {
            UserDAO utenteDAO = new UserDAO();

            if (utenteDAO.emailExists(email)) {
                request.setAttribute("errorMessage", "Email già registrata!");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            User utente = new User();
            utente.setUsername(nome);
            utente.setEmail(email); 
            utente.setShippingAddress(indirizzo);

            boolean success = utenteDAO.create(utente);

            if (success) {
                request.setAttribute("successMessage", "Registrazione completata! Effettua il login.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Errore durante la registrazione");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }
        } catch (Exception e) {
            logger.severe("Errore durante la registrazione" + e.getMessage());
            request.setAttribute("errorMessage", "Errore interno del server");
            request.getRequestDispatcher("register.jsp").forward(request, response);
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
}
