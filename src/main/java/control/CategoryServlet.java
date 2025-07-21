package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Product;
import dao.ProductDAO;
import util.CharacterManager;
import java.util.*;

import java.io.IOException;
import java.sql.SQLException;

// @WebServlet("/CategoryServlet")
public class CategoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final int PRODUCTS_PER_PAGE = 12;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String category = request.getParameter("category");
        String personaggio = request.getParameter("personaggio");
        String sort = request.getParameter("sort");
        String maxPrice = request.getParameter("maxPrice");
        String[] characters = request.getParameterValues("characters");
        String inStock = request.getParameter("inStock");
        String featured = request.getParameter("featured");
        String pageStr = request.getParameter("page");
        
        int currentPage = 1;
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageStr);
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        try {
            ProductDAO productDAO = new ProductDAO();
            CharacterManager characterManager = new CharacterManager();
            
            // Ottieni tutti i personaggi per i filtri (ora gestiti tramite is_featured)
            List<String> allCharacters = characterManager.getAllCharacterNames();
            request.setAttribute("characters", allCharacters);
            
            // Ottieni tutte le categorie per il filtro
            List<String> allCategories = productDAO.findAllCategories();
            request.setAttribute("categories", allCategories);
            
            // Ottieni i prodotti filtrati
            List<Product> products = getFilteredProducts(productDAO, category, personaggio, sort, maxPrice, characters, inStock, featured);
            
            // Calcola la paginazione
            int totalProducts = products.size();
            int totalPages = (int) Math.ceil((double) totalProducts / PRODUCTS_PER_PAGE);
            
            // Applica la paginazione
            int startIndex = (currentPage - 1) * PRODUCTS_PER_PAGE;
            int endIndex = Math.min(startIndex + PRODUCTS_PER_PAGE, totalProducts);
            List<Product> paginatedProducts = products.subList(startIndex, endIndex);
            
            // Ottieni i personaggi per ogni prodotto (ora gestiti tramite is_featured)
            Map<Integer, List<String>> productCharacters = new HashMap<>();
            for (Product product : paginatedProducts) {
                if (product.getIsFeatured() != null && !product.getIsFeatured().isEmpty()) {
                    List<String> productChars = CharacterManager.parseCharacterNames(product.getIsFeatured());
                    productCharacters.put(product.getId(), productChars);
                } else {
                    productCharacters.put(product.getId(), new ArrayList<>());
                }
            }
            
            // Imposta gli attributi per la JSP
            request.setAttribute("products", paginatedProducts);
            request.setAttribute("productCharacters", productCharacters);
            request.setAttribute("categoryName", category != null ? category : "Tutti i prodotti");
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalProducts", totalProducts);
            request.setAttribute("hasNextPage", currentPage < totalPages);
            request.setAttribute("hasPrevPage", currentPage > 1);
            
            // Mantieni i parametri di filtro per la paginazione
            request.setAttribute("currentFilters", buildFilterParams(category, personaggio, sort, maxPrice, characters, inStock, featured));
            
            request.getRequestDispatcher("/jsp/catalog.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Errore nel caricamento dei prodotti");
            request.getRequestDispatcher("/jsp/error.jsp").forward(request, response);
        }
    }

    private List<Product> getFilteredProducts(ProductDAO productDAO, String category, String personaggio, String sort, 
                                            String maxPrice, String[] characters, String inStock, String featured) 
                                            throws SQLException {
        List<Product> products = new ArrayList<>();
        
        // Filtra per categoria
        if (category != null && !category.isEmpty()) {
            products = productDAO.findByCategoria(category);
        } else {
            products = productDAO.findAll();
        }
        
        // Filtra per personaggio
        if (personaggio != null && !personaggio.isEmpty()) {
            products = products.stream()
                .filter(p -> {
                    if (p.getIsFeatured() != null && !p.getIsFeatured().isEmpty()) {
                        return CharacterManager.containsCharacter(p.getIsFeatured(), personaggio);
                    }
                    return false;
                })
                .collect(ArrayList::new, ArrayList::add, ArrayList::addAll);
        }
        
        // Filtra per prezzo massimo
        if (maxPrice != null && !maxPrice.isEmpty()) {
            try {
                double maxPriceValue = Double.parseDouble(maxPrice);
                products = products.stream()
                    .filter(p -> p.getPrice().doubleValue() <= maxPriceValue)
                    .collect(ArrayList::new, ArrayList::add, ArrayList::addAll);
            } catch (NumberFormatException e) {
                // Ignora il filtro prezzo se non valido
            }
        }
        
        // Filtra per disponibilità
        if ("true".equals(inStock)) {
            products = products.stream()
                .filter(p -> p.getStockQuantity() > 0)
                .collect(ArrayList::new, ArrayList::add, ArrayList::addAll);
        }
        
        // Filtra per prodotti in evidenza
        if ("true".equals(featured)) {
            products = products.stream()
                .filter(p -> p.getIsFeatured() != null && !p.getIsFeatured().isEmpty())
                .collect(ArrayList::new, ArrayList::add, ArrayList::addAll);
        }
        
        // Filtra per personaggi (se implementato)
        if (characters != null && characters.length > 0) {
            // Questo richiederebbe una query più complessa per filtrare per personaggi
            // Per ora, manteniamo tutti i prodotti
        }
        
        // Ordina i prodotti
        if (sort != null) {
            switch (sort) {
                case "name":
                    products.sort((p1, p2) -> p1.getName().compareToIgnoreCase(p2.getName()));
                    break;
                case "price_asc":
                    products.sort((p1, p2) -> p1.getPrice().compareTo(p2.getPrice()));
                    break;
                case "price_desc":
                    products.sort((p1, p2) -> p2.getPrice().compareTo(p1.getPrice()));
                    break;
                case "newest":
                    products.sort((p1, p2) -> {
                        if (p1.getCreatedAt() == null) return 1;
                        if (p2.getCreatedAt() == null) return -1;
                        return p2.getCreatedAt().compareTo(p1.getCreatedAt());
                    });
                    break;
                default:
                    // Ordine predefinito
                    break;
            }
        }
        
        return products;
    }
    
    private Map<String, String> buildFilterParams(String category, String personaggio, String sort, String maxPrice, 
                                                 String[] characters, String inStock, String featured) {
        Map<String, String> params = new HashMap<>();
        if (category != null) params.put("category", category);
        if (personaggio != null) params.put("personaggio", personaggio);
        if (sort != null) params.put("sort", sort);
        if (maxPrice != null) params.put("maxPrice", maxPrice);
        if (inStock != null) params.put("inStock", inStock);
        if (featured != null) params.put("featured", featured);
        return params;
    }
} 