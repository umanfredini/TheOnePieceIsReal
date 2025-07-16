package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.CartItem;
import model.Order;
import model.OrderItem;
import model.User;
import dao.OrderDAO;
import dao.OrderItemDAO;
import java.util.logging.Logger;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.Map;

@WebServlet("/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(CheckoutServlet.class.getName());

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (!isUserLoggedIn(session)) {
            response.sendRedirect("/WEB-INF/jsp/login.jsp");
            return;
        }

        @SuppressWarnings("unchecked")
        Map<Integer, CartItem> carrello = (Map<Integer, CartItem>) session.getAttribute("carrello");
        if (carrello == null || carrello.isEmpty()) {
            response.sendRedirect("/WEB-INF/jsp/cart.jsp");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/jsp/checkout.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (!isValidToken(request, session)) {
            response.sendRedirect("/WEB-INF/jsp/error.jsp");
            return;
        }

        if (!isUserLoggedIn(session)) {
            response.sendRedirect("/WEB-INF/jsp/login.jsp");
            return;
        }

        try {
            User utente = (User) session.getAttribute("utente");
            @SuppressWarnings("unchecked")
            Map<Integer, CartItem> carrello = (Map<Integer, CartItem>) session.getAttribute("carrello");

            if (carrello == null || carrello.isEmpty()) {
                response.sendRedirect("/WEB-INF/jsp/cart.jsp");
                return;
            }

            Order ordine = new Order();
            ordine.setUserId(utente.getId());
            ordine.setOrderDate(new Timestamp(System.currentTimeMillis()));
            ordine.setStatus("CONFERMATO");
            ordine.setShippingAddress(request.getParameter("indirizzo"));

            BigDecimal totale = BigDecimal.ZERO;
            for (CartItem item : carrello.values()) {
                BigDecimal prezzo = item.getProduct().getPrice();
                BigDecimal quantita = BigDecimal.valueOf(item.getQuantity());
                totale = totale.add(prezzo.multiply(quantita));
            }
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
                request.setAttribute("ordineId", ordineId);
                request.getRequestDispatcher("/WEB-INF/jsp/orderConfirmed").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Errore durante la creazione dell'ordine");
                request.getRequestDispatcher("/WEB-INF/jsp/checkout.jsp").forward(request, response);
            }
        } catch (Exception e) {
            logger.severe("Errore durante il checkout: " + e.getMessage());
            request.setAttribute("errorMessage", "Errore interno del server");
            request.getRequestDispatcher("/WEB-INF/jsp/checkout.jsp").forward(request, response);
        }
    }


    private boolean isUserLoggedIn(HttpSession session) {
        Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
        return isLoggedIn != null && isLoggedIn;
    }

    private boolean isValidToken(HttpServletRequest request, HttpSession session) {
        String sessionToken = (String) session.getAttribute("token");
        String requestToken = request.getParameter("token");
        return sessionToken != null && sessionToken.equals(requestToken);
    }
}
