<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="header.jsp" />

<!-- Debug per pagina logout -->
<script>
console.log('=== DEBUG PAGINA LOGOUT ===');
console.log('Pagina logout caricata');
console.log('CSRF Token disponibile:', '${sessionScope.csrfToken}');
console.log('Session isAdmin:', '${sessionScope.isAdmin}');
console.log('Session isLoggedIn:', '${sessionScope.isLoggedIn}');
console.log('=== FINE DEBUG PAGINA LOGOUT ===');

// Aggiungi classe admin-page al body se l'utente è admin
document.addEventListener('DOMContentLoaded', function() {
    const isAdmin = '${sessionScope.isAdmin}' === 'true';
    console.log('Utente è admin:', isAdmin);
    
    if (isAdmin) {
        document.body.classList.add('admin-page');
        console.log('Classe admin-page aggiunta al body per pagina logout');
        console.log('Pagina logout configurata per admin - solo Conferma Logout e Torna alla Dashboard');
    } else {
        console.log('Pagina logout configurata per utente normale - Home e Profilo disponibili');
    }
});
</script>

<style>
/* Stili One Piece per logout */
h2 {
    font-family: 'Pirata One', 'Bangers', cursive;
    color: #f1c40f;
    text-shadow: 3px 3px 0px #2c3e50;
    letter-spacing: 2px;
}

.card {
    background: rgba(255, 255, 255, 0.95);
    border: 3px solid #f1c40f;
    border-radius: 20px;
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
}

.card-header {
    background: linear-gradient(135deg, #e74c3c, #c0392b) !important;
    border: none !important;
    border-radius: 17px 17px 0 0 !important;
}

.card-header h2 {
    color: white !important;
    text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.8);
}

h4 {
    font-family: 'Bangers', cursive;
    color: #2c3e50;
    font-weight: bold;
    text-transform: uppercase;
    letter-spacing: 1px;
}

.btn-danger {
    background: linear-gradient(135deg, #e74c3c, #c0392b);
    border: none;
    border-radius: 12px;
    font-family: 'Bangers', cursive;
    font-weight: bold;
    text-transform: uppercase;
    letter-spacing: 1px;
    box-shadow: 0 6px 12px rgba(231, 76, 60, 0.3);
    transition: all 0.3s ease;
}

.btn-danger:hover {
    background: linear-gradient(135deg, #c0392b, #a93226);
    transform: translateY(-2px);
    box-shadow: 0 8px 16px rgba(231, 76, 60, 0.4);
}

.btn-outline-secondary {
    border: 2px solid #6c757d;
    border-radius: 12px;
    font-family: 'Bangers', cursive;
    font-weight: bold;
    text-transform: uppercase;
    letter-spacing: 1px;
    transition: all 0.3s ease;
}

.btn-outline-secondary:hover {
    background: #6c757d;
    border-color: #6c757d;
    transform: translateY(-2px);
}

.btn-outline-primary {
    border: 2px solid #3498db;
    border-radius: 12px;
    font-family: 'Bangers', cursive;
    font-weight: bold;
    text-transform: uppercase;
    letter-spacing: 1px;
    transition: all 0.3s ease;
}

.btn-outline-primary:hover {
    background: #3498db;
    border-color: #3498db;
    transform: translateY(-2px);
}

.card-footer {
    background: linear-gradient(135deg, #f8f9fa, #e9ecef) !important;
    border-top: 2px solid #f1c40f !important;
    border-radius: 0 0 17px 17px !important;
}

.text-warning {
    color: #f1c40f !important;
}

/* Regole responsive specifiche per pagina logout con menu admin */
@media (max-width: 1200px) {
    .admin-page .main-nav a {
        padding: 0.3rem 0.4rem;
        font-size: 0.75rem;
    }
    
    .admin-page .main-nav ul {
        gap: 0.4rem;
    }
    
    .admin-page .main-nav a i {
        font-size: 0.8rem;
    }
}

@media (max-width: 1024px) {
    .admin-page .main-nav a {
        padding: 0.25rem 0.35rem;
        font-size: 0.7rem;
    }
    
    .admin-page .main-nav ul {
        gap: 0.3rem;
    }
    
    .admin-page .main-nav a i {
        font-size: 0.75rem;
    }
}

@media (max-width: 900px) {
    .admin-page .main-nav a {
        padding: 0.2rem 0.3rem;
        font-size: 0.65rem;
    }
    
    .admin-page .main-nav ul {
        gap: 0.25rem;
    }
    
    .admin-page .main-nav a i {
        font-size: 0.7rem;
    }
}

@media (max-width: 768px) {
    .admin-page .main-nav a {
        padding: 0.15rem 0.25rem;
        font-size: 0.6rem;
    }
    
    .admin-page .main-nav ul {
        gap: 0.2rem;
    }
    
    .admin-page .main-nav a i {
        font-size: 0.65rem;
    }
}
</style>

<main class="container mt-5" role="main">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card shadow-lg border-0">
                <div class="card-header bg-gradient-primary text-white text-center py-4">
                    <h2 class="mb-0">
                        <i class="fas fa-sign-out-alt me-2"></i>
                        Logout
                    </h2>
                </div>
                
                <div class="card-body p-5">
                    <div class="text-center mb-4">
                        <i class="fas fa-question-circle text-warning" style="font-size: 3rem;"></i>
                    </div>
                    
                    <h4 class="text-center mb-4">Sei sicuro di voler effettuare il logout?</h4>
                    
                    <p class="text-muted text-center mb-4">
                        <c:choose>
                            <c:when test="${sessionScope.isAdmin}">
                                Verrai disconnesso dal pannello amministratore e dovrai effettuare nuovamente l'accesso per gestire il sistema.
                            </c:when>
                            <c:otherwise>
                                Verrai disconnesso dal tuo account e dovrai effettuare nuovamente l'accesso per utilizzare le funzionalità riservate.
                            </c:otherwise>
                        </c:choose>
                    </p>
                    
                    <div class="d-grid gap-3">
                        <form action="${pageContext.request.contextPath}/LogoutServlet" method="post" class="d-grid">
                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                            <button type="submit" class="btn btn-danger btn-lg">
                                <i class="fas fa-sign-out-alt me-2"></i>
                                Conferma Logout
                            </button>
                        </form>
                        
                        <c:choose>
                            <c:when test="${sessionScope.isAdmin}">
                                <!-- Solo per admin: Torna alla Dashboard -->
                                <a href="${pageContext.request.contextPath}/DashboardServlet" class="btn btn-outline-primary btn-lg">
                                    <i class="fas fa-tachometer-alt me-2"></i>
                                    Torna alla Dashboard
                                </a>
                            </c:when>
                            <c:otherwise>
                                <!-- Per utenti normali: Home e Profilo -->
                                <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary btn-lg">
                                    <i class="fas fa-home me-2"></i>
                                    Torna alla Home
                                </a>
                                
                                <a href="${pageContext.request.contextPath}/jsp/profile.jsp" class="btn btn-outline-primary btn-lg">
                                    <i class="fas fa-user-circle me-2"></i>
                                    Torna al Profilo
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                
                <div class="card-footer bg-light text-center py-3">
                    <small class="text-muted">
                        <i class="fas fa-info-circle me-1"></i>
                        La tua sessione verrà terminata in modo sicuro
                    </small>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="footer.jsp" /> 