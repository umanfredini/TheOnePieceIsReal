<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="header.jsp" />

<main class="container mt-5" role="main">
    <h1 class="mb-4 text-center">Catalogo Prodotti</h1>

    <!-- Filtri dinamici -->
    <form method="get" action="CatalogServlet" class="row mb-4">
        <div class="col-md-3">
            <label for="category" class="form-label">Categoria</label>
            <select name="category" id="category" class="form-select">
                <option value="">Tutte</option>
                <c:forEach var="cat" items="${categories}">
                    <option value="${cat}" <c:if test="${param.category == cat}">selected</c:if>>${cat}</option>
                </c:forEach>
            </select>
        </div>
        <div class="col-md-3">
            <label for="personaggio" class="form-label">Personaggio</label>
            <select name="personaggio" id="personaggio" class="form-select">
                <option value="">Tutti</option>
                <c:forEach var="p" items="${personaggi}">
                    <option value="${p}" <c:if test="${param.personaggio == p}">selected</c:if>>${p}</option>
                </c:forEach>
            </select>
        </div>
        <div class="col-md-3">
            <label for="prezzoMax" class="form-label">Prezzo massimo</label>
            <input type="number" name="prezzoMax" id="prezzoMax" class="form-control" value="${param.prezzoMax}" />
        </div>
        <div class="col-md-3 d-flex align-items-end">
            <button type="submit" class="btn btn-outline-primary w-100">Filtra</button>
        </div>
    </form>

    <!-- Lista prodotti -->
    <section class="row" role="region" aria-label="Lista prodotti">
        <c:choose>
            <c:when test="${not empty products}">
                <c:forEach var="product" items="${products}">
                    <div class="col-md-4 mb-4">
                        <div class="card h-100 shadow-sm">
                            <img src="${product.imageUrl}" class="card-img-top" alt="Immagine di ${product.name}" />
                            <div class="card-body">
                                <h5 class="card-title"><c:out value="${product.name}" /></h5>
                                <p class="card-text">Categoria: <c:out value="${product.category}" /></p>
                                <p class="card-text">Personaggi: <c:out value="${product.personaggi}" /></p>
                                <p class="card-text fw-bold text-primary">
                                    € <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="€" />
                                </p>
                                <a href="ProductServlet?id=${product.id}" class="btn btn-outline-primary">Dettagli</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="alert alert-info text-center" role="alert">
                    Nessun prodotto disponibile al momento.
                </div>
            </c:otherwise>
        </c:choose>
    </section>
</main>

<jsp:include page="footer.jsp" />