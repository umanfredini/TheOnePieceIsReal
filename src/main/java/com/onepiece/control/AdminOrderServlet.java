package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.dao.OrdineDAO;
import model.bean.Ordine;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.List;

@WebServlet("/AdminOrderServlet")
public class AdminOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = LoggerFactory.getLogger(AdminOrderServlet.class);

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (!isAdminLoggedIn(session)) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            String dataInizio = request.getParameter("dataInizio");
            String dataFine = request.getParameter("dataFine");
            String clienteId = request.getParameter("clienteId");

            OrdineDAO ordineDAO = new OrdineDAO();
            List<Ordine> ordini;

            if (dataInizio != null && dataFine != null) {
                ordini = ordineDAO.doRetrieveByDateRange(dataInizio, dataFine);
            } else if (clienteId != null && !clienteId.isEmpty()) {
                ordini = ordineDAO.doRetrieveByUtente(Integer.parseInt(clienteId));
            } else {
                ordini = ordineDAO.doRetrieveAll();
            }

            request.setAttribute("ordini", ordini);
            request.getRequestDispatcher("orders.jsp").forward(request, response);
        } catch (Exception e) {
            logger.error("Errore nella gestione ordini admin", e);
            response.sendRedirect("error.jsp");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (!isValidToken(request, session)) {
            response.sendRedirect("error.jsp");
            return;
        }

        if (!isAdminLoggedIn(session)) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int ordineId = Integer.parseInt(request.getParameter("ordineId"));
            String nuovoStato = request.getParameter("stato");

            OrdineDAO ordineDAO = new OrdineDAO();
            ordineDAO.updateStato(ordineId, nuovoStato);

            response.sendRedirect("AdminOrderServlet");
        } catch (Exception e) {
            logger.error("Errore nell'aggiornamento stato ordine", e);
            response.sendRedirect("error.jsp");
        }
    }

    private boolean isAdminLoggedIn(HttpSession session) {
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        Boolean isLoggedIn = (Boolean) session.getAttribute("isLoggedIn");
        return isAdmin != null && isAdmin && isLoggedIn != null && isLoggedIn;
    }

    private boolean isValidToken(HttpServletRequest request, HttpSession session) {
        String sessionToken = (String) session.getAttribute("token");
        String requestToken = request.getParameter("token");
        return sessionToken != null && sessionToken.equals(requestToken);
    }
}
