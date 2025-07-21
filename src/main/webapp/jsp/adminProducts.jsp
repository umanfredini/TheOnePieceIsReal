<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="header.jsp" />

<main class="container mt-5" role="main">
    <h1 class="mb-4 text-center">Gestione Prodotti</h1>

    <section class="row" role="region" aria-label="Lista prodotti">
        <c:choose>
            <c:when test="${not empty products}">
                <c:forEach var="product" items="${products}">
                    <div class="col-md-4 mb-4">
                        <div class="card h-100 shadow-sm">
                            <img src="${pageContext.request.contextPath}/styles/images/prodotti/${product.imageUrl}" class="card-img-top" alt="Immagine di ${product.name}" />
                            <div class="card-body">
                                <h5 class="card-title"><c:out value="${product.name}" /></h5>
                                <p class="card-text">Categoria: <c:out value="${product.category}" /></p>
                                <p class="card-text">Prezzo: € <c:out value="${product.price}" /></p>
                                <p class="card-text">Stock: <c:out value="${product.stockQuantity}" /></p>
                                <p class="card-text">
                                    <c:choose>
                                      <c:when test="${product.isActive}">
                                        <span class="badge bg-success">Attivo</span>
                                      </c:when>
                                      <c:otherwise>
                                        <span class="badge bg-danger">Non attivo</span>
                                      </c:otherwise>
                                      </c:choose>
                                    </span>
                                </p>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="alert alert-info text-center" role="alert">
                    Nessun prodotto disponibile.
                </div>
            </c:otherwise>
        </c:choose>
    </section>
</main>

<jsp:include page="footer.jsp" />
