package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.logging.Logger;
import java.util.logging.Level;

@WebServlet("/SimulatedPaymentServlet")
public class SimulatedPaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(SimulatedPaymentServlet.class.getName());
    
    // Carte di test predefinite
    private static final String SUCCESS_CARD = "4111111111111111";
    private static final String FAILURE_CARD = "4000000000000002";
    private static final String INSUFFICIENT_CARD = "4000000000009995";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            // Simula latenza di elaborazione
            Thread.sleep(2000);
            
            String cardNumber = request.getParameter("cardNumber");
            String amount = request.getParameter("amount");
            String cardHolder = request.getParameter("cardHolder");
            
            logger.info("Simulazione pagamento: Carta=" + maskCardNumber(cardNumber) + 
                       ", Importo=" + amount + ", Intestatario=" + cardHolder);
            
            // Simula diversi scenari di pagamento
            if (cardNumber.equals(FAILURE_CARD)) {
                // Simula carta rifiutata
                response.getWriter().write("{\"success\": false, \"error\": \"Carta rifiutata dalla banca\", \"code\": \"CARD_DECLINED\"}");
                logger.warning("Pagamento simulato: Carta rifiutata");
                
            } else if (cardNumber.equals(INSUFFICIENT_CARD)) {
                // Simula fondi insufficienti
                response.getWriter().write("{\"success\": false, \"error\": \"Fondi insufficienti\", \"code\": \"INSUFFICIENT_FUNDS\"}");
                logger.warning("Pagamento simulato: Fondi insufficienti");
                
            } else if (cardNumber.equals(SUCCESS_CARD) || cardNumber.startsWith("4")) {
                // Simula pagamento riuscito
                String transactionId = "TXN_" + System.currentTimeMillis();
                response.getWriter().write("{\"success\": true, \"transactionId\": \"" + transactionId + 
                                         "\", \"amount\": \"" + amount + "\", \"timestamp\": \"" + 
                                         new java.util.Date().toISOString() + "\"}");
                logger.info("Pagamento simulato: Successo - Transaction ID: " + transactionId);
                
            } else {
                // Carta non riconosciuta
                response.getWriter().write("{\"success\": false, \"error\": \"Numero carta non valido\", \"code\": \"INVALID_CARD\"}");
                logger.warning("Pagamento simulato: Carta non valida");
            }
            
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            response.getWriter().write("{\"success\": false, \"error\": \"Errore interno del server\", \"code\": \"INTERNAL_ERROR\"}");
            logger.log(Level.SEVERE, "Errore durante simulazione pagamento", e);
        } catch (Exception e) {
            response.getWriter().write("{\"success\": false, \"error\": \"Errore durante l'elaborazione\", \"code\": \"PROCESSING_ERROR\"}");
            logger.log(Level.SEVERE, "Errore durante simulazione pagamento", e);
        }
    }
    
    /**
     * Maschera il numero della carta per i log
     */
    private String maskCardNumber(String cardNumber) {
        if (cardNumber == null || cardNumber.length() < 4) {
            return "****";
        }
        return "****" + cardNumber.substring(cardNumber.length() - 4);
    }
} 