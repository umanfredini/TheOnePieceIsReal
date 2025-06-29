package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.dao.UtenteDAO;
import model.bean.Utente;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.List;

@WebServlet("/AdminUserServlet")
public class AdminUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = LoggerFactory.getLogger(AdminUserServlet.class);

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (!isAdminLoggedIn(session)) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        try {
            UtenteDAO utenteDAO = new UtenteDAO();

            if ("detail".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Utente utente = utenteDAO.doRetrieveByKey(id);
                request.setAttribute("utente", utente);
                request.getRequestDispatcher("user-detail.jsp").forward(request, response);
            } else if ("toggle".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                utenteDAO.toggleUserStatus(id);
                response.sendRedirect("AdminUserServlet");
            } else {
                List<Utente> utenti = utenteDAO.doRetrieveAll();
                request.setAttribute("utenti", utenti);
                request.getRequestDispatcher("users.jsp").forward(request, response);
            }
        } catch (Exception e) {
            logger.error("Errore nella gestione utenti admin", e);
            response.sendRedirect("error.jsp");
        }
    }

    private boolean isAdminLoggedIn(HttpSession session) {
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
        return isAdmin != null && isAdmin && isLoggedIn != null && isLoggedIn;
    }
}
