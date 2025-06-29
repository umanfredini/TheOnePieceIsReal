package control;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.dao.ProdottoDAO;
import model.bean.Prodotto;

@WebServlet("/ProductServlet")
public class ProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String personaggio = request.getParameter("personaggio");
        String categoria = request.getParameter("categoria");
        String search = request.getParameter("search");
        
        try {
            ProdottoDAO prodottoDAO = new ProdottoDAO();
            
            if ("detail".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Prodotto prodotto = prodottoDAO.doRetrieveByKey(id);
                request.setAttribute("prodotto", prodotto);
                request.getRequestDispatcher("product-detail.jsp").forward(request, response);
            } else {
                List<Prodotto> prodotti;
                
                if (personaggio != null && !personaggio.isEmpty()) {
                    prodotti = prodottoDAO.doRetrieveByPersonaggio(personaggio);
                } else if (categoria != null && !categoria.isEmpty()) {
                    prodotti = prodottoDAO.doRetrieveByCategoria(categoria);
                } else if (search != null && !search.isEmpty()) {
                    prodotti = prodottoDAO.doRetrieveBySearch(search);
                } else {
                    prodotti = prodottoDAO.doRetrieveAll();
                }
                
                request.setAttribute("prodotti", prodotti);
                request.getRequestDispatcher("catalog.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}