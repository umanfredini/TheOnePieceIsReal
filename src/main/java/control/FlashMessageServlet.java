package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/FlashMessageServlet")
public class FlashMessageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Gestisce la visualizzazione dei messaggi flash
        String messageType = request.getParameter("type");
        String message = request.getParameter("message");
        
        if (messageType != null && message != null) {
            request.setAttribute(messageType + "Message", message);
        }
        
        // Reindirizza alla pagina richiesta
        String redirectUrl = request.getParameter("redirect");
        if (redirectUrl != null) {
            response.sendRedirect(redirectUrl);
        } else {
            response.sendRedirect("index.jsp");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
} 