package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

// @WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            // Log per debug
            System.out.println("=== LOGOUT DEBUG ===");
            System.out.println("Session ID: " + session.getId());
            System.out.println("isAdmin: " + session.getAttribute("isAdmin"));
            System.out.println("isLoggedIn: " + session.getAttribute("isLoggedIn"));
            System.out.println("Invalidating session...");
            
            session.invalidate();
            System.out.println("Session invalidated successfully");
            System.out.println("=== FINE LOGOUT DEBUG ===");
        }
        
        // Redirect alla home con context path
        response.sendRedirect(request.getContextPath() + "/");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Validazione CSRF token per il logout
        HttpSession session = request.getSession(false);
        if (session != null) {
            String sessionToken = (String) session.getAttribute("csrfToken");
            String requestToken = request.getParameter("csrfToken");
            
            if (sessionToken == null || !sessionToken.equals(requestToken)) {
                System.out.println("=== LOGOUT CSRF ERROR ===");
                System.out.println("Session Token: " + sessionToken);
                System.out.println("Request Token: " + requestToken);
                System.out.println("CSRF validation failed for logout");
                System.out.println("=== FINE LOGOUT CSRF ERROR ===");
                
                // Redirect alla home in caso di errore CSRF
                response.sendRedirect(request.getContextPath() + "/");
                return;
            }
        }
        
        doGet(request, response);
    }
}
