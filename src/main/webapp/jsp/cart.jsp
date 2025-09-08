<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="header.jsp" />
<script src="${pageContext.request.contextPath}/scripts/cart.js" defer></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/treasure-chest.css">

<main class="container mt-5" role="main">
    <div class="treasure-chest-header">
        <h1 class="mb-4 text-center gradient-text">🏴‍☠️ Il tuo Tesoro</h1>
        <p class="text-center text-muted">I tuoi preziosi One Piece nel carrello</p>
    </div>

    <section role="region" aria-label="Contenuto del carrello" class="treasure-chest-container">
        <c:choose>
            <c:when test="${not empty cart.items}">
                <form action="${pageContext.request.contextPath}/CartServlet" method="post" id="cartForm">
                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />
                    <input type="hidden" name="productId" id="productIdToRemove" value="" />
                    
                    <div class="treasure-items">
                        <c:forEach var="item" items="${cart.items}">
                            <div class="treasure-item" data-product-id="${item.productId}">
                                <div class="treasure-item-image">
                                    <img src="${pageContext.request.contextPath}/styles/images/prodotti/${item.product.imageUrl}" 
                                         alt="${item.product.name}" 
                                         onerror="this.src='${pageContext.request.contextPath}/styles/images/altro/zoro-lost.gif'" />
                                </div>
                                <div class="treasure-item-info">
                                    <h4 class="treasure-item-title">${item.product.name}</h4>
                                    <div class="treasure-item-category">${item.product.category}</div>
                                    <c:if test="${not empty item.variantId}">
                                        <div class="treasure-item-variant">Variante ${item.variantId}</div>
                                    </c:if>
                                </div>
                                <div class="treasure-item-quantity">
                                    <label>Quantità:</label>
                                    <input type="number" name="quantity_${item.productId}" value="${item.quantity}" min="1" class="treasure-quantity-input" />
                                </div>
                                <div class="treasure-item-price">
                                    <div class="unit-price">€ <fmt:formatNumber value="${item.product.price}" type="currency" currencySymbol="€" /></div>
                                    <div class="total-price">€ <fmt:formatNumber value="${item.product.price.doubleValue() * item.quantity}" type="currency" currencySymbol="€" /></div>
                                </div>
                                <div class="treasure-item-actions">
                                    <button type="submit" name="action" value="remove" onclick="setProductId(${item.productId})" class="treasure-remove-btn">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
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