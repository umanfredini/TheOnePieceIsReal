package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.User;
import dao.UserDAO;
import java.util.logging.Logger;

import java.io.IOException;
import java.security.MessageDigest;

// @WebServlet("/ProfileServlet")
public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(ProfileServlet.class.getName());

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (!isUserLoggedIn(session)) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        // Controlla se l'utente è admin e reindirizza alla dashboard
        User utente = (User) session.getAttribute("utente");
        if (utente != null && utente.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/DashboardServlet");
            return;
        }

        request.getRequestDispatcher("/jsp/profile.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (!isUserLoggedIn(session)) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        try {
            User utente = (User) session.getAttribute("utente");
            UserDAO utenteDAO = new UserDAO();
            boolean hasChanges = false;

            // Gestione username (opzionale)
            String newUsername = request.getParameter("username");
            if (newUsername != null && !newUsername.trim().isEmpty() && !newUsername.equals(utente.getUsername())) {
                utente.setUsername(newUsername.trim());
                hasChanges = true;
            }

            // Gestione password (opzionale)
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");
            
            if (currentPassword != null && !currentPassword.isEmpty() && 
                newPassword != null && !newPassword.isEmpty() && 
                confirmPassword != null && !confirmPassword.isEmpty()) {
                
                // Verifica che la password attuale sia corretta
                String currentPasswordHash = hashPassword(currentPassword);
                if (!currentPasswordHash.equals(utente.getPasswordHash())) {
                    request.setAttribute("errorMessage", "Password attuale non corretta");
                    request.getRequestDispatcher("/jsp/profile.jsp").forward(request, response);
                    return;
                }
                
                // Verifica che le nuove password coincidano
                if (!newPassword.equals(confirmPassword)) {
                    request.setAttribute("errorMessage", "Le nuove password non coincidono");
                    request.getRequestDispatcher("/jsp/profile.jsp").forward(request, response);
                    return;
                }
                
                // Verifica che la nuova password sia diversa da quella attuale
                if (currentPassword.equals(newPassword)) {
                    request.setAttribute("errorMessage", "La nuova password deve essere diversa da quella attuale");
                    request.getRequestDispatcher("/jsp/profile.jsp").forward(request, response);
                    return;
                }
                
                // Imposta la nuova password
                utente.setPasswordHash(hashPassword(newPassword));
                hasChanges = true;
            }

            // Gestione indirizzo di spedizione (opzionale)
            String newShippingAddress = request.getParameter("shippingAddress");
            if (newShippingAddress != null && !newShippingAddress.trim().isEmpty() && 
                !newShippingAddress.equals(utente.getShippingAddress())) {
                utente.setShippingAddress(newShippingAddress.trim());
                hasChanges = true;
            }

            // Aggiorna il database solo se ci sono cambiamenti
            if (hasChanges) {
                boolean success = utenteDAO.update(utente);
                if (success) {
                    session.setAttribute("utente", utente);
                    request.setAttribute("successMessage", "Profilo aggiornato con successo!");
                } else {
                    request.setAttribute("errorMessage", "Errore durante l'aggiornamento del profilo");
                }
            } else {
                request.setAttribute("successMessage", "Nessuna modifica effettuata");
            }

            request.getRequestDispatcher("/jsp/profile.jsp").forward(request, response);

        } catch (Exception e) {
            logger.severe("Errore durante l'aggiornamento del profilo: " + e.getMessage());
            request.setAttribute("errorMessage", "Errore interno del server");
            request.getRequestDispatcher("/jsp/profile.jsp").forward(request, response);
        }
    }

    private boolean isUserLoggedIn(HttpSession session) {
        Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
        return isLoggedIn != null && isLoggedIn;
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
