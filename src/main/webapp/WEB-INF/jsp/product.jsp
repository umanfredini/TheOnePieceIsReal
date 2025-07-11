<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="header.jsp" />

<main class="container mt-5" role="main">
    <div class="row">
        <div class="col-md-6">
            <img src="${product.imageUrl}" alt="Immagine di ${product.name}" class="img-fluid rounded shadow-sm" />
        </div>
        <div class="col-md-6">
            <h1 class="mb-3"><c:out value="${product.name}" /></h1>
            <p class="text-muted"><c:out value="${product.description}" /></p>
            <p class="fs-4 fw-bold text-primary">€ <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="€" /></p>

            <form action="CartServlet" method="post" class="mt-4">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />
                <input type="hidden" name="productId" value="${product.id}" />

                <c:if test="${not empty product.variants}">
                    <div class="mb-3">
                        <label for="variantId" class="form-label">Seleziona variante</label>
                        <select name="variantId" id="variantId" class="form-select" required>
                            <c:forEach var="variant" items="${product.variants}">
                                <option value="${variant.id}">${variant.variantName}</option>
                            </c:forEach>
                        </select>
                    </div>
                </c:if>

                <div class="mb-3">
                    <label for="quantity" class="form-label">Quantità</label>
                    <input type="number" name="quantity" id="quantity" value="1" min="1" class="form-control" required />
                </div>

                <button type="submit" class="btn btn-success btn-lg w-100">Aggiungi al Carrello</button>
            </form>
        </div>
    </div>
</main>

<jsp:include page="footer.jsp" />