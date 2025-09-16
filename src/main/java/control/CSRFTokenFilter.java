package control;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.UUID;

public class CSRFTokenFilter implements Filter {
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        String requestURI = httpRequest.getRequestURI();
        
        // Salta il filtro per file statici e per il logout
        if (requestURI.contains("/styles/") || 
            requestURI.contains("/scripts/") || 
            requestURI.contains("/images/") ||
            requestURI.contains(".css") || 
            requestURI.contains(".js") || 
            requestURI.contains(".jpg") || 
            requestURI.contains(".png") || 
            requestURI.contains(".gif") ||
            requestURI.contains(".ico") ||
            requestURI.contains("/LogoutServlet") ||
            requestURI.contains("/jsp/logout.jsp") ||
            requestURI.contains("/CartServlet")) {
            chain.doFilter(request, response);
            return;
        }
        
        HttpSession session = httpRequest.getSession(true); // Crea sessione se non esiste
        
        // Debug logging solo per richieste non-statiche
        System.out.println("=== CSRFTokenFilter DEBUG ===");
        System.out.println("Request URI: " + requestURI);
        System.out.println("Session ID: " + session.getId());
        System.out.println("Session is new: " + session.isNew());
        System.out.println("Existing CSRF Token: " + session.getAttribute("csrfToken"));
        
        // Genera token CSRF se non esiste
        if (session.getAttribute("csrfToken") == null) {
            String csrfToken = UUID.randomUUID().toString();
            session.setAttribute("csrfToken", csrfToken);
            System.out.println("Nuovo CSRF Token generato: " + csrfToken);
        }
        
        System.out.println("=== FINE CSRFTokenFilter DEBUG ===");
        
        chain.doFilter(request, response);
    }
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Inizializzazione del filtro
    }
    
    @Override
    public void destroy() {
        // Pulizia del filtro
    }
} 