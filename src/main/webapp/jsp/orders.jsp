<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="header.jsp" />

<main class="container mt-5" role="main">
    <h1 class="mb-4 text-center">I tuoi ordini</h1>

    <section role="region" aria-label="Storico ordini" class="table-responsive">
        <c:if test="${not empty orders}">
            <table class="table table-striped table-hover align-middle">
                <thead class="table-dark">
                    <tr>
                        <th>ID Ordine</th>
                        <th>Data</th>
                        <th>Totale</th>
                        <th>Stato</th>
                        <th>Timeline</th>
                        <th>Azioni</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="order" items="${orders}">
                        <tr>
                            <td>#<c:out value="${order.id}" /></td>
                            <td><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy" /></td>
                            <td>€ <fmt:formatNumber value="${order.total}" type="currency" currencySymbol="€" /></td>
                            <td>
                                <c:out value="${order.status}" />
                            </td>
                            <td>
                                <div class="d-flex gap-2">
                                    <c:if test="${order.status == 'pending'}">
                                        <img src="images/timeline/pending.png" alt="Ordine ricevuto" title="Ordine ricevuto" width="32" height="32" />
                                    </c:if>
                                    <c:if test="${order.status == 'processing'}">
                                        <img src="images/timeline/pending.png" alt="Ordine ricevuto" title="Ordine ricevuto" width="32" height="32" />
                                        <img src="images/timeline/processing.png" alt="In lavorazione" title="In lavorazione" width="32" height="32" />
                                    </c:if>
                                    <c:if test="${order.status == 'shipped'}">
                                        <img src="images/timeline/pending.png" alt="Ordine ricevuto" title="Ordine ricevuto" width="32" height="32" />
                                        <img src="images/timeline/processing.png" alt="In lavorazione" title="In lavorazione" width="32" height="32" />
                                        <img src="images/timeline/shipped.png" alt="Spedito" title="Spedito" width="32" height="32" />
                                    </c:if>
                                    <c:if test="${order.status == 'delivered'}">
                                        <img src="images/timeline/pending.png" alt="Ordine ricevuto" title="Ordine ricevuto" width="32" height="32" />
                                        <img src="images/timeline/processing.png" alt="In lavorazione" title="In lavorazione" width="32" height="32" />
                                        <img src="images/timeline/shipped.png" alt="Spedito" title="Spedito" width="32" height="32" />
                                        <img src="images/timeline/delivered.png" alt="Consegnato" title="Consegnato" width="32" height="32" />
                                    </c:if>
                                </div>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/OrderServlet?action=detail&orderId=${order.id}" class="btn btn-sm btn-outline-primary">Dettagli</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:if>
        <c:if test="${empty orders}">
            <div class="alert alert-info text-center" role="alert">
                Non hai ancora effettuato ordini.
            </div>
        </c:if>
    </section>
</main>

<jsp:include page="footer.jsp" />