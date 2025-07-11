package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Product;
import dao.ProductDAO;
import java.util.logging.Logger;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/AdminProductServlet")
public class AdminProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(AdminProductServlet.class.getName());

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (!isAdminLoggedIn(session)) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        try {
            ProductDAO prodottoDAO = new ProductDAO();

            if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Product prodotto = prodottoDAO.findByProductId(id);
                request.setAttribute("prodotto", prodotto);
                request.getRequestDispatcher("product-form.jsp").forward(request, response);
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                prodottoDAO.delete(id);
                response.sendRedirect("AdminProductServlet");
            } else {
                List<Product> prodotti = prodottoDAO.findAll();
                request.setAttribute("prodotti", prodotti);
                request.getRequestDispatcher("products.jsp").forward(request, response);
            }
        } catch (Exception e) {
            logger.severe("Errore nella gestione prodotti admin" + e.getMessage());
            response.sendRedirect("error.jsp");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (!isValidToken(request, session)) {
            response.sendRedirect("error.jsp");
            return;
        }

        if (!isAdminLoggedIn(session)) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            String idStr = request.getParameter("id");
            Product prodotto = new Product();

            if (idStr != null && !idStr.isEmpty()) {
                prodotto.setId(Integer.parseInt(idStr));
            }

            prodotto.setName(request.getParameter("nome"));
            prodotto.setDescription(request.getParameter("descrizione"));
            prodotto.setPrice(new BigDecimal(request.getParameter("prezzo")));
            prodotto.setStockQuantity(Integer.parseInt(request.getParameter("quantita")));
            prodotto.setPersonaggi(request.getParameter("personaggio"));
            prodotto.setCategory(request.getParameter("categoria"));
            prodotto.setImageUrl(request.getParameter("immagine"));

            ProductDAO prodottoDAO = new ProductDAO();

            if (prodotto.getId() > 0) {
                prodottoDAO.update(prodotto);
            } else {
                prodottoDAO.create(prodotto);
            }

            response.sendRedirect("AdminProductServlet");
        } catch (Exception e) {
            logger.severe("Errore durante il salvataggio del prodotto" + e.getMessage());
            request.setAttribute("errorMessage", "Errore durante il salvataggio del prodotto");
            request.getRequestDispatcher("product-form.jsp").forward(request, response);
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
