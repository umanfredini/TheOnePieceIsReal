package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Order;
import model.OrderItem;
import model.User;
import dao.OrderDAO;
import dao.OrderItemDAO;
import java.util.logging.Logger;

import java.io.IOException;
import java.util.List;

// @WebServlet("/OrderServlet")
public class OrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(OrderServlet.class.getName());

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (!isUserLoggedIn(session)) {
            response.sendRedirect("/login");
            return;
        }

        String action = request.getParameter("action");
        
        try {
            User utente = (User) session.getAttribute("utente");
            OrderDAO ordineDAO = new OrderDAO();
            
            if ("detail".equals(action)) {
                // Gestione dettagli ordine
                String orderIdParam = request.getParameter("orderId");
                if (orderIdParam != null && !orderIdParam.isEmpty()) {
                    try {
                        int orderId = Integer.parseInt(orderIdParam);
                        Order order = ordineDAO.findByOrderId(orderId);
                        
                        // Verifica che l'ordine appartenga all'utente loggato
                        if (order != null && order.getUserId() == utente.getId()) {
                            // Recupera gli elementi dell'ordine
                            OrderItemDAO orderItemDAO = new OrderItemDAO();
                            List<OrderItem> orderItems = orderItemDAO.findByOrderId(orderId);
                            
                            request.setAttribute("order", order);
                            request.setAttribute("orderItems", orderItems);
                            request.getRequestDispatcher("/jsp/order-detail.jsp").forward(request, response);
                            return;
                        } else {
                            request.setAttribute("errorMessage", "Ordine non trovato o accesso negato.");
                            request.getRequestDispatcher("/jsp/error.jsp").forward(request, response);
                            return;
                        }
                    } catch (NumberFormatException e) {
                        request.setAttribute("errorMessage", "ID ordine non valido.");
                        request.getRequestDispatcher("/jsp/error.jsp").forward(request, response);
                        return;
                    }
                }
            }
            
            // Lista ordini (comportamento di default)
            List<Order> ordini = ordineDAO.findByUserId(utente.getId());
            request.setAttribute("ordini", ordini);
            request.getRequestDispatcher("/jsp/orders.jsp").forward(request, response);
        } catch (Exception e) {
            logger.severe("Errore nel recupero degli ordini utente" + e.getMessage());
            request.setAttribute("errorMessage", "Errore durante la creazione dell'ordine. Riprova.");
            request.getRequestDispatcher("/jsp/error.jsp").forward(request, response);
        }
    }

    private boolean isUserLoggedIn(HttpSession session) {
        Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
        return isLoggedIn != null && isLoggedIn;
    }
}
