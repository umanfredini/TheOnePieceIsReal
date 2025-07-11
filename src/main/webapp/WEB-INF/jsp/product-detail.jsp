<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="header.jsp" />

<main class="container mt-5" role="main">
    <div class="row">
        <div class="col-md-6 text-center">
            <img src="${product.imageUrl}" alt="${product.name}" class="img-fluid rounded shadow-sm" style="max-height: 400px;">
        </div>
        <div class="col-md-6">
            <h1 class="mb-3">${product.name}</h1>
            <h4 class="text-muted mb-3">
                <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="€" />
            </h4>
            <p class="mb-4">${product.description}</p>
            <ul class="list-group mb-3">
                <li class="list-group-item"><strong>Categoria:</strong> ${product.category}</li>
                <li class="list-group-item"><strong>Personaggi:</strong> ${product.personaggi}</li>
                <li class="list-group-item">
                    <strong>Disponibilità:</strong>
                    <c:choose>
                        <c:when test="${product.stockQuantity > 0}">
                            <span class="text-success">Disponibile</span>
                        </c:when>
                        <c:otherwise>
                            <span class="text-danger">Non disponibile</span>
                        </c:otherwise>
                    </c:choose>
                </li>
            </ul>

            <form action="CartServlet" method="post" class="card p-3">
                <input type="hidden" name="action" value="add" />
                <input type="hidden" name="productId" value="${product.id}" />
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />

                <div class="mb-3">
                    <label for="variant" class="form-label">Variante (es. taglia)</label>
                    <select name="variantId" id="variant" class="form-select" required>
                        <c:forEach var="variant" items="${variants}">
                            <option value="${variant.id}">${variant.name}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="mb-3">
                    <label for="quantity" class="form-label">Quantità</label>
                    <input type="number" name="quantity" id="quantity" class="form-control" min="1" max="${product.stockQuantity}" value="1" required />
                </div>

                <div class="d-grid">
                    <button type="submit" class="btn btn-primary" <c:if test="${product.stockQuantity == 0}">disabled</c:if>>
                        Aggiungi al carrello
                    </button>
                </div>
            </form>
        </div>
    </div>
</main>

<jsp:include page="footer.jsp" />
