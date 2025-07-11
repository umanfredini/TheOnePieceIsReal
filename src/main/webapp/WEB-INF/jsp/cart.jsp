<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="header.jsp" />

<main class="container mt-5" role="main">
    <h1 class="mb-4 text-center">Il tuo Carrello</h1>

    <section role="region" aria-label="Contenuto del carrello" class="table-responsive">
        <c:choose>
            <c:when test="${not empty cart.items}">
                <form action="UpdateCartServlet" method="post">
                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />
                    <table class="table table-striped table-hover align-middle">
                        <thead class="table-dark">
                            <tr>
                                <th>Prodotto</th>
                                <th>Variante</th>
                                <th>Quantità</th>
                                <th>Prezzo</th>
                                <th>Totale</th>
                                <th>Azioni</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${cart.items}">
                                <tr>
                                    <td><c:out value="${item.productName}" /></td>
                                    <td>
                                        <select name="variant_${item.id}" class="form-select">
                                            <c:forEach var="v" items="${item.availableVariants}">
                                                <option value="${v.id}" <c:if test="${v.id == item.variantId}">selected</c:if>>
                                                    ${v.name}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </td>
                                    <td>
                                        <input type="number" name="quantity_${item.id}" value="${item.quantity}" min="1" class="form-control" />
                                    </td>
                                    <td>€ <fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="€" /></td>
                                    <td>€ <fmt:formatNumber value="${item.unitPrice * item.quantity}" type="currency" currencySymbol="€" /></td>
                                    <td>
                                        <button type="submit" name="update" value="${item.id}" class="btn btn-sm btn-outline-secondary">Aggiorna</button>
                                        <button type="submit" name="remove" value="${item.id}" class="btn btn-sm btn-outline-danger">Rimuovi</button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </form>

                <div class="text-end mt-4">
                    <form action="CheckoutServlet" method="post">
                        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />
                        <button type="submit" class="btn btn-primary btn-lg">Procedi al Checkout</button>
                    </form>
                </div>
            </c:when>
            <c:otherwise>
                <div class="alert alert-info text-center" role="alert">
                    Il tuo carrello è vuoto.
                </div>
            </c:otherwise>
        </c:choose>
    </section>
</main>

<jsp:include page="footer.jsp" />