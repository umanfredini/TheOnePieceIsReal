<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="header.jsp" />

<style>
/* Stili per il sistema di tracking One Piece */
.tracking-container {
    background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
    min-height: 100vh;
    padding: 2rem 0;
}

.tracking-card {
    background: rgba(255, 255, 255, 0.95);
    border-radius: 20px;
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
    backdrop-filter: blur(10px);
    border: 2px solid rgba(255, 215, 0, 0.3);
}

.tracking-header {
    background: linear-gradient(135deg, #ffd700, #ffed4e);
    color: #1e3c72;
    border-radius: 15px 15px 0 0;
    padding: 2rem;
    text-align: center;
    position: relative;
    overflow: hidden;
}

.tracking-header::before {
    content: '';
    position: absolute;
    top: -50%;
    left: -50%;
    width: 200%;
    height: 200%;
    background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="50" cy="50" r="2" fill="rgba(30,60,114,0.1)"/></svg>') repeat;
    animation: float 20s infinite linear;
}

@keyframes float {
    0% { transform: translateX(-50px) translateY(-50px); }
    100% { transform: translateX(50px) translateY(50px); }
}

.tracking-title {
    font-size: 2.5rem;
    font-weight: bold;
    margin-bottom: 0.5rem;
    text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);
}

.tracking-subtitle {
    font-size: 1.2rem;
    opacity: 0.8;
}

.search-form {
    padding: 2rem;
    background: white;
    border-radius: 0 0 15px 15px;
}

.search-input-group {
    position: relative;
    margin-bottom: 1rem;
}

.search-input {
    border: 3px solid #ffd700;
    border-radius: 50px;
    padding: 1rem 1.5rem;
    font-size: 1.1rem;
    width: 100%;
    transition: all 0.3s ease;
}

.search-input:focus {
    border-color: #1e3c72;
    box-shadow: 0 0 20px rgba(30, 60, 114, 0.3);
    outline: none;
}

.search-btn {
    background: linear-gradient(135deg, #ffd700, #ffed4e);
    border: none;
    border-radius: 50px;
    padding: 1rem 2rem;
    font-weight: bold;
    color: #1e3c72;
    transition: all 0.3s ease;
    width: 100%;
    font-size: 1.1rem;
}

.search-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 10px 20px rgba(255, 215, 0, 0.4);
}

.tracking-result {
    margin-top: 2rem;
    padding: 2rem;
    background: white;
    border-radius: 15px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
}

