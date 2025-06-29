package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.dao.ProdottoDAO;
import model.dao.OrdineDAO;
import model.dao.UtenteDAO;
import model.bean.Ordine;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/DashboardServlet")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = LoggerFactory.getLogger(DashboardServlet.class);

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (!isAdminLoggedIn(session)) {
            response.sendRedirect("../login.jsp");
            return;
        }

        try {
            ProdottoDAO prodottoDAO = new ProdottoDAO();
            OrdineDAO ordineDAO = new OrdineDAO();
            UtenteDAO utenteDAO = new UtenteDAO();

            int totaleProdotti = prodottoDAO.countAll();
            int totaleOrdini = ordineDAO.countAll();
            int totaleUtenti = utenteDAO.countAll();
            double ricaviTotali = ordineDAO.getTotalRevenue();
            List<Map<String, Object>> prodottiTopSelling = prodottoDAO.getTopSellingProducts(5);
            List<Ordine> ordiniRecenti = ordineDAO.getRecentOrders(10);

            request.setAttribute("totaleProdotti", totaleProdotti);
            request.setAttribute("totaleOrdini", totaleOrdini);
            request.setAttribute("totaleUtenti", totaleUtenti);
            request.setAttribute("ricaviTotali", ricaviTotali);
            request.setAttribute("prodottiTopSelling", prodottiTopSelling);
            request.setAttribute("ordiniRecenti", ordiniRecenti);

            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            logger.error("Errore nel caricamento della dashboard", e);
            response.sendRedirect("../error.jsp");
        }
    }

    private boolean isAdminLoggedIn(HttpSession session) {
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
        return isAdmin != null && isAdmin && isLoggedIn != null && isLoggedIn;
    }
}
