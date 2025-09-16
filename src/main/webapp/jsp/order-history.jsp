<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="header.jsp" %>

<main class="container mt-5" role="main">
    <h1 class="mb-4 text-center">Storico Ordini</h1>

    <c:choose>
        <c:when test="${empty orders}">
            <div class="alert alert-info text-center" role="alert">
                <h4 class="alert-heading">Nessun ordine trovato</h4>
                <p>Non hai ancora effettuato nessun ordine. Inizia a fare shopping!</p>
                <hr>
                <a href="HomeServlet" class="btn btn-primary">Vai al Catalogo</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="row">
                <c:forEach var="order" items="${orders}">
                    <div class="col-12 mb-4">
                        <div class="card shadow-sm">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h5 class="mb-0">
                                    <i class="fas fa-shopping-bag me-2"></i>
                                    Ordine #${order.id}
                                </h5>
                                <div class="d-flex align-items-center">
                                    <span class="badge me-3
                                        <c:choose>
                                            <c:when test="${order.status == 'pending'}">bg-warning</c:when>
                                            <c:when test="${order.status == 'processing'}">bg-info</c:when>
                                            <c:when test="${order.status == 'shipped'}">bg-primary</c:when>
                                            <c:when test="${order.status == 'delivered'}">bg-success</c:when>
                                            <c:otherwise>bg-secondary</c:otherwise>
                                        </c:choose>">
                                        <c:choose>
                                            <c:when test="${order.status == 'pending'}">In Attesa</c:when>
                                            <c:when test="${order.status == 'processing'}">In Elaborazione</c:when>
                                            <c:when test="${order.status == 'shipped'}">Spedito</c:when>
                                            <c:when test="${order.status == 'delivered'}">Consegnato</c:when>
                                            <c:otherwise>${order.status}</c:otherwise>
                                        </c:choose>
                                    </span>
                                    <small class="text-muted">
                                        <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy 'alle' HH:mm"/>
                                    </small>
                                </div>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-8">
                                        <h6 class="card-subtitle mb-3">Dettagli Ordine:</h6>
                                        <ul class="list-unstyled">
                                            <li><strong>Data Ordine:</strong> <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy"/></li>
                                            <li><strong>Stato:</strong> 
                                                <c:choose>
                                                    <c:when test="${order.status == 'pending'}">In Attesa di Conferma</c:when>
                                                    <c:when test="${order.status == 'processing'}">In Elaborazione</c:when>
                                                    <c:when test="${order.status == 'shipped'}">Spedito</c:when>
                                                    <c:when test="${order.status == 'delivered'}">Consegnato</c:when>
                                                    <c:otherwise>${order.status}</c:otherwise>
                                                </c:choose>
                                            </li>
                                            <c:if test="${not empty order.shippingAddress}">
                                                <li><strong>Indirizzo di Spedizione:</strong> ${order.shippingAddress}</li>
                                            </c:if>
                                            <c:if test="${not empty order.trackingNumber}">
                                                <li><strong>Numero di Tracking:</strong> ${order.trackingNumber}</li>
                                            </c:if>
                                        </ul>
                                    </div>
                                    <div class="col-md-4 text-end">
                                        <div class="card bg-light">
                                            <div class="card-body">
                                                <h6 class="card-title">Totale Ordine</h6>
                                                <h4 class="text-primary mb-0">€<fmt:formatNumber value="${order.totalAmount}" type="number" maxFractionDigits="2" minFractionDigits="2"/></h4>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Prodotti dell'ordine -->
                                <c:if test="${not empty order.orderItems}">
                                    <hr>
                                    <h6 class="mb-3">Prodotti Ordinati:</h6>
                                    <div class="table-responsive">
                                        <table class="table table-sm">
                                            <thead class="table-light">
                                                <tr>
                                                    <th>Prodotto</th>
                                                    <th>Quantità</th>
                                                    <th>Prezzo Unitario</th>
                                                    <th>Totale</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="item" items="${order.orderItems}">
                                                    <tr>
                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                <img src="${pageContext.request.contextPath}/styles/images/prodotti/${item.product.imageUrl}" alt="${item.product.name}" 
                                                                     class="me-2" style="width: 40px; height: 40px; object-fit: cover; border-radius: 4px;">
                                                                <span>${item.product.name}</span>
                                                            </div>
                                                        </td>
                                                        <td>${item.quantity}</td>
                                                        <td>€<fmt:formatNumber value="${item.unitPrice}" type="number" maxFractionDigits="2"/></td>
                                                        <td>€<fmt:formatNumber value="${item.unitPrice * item.quantity}" type="number" maxFractionDigits="2"/></td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:if>
                            </div>
                            <div class="card-footer">
                                <div class="d-flex justify-content-between align-items-center">
                                    <small class="text-muted">Ordine effettuato il <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy 'alle' HH:mm"/></small>
                                    <c:if test="${order.status == 'delivered'}">
                                        <button class="btn btn-outline-primary btn-sm" onclick="window.print()">
                                            <i class="fas fa-print me-1"></i>Stampa Ricevuta
                                        </button>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<style>
@media print {
    .btn, .card-footer {
        display: none !important;
    }
    .card {
        border: 1px solid #000 !important;
        box-shadow: none !important;
    }
}
</style>

<jsp:include page="footer.jsp" />
