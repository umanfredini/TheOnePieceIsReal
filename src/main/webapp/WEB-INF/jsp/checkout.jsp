<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="header.jsp" />

<main class="container mt-5" role="main">
    <h1 class="mb-4 text-center">Checkout</h1>

    <!-- Riepilogo Ordine -->
    <section class="mb-4" role="region" aria-label="Riepilogo ordine" class="table-responsive">
        <c:if test="${not empty cart.items}">
            <table class="table table-bordered">
                <thead class="table-light">
                    <tr>
                        <th>Prodotto</th>
                        <th>Variante</th>
                        <th>Quantità</th>
                        <th>Prezzo</th>
                        <th>Totale</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${cart.items}">
                        <tr>
                            <td><c:out value="${item.productName}" /></td>
                            <td><c:out value="${item.variantName}" /></td>
                            <td><c:out value="${item.quantity}" /></td>
                            <td>€ <fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="€" /></td>
                            <td>€ <fmt:formatNumber value="${item.unitPrice * item.quantity}" type="currency" currencySymbol="€" /></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:if>
    </section>

    <!-- Form Checkout -->
    <section class="row justify-content-center" role="region" aria-label="Modulo di checkout">
        <div class="col-md-6">
            <form action="CheckoutServlet" method="post" class="card p-4 shadow-sm">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />

                <div class="mb-3">
                    <label for="shippingAddress" class="form-label">Indirizzo di spedizione</label>
                    <input type="text" id="shippingAddress" name="shippingAddress" class="form-control" required />
                </div>

                <div class="mb-3">
                    <label for="paymentMethod" class="form-label">Metodo di pagamento</label>
                    <select id="paymentMethod" name="paymentMethod" class="form-select" required>
                        <option value="credit_card">Carta di Credito</option>
                        <option value="paypal">PayPal</option>
                    </select>
                </div>

                <div class="d-grid">
                    <button type="submit" class="btn btn-primary btn-lg">Conferma Ordine</button>
                </div>
            </form>
        </div>
    </section>
</main>

<jsp:include page="footer.jsp" />