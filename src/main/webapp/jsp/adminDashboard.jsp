<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="header.jsp" />

<main class="container mt-5" role="main">
    <h1 class="mb-4 text-center">Dashboard Amministratore</h1>

    <!-- Statistiche generali -->
    <section class="row text-center mb-5" role="region" aria-label="Statistiche generali">
        <div class="col-md-3 mb-3">
            <div class="card shadow-sm border-primary">
                <div class="card-body">
                    <h5 class="card-title">Totale Utenti</h5>
                    <p class="card-text display-6 text-primary">
                        <c:out value="${userCount}" default="0"/>
                    </p>
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-3">
            <div class="card shadow-sm border-success">
                <div class="card-body">
                    <h5 class="card-title">Totale Ordini</h5>
                    <p class="card-text display-6 text-success">
                        <c:out value="${orderCount}" default="0"/>
                    </p>
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-3">
            <div class="card shadow-sm border-warning">
                <div class="card-body">
                    <h5 class="card-title">Totale Prodotti</h5>
                    <p class="card-text display-6 text-warning">
                        <c:out value="${productCount}" default="0"/>
                    </p>
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-3">
            <div class="card shadow-sm border-info">
                <div class="card-body">
                    <h5 class="card-title">Ricavi Totali</h5>
                    <p class="card-text display-6 text-info">
                        €<fmt:formatNumber value="${totalRevenue}" type="number" maxFractionDigits="2" minFractionDigits="2"/>
                    </p>
                </div>
            </div>
        </div>
    </section>

    <!-- Prodotti più venduti -->
    <section class="row mb-5" role="region" aria-label="Prodotti più venduti">
        <div class="col-12">
            <h3 class="mb-3">Prodotti Più Venduti</h3>
            <div class="table-responsive">
                <table class="table table-striped">
                    <thead class="table-dark">
                        <tr>
                            <th>Prodotto</th>
                            <th>Categoria</th>
                            <th>Prezzo</th>
                            <th>Quantità Venduta</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="product" items="${topSellingProducts}">
                            <tr>
                                <td><c:out value="${product.name}"/></td>
                                <td><c:out value="${product.category}"/></td>
                                <td>€<fmt:formatNumber value="${product.price}" type="number" maxFractionDigits="2"/></td>
                                <td><c:out value="${product.totalSold}"/></td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty topSellingProducts}">
                            <tr>
                                <td colspan="4" class="text-center">Nessun dato di vendita disponibile</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </section>

    <!-- Ordini recenti -->
    <section class="row" role="region" aria-label="Ordini recenti">
        <div class="col-12">
            <h3 class="mb-3">Ordini Recenti</h3>
            <div class="table-responsive">
                <table class="table table-striped">
                    <thead class="table-dark">
                        <tr>
                            <th>ID Ordine</th>
                            <th>Data</th>
                            <th>Totale</th>
                            <th>Stato</th>
                            <th>Azioni</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="order" items="${recentOrders}">
                            <tr>
                                <td>#<c:out value="${order.id}"/></td>
                                <td><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                <td>€<fmt:formatNumber value="${order.totalPrice}" type="number" maxFractionDigits="2"/></td>
                                <td>
                                    <span class="badge bg-${order.status == 'pending' ? 'warning' : 
                                                         order.status == 'processing' ? 'info' : 
                                                         order.status == 'shipped' ? 'primary' : 
                                                         order.status == 'delivered' ? 'success' : 
                                                         order.status == 'cancelled' ? 'danger' : 'secondary'}">
                                        <c:out value="${order.status}"/>
                                    </span>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/AdminOrderServlet?action=view&id=${order.id}" 
                                       class="btn btn-sm btn-outline-primary">
                                        <i class="fas fa-eye"></i> Visualizza
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty recentOrders}">
                            <tr>
                                <td colspan="5" class="text-center">Nessun ordine recente</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </section>

    <!-- Link rapidi -->
    <section class="row mt-5" role="region" aria-label="Link rapidi">
        <div class="col-12">
            <h3 class="mb-3">Gestione Rapida</h3>
            <div class="row">
                <div class="col-md-3 mb-3">
                    <a href="${pageContext.request.contextPath}/AdminProductServlet" class="btn btn-primary btn-lg w-100">
                        <i class="fas fa-box"></i><br>Gestione Prodotti
                    </a>
                </div>
                <div class="col-md-3 mb-3">
                    <a href="${pageContext.request.contextPath}/AdminOrderServlet" class="btn btn-success btn-lg w-100">
                        <i class="fas fa-shopping-cart"></i><br>Gestione Ordini
                    </a>
                </div>
                <div class="col-md-3 mb-3">
                    <a href="${pageContext.request.contextPath}/AdminUserServlet" class="btn btn-info btn-lg w-100">
                        <i class="fas fa-users"></i><br>Gestione Utenti
                    </a>
                </div>
                <div class="col-md-3 mb-3">
                    <a href="${pageContext.request.contextPath}/catalog" class="btn btn-warning btn-lg w-100">
                        <i class="fas fa-store"></i><br>Vai al Negozio
                    </a>
                </div>
            </div>
        </div>
    </section>
</main>

<jsp:include page="footer.jsp" />