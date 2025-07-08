package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Order;
import model.User;
import dao.OrderDAO;
import java.util.logging.Logger;

import java.io.IOException;
import java.util.List;

@WebServlet("/OrderServlet")
public class OrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(OrderServlet.class.getName());

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (!isUserLoggedIn(session)) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            User utente = (User) session.getAttribute("utente");
            OrderDAO ordineDAO = new OrderDAO();
            List<Order> ordini = ordineDAO.findByUserId(utente.getId());

            request.setAttribute("ordini", ordini);
            request.getRequestDispatcher("orders.jsp").forward(request, response);
        } catch (Exception e) {
            logger.severe("Errore nel recupero degli ordini utente" + e.getMessage());
            response.sendRedirect("error.jsp");
        }
    }

    private boolean isUserLoggedIn(HttpSession session) {
        Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
        return isLoggedIn != null && isLoggedIn;
    }
}
