<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="header.jsp" />

<main class="container mt-5" role="main">
    <h1 class="mb-4 text-center">La mia Wishlist</h1>

    <section class="row" role="region" aria-label="Prodotti salvati">
        <c:choose>
            <c:when test="${not empty wishlist}">
                <c:forEach var="product" items="${wishlist}">
                    <div class="col-md-4 mb-4">
                        <div class="card h-100 shadow-sm">
                            <img src="${product.imageUrl}" class="card-img-top" alt="Immagine di ${product.name}" />
                            <div class="card-body">
                                <h5 class="card-title"><c:out value="${product.name}" /></h5>
                               c:out value="${product.category}" /></p>
                                <p class="card-text fw-bold text-primary">€ <c:out value="${product.price}" /></p>
                                <a href="product.jsp?id=${product.id}" class="btn btn-outline-primary">Vai al prodotto</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="alert alert-info text-center" role="alert">
                    Nessun prodotto nella tua wishlist.
                </div>
            </c:otherwise>
        </c:choose>
    </section>
</main>

<jsp:include page="footer.jsp" />