package control;

import dao.OrderDAO;
import model.Order;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

// @WebServlet("/OrderHistoryServlet")
public class OrderHistoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User utente = (User) request.getSession().getAttribute("utente");
        Integer userId = utente != null ? utente.getId() : null;

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }
        
        try {
            OrderDAO ordine = new OrderDAO();
            List<Order> orders = ordine.findByUserId(userId);
            request.setAttribute("orders", orders);
            request.getRequestDispatcher("/jsp/order-history.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Errore interno del server");
            request.getRequestDispatcher("/jsp/error.jsp").forward(request, response);
        }
        
    }
}