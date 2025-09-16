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
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        // Test connessione database con retry
        int retryCount = 0;
        int maxRetries = 3;
        boolean connectionOk = false;
        
        while (retryCount < maxRetries && !connectionOk) {
            try {
                DBConnection.getConnection().close();
                logger.info("Connessione al database verificata (tentativo " + (retryCount + 1) + ")");
                connectionOk = true;
            } catch (SQLException e) {
                retryCount++;
                logger.warning("Tentativo " + retryCount + " fallito: " + e.getMessage());
                
                if (retryCount >= maxRetries) {
                    logger.severe("Errore di connessione al database dopo " + maxRetries + " tentativi: " + e.getMessage());
                    request.setAttribute("errorMessage", "Errore di connessione al database. Riprovare tra qualche istante.");
                    request.getRequestDispatcher("/jsp/error.jsp").forward(request, response);
                    return;
                }
                
                // Attesa prima del retry
                try {
                    Thread.sleep(1000 * retryCount);
                } catch (InterruptedException ie) {
                    Thread.currentThread().interrupt();
                    break;
                }
            }
        }

        try {
            // Inizializza i DAO con gestione errori
            ProductDAO prodottoDAO = new ProductDAO();
            
            // Recupera i dati con gestione errori
            int totaleProdotti = 0;
            int totaleOrdini = 0;
            int totaleUtenti = 0;
            double ricaviTotali = 0.0;
            List<Order> ordiniRecenti = new java.util.ArrayList<>();
            List<Map<String, Object>> prodottiTopSelling = new java.util.ArrayList<>();
            
            // Recupera il conteggio dei prodotti
            try {
                totaleProdotti = prodottoDAO.countAll();
                logger.info("✅ Conteggio prodotti recuperato: " + totaleProdotti);
            } catch (Exception e) {
                logger.severe("❌ Errore nel conteggio prodotti: " + e.getMessage());
                e.printStackTrace();
            }
            
            // Recupera il conteggio degli ordini
            try {
                OrderDAO ordineDAO = new OrderDAO();
                totaleOrdini = ordineDAO.countAll();
                logger.info("✅ Conteggio ordini recuperato: " + totaleOrdini);
            } catch (Exception e) {
                logger.severe("❌ Errore nel conteggio ordini: " + e.getMessage());
                e.printStackTrace();
            }
            
            // Recupera il conteggio degli utenti
            try {
                UserDAO utenteDAO = new UserDAO();
                totaleUtenti = utenteDAO.countAll();
                logger.info("✅ Conteggio utenti recuperato: " + totaleUtenti);
            } catch (Exception e) {
                logger.severe("❌ Errore nel conteggio utenti: " + e.getMessage());
                e.printStackTrace();
            }
            
            // Recupera i ricavi totali
            try {
                OrderDAO ordineDAO = new OrderDAO();
                ricaviTotali = ordineDAO.getTotalRevenue();
                logger.info("✅ Ricavi totali recuperati: " + ricaviTotali);
            } catch (Exception e) {
                logger.severe("❌ Errore nel recupero ricavi: " + e.getMessage());
                e.printStackTrace();
            }
            
            // Recupera gli ordini recenti
            try {
                OrderDAO ordineDAO = new OrderDAO();
                ordiniRecenti = ordineDAO.getRecentOrders(10);
                logger.info("✅ Ordini recenti recuperati: " + ordiniRecenti.size());
            } catch (Exception e) {
                logger.severe("❌ Errore nel recupero ordini recenti: " + e.getMessage());
                e.printStackTrace();
            }
            
            // Recupera i prodotti più venduti
            try {
                prodottiTopSelling = prodottoDAO.getTopSellingProducts(5);
                logger.info("✅ Prodotti più venduti recuperati: " + prodottiTopSelling.size());
            } catch (Exception e) {
                logger.severe("❌ Errore nel recupero prodotti più venduti: " + e.getMessage());
                e.printStackTrace();
            }
            
            logger.info("📊 Riepilogo finale dashboard - Prodotti: " + totaleProdotti + 
                       ", Ordini: " + totaleOrdini + 
                       ", Utenti: " + totaleUtenti + 
                       ", Ricavi: " + ricaviTotali);

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
    
}