.order-info {
    background: linear-gradient(135deg, #f8f9fa, #e9ecef);
    border-radius: 10px;
    padding: 1.5rem;
    margin-bottom: 2rem;
    border-left: 5px solid #ffd700;
}

.progress-container {
    margin: 2rem 0;
}

.progress-bar-custom {
    height: 20px;
    background: linear-gradient(90deg, #ffd700, #ffed4e);
    border-radius: 10px;
    position: relative;
    overflow: hidden;
    box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.1);
}

.progress-bar-custom::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    height: 100%;
    background: linear-gradient(90deg, #1e3c72, #2a5298);
    border-radius: 10px;
    transition: width 1s ease-in-out;
}

.status-steps {
    display: flex;
    justify-content: space-between;
    margin-top: 1rem;
    position: relative;
}

.status-step {
    text-align: center;
    flex: 1;
    position: relative;
}

.status-step::after {
    content: '';
    position: absolute;
    top: 15px;
    right: -50%;
    width: 100%;
    height: 2px;
    background: #dee2e6;
    z-index: 1;
}

.status-step:last-child::after {
    display: none;
}

.status-step.active::after {
    background: #ffd700;
}

.status-icon {
    width: 30px;
    height: 30px;
    border-radius: 50%;
    background: #dee2e6;
    color: white;
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto 0.5rem;
    position: relative;
    z-index: 2;
    transition: all 0.3s ease;
}

.status-step.active .status-icon {
    background: #ffd700;
    color: #1e3c72;
    transform: scale(1.2);
}

.status-step.completed .status-icon {
    background: #28a745;
    color: white;
}

.status-label {
    font-size: 0.9rem;
    font-weight: 500;
    color: #6c757d;
}

.status-step.active .status-label {
    color: #1e3c72;
    font-weight: bold;
}

.status-step.completed .status-label {
    color: #28a745;
}

.error-message {
    background: linear-gradient(135deg, #f8d7da, #f5c6cb);
    border: 1px solid #f5c6cb;
    color: #721c24;
    padding: 1rem;
    border-radius: 10px;
    text-align: center;
    margin: 1rem 0;
}

.success-message {
    background: linear-gradient(135deg, #d4edda, #c3e6cb);
    border: 1px solid #c3e6cb;
    color: #155724;
    padding: 1rem;
    border-radius: 10px;
    text-align: center;
    margin: 1rem 0;
}

.order-details {
    background: #f8f9fa;
    border-radius: 10px;
    padding: 1.5rem;
    margin-top: 1rem;
}

.detail-row {
    display: flex;
    justify-content: space-between;
    padding: 0.5rem 0;
    border-bottom: 1px solid #dee2e6;
}

.detail-row:last-child {
    border-bottom: none;
}

.detail-label {
    font-weight: 600;
    color: #495057;
}

.detail-value {
    color: #6c757d;
}

/* Responsive Design */
@media (max-width: 768px) {
    .tracking-title {
        font-size: 2rem;
    }
    
    .tracking-subtitle {
        font-size: 1rem;
    }
    
    .status-steps {
        flex-direction: column;
        gap: 1rem;
    }
    
    .status-step::after {
        display: none;
    }
    
    .detail-row {
        flex-direction: column;
        gap: 0.25rem;
    }
}

/* Animazioni */
@keyframes slideInUp {
    from {
        opacity: 0;
        transform: translateY(30px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.tracking-result {
    animation: slideInUp 0.6s ease-out;
}

/* Effetti hover */
.tracking-card:hover {
    transform: translateY(-5px);
    transition: transform 0.3s ease;
}
</style>

<main class="tracking-container">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="tracking-card">
                    <!-- Header -->
                    <div class="tracking-header">
                        <h1 class="tracking-title">
                            <i class="fas fa-ship me-3"></i>Tracking Ordine
                        </h1>
                        <p class="tracking-subtitle">Segui il tuo tesoro in viaggio verso la Grand Line!</p>
                    </div>
                    
                    <!-- Form di ricerca -->
                    <div class="search-form">
                        <form method="post" action="${pageContext.request.contextPath}/TrackingServlet">
                            <div class="search-input-group">
                                <input type="text" 
                                       name="trackingNumber" 
                                       class="form-control search-input" 
                                       placeholder="Inserisci il tuo numero di tracking (es. TRK1234567890OP)"
                                       value="${trackingNumber}"
                                       required>
                            </div>
                            <button type="submit" class="btn search-btn">
                                <i class="fas fa-search me-2"></i>Cerca Ordine
                            </button>
                        </form>
                    </div>
                </div>
                
                <!-- Risultati della ricerca -->
                <c:if test="${not empty trackingNumber}">
                    <c:choose>
                        <c:when test="${found}">
                            <!-- Ordine trovato -->
                            <div class="tracking-result">
                                <div class="success-message">
                                    <i class="fas fa-check-circle me-2"></i>
                                    <strong>Ordine trovato!</strong> Ecco i dettagli del tuo tesoro.
                                </div>
                                
                                
                                <!-- Informazioni ordine -->
                                <div class="order-info">
                                    <h3 class="mb-3">
                                        <i class="fas fa-box me-2"></i>Dettagli Ordine
                                    </h3>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="detail-row">
                                                <span class="detail-label">Numero Tracking:</span>
                                                <span class="detail-value">${order.trackingNumber}</span>
                                            </div>
                                            <div class="detail-row">
                                                <span class="detail-label">Data Ordine:</span>
                                                <span class="detail-value">
                                                    <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                </span>
                                            </div>
                                            <div class="detail-row">
                                                <span class="detail-label">Totale Ordine:</span>
                                                <span class="detail-value">
                                                    <strong style="color: #28a745; font-size: 1.1em;">
                                                        <c:choose>
                                                            <c:when test="${not empty order.totalPrice and order.totalPrice > 0}">
                                                                <fmt:formatNumber value="${order.totalPrice}" type="currency" currencySymbol="€"/>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span style="color: #dc3545;">€ 0,00 (Totale non disponibile)</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </strong>
                                                </span>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="detail-row">
                                                <span class="detail-label">Indirizzo Spedizione:</span>
                                                <span class="detail-value">${order.shippingAddress}</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Progresso spedizione -->
                                <div class="progress-container">
                                    <h4 class="mb-3">
                                        <i class="fas fa-route me-2"></i>Stato della Spedizione
                                    </h4>
                                    <div class="progress-bar-custom" style="width: ${progressPercentage}%"></div>
                                    
                                    <div class="status-steps">
                                        <div class="status-step ${order.status == 'pending' ? 'active' : (order.status == 'processing' || order.status == 'shipped' || order.status == 'delivered' ? 'completed' : '')}">
                                            <div class="status-icon">
                                                <i class="fas fa-receipt"></i>
                                            </div>
                                            <div class="status-label">Ordine Ricevuto</div>
                                        </div>
                                        
                                        <div class="status-step ${order.status == 'processing' ? 'active' : (order.status == 'shipped' || order.status == 'delivered' ? 'completed' : '')}">
                                            <div class="status-icon">
                                                <i class="fas fa-cogs"></i>
                                            </div>
                                            <div class="status-label">In Preparazione</div>
                                        </div>
                                        
                                        <div class="status-step ${order.status == 'shipped' ? 'active' : (order.status == 'delivered' ? 'completed' : '')}">
                                            <div class="status-icon">
                                                <i class="fas fa-shipping-fast"></i>
                                            </div>
                                            <div class="status-label">Spedito</div>
                                        </div>
                                        
                                        <div class="status-step ${order.status == 'delivered' ? 'active' : ''}">
                                            <div class="status-icon">
                                                <i class="fas fa-check-circle"></i>
                                            </div>
                                            <div class="status-label">Consegnato</div>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Stato attuale migliorato -->
                                <div class="order-details">
                                    <h5 class="mb-3">
                                        <i class="fas fa-info-circle me-2"></i>Stato Attuale della Spedizione
                                    </h5>
                                    
                                    <!-- Card dello stato principale -->
                                    <div class="alert alert-info border-0 mb-3" style="background: linear-gradient(135deg, #e3f2fd, #bbdefb);">
                                        <div class="d-flex align-items-center">
                                            <div class="me-3">
                                                <c:choose>
                                                    <c:when test="${order.status == 'pending'}">
                                                        <i class="fas fa-clock fa-2x text-warning"></i>
                                                    </c:when>
                                                    <c:when test="${order.status == 'processing'}">
                                                        <i class="fas fa-cogs fa-2x text-info"></i>
                                                    </c:when>
                                                    <c:when test="${order.status == 'shipped'}">
                                                        <i class="fas fa-shipping-fast fa-2x text-primary"></i>
                                                    </c:when>
                                                    <c:when test="${order.status == 'delivered'}">
                                                        <i class="fas fa-check-circle fa-2x text-success"></i>
                                                    </c:when>
                                                    <c:when test="${order.status == 'cancelled'}">
                                                        <i class="fas fa-times-circle fa-2x text-danger"></i>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="fas fa-question-circle fa-2x text-secondary"></i>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div>
                                                <h6 class="mb-1 fw-bold">
                                                    <c:choose>
                                                        <c:when test="${order.status == 'pending'}">Ordine in Elaborazione</c:when>
                                                        <c:when test="${order.status == 'processing'}">Ordine in Preparazione</c:when>
                                                        <c:when test="${order.status == 'shipped'}">Ordine Spedito</c:when>
                                                        <c:when test="${order.status == 'delivered'}">Ordine Consegnato</c:when>
                                                        <c:when test="${order.status == 'cancelled'}">Ordine Annullato</c:when>
                                                        <c:otherwise>Stato Sconosciuto</c:otherwise>
                                                    </c:choose>
                                                </h6>
                                                <p class="mb-0 text-muted">${shippingStatus}</p>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Dettagli aggiuntivi -->
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="detail-row">
                                                <span class="detail-label">Progresso:</span>
                                                <span class="detail-value">${progressPercentage}% completato</span>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="detail-row">
                                                <span class="detail-label">Ultimo Aggiornamento:</span>
                                                <span class="detail-value">
                                                    <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- Ordine non trovato -->
                            <div class="tracking-result">
                                <div class="error-message">
                                    <i class="fas fa-exclamation-triangle me-2"></i>
                                    <strong>Ordine non trovato!</strong>
                                    <c:if test="${not empty errorMessage}">
                                        <br>${errorMessage}
                                    </c:if>
                                </div>
                                
                                <div class="text-center mt-3">
                                    <p class="text-muted">
                                        Verifica di aver inserito correttamente il numero di tracking.<br>
                                        Il numero dovrebbe essere nel formato: <strong>TRK1234567890OP</strong>
                                    </p>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </c:if>
            </div>
        </div>
    </div>
</main>

<script>
// Animazione della barra di progresso
document.addEventListener('DOMContentLoaded', function() {
    const progressBar = document.querySelector('.progress-bar-custom');
    if (progressBar) {
        // Ottieni la percentuale dalla larghezza attuale
        const currentWidth = progressBar.style.width;
        if (currentWidth) {
            // Reset per l'animazione
            progressBar.style.width = '0%';
            
            // Anima la barra di progresso
            setTimeout(() => {
                progressBar.style.width = currentWidth;
            }, 500);
        }
    }
});

</script>

<jsp:include page="footer.jsp" />
