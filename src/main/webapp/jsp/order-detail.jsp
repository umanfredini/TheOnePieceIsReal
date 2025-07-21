<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="header.jsp" />

<main class="container mt-5" role="main">
    <h1 class="mb-4 text-center">Dettagli Ordine #<c:out value="${order.id}" /></h1>

    <section class="mb-4" role="region" aria-label="Informazioni ordine">
        <ul class="list-group">
            <li class="list-group-item"><strong>Data ordine:</strong> <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm" /></li>
            <li class="list-group-item"><strong>Indirizzo spedizione:</strong> <c:out value="${order.shippingAddress}" /></li>
            <li class="list-group-item"><strong>Metodo di pagamento:</strong> <c:out value="${order.paymentMethod}" /></li>
            <li class="list-group-item"><strong>Stato:</strong>
                <span class="badge bg-secondary"><c:out value="${order.status}" /></span>
            </li>
        </ul>
    </section>

    <section role="region" aria-label="Prodotti ordinati" class="table-responsive">
        <table class="table table-bordered table-hover">
            <thead class="table-dark">
                <tr>
                    <th>Prodotto</th>
                    <th>Variante</th>
                    <th>Prezzo unitario</th>
                    <th>Quantità</th>
                    <th>Totale</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="item" items="${orderItems}">
                    <tr>
                        <td><c:out value="${item.productName}" /></td>
                        <td><c:out value="${item.variantName}" /></td>
                        <td>€ <fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="€" /></td>
                        <td><c:out value="${item.quantity}" /></td>
                        <td>€ <fmt:formatNumber value="${item.unitPrice * item.quantity}" type="currency" currencySymbol="€" /></td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </section>

    <div class="text-center mt-4">
        <a href="${pageContext.request.contextPath}/OrderServlet" class="btn btn-primary">Torna ai miei ordini</a>
    </div>
</main>

<jsp:include page="footer.jsp" /> 