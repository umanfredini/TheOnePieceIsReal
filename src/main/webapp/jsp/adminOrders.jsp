<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="header.jsp" />

<main class="container mt-5" role="main">
    <jsp:include page="adminBreadcrumb.jsp">
        <jsp:param name="page" value="orders" />
    </jsp:include>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1>Gestione Ordini</h1>
        <div>
            <button class="btn btn-outline-secondary" onclick="exportOrders()">
                <i class="fas fa-download me-1"></i>Esporta
            </button>
        </div>
    </div>

    <!-- Filtri -->
    <div class="card mb-4">
        <div class="card-body">
            <form method="GET" action="AdminOrderServlet" class="row g-3">
                <div class="col-md-3">
                    <label for="dataInizio" class="form-label">Data Inizio</label>
                    <input type="date" class="form-control" id="dataInizio" name="dataInizio" 
                           value="${param.dataInizio}">
                </div>
                <div class="col-md-3">
                    <label for="dataFine" class="form-label">Data Fine</label>
                    <input type="date" class="form-control" id="dataFine" name="dataFine" 
                           value="${param.dataFine}">
                </div>
                <div class="col-md-3">
                    <label for="clienteId" class="form-label">ID Cliente</label>
                    <input type="number" class="form-control" id="clienteId" name="clienteId" 
                           value="${param.clienteId}" placeholder="Filtra per cliente">
                </div>
                <div class="col-md-3 d-flex align-items-end">
                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-search me-1"></i>Filtra
                        </button>
                        <a href="AdminOrderServlet" class="btn btn-outline-secondary">
                            <i class="fas fa-times me-1"></i>Reset
                        </a>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Statistiche rapide -->
    <div class="row mb-4">
        <div class="col-md-3">
            <div class="card bg-primary text-white">
                <div class="card-body text-center">
                    <h5 class="card-title">Totale Ordini</h5>
                    <h3 class="mb-0">${ordini.size()}</h3>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card bg-warning text-white">
                <div class="card-body text-center">
                    <h5 class="card-title">In Attesa</h5>
                    <h3 class="mb-0">
                        <c:set var="pendingCount" value="0"/>
                        <c:forEach var="order" items="${ordini}">
                            <c:if test="${order.status == 'pending'}">
                                <c:set var="pendingCount" value="${pendingCount + 1}"/>
                            </c:if>
                        </c:forEach>
                        ${pendingCount}
                    </h3>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card bg-info text-white">
                <div class="card-body text-center">
                    <h5 class="card-title">In Elaborazione</h5>
                    <h3 class="mb-0">
                        <c:set var="processingCount" value="0"/>
                        <c:forEach var="order" items="${ordini}">
                            <c:if test="${order.status == 'processing'}">
                                <c:set var="processingCount" value="${processingCount + 1}"/>
                            </c:if>
                        </c:forEach>
                        ${processingCount}
                    </h3>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card bg-success text-white">
                <div class="card-body text-center">
                    <h5 class="card-title">Consegnati</h5>
                    <h3 class="mb-0">
                        <c:set var="deliveredCount" value="0"/>
                        <c:forEach var="order" items="${ordini}">
                            <c:if test="${order.status == 'delivered'}">
                                <c:set var="deliveredCount" value="${deliveredCount + 1}"/>
                            </c:if>
                        </c:forEach>
                        ${deliveredCount}
                    </h3>
                </div>
            </div>
        </div>
    </div>

    <!-- Tabella ordini -->
    <section role="region" aria-label="Tabella ordini" class="table-responsive">
        <c:choose>
            <c:when test="${not empty ordini}">
                <table class="table table-striped table-hover align-middle">
                    <thead class="table-dark">
                        <tr>
                            <th scope="col">ID Ordine</th>
                            <th scope="col">Data</th>
                            <th scope="col">Cliente</th>
                            <th scope="col">Totale</th>
                            <th scope="col">Stato</th>
                            <th scope="col">Azioni</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="order" items="${ordini}">
                            <tr>
                                <td>
                                    <strong>#<c:out value="${order.id}" /></strong>
                                </td>
                                <td>
                                    <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy"/>
                                    <br>
                                    <small class="text-muted">
                                        <fmt:formatDate value="${order.orderDate}" pattern="HH:mm"/>
                                    </small>
                                </td>
                                <td>
                                    <div>
                                        <strong><c:out value="${order.userEmail}" /></strong>
                                        <c:if test="${not empty order.userId}">
                                            <br>
                                            <small class="text-muted">ID: ${order.userId}</small>
                                        </c:if>
                                    </div>
                                </td>
                                <td>
                                    <strong>€ <fmt:formatNumber value="${order.totalPrice}" type="currency" currencySymbol="€" /></strong>
                                </td>
                                <td>
                                    <span class="badge 
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
                                </td>
                                <td>
                                    <div class="d-flex gap-1">
                                        <a href="AdminOrderServlet?action=detail&id=${order.id}" 
                                           class="btn btn-sm btn-outline-primary" title="Visualizza Dettagli">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <div class="dropdown">
                                            <button type="button" class="btn btn-sm btn-outline-secondary dropdown-toggle" 
                                                    data-bs-toggle="dropdown" aria-expanded="false" title="Azioni">
                                                <i class="fas fa-ellipsis-v"></i>
                                            </button>
                                            <ul class="dropdown-menu dropdown-menu-end">
                                                <li><h6 class="dropdown-header">Aggiorna Stato</h6></li>
                                                <li><a class="dropdown-item" href="#" onclick="updateOrderStatus(${order.id}, 'processing')">
                                                    <i class="fas fa-cogs me-2 text-info"></i>In Elaborazione
                                                </a></li>
                                                <li><a class="dropdown-item" href="#" onclick="updateOrderStatus(${order.id}, 'shipped')">
                                                    <i class="fas fa-shipping-fast me-2 text-primary"></i>Spedito
                                                </a></li>
                                                <li><a class="dropdown-item" href="#" onclick="updateOrderStatus(${order.id}, 'delivered')">
                                                    <i class="fas fa-check-circle me-2 text-success"></i>Consegnato
                                                </a></li>
                                                <li><hr class="dropdown-divider"></li>
                                                <li><a class="dropdown-item text-danger" href="#" onclick="deleteOrder(${order.id})">
                                                    <i class="fas fa-trash me-2"></i>Elimina Ordine
                                                </a></li>
                                            </ul>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="alert alert-info text-center" role="alert">
                    <i class="fas fa-info-circle me-2"></i>
                    Nessun ordine trovato con i filtri applicati.
                </div>
            </c:otherwise>
        </c:choose>
    </section>
