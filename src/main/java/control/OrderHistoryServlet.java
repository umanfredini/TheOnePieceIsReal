package control;

import dao.OrderDAO;
import model.Order;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/OrderHistoryServlet")
public class OrderHistoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Integer userId = (Integer) request.getSession().getAttribute("userId");

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
		try {
			OrderDAO ordine = new OrderDAO();
			List<Order> orders = ordine.findByUserId(userId);
			request.setAttribute("orders", orders);
			request.getRequestDispatcher("/WEB-INF/jsp/order-history.jsp").forward(request, response);
		} catch (SQLException e) {
			request.setAttribute("errorMessage", "Errore interno del server");
            request.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(request, response);
		}
        
    }
}