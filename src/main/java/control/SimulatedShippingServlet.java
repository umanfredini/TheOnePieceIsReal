package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.logging.Logger;
import java.util.logging.Level;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Random;

// @WebServlet("/SimulatedShippingServlet")
public class SimulatedShippingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(SimulatedShippingServlet.class.getName());
    
    // Opzioni di spedizione simulate
    private static final String[] SHIPPING_OPTIONS = {
        "Spedizione Standard (3-5 giorni) - €5.99",
        "Spedizione Express (1-2 giorni) - €12.99", 
        "Spedizione Premium (24 ore) - €19.99"
    };
    
    // Stati di spedizione
    private static final String[] SHIPPING_STATUSES = {
        "Ordine confermato",
        "In preparazione",
        "Spedito dal magazzino",
        "In transito",
        "In consegna",
        "Consegnato"
    };
    
    // Località simulate
    private static final String[] LOCATIONS = {
        "Centro di smistamento Milano",
        "Centro di smistamento Roma", 
        "Centro di smistamento Napoli",
        "Centro di smistamento Torino",
        "Centro di smistamento Firenze",
        "Centro di consegna locale"
    };

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String orderId = request.getParameter("orderId");
        String action = request.getParameter("action");
        
        try {
            if ("track".equals(action)) {
                // Simula tracking di un ordine
                simulateOrderTracking(orderId, response);
            } else if ("options".equals(action)) {
                // Restituisce opzioni di spedizione
                getShippingOptions(response);
            } else {
                // Simula creazione spedizione
                simulateShippingCreation(orderId, request, response);
            }
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Errore durante simulazione spedizione", e);
            response.getWriter().write("{\"success\": false, \"error\": \"Errore durante l'elaborazione\"}");
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    /**
     * Simula la creazione di una spedizione
     */
    private void simulateShippingCreation(String orderId, HttpServletRequest request, HttpServletResponse response) 
            throws IOException, InterruptedException {
        
        // Simula latenza di elaborazione
        Thread.sleep(1500);
        
        String shippingOption = request.getParameter("shippingOption");
        String address = request.getParameter("address");
        
        logger.info("Simulazione spedizione: Ordine=" + orderId + ", Opzione=" + shippingOption);
        
        // Genera tracking number
        String trackingNumber = generateTrackingNumber();
        
        // Calcola data di consegna stimata
        LocalDate estimatedDelivery = calculateEstimatedDelivery(shippingOption);
        
        // Crea risposta di successo
        String jsonResponse = String.format(
            "{\"success\": true, \"trackingNumber\": \"%s\", \"estimatedDelivery\": \"%s\", " +
            "\"status\": \"%s\", \"currentLocation\": \"%s\", \"shippingOption\": \"%s\"}",
            trackingNumber,
            estimatedDelivery.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")),
            SHIPPING_STATUSES[0],
            LOCATIONS[0],
            shippingOption
        );
        
        response.getWriter().write(jsonResponse);
        logger.info("Spedizione simulata creata: Tracking=" + trackingNumber);
    }
    
    /**
     * Simula il tracking di un ordine
     */
    private void simulateOrderTracking(String orderId, HttpServletResponse response) 
            throws IOException, InterruptedException {
        
        // Simula latenza di rete
        Thread.sleep(1000);
        
        // Genera stato casuale basato sull'ID ordine
        Random random = new Random(orderId.hashCode());
        int statusIndex = random.nextInt(SHIPPING_STATUSES.length);
        int locationIndex = random.nextInt(LOCATIONS.length);
        
        // Calcola progresso (0-100%)
        int progress = (statusIndex * 100) / (SHIPPING_STATUSES.length - 1);
        
        // Genera tracking number se non esiste
        String trackingNumber = "TRK" + orderId + "IT";
        
        String jsonResponse = String.format(
            "{\"success\": true, \"trackingNumber\": \"%s\", \"status\": \"%s\", " +
            "\"currentLocation\": \"%s\", \"progress\": %d, \"lastUpdate\": \"%s\"}",
            trackingNumber,
            SHIPPING_STATUSES[statusIndex],
            LOCATIONS[locationIndex],
            progress,
            LocalDate.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"))
        );
        
        response.getWriter().write(jsonResponse);
        logger.info("Tracking simulato: Ordine=" + orderId + ", Stato=" + SHIPPING_STATUSES[statusIndex]);
    }
    
    /**
     * Restituisce le opzioni di spedizione disponibili
     */
    private void getShippingOptions(HttpServletResponse response) throws IOException {
        StringBuilder json = new StringBuilder("{\"success\": true, \"options\": [");
        
        for (int i = 0; i < SHIPPING_OPTIONS.length; i++) {
            if (i > 0) json.append(",");
            json.append("\"").append(SHIPPING_OPTIONS[i]).append("\"");
        }
        
        json.append("]}");
        response.getWriter().write(json.toString());
    }
    
    /**
     * Genera un numero di tracking realistico
     */
    private String generateTrackingNumber() {
        Random random = new Random();
        StringBuilder tracking = new StringBuilder("TRK");
        
        // Aggiunge timestamp
        tracking.append(System.currentTimeMillis() % 1000000);
        
        // Aggiunge caratteri casuali
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        for (int i = 0; i < 6; i++) {
            tracking.append(chars.charAt(random.nextInt(chars.length())));
        }
        
        return tracking.toString();
    }
    
    /**
     * Calcola la data di consegna stimata basata sull'opzione di spedizione
     */
    private LocalDate calculateEstimatedDelivery(String shippingOption) {
        LocalDate today = LocalDate.now();
        
        if (shippingOption.contains("Premium")) {
            return today.plusDays(1);
        } else if (shippingOption.contains("Express")) {
            return today.plusDays(2);
        } else {
            return today.plusDays(4);
        }
    }
} 