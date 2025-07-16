package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Order;
import dao.OrderDAO;
import java.util.logging.Logger;
import java.sql.Date;


import java.io.IOException;
import java.util.List;

@WebServlet("/AdminOrderServlet")
public class AdminOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(AdminOrderServlet.class.getName());

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (!isAdminLoggedIn(session)) {
            response.sendRedirect("/WEB-INF/jsp/login.jsp");
            return;
        }

        try {
            String dataInizioStr = request.getParameter("dataInizio");
            String dataFineStr = request.getParameter("dataFine");
            String clienteId = request.getParameter("clienteId");

            OrderDAO ordineDAO = new OrderDAO(null);
            List<Order> ordini;

            if (dataInizioStr != null && dataFineStr != null) {
                Date dataInizio = Date.valueOf(dataInizioStr); // formato: yyyy-MM-dd
                Date dataFine = Date.valueOf(dataFineStr);
                ordini = ordineDAO.findByDateRange(dataInizio, dataFine);
            } else if (clienteId != null && !clienteId.isEmpty()) {
                ordini = ordineDAO.findByUserId(Integer.parseInt(clienteId));
            } else {
                ordini = ordineDAO.findAll();
            }

            request.setAttribute("ordini", ordini);
            request.getRequestDispatcher("/WEB-INF/jsp/orders.jsp").forward(request, response);
        } catch (Exception e) {
            logger.severe("Errore nella gestione ordini admin: " + e.getMessage());
            response.sendRedirect("/WEB-INF/jsp/error.jsp");
        }
    }


    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (!isValidToken(request, session)) {
            response.sendRedirect("/WEB-INF/jsp/error.jsp");
            return;
        }

        if (!isAdminLoggedIn(session)) {
            response.sendRedirect("/WEB-INF/jsp/login.jsp");
            return;
        }

        try {
            int ordineId = Integer.parseInt(request.getParameter("ordineId"));
            String nuovoStato = request.getParameter("stato");

            OrderDAO ordineDAO = new OrderDAO(null);
            ordineDAO.updateStato(ordineId, nuovoStato);

            response.sendRedirect("AdminOrderServlet");
        } catch (Exception e) {
            logger.severe("Errore nell'aggiornamento stato ordine" + e.getMessage());
            response.sendRedirect("/WEB-INF/jsp/error.jsp");
        }
    }

    private boolean isAdminLoggedIn(HttpSession session) {
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
        return isAdmin != null && isAdmin && isLoggedIn != null && isLoggedIn;
    }

    private boolean isValidToken(HttpServletRequest request, HttpSession session) {
        String sessionToken = (String) session.getAttribute("token");
        String requestToken = request.getParameter("token");
        return sessionToken != null && sessionToken.equals(requestToken);
    }
}
