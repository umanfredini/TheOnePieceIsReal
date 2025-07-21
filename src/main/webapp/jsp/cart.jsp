<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="header.jsp" />
<script src="${pageContext.request.contextPath}/scripts/cart.js" defer></script>

<main class="container mt-5" role="main">
    <h1 class="mb-4 text-center">Il tuo Carrello</h1>



    <section role="region" aria-label="Contenuto del carrello" class="table-responsive">
        <c:choose>
            <c:when test="${not empty cart.items}">
                            <form action="${pageContext.request.contextPath}/CartServlet" method="post" id="cartForm">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />
                <input type="hidden" name="productId" id="productIdToRemove" value="" />
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
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty item.product}">
                                                <strong>${item.product.name}</strong>
                                                <br><small class="text-muted">${item.product.category}</small>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">Prodotto non disponibile</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty item.variantId}">
                                                <span class="badge bg-info">Variante ${item.variantId}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">Nessuna variante</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <input type="number" name="quantity_${item.productId}" value="${item.quantity}" min="1" class="form-control" style="width: 80px;" />
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty item.product}">
                                                € <fmt:formatNumber value="${item.product.price}" type="currency" currencySymbol="€" />
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">N/A</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty item.product}">
                                                € <fmt:formatNumber value="${item.product.price.doubleValue() * item.quantity}" type="currency" currencySymbol="€" />
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">N/A</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <button type="submit" name="action" value="remove" onclick="setProductId(${item.productId})" class="btn btn-sm btn-outline-danger">Rimuovi</button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </form>

                <div class="row mt-4">
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">Riepilogo</h5>
                                <p class="card-text">
                                    <strong>Totale articoli:</strong> ${cart.items.size()}<br>
                                    <strong>Totale ordine:</strong> € <fmt:formatNumber value="${cart.total}" type="currency" currencySymbol="€" />
                                </p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 text-end">
                        <form action="${pageContext.request.contextPath}/CheckoutServlet" method="post">
                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />
                            <button type="submit" class="btn btn-primary btn-lg" <c:if test="${cart.items.size() == 0}">disabled</c:if>>
                                <i class="fas fa-shopping-cart me-2"></i>Procedi al Checkout
                            </button>
                        </form>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="alert alert-info text-center" role="alert">
                    <i class="fas fa-shopping-cart fa-3x mb-3 text-muted"></i>
                    <h4>Il tuo carrello è vuoto</h4>
                    <p class="mb-3">Non hai ancora aggiunto nessun prodotto al carrello.</p>
                    <a href="${pageContext.request.contextPath}/catalog" class="btn btn-primary">
                        <i class="fas fa-search me-2"></i>Esplora i prodotti
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </section>
</main>

<script>
function setProductId(productId) {
    document.getElementById('productIdToRemove').value = productId;
}
</script>

<jsp:include page="footer.jsp" />