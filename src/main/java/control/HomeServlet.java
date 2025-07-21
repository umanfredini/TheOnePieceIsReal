package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import dao.ProductDAO;
import model.Product;

// @WebServlet("/HomeServlet")
public class HomeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProductDAO productDAO;

    public void init() throws ServletException {
        try {
            productDAO = new ProductDAO();
        } catch (Exception e) {
            throw new ServletException("Errore nell'inizializzazione del ProductDAO", e);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Recupera prodotti in evidenza (es. i primi 6 prodotti)
            List<Product> featuredProducts = productDAO.getFeaturedProducts(6);
            
            // Aggiunge i prodotti alla request
            request.setAttribute("featuredProducts", featuredProducts);
            
            // Forward alla homepage
            request.getRequestDispatcher("/index.jsp").forward(request, response);
            
        } catch (Exception e) {
            // In caso di errore, reindirizza alla pagina di errore
            request.setAttribute("errorMessage", "Errore nel caricamento della homepage: " + e.getMessage());
            request.getRequestDispatcher("/jsp/error.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
} 