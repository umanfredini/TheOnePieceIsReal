package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import dao.ProductDAO;
import model.Product;
import java.util.logging.Logger;

import java.io.IOException;
import java.util.List;

// @WebServlet("/SearchAjaxServlet")
public class SearchAjaxServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(SearchAjaxServlet.class.getName());

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
            ProductDAO prodottoDAO = new ProductDAO();
            List<Product> risultati = prodottoDAO.findBySearch(query);

            StringBuilder json = new StringBuilder();
            json.append("{\"results\": [");

            for (int i = 0; i < risultati.size(); i++) {
                Product p = risultati.get(i);
                if (i > 0) json.append(",");
                json.append("{")
                        .append("\"id\": ").append(p.getId()).append(",")
                        .append("\"nome\": \"").append(p.getName().replace("\"", "\\\"")).append("\",")
                        .append("\"prezzo\": ").append(p.getPrice()).append(",")
                        .append("\"immagine\": \"").append(p.getImageUrl()).append("\"")
                        .append("}");
            }

            json.append("]}");
            response.getWriter().write(json.toString());
        } catch (Exception e) {
            logger.severe("Errore nella ricerca AJAX" + e.getMessage());
            response.getWriter().write("{\"error\": \"Errore nella ricerca\"}");
        }
    }
}
