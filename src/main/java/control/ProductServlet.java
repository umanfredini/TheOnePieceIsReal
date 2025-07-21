package control;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.ArrayList;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Product;
import model.ProductVariant;
import dao.ProductDAO;
import dao.ProductVariantDAO;
import util.CharacterManager;

// @WebServlet("/ProductServlet")
public class ProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String personaggio = request.getParameter("personaggio");
        String categoria = request.getParameter("category");
        String search = request.getParameter("search");
        
        try {
            ProductDAO prodottoDAO = new ProductDAO();
            CharacterManager characterManager = new CharacterManager();
            
            if ("detail".equals(action)) {
                String idParam = request.getParameter("id");
                
                int id = -1;
                try {
                    id = Integer.parseInt(idParam);
                } catch (Exception ex) {
                    request.setAttribute("errorMessage", "ID prodotto non valido o mancante.");
                    request.getRequestDispatcher("/jsp/error.jsp").forward(request, response);
                    return;
                }
                
                Product prodotto = prodottoDAO.findByProductId(id);
                
                if (prodotto == null) {
                    // Prodotto non trovato: redirect a 404
                    request.getRequestDispatcher("/jsp/404.jsp").forward(request, response);
                    return;
                }
                request.setAttribute("product", prodotto);
                
                // Ottieni i personaggi del prodotto
                List<String> productCharacters = new ArrayList<>();
                if (prodotto.getIsFeatured() != null && !prodotto.getIsFeatured().isEmpty()) {
                    productCharacters = characterManager.parseCharacterNames(prodotto.getIsFeatured());
                }
                request.setAttribute("productCharacters", productCharacters);
                
                try {
                    ProductVariantDAO variantDAO = new ProductVariantDAO();
                    List<ProductVariant> variants = variantDAO.findAllByProductId(id);
                    request.setAttribute("variants", variants);
                } catch (Exception e) {
                    System.err.println("Errore nel caricamento varianti: " + e.getMessage());
                    request.setAttribute("variants", new ArrayList<>());
                }
                request.getRequestDispatcher("/jsp/product-detail.jsp").forward(request, response);
            } else {
                List<Product> prodotti;
                
                // Ottieni tutti i personaggi per i filtri (ora gestiti tramite is_featured)
                List<String> allCharacters = characterManager.getAllCharacterNames();
                request.setAttribute("characters", allCharacters);
                
                // Ottieni tutte le categorie per il filtro
                List<String> allCategories = prodottoDAO.findAllCategories();
                request.setAttribute("categories", allCategories);
                
                // Gestione filtri
                String maxPrice = request.getParameter("maxPrice");
                String[] characters = request.getParameterValues("characters");
                String inStock = request.getParameter("inStock");
                String featured = request.getParameter("featured");
                String sort = request.getParameter("sort");
                
                // Gestione paginazione
                int page = 1;
                int pageSize = 12; // Prodotti per pagina
                try {
                    String pageParam = request.getParameter("page");
                    if (pageParam != null && !pageParam.isEmpty()) {
                        page = Integer.parseInt(pageParam);
                        if (page < 1) page = 1;
                    }
                } catch (NumberFormatException e) {
                    page = 1;
                }
                
                // Prepara parametri per la paginazione
                Double maxPriceValue = null;
                if (maxPrice != null && !maxPrice.isEmpty()) {
                    try {
                        maxPriceValue = Double.parseDouble(maxPrice);
                    } catch (NumberFormatException e) {
                        // Ignora il filtro se il prezzo non è valido
                    }
                }
                
                // Recupera prodotti con paginazione
                prodotti = prodottoDAO.getProductsWithPagination(page, pageSize, categoria, personaggio, search, maxPriceValue);
                
                // Calcola informazioni paginazione
                int totalProducts = prodottoDAO.getTotalProductsCount(categoria, personaggio, search, maxPriceValue);
                int totalPages = (int) Math.ceil((double) totalProducts / pageSize);
                
                // Assicurati che la pagina corrente sia valida
                if (page > totalPages && totalPages > 0) {
                    page = totalPages;
                    // Ricarica i prodotti per la pagina corretta
                    prodotti = prodottoDAO.getProductsWithPagination(page, pageSize, categoria, personaggio, search, maxPriceValue);
                }
                
                // Ottieni i personaggi per ogni prodotto (ora gestiti tramite is_featured)
                Map<Integer, List<String>> productCharacters = new HashMap<>();
                for (Product product : prodotti) {
                    if (product.getIsFeatured() != null && !product.getIsFeatured().isEmpty()) {
                        List<String> productChars = characterManager.parseCharacterNames(product.getIsFeatured());
                        productCharacters.put(product.getId(), productChars);
                    } else {
                        productCharacters.put(product.getId(), new ArrayList<>());
                    }
                }
                
                request.setAttribute("products", prodotti);
                request.setAttribute("prodotti", prodotti); // Mantieni compatibilità
                request.setAttribute("productCharacters", productCharacters);
                request.setAttribute("categoryName", categoria != null ? categoria : "Tutti i prodotti");
                
                // Informazioni paginazione
                request.setAttribute("currentPage", page);
                request.setAttribute("totalPages", totalPages);
                request.setAttribute("totalProducts", totalProducts);
                request.setAttribute("pageSize", pageSize);
                request.setAttribute("hasNextPage", page < totalPages);
                request.setAttribute("hasPrevPage", page > 1);
                request.getRequestDispatcher("/jsp/catalog.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Errore nel caricamento del prodotto. Prodotto non trovato.");
            request.getRequestDispatcher("/jsp/error.jsp").forward(request, response);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Reindirizza al CartServlet per gestire l'aggiunta al carrello
        request.getRequestDispatcher("/CartServlet").include(request, response);
    }
}