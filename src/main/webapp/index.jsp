<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="WEB-INF/jsp/header.jsp" />

<main class="container mt-5" role="main">
    <!-- Sezione di benvenuto -->
    <section class="text-center mb-5" aria-label="Benvenuto">
        <h1 class="display-5 fw-bold">Benvenuto nel negozio ufficiale di One Piece!</h1>
        <p class="lead">Scopri i prodotti esclusivi della Grand Line e unisciti alla ciurma!</p>
        <a href="catalog.jsp" class="btn btn-primary btn-lg mt-3">Vai al Catalogo</a>
	</section>

    <!-- Sezione prodotti in evidenza -->
    <section aria-label="Prodotti in evidenza">
        <h2 class="mb-4 text-center">Prodotti in evidenza</h2>
        <div class="row">
            <c:forEach var="product" items="${featuredProducts}">
                <div class="col-md-4 mb-4">
                    <div class="card h-100 shadow-sm">
                        <img src="${product.imageUrl}" class="card-img-top" alt="Immagine di ${product.name}" />
                        <div class="card-body">
                            <h5 class="card-title"><c:out value="${product.name}" /></h5>
                            <p class="card-text text-muted"><c:out value="${product.category}" /></p>
                            <p class="card-text fw-bold text-primary">€ <c:out value="${product.price}" /></p>
                            <a href="product.jsp?id=${product.id}" class="btn btn-outline-primary">Dettagli</a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </section>
</main>

<jsp:include page="WEB-INF/jsp/footer.jsp" />