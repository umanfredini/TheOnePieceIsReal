package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.dao.ProdottoDAO;
import model.bean.Prodotto;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.List;

@WebServlet("/SearchAjaxServlet")
public class SearchAjaxServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = LoggerFactory.getLogger(SearchAjaxServlet.class);

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String query = request.getParameter("q");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (query == null || query.trim().isEmpty()) {
            response.getWriter().write("{\"results\": []}");
            return;
        }

        try {
            ProdottoDAO prodottoDAO = new ProdottoDAO();
            List<Prodotto> risultati = prodottoDAO.doRetrieveBySearch(query);

            StringBuilder json = new StringBuilder();
            json.append("{\"results\": [");

            for (int i = 0; i < risultati.size(); i++) {
                Prodotto p = risultati.get(i);
                if (i > 0) json.append(",");
                json.append("{")
                        .append("\"id\": ").append(p.getId()).append(",")
                        .append("\"nome\": \"").append(p.getNome().replace("\"", "\\\"")).append("\",")
                        .append("\"prezzo\": ").append(p.getPrezzo()).append(",")
                        .append("\"immagine\": \"").append(p.getImmagine()).append("\"")
                        .append("}");
            }

            json.append("]}");
            response.getWriter().write(json.toString());
        } catch (Exception e) {
            logger.error("Errore nella ricerca AJAX", e);
            response.getWriter().write("{\"error\": \"Errore nella ricerca\"}");
        }
    }
}
