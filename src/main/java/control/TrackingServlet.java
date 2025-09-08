package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Order;
import dao.OrderDAO;
import java.io.IOException;
import java.util.logging.Logger;
import java.util.List;

// @WebServlet("/TrackingServlet")
public class TrackingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(TrackingServlet.class.getName());
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String trackingNumber = request.getParameter("trackingNumber");
        String action = request.getParameter("action");
        
        if ("search".equals(action) && trackingNumber != null && !trackingNumber.trim().isEmpty()) {
            // Cerca l'ordine per tracking number
            try {
                OrderDAO orderDAO = new OrderDAO();
                Order order = orderDAO.findByTrackingNumber(trackingNumber.trim());
                
                if (order != null) {
                    request.setAttribute("order", order);
                    request.setAttribute("trackingNumber", trackingNumber.trim());
                    request.setAttribute("found", true);
                    
                    // Calcola lo stato della spedizione
                    String shippingStatus = calculateShippingStatus(order);
                    request.setAttribute("shippingStatus", shippingStatus);
                    
                    // Calcola la percentuale di completamento
                    int progressPercentage = calculateProgressPercentage(order.getStatus());
                    request.setAttribute("progressPercentage", progressPercentage);
                    
                } else {
                    request.setAttribute("found", false);
                    request.setAttribute("trackingNumber", trackingNumber.trim());
                    request.setAttribute("errorMessage", "Nessun ordine trovato con questo numero di tracking.");
                }
                
            } catch (Exception e) {
                logger.severe("Errore nella ricerca dell'ordine: " + e.getMessage());
                request.setAttribute("found", false);
                request.setAttribute("errorMessage", "Errore nella ricerca dell'ordine. Riprova più tardi.");
            }
        }
        
        request.getRequestDispatcher("/jsp/tracking.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Reindirizza al GET per mantenere i parametri nell'URL
        String trackingNumber = request.getParameter("trackingNumber");
        response.sendRedirect(request.getContextPath() + "/TrackingServlet?action=search&trackingNumber=" + 
                            java.net.URLEncoder.encode(trackingNumber, "UTF-8"));
    }
    
    /**
     * Calcola lo stato della spedizione basato sullo status dell'ordine
     */
    private String calculateShippingStatus(Order order) {
        switch (order.getStatus().toLowerCase()) {
            case "pending":
                return "Ordine ricevuto e in elaborazione";
            case "processing":
                return "Ordine in preparazione per la spedizione";
            case "shipped":
                return "Ordine spedito e in transito";
            case "delivered":
                return "Ordine consegnato";
            case "cancelled":
                return "Ordine annullato";
            default:
                return "Stato sconosciuto";
        }
    }
    
    /**
     * Calcola la percentuale di completamento basata sullo status
     */
    private int calculateProgressPercentage(String status) {
        switch (status.toLowerCase()) {
            case "pending":
                return 25;
            case "processing":
                return 50;
            case "shipped":
                return 75;
            case "delivered":
                return 100;
            case "cancelled":
                return 0;
            default:
                return 0;
        }
    }
}
