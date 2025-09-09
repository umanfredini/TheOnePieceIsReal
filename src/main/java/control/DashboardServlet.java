package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Order;
import dao.ProductDAO;
import dao.OrderDAO;
import dao.UserDAO;
import java.util.logging.Logger;
import java.sql.SQLException;
import util.DBConnection;

import java.io.IOException;
import java.util.List;
import java.util.Map;

// @WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(DashboardServlet.class.getName());

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (!isAdminLoggedIn(session)) {
            response.sendRedirect("LoginServlet");
            return;
        }

        // Test connessione database
        if (!testDatabaseConnection()) {
            logger.severe("Impossibile connettersi al database");
            request.setAttribute("errorMessage", "Errore di connessione al database. Verificare che il database sia attivo.");
            request.getRequestDispatcher("/jsp/error.jsp").forward(request, response);
            return;
        }

        try {
            // Inizializza i DAO con gestione errori
            ProductDAO prodottoDAO = new ProductDAO();
            OrderDAO ordineDAO;
            UserDAO utenteDAO;
            
            ordineDAO = new OrderDAO();
            utenteDAO = new UserDAO();

            // Recupera i dati con gestione errori
            int totaleProdotti = prodottoDAO.countAll();
            
            int totaleOrdini = 0;
            int totaleUtenti = 0;
            double ricaviTotali = 0.0;
            List<Order> ordiniRecenti = new java.util.ArrayList<>();
            
            try {
                totaleOrdini = ordineDAO.countAll();
                totaleUtenti = utenteDAO.countAll();
                ricaviTotali = ordineDAO.getTotalRevenue();
                ordiniRecenti = ordineDAO.getRecentOrders(10);
            } catch (Exception e) {
                logger.warning("Errore nel recupero dati dashboard: " + e.getMessage());
            }
            
            List<Map<String, Object>> prodottiTopSelling = prodottoDAO.getTopSellingProducts(5);

            request.setAttribute("productCount", totaleProdotti);
            request.setAttribute("orderCount", totaleOrdini);
            request.setAttribute("userCount", totaleUtenti);
            request.setAttribute("totalRevenue", ricaviTotali);
            request.setAttribute("topSellingProducts", prodottiTopSelling);
            request.setAttribute("recentOrders", ordiniRecenti);

            request.getRequestDispatcher("/jsp/adminDashboard.jsp").forward(request, response);
        } catch (ServletException e) {
            logger.severe("Errore Servlet nel caricamento della dashboard: " + e.getMessage());
            request.setAttribute("errorMessage", "Errore di connessione al database: " + e.getMessage());
            request.getRequestDispatcher("/jsp/error.jsp").forward(request, response);
        } catch (Exception e) {
            logger.severe("Errore generico nel caricamento della dashboard: " + e.getMessage());
            logger.severe("Errore nel DashboardServlet: " + e.getMessage());
            request.setAttribute("errorMessage", "Errore nel caricamento della dashboard: " + e.getMessage());
            request.getRequestDispatcher("/jsp/error.jsp").forward(request, response);
        }
    }

    private boolean isAdminLoggedIn(HttpSession session) {
        // Controlla se la sessione esiste
        if (session == null) {
            logger.warning("Sessione non trovata - utente non autenticato");
            return false;
        }
        
        try {
            Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
            Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
            
            // Log per debug
            logger.info("Controllo sessione - isAdmin: " + isAdmin + ", isLoggedIn: " + isLoggedIn);
            
            return isAdmin != null && isAdmin && isLoggedIn != null && isLoggedIn;
        } catch (Exception e) {
            logger.severe("Errore nel controllo della sessione: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Testa la connessione al database
     * @return true se la connessione è riuscita, false altrimenti
     */
    private boolean testDatabaseConnection() {
        try {
            DBConnection.getConnection().close();
            logger.info("Connessione al database riuscita");
            return true;
        } catch (SQLException e) {
            logger.severe("Errore nella connessione al database: " + e.getMessage());
            return false;
        } catch (Exception e) {
            logger.severe("Errore generico nella connessione al database: " + e.getMessage());
            return false;
        }
    }
}
