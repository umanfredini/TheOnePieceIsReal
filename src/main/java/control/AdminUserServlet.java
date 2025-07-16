package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.User;
import dao.UserDAO;
import java.util.logging.Logger;
import java.io.IOException;
import java.util.List;

@WebServlet("/AdminUserServlet")
public class AdminUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(AdminUserServlet.class.getName());

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (!isAdminLoggedIn(session)) {
            response.sendRedirect("/WEB-INF/jsp/login.jsp");
            return;
        }

        String action = request.getParameter("action");

        try {
            UserDAO utenteDAO = new UserDAO();

            if ("detail".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                User utente = utenteDAO.findByUserId(id);
                request.setAttribute("utente", utente);
                request.getRequestDispatcher("/WEB-INF/jsp/user-detail.jsp").forward(request, response);
            } else if ("toggle".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                utenteDAO.toggleUserStatus(id);
                request.setAttribute("successMessage", "Stato utente aggiornato con successo.");
                request.getRequestDispatcher("/WEB-INF/jsp/success.jsp").forward(request, response);
            } else {
                List<User> utenti = utenteDAO.findAll();
                request.setAttribute("utenti", utenti);
                request.getRequestDispatcher("/WEB-INF/jsp/users.jsp").forward(request, response);
            }
        } catch (Exception e) {
            logger.severe("Errore nella gestione utenti admin" + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(request, response);
        }
    }

    private boolean isAdminLoggedIn(HttpSession session) {
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
        return isAdmin != null && isAdmin && isLoggedIn != null && isLoggedIn;
    }
}
