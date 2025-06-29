package control;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.dao.ProdottoDAO;
import model.bean.Prodotto;
import model.bean.CartItem;

@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        
        @SuppressWarnings("unchecked")
        Map<Integer, CartItem> carrello = (Map<Integer, CartItem>) session.getAttribute("carrello");
        if (carrello == null) {
            carrello = new HashMap<>();
            session.setAttribute("carrello", carrello);
        }
        
        try {
            switch (action) {
                case "add":
                    addToCart(request, carrello);
                    break;
                case "update":
                    updateCart(request, carrello);
                    break;
                case "remove":
                    removeFromCart(request, carrello);
                    break;
                case "clear":
                    carrello.clear();
                    break;
            }
            
            session.setAttribute("carrello", carrello);
            
            // AJAX response
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": true, \"cartSize\": " + carrello.size() + "}");
            } else {
                response.sendRedirect("cart.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"error\": \"Errore interno\"}");
            } else {
                response.sendRedirect("error.jsp");
            }
        }
    }
    
    private void addToCart(HttpServletRequest request, Map<Integer, CartItem> carrello) throws Exception {
        int prodottoId = Integer.parseInt(request.getParameter("prodottoId"));
        int quantita = Integer.parseInt(request.getParameter("quantita"));
        String taglia = request.getParameter("taglia");
        
        ProdottoDAO prodottoDAO = new ProdottoDAO();
        Prodotto prodotto = prodottoDAO.doRetrieveByKey(prodottoId);
        
        if (prodotto != null && prodotto.getQuantita() >= quantita) {
            CartItem item = carrello.get(prodottoId);
            if (item != null) {
                item.setQuantita(item.getQuantita() + quantita);
            } else {
                item = new CartItem(prodotto, quantita, taglia);
                carrello.put(prodottoId, item);
            }
        }
    }
    
    private void updateCart(HttpServletRequest request, Map<Integer, CartItem> carrello) {
        int prodottoId = Integer.parseInt(request.getParameter("prodottoId"));
        int quantita = Integer.parseInt(request.getParameter("quantita"));
        
        if (quantita <= 0) {
            carrello.remove(prodottoId);
        } else {
            CartItem item = carrello.get(prodottoId);
            if (item != null) {
                item.setQuantita(quantita);
            }
        }
    }
    
    private void removeFromCart(HttpServletRequest request, Map<Integer, CartItem> carrello) {
        int prodottoId = Integer.parseInt(request.getParameter("prodottoId"));
        carrello.remove(prodottoId);
    }
}