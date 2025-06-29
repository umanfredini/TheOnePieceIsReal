package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.dao.OrdineDAO;
import model.dao.DettaglioOrdineDAO;
import model.bean.Utente;
import model.bean.Ordine;
import model.bean.DettaglioOrdine;
import model.bean.CartItem;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.Map;

@WebServlet("/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = LoggerFactory.getLogger(CheckoutServlet.class);

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (!isUserLoggedIn(session)) {
            response.sendRedirect("login.jsp");
            return;
        }

        @SuppressWarnings("unchecked")
        Map<Integer, CartItem> carrello = (Map<Integer, CartItem>) session.getAttribute("carrello");
        if (carrello == null || carrello.isEmpty()) {
            response.sendRedirect("cart.jsp");
            return;
        }

        request.getRequestDispatcher("checkout.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (!isValidToken(request, session)) {
            response.sendRedirect("error.jsp");
            return;
        }

        if (!isUserLoggedIn(session)) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            Utente utente = (Utente) session.getAttribute("utente");
            @SuppressWarnings("unchecked")
            Map<Integer, CartItem> carrello = (Map<Integer, CartItem>) session.getAttribute("carrello");

            if (carrello == null || carrello.isEmpty()) {
                response.sendRedirect("cart.jsp");
                return;
            }

            Ordine ordine = new Ordine();
            ordine.setUtenteId(utente.getId());
            ordine.setDataOrdine(new Timestamp(System.currentTimeMillis()));
            ordine.setStato("CONFERMATO");
            ordine.setIndirizzoSpedizione(request.getParameter("indirizzo"));
            ordine.setCittaSpedizione(request.getParameter("citta"));
            ordine.setCapSpedizione(request.getParameter("cap"));

            double totale = 0;
            for (CartItem item : carrello.values()) {
                totale += item.getProdotto().getPrezzo() * item.getQuantita();
            }
            ordine.setTotale(totale);

            OrdineDAO ordineDAO = new OrdineDAO();
            int ordineId = ordineDAO.doSave(ordine);

            if (ordineId > 0) {
                DettaglioOrdineDAO dettaglioDAO = new DettaglioOrdineDAO();
                for (CartItem item : carrello.values()) {
                    DettaglioOrdine dettaglio = new DettaglioOrdine();
                    dettaglio.setOrdineId(ordineId);
                    dettaglio.setProdottoId(item.getProdotto().getId());
                    dettaglio.setQuantita(item.getQuantita());
                    dettaglio.setPrezzo(item.getProdotto().getPrezzo());
                    dettaglio.setTaglia(item.getTaglia());
                    dettaglioDAO.doSave(dettaglio);
                }

                carrello.clear();
                session.setAttribute("carrello", carrello);
                request.setAttribute("ordineId", ordineId);
                request.getRequestDispatcher("order-success.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Errore durante la creazione dell'ordine");
                request.getRequestDispatcher("checkout.jsp").forward(request, response);
            }
        } catch (Exception e) {
            logger.error("Errore durante il checkout", e);
            request.setAttribute("errorMessage", "Errore interno del server");
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
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
