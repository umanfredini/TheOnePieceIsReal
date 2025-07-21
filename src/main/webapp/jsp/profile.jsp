<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="header.jsp" />

<style>
/* Stili per la pagina del profilo con texture del legno */
.profile-container {
    background: url('${pageContext.request.contextPath}/styles/images/altro/texture_legno.jpeg') repeat;
    background-size: 200px;
    min-height: 100vh;
    padding: 40px 0;
}

.profile-content {
    background: rgba(255, 255, 255, 0.95);
    border-radius: 15px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
    backdrop-filter: blur(10px);
    border: 2px solid #8B4513;
    overflow: hidden;
}

.profile-header {
    background: linear-gradient(135deg, #8B4513, #A0522D);
    color: white;
    padding: 30px;
    text-align: center;
    position: relative;
}

.profile-header::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: url('${pageContext.request.contextPath}/styles/images/altro/texture_legno.jpeg') repeat;
    background-size: 100px;
    opacity: 0.1;
    z-index: 1;
}

.profile-header h1 {
    position: relative;
    z-index: 2;
    margin: 0;
    font-size: 2.5rem;
    font-weight: 700;
    text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
}

.profile-form {
    padding: 40px;
    background: rgba(255, 255, 255, 0.9);
}

.form-group {
    margin-bottom: 25px;
}

.form-label {
    display: block;
    margin-bottom: 8px;
    font-weight: 600;
    color: #8B4513;
    font-size: 1.1rem;
}

.form-control {
    width: 100%;
    padding: 12px 15px;
    border: 2px solid #D2B48C;
    border-radius: 8px;
    font-size: 1rem;
    transition: all 0.3s ease;
    background: rgba(255, 255, 255, 0.9);
}

.form-control:focus {
    outline: none;
    border-color: #8B4513;
    box-shadow: 0 0 0 3px rgba(139, 69, 19, 0.2);
    background: white;
}

.form-text {
    display: block;
    margin-top: 5px;
    font-size: 0.9rem;
    color: #666;
    font-style: italic;
}

.alert {
    padding: 15px 20px;
    border-radius: 8px;
    margin-bottom: 25px;
    border: none;
    font-weight: 500;
}

.alert-success {
    background: linear-gradient(135deg, #d4edda, #c3e6cb);
    color: #155724;
    border-left: 4px solid #28a745;
}

.alert-danger {
    background: linear-gradient(135deg, #f8d7da, #f5c6cb);
    color: #721c24;
    border-left: 4px solid #dc3545;
}

.alert-info {
    background: linear-gradient(135deg, #d1ecf1, #bee5eb);
    color: #0c5460;
    border-left: 4px solid #17a2b8;
}

.alert-link {
    color: #0c5460;
    text-decoration: underline;
    font-weight: 600;
}

.alert-link:hover {
    color: #062c33;
}

.btn {
    padding: 12px 25px;
    border: none;
    border-radius: 8px;
    font-size: 1rem;
    font-weight: 600;
    cursor: pointer;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    gap: 10px;
    transition: all 0.3s ease;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.btn-primary {
    background: linear-gradient(135deg, #8B4513, #A0522D);
    color: white;
    box-shadow: 0 4px 15px rgba(139, 69, 19, 0.3);
}

.btn-primary:hover {
    background: linear-gradient(135deg, #A0522D, #CD853F);
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(139, 69, 19, 0.4);
}

.btn-secondary {
    background: linear-gradient(135deg, #6c757d, #495057);
    color: white;
    box-shadow: 0 4px 15px rgba(108, 117, 125, 0.3);
}

.btn-secondary:hover {
    background: linear-gradient(135deg, #495057, #343a40);
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(108, 117, 125, 0.4);
}

.btn-group {
    display: flex;
    gap: 15px;
    flex-wrap: wrap;
}

.btn-group .btn {
    flex: 1;
    min-width: 200px;
    justify-content: center;
}

/* Responsive */
@media (max-width: 768px) {
    .profile-container {
        padding: 20px 0;
    }
    
    .profile-header h1 {
        font-size: 2rem;
    }
    
    .profile-form {
        padding: 25px;
    }
    
    .btn-group {
        flex-direction: column;
    }
    
    .btn-group .btn {
        min-width: auto;
    }
}

/* Animazioni */
@keyframes fadeInUp {
    from {
        opacity: 0;
        transform: translateY(30px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.profile-content {
    animation: fadeInUp 0.6s ease-out;
}
</style>

<main class="profile-container" role="main">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8 col-md-10">
                <div class="profile-content">
                    <div class="profile-header">
                        <h1><i class="fas fa-user-circle me-3"></i>Profilo Utente</h1>
                    </div>

                    <div class="profile-form">
                        <c:if test="${sessionScope.isAdmin}">
                            <div class="alert alert-info" role="alert">
                                <i class="fas fa-info-circle me-2"></i>
                                <strong>Amministratore rilevato!</strong> 
                                <a href="${pageContext.request.contextPath}/DashboardServlet" class="alert-link">Accedi alla Dashboard Amministratore</a>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty successMessage}">
                            <div class="alert alert-success" role="alert">
                                <i class="fas fa-check-circle me-2"></i>
                                <c:out value="${successMessage}" />
                            </div>
                        </c:if>
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger" role="alert">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                <c:out value="${errorMessage}" />
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/ProfileServlet" method="post" role="form" aria-label="Modulo aggiornamento profilo">

                            <div class="form-group">
                                <label for="username" class="form-label">
                                    <i class="fas fa-user me-2"></i>Username
                                </label>
                                <input type="text" id="username" name="username" value="${sessionScope.utente.username}" class="form-control" />
                                <small class="form-text">Lascia vuoto per mantenere l'username attuale</small>
                            </div>

                            <div class="form-group">
                                <label for="currentPassword" class="form-label">
                                    <i class="fas fa-lock me-2"></i>Password Attuale
                                </label>
                                <input type="password" id="currentPassword" name="currentPassword" class="form-control" />
                                <small class="form-text">Inserisci solo se vuoi cambiare la password</small>
                            </div>

                            <div class="form-group">
                                <label for="newPassword" class="form-label">
                                    <i class="fas fa-key me-2"></i>Nuova Password
                                </label>
                                <input type="password" id="newPassword" name="newPassword" class="form-control" />
                                <small class="form-text">Inserisci solo se vuoi cambiare la password</small>
                            </div>

                            <div class="form-group">
                                <label for="confirmPassword" class="form-label">
                                    <i class="fas fa-check-circle me-2"></i>Conferma Nuova Password
                                </label>
                                <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" />
                                <small class="form-text">Inserisci solo se vuoi cambiare la password</small>
                            </div>

                            <div class="form-group">
                                <label for="shippingAddress" class="form-label">
                                    <i class="fas fa-map-marker-alt me-2"></i>Indirizzo di spedizione
                                </label>
                                <input type="text" id="shippingAddress" name="shippingAddress" value="${sessionScope.utente.shippingAddress}" class="form-control" />
                                <small class="form-text">Lascia vuoto per mantenere l'indirizzo attuale</small>
                            </div>

                            <div class="btn-group">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i>
                                    Aggiorna Profilo
                                </button>
                                <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">
                                    <i class="fas fa-home"></i>
                                    Torna alla Home
                                </a>
                            </div>
            </form>
        </div>
    </section>
</main>

<jsp:include page="footer.jsp" />