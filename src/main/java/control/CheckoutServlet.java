package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.CartItem;
import model.Cart;
import model.Order;
import model.OrderItem;
import model.User;
import dao.OrderDAO;
import dao.OrderItemDAO;
import java.util.logging.Logger;
import java.util.ArrayList;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.Map;

// @WebServlet("/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(CheckoutServlet.class.getName());
    
    // Costanti per i valori di status validi (ENUM nel database)
    private static final String STATUS_PENDING = "pending";
    private static final String STATUS_PROCESSING = "processing";
    private static final String STATUS_SHIPPED = "shipped";
    private static final String STATUS_DELIVERED = "delivered";
    private static final String STATUS_CANCELLED = "cancelled";

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Gestione utente loggato o ospite
        User utente = (User) session.getAttribute("utente");
        boolean isGuest = (utente == null);
        
        if (isGuest) {
            // Per ospiti, mostra form di checkout senza login
            request.setAttribute("isGuest", true);
        } else {
            request.setAttribute("isGuest", false);
        }

        @SuppressWarnings("unchecked")
        Map<Integer, CartItem> carrello = (Map<Integer, CartItem>) session.getAttribute("carrello");
        if (carrello == null || carrello.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/CartServlet");
            return;
        }

        // Crea un oggetto Cart per la JSP
        Cart cart = new Cart();
        cart.setItems(new ArrayList<>(carrello.values()));
        
        // Calcola il totale
        double total = 0.0;
        for (CartItem item : carrello.values()) {
            if (item.getProduct() != null) {
                total += item.getProduct().getPrice().doubleValue() * item.getQuantity();
            }
        }
        cart.setTotal(total);
        
        request.setAttribute("cart", cart);
        request.setAttribute("carrello", carrello);
        
        request.getRequestDispatcher("/jsp/checkout.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (!isValidToken(request, session)) {
            request.setAttribute("errorMessage", "Token di sicurezza non valido. Riprova.");
            request.getRequestDispatcher("/jsp/error.jsp").forward(request, response);
            return;
        }

        // Gestione utente loggato o ospite
        User utente = (User) session.getAttribute("utente");
        boolean isGuest = (utente == null);
        
        if (isGuest) {
            // Per ospiti, crea un utente temporaneo o gestisci diversamente
            request.setAttribute("isGuest", true);
        } else {
            request.setAttribute("isGuest", false);
        }

        try {
            @SuppressWarnings("unchecked")
            Map<Integer, CartItem> carrello = (Map<Integer, CartItem>) session.getAttribute("carrello");

            if (carrello == null || carrello.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/CartServlet");
                return;
            }

            Order ordine = new Order();
            
            // Gestione utente loggato o ospite
            if (utente != null) {
                ordine.setUserId(utente.getId());
            } else {
                // Per ospiti, usa un utente di sistema esistente (ID 1)
                // Assumiamo che esista un utente con ID 1 nel database
                ordine.setUserId(1); // ID utente di sistema per ospiti
            }
            
            // Gestione opzione di spedizione
            String shippingOption = request.getParameter("shippingOption");
            if (shippingOption == null || shippingOption.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Seleziona un'opzione di spedizione.");
                request.getRequestDispatcher("/jsp/checkout.jsp").forward(request, response);
                return;
            }
            
            BigDecimal shippingCost = BigDecimal.ZERO;
            
            switch (shippingOption) {
                case "standard":
                    shippingCost = new BigDecimal("5.00");
                    break;
                case "express":
                    shippingCost = new BigDecimal("12.00");
                    break;
                case "premium":
                    shippingCost = new BigDecimal("20.00");
                    break;
                case "same-day":
                    shippingCost = new BigDecimal("35.00");
                    break;
                default:
                    request.setAttribute("errorMessage", "Opzione di spedizione non valida.");
                    request.getRequestDispatcher("/jsp/checkout.jsp").forward(request, response);
                    return;
            }
            
            // Simulazione pagamento
            String cardNumber = request.getParameter("cardNumber");
            String cardHolder = request.getParameter("cardHolder");
            String cardExpiry = request.getParameter("cardExpiry");
            String cardCvv = request.getParameter("cardCvv");
            
            // Validazione base della carta (simulazione)
            if (cardNumber == null || cardNumber.trim().isEmpty() || 
                cardHolder == null || cardHolder.trim().isEmpty() ||
                cardExpiry == null || cardExpiry.trim().isEmpty() ||
                cardCvv == null || cardCvv.trim().isEmpty()) {
                throw new Exception("Dati di pagamento incompleti");
            }
            
            // Simulazione approvazione carta (sempre approvata per test)
            logger.info("Simulazione pagamento: Carta " + cardNumber.substring(0, 4) + "**** approvata per " + cardHolder);
            
            ordine.setOrderDate(new Timestamp(System.currentTimeMillis()));
            // Status valido per l'ENUM: 'pending', 'processing', 'shipped', 'delivered', 'cancelled'
            ordine.setStatus(STATUS_PENDING); // Ordine confermato ma in attesa di elaborazione
            ordine.setShippingAddress(request.getParameter("address"));
            ordine.setPaymentMethod("Carta di Credito"); // Metodo di pagamento simulato
            
            // Genera tracking number univoco
            String trackingNumber = "TRK" + System.currentTimeMillis() + "OP";
            ordine.setTrackingNumber(trackingNumber);
            
            // Aggiungi note per l'ordine
            String notes = "Ordine " + (isGuest ? "ospite" : "utente registrato") + 
                          " - Spedizione: " + shippingOption + 
                          " - Pagamento: Carta di Credito";
            ordine.setNotes(notes);

            BigDecimal totale = BigDecimal.ZERO;
            for (CartItem item : carrello.values()) {
                BigDecimal prezzo = item.getProduct().getPrice();
                BigDecimal quantita = BigDecimal.valueOf(item.getQuantity());
                totale = totale.add(prezzo.multiply(quantita));
            }
            
            // Aggiungi costo di spedizione
            totale = totale.add(shippingCost);
            ordine.setTotalPrice(totale);

            OrderDAO ordineDAO = new OrderDAO();
            ordineDAO.create(ordine);
            int ordineId = ordine.getId();

            if (ordineId > 0) {
            	OrderItemDAO orderItemDAO = new OrderItemDAO();
            	for (CartItem item : carrello.values()) {
            	    OrderItem orderItem = new OrderItem();
            	    orderItem.setOrderId(ordineId);
            	    orderItem.setProductId(item.getProduct().getId());
            	    orderItem.setQuantity(item.getQuantity());
            	    orderItem.setUnitPrice(item.getProduct().getPrice());
            	    orderItem.setVariantId(item.getVariantId());
            	    orderItem.setVariantName(item.getVariantId() != null ? String.valueOf(item.getVariantId()) : null);

            	    orderItemDAO.add(orderItem);
            	}


                carrello.clear();
                session.setAttribute("carrello", carrello);
                
                // Passa l'ordine e l'informazione se è un ospite alla pagina di conferma
                request.setAttribute("order", ordine);
                request.setAttribute("isGuest", isGuest);
                request.setAttribute("ordineId", ordineId);
                request.getRequestDispatcher("/jsp/orderConfirmed.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Errore durante la creazione dell'ordine");
                request.getRequestDispatcher("/jsp/checkout.jsp").forward(request, response);
            }
        } catch (Exception e) {
            logger.severe("Errore durante il checkout: " + e.getMessage());
            request.setAttribute("errorMessage", "Errore interno del server: " + e.getMessage());
            request.getRequestDispatcher("/jsp/checkout.jsp").forward(request, response);
        }
    }




    private boolean isValidToken(HttpServletRequest request, HttpSession session) {
        String sessionToken = (String) session.getAttribute("csrfToken");
        String requestToken = request.getParameter("csrfToken");
        return sessionToken != null && sessionToken.equals(requestToken);
    }
}
