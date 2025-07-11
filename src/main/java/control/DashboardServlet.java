package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Order;
import dao.ProductDAO;
import dao.OrderDAO;
import dao.UserDAO;
import java.util.logging.Logger;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/DashboardServlet")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(DashboardServlet.class.getName());

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (!isAdminLoggedIn(session)) {
            response.sendRedirect("../login.jsp");
            return;
        }

        try {
            ProductDAO prodottoDAO = new ProductDAO();
            OrderDAO ordineDAO = new OrderDAO();
            UserDAO utenteDAO = new UserDAO();

            int totaleProdotti = prodottoDAO.countAll();
            int totaleOrdini = ordineDAO.countAll();
            int totaleUtenti = utenteDAO.countAll();
            double ricaviTotali = ordineDAO.getTotalRevenue();
            List<Map<String, Object>> prodottiTopSelling = prodottoDAO.getTopSellingProducts(5);
            List<Order> ordiniRecenti = ordineDAO.getRecentOrders(10);

            request.setAttribute("totaleProdotti", totaleProdotti);
            request.setAttribute("totaleOrdini", totaleOrdini);
            request.setAttribute("totaleUtenti", totaleUtenti);
            request.setAttribute("ricaviTotali", ricaviTotali);
            request.setAttribute("prodottiTopSelling", prodottiTopSelling);
            request.setAttribute("ordiniRecenti", ordiniRecenti);

            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            logger.severe("Errore nel caricamento della dashboard" + e.getMessage());
            response.sendRedirect("../error.jsp");
        }
    }

    private boolean isAdminLoggedIn(HttpSession session) {
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
        return isAdmin != null && isAdmin && isLoggedIn != null && isLoggedIn;
    }
}
