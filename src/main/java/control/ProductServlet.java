package control;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Product;
import dao.ProductDAO;

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
            ProductDAO prodottoDAO = new ProductDAO();
            
            if ("detail".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Product prodotto = prodottoDAO.findByProductId(id);
                request.setAttribute("prodotto", prodotto);
                request.getRequestDispatcher("product-detail.jsp").forward(request, response);
            } else {
                List<Product> prodotti;
                
                if (personaggio != null && !personaggio.isEmpty()) {
                    prodotti = prodottoDAO.findByPersonaggio(personaggio);
                } else if (categoria != null && !categoria.isEmpty()) {
                    prodotti = prodottoDAO.findByCategoria(categoria);
                } else if (search != null && !search.isEmpty()) {
                    prodotti = prodottoDAO.findBySearch(search);
                } else {
                    prodotti = prodottoDAO.findAll();
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