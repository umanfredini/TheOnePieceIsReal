package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Product;
import dao.ProductDAO;
import java.util.logging.Logger;

import java.io.IOException;

// @WebServlet("/CheckAvailabilityServlet")
public class CheckAvailabilityServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(CheckAvailabilityServlet.class.getName());

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int prodottoId = Integer.parseInt(request.getParameter("prodottoId"));
            int quantitaRichiesta = Integer.parseInt(request.getParameter("quantita"));

            ProductDAO prodottoDAO = new ProductDAO();
            Product prodotto = prodottoDAO.findByProductId(prodottoId);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            if (prodotto != null && prodotto.getStockQuantity() >= quantitaRichiesta) {
                response.getWriter().write("{\"available\": true, \"stock\": " + prodotto.getStockQuantity() + "}");
            } else {
                int stockDisponibile = (prodotto != null) ? prodotto.getStockQuantity() : 0;
                response.getWriter().write("{\"available\": false, \"stock\": " + stockDisponibile + "}");
            }
        } catch (Exception e) {
            logger.severe("Errore nel controllo disponibilità" + e.getMessage());
            response.setContentType("application/json");
            response.getWriter().write("{\"error\": \"Errore nel controllo disponibilità\"}");
        }
    }
}
