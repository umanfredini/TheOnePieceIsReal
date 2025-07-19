<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="header.jsp" %>

<h2>Storico Ordini</h2>

<c:if test="${empty orders}">
    <p>Non hai effettuato ordini.</p>
</c:if>

<c:forEach var="order" items="${orders}">
    <div class="order-block">
        <h4>Ordine #${order.id}</h4>
        <p>Data: ${order.orderDate}</p>
        <p>Totale: €${order.totalAmount}</p>
        <hr>
    </div>
</c:forEach>

<%@ include file="footer.jsp" %>
