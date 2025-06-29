package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.dao.ProdottoDAO;
import model.bean.Prodotto;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

@WebServlet("/CheckAvailabilityServlet")
public class CheckAvailabilityServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = LoggerFactory.getLogger(CheckAvailabilityServlet.class);

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int prodottoId = Integer.parseInt(request.getParameter("prodottoId"));
            int quantitaRichiesta = Integer.parseInt(request.getParameter("quantita"));

            ProdottoDAO prodottoDAO = new ProdottoDAO();
            Prodotto prodotto = prodottoDAO.doRetrieveByKey(prodottoId);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            if (prodotto != null && prodotto.getQuantita() >= quantitaRichiesta) {
                response.getWriter().write("{\"available\": true, \"stock\": " + prodotto.getQuantita() + "}");
            } else {
                int stockDisponibile = (prodotto != null) ? prodotto.getQuantita() : 0;
                response.getWriter().write("{\"available\": false, \"stock\": " + stockDisponibile + "}");
            }
        } catch (Exception e) {
            logger.error("Errore nel controllo disponibilità", e);
            response.setContentType("application/json");
            response.getWriter().write("{\"error\": \"Errore nel controllo disponibilità\"}");
        }
    }
}
