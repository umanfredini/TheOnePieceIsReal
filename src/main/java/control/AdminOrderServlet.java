package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Order;
import dao.OrderDAO;
import java.util.logging.Logger;
import java.sql.Date;


import java.io.IOException;
import java.util.List;

public class AdminOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(AdminOrderServlet.class.getName());

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (!isAdminLoggedIn(session)) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        try {
            String dataInizioStr = request.getParameter("dataInizio");
            String dataFineStr = request.getParameter("dataFine");
            String clienteId = request.getParameter("clienteId");

            logger.info("=== DEBUG FILTRO ORDINI ===");
            logger.info("Data inizio: " + dataInizioStr);
            logger.info("Data fine: " + dataFineStr);
            logger.info("Cliente ID: " + clienteId);

            OrderDAO ordineDAO = new OrderDAO();
            List<Order> ordini;

            if (dataInizioStr != null && dataFineStr != null) {
                logger.info("Filtro per range di date");
                Date dataInizio = Date.valueOf(dataInizioStr); // formato: yyyy-MM-dd
                Date dataFine = Date.valueOf(dataFineStr);
                logger.info("Date convertite - Inizio: " + dataInizio + ", Fine: " + dataFine);
                ordini = ordineDAO.findByDateRange(dataInizio, dataFine);
                logger.info("Ordini trovati per range: " + ordini.size());
            } else if (clienteId != null && !clienteId.isEmpty()) {
                logger.info("Filtro per cliente ID: " + clienteId);
                int clienteIdInt = Integer.parseInt(clienteId);
                ordini = ordineDAO.findByUserId(clienteIdInt);
                logger.info("Ordini trovati per cliente: " + ordini.size());
            } else {
                logger.info("Nessun filtro - caricamento tutti gli ordini");
                ordini = ordineDAO.findAll();
                logger.info("Tutti gli ordini caricati: " + ordini.size());
            }

            request.setAttribute("ordini", ordini);
            logger.info("=== FINE DEBUG FILTRO ORDINI ===");
            request.getRequestDispatcher("/jsp/adminOrders.jsp").forward(request, response);
        } catch (Exception e) {
            logger.severe("=== ERRORE FILTRO ORDINI ===");
            logger.severe("Errore nella gestione ordini admin: " + e.getMessage());
            logger.severe("Stack trace: ");
            e.printStackTrace();
            logger.severe("=== FINE ERRORE FILTRO ORDINI ===");
            
            request.setAttribute("errorMessage", "Errore nella gestione degli ordini. Riprova.");
            request.getRequestDispatcher("/jsp/error.jsp").forward(request, response);
        }
    }


    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (!isValidToken(request, session)) {
            request.setAttribute("errorMessage", "Token di sicurezza non valido. Riprova.");
            request.getRequestDispatcher("/jsp/error.jsp").forward(request, response);
            return;
        }

        if (!isAdminLoggedIn(session)) {
            response.sendRedirect("LoginServlet");
            return;
        }

        try {
            int ordineId = Integer.parseInt(request.getParameter("ordineId"));
            String nuovoStato = request.getParameter("stato");

            OrderDAO ordineDAO = new OrderDAO();
            ordineDAO.updateStato(ordineId, nuovoStato);

            response.sendRedirect("AdminOrderServlet");
        } catch (Exception e) {
            // Errore nell'aggiornamento stato ordine
            request.setAttribute("errorMessage", "Errore nell'aggiornamento dello stato dell'ordine. Riprova.");
            request.getRequestDispatcher("/jsp/error.jsp").forward(request, response);
        }
    }

    private boolean isAdminLoggedIn(HttpSession session) {
        logger.info("=== DEBUG SESSIONE ADMIN ===");
        logger.info("Session: " + (session != null ? "presente" : "null"));
        
        if (session == null) {
            logger.warning("Sessione null - logout automatico");
            return false;
        }
        
        logger.info("Session ID: " + session.getId());
        logger.info("Session is new: " + session.isNew());
        logger.info("Session creation time: " + new java.util.Date(session.getCreationTime()));
        logger.info("Session last accessed: " + new java.util.Date(session.getLastAccessedTime()));
        logger.info("Session max inactive interval: " + session.getMaxInactiveInterval());
        
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
        
        logger.info("isAdmin: " + isAdmin);
        logger.info("isLoggedIn: " + isLoggedIn);
        
        boolean result = isAdmin != null && isAdmin && isLoggedIn != null && isLoggedIn;
        logger.info("Risultato controllo admin: " + result);
        logger.info("=== FINE DEBUG SESSIONE ADMIN ===");
        
        return result;
    }

    private boolean isValidToken(HttpServletRequest request, HttpSession session) {
        String sessionToken = (String) session.getAttribute("csrfToken");
        String requestToken = request.getParameter("csrfToken");
        return sessionToken != null && sessionToken.equals(requestToken);
    }
}