</main>

<script>
function updateOrderStatus(orderId, status) {
    if (confirm('Sei sicuro di voler aggiornare lo stato dell\'ordine?')) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = 'AdminOrderServlet';
        
        const orderIdInput = document.createElement('input');
        orderIdInput.type = 'hidden';
        orderIdInput.name = 'ordineId';
        orderIdInput.value = orderId;
        
        const statusInput = document.createElement('input');
        statusInput.type = 'hidden';
        statusInput.name = 'stato';
        statusInput.value = status;
        
        const tokenInput = document.createElement('input');
        tokenInput.type = 'hidden';
        tokenInput.name = 'token';
        tokenInput.value = '${sessionScope.csrfToken}';
        
        form.appendChild(orderIdInput);
        form.appendChild(statusInput);
        form.appendChild(tokenInput);
        document.body.appendChild(form);
        form.submit();
    }
}

function deleteOrder(orderId) {
    if (confirm('Sei sicuro di voler eliminare questo ordine? Questa azione non può essere annullata.')) {
        // Implementare eliminazione ordine
        alert('Funzionalità di eliminazione non ancora implementata');
    }
}

function exportOrders() {
    // Implementare esportazione ordini
    alert('Funzionalità di esportazione non ancora implementata');
}
</script>

<jsp:include page="footer.jsp" />