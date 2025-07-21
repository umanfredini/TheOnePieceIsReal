<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="header.jsp" />

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
                        Verrai disconnesso dal tuo account e dovrai effettuare nuovamente l'accesso per utilizzare le funzionalità riservate.
                    </p>
                    
                    <div class="d-grid gap-3">
                        <form action="${pageContext.request.contextPath}/LogoutServlet" method="post" class="d-grid">
                            <button type="submit" class="btn btn-danger btn-lg">
                                <i class="fas fa-sign-out-alt me-2"></i>
                                Conferma Logout
                            </button>
                        </form>
                        
                        <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary btn-lg">
                            <i class="fas fa-home me-2"></i>
                            Torna alla Home
                        </a>
                        
                        <a href="${pageContext.request.contextPath}/jsp/profile.jsp" class="btn btn-outline-primary btn-lg">
                            <i class="fas fa-user-circle me-2"></i>
                            Torna al Profilo
                        </a>
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