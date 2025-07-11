<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="header.jsp" />

<main class="container mt-5" role="main">
    <h1 class="mb-4 text-center">Gestione Ordini</h1>

    <section role="region" aria-label="Tabella ordini" class="table-responsive">
        <c:choose>
            <c:when test="${not empty orders}">
                <table class="table table-striped table-hover align-middle">
                    <thead class="table-dark">
                        <tr>
                            <th scope="col">ID Ordine</th>
                            <th scope="col">Data</th>
                            <th scope="col">Cliente</th>
                            <th scope="col">Totale</th>
                            <th scope="col">Stato</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="order" items="${orders}">
                            <tr>
                                <td>#<c:out value="${order.id}" /></td>
                                <td><c:out value="${order.orderDate}" /></td>
                                <td><c:out value="${order.userEmail}" /></td>
                                <td>€ <fmt:formatNumber value="${order.totalPrice}" type="currency" currencySymbol="€" /></td>
                                <td>
                                    <span class="badge 
                                        <c:choose>
                                            <c:when test="${order.status == 'pending'}">bg-warning</c:when>
                                            <c:when test="${order.status == 'processing'}">bg-info</c:when>
                                            <c:when test="${order.status == 'shipped'}">bg-primary</c:when>
                                            <c:when test="${order.status == 'delivered'}">bg-success</c:when>
                                            <c:otherwise>bg-secondary</c:otherwise>
                                        </c:choose>">
                                        <c:out value="${order.status}" />
                                    </span>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="alert alert-info text-center" role="alert">
                    Nessun ordine disponibile al momento.
                </div>
            </c:otherwise>
        </c:choose>
    </section>
</main>

<jsp:include page="footer.jsp" />