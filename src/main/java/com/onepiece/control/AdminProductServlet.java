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

@WebServlet("/AdminProductServlet")
public class AdminProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = LoggerFactory.getLogger(AdminProductServlet.class);

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (!isAdminLoggedIn(session)) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        try {
            ProdottoDAO prodottoDAO = new ProdottoDAO();

            if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Prodotto prodotto = prodottoDAO.doRetrieveByKey(id);
                request.setAttribute("prodotto", prodotto);
                request.getRequestDispatcher("product-form.jsp").forward(request, response);
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                prodottoDAO.doDelete(id);
                response.sendRedirect("AdminProductServlet");
            } else {
                List<Prodotto> prodotti = prodottoDAO.doRetrieveAll();
                request.setAttribute("prodotti", prodotti);
                request.getRequestDispatcher("products.jsp").forward(request, response);
            }
        } catch (Exception e) {
            logger.error("Errore nella gestione prodotti admin", e);
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
            Prodotto prodotto = new Prodotto();

            if (idStr != null && !idStr.isEmpty()) {
                prodotto.setId(Integer.parseInt(idStr));
            }

            prodotto.setNome(request.getParameter("nome"));
            prodotto.setDescrizione(request.getParameter("descrizione"));
            prodotto.setPrezzo(Double.parseDouble(request.getParameter("prezzo")));
            prodotto.setQuantita(Integer.parseInt(request.getParameter("quantita")));
            prodotto.setPersonaggio(request.getParameter("personaggio"));
            prodotto.setCategoria(request.getParameter("categoria"));
            prodotto.setImmagine(request.getParameter("immagine"));

            ProdottoDAO prodottoDAO = new ProdottoDAO();

            if (prodotto.getId() > 0) {
                prodottoDAO.doUpdate(prodotto);
            } else {
                prodottoDAO.doSave(prodotto);
            }

            response.sendRedirect("AdminProductServlet");
        } catch (Exception e) {
            logger.error("Errore durante il salvataggio del prodotto", e);
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
