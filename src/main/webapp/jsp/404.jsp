<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="header.jsp" />

<main class="container text-center mt-5" role="main">
    <h1 class="display-4 text-danger">404 - Rotta per questo file non trovata</h1>

    <div class="d-flex flex-column flex-md-row align-items-center justify-content-center my-4" style="gap: 2rem;">
        <div class="mb-3 mb-md-0">
            <img src="${pageContext.request.contextPath}/styles/images/altro/zoro-lost.gif" alt="Zoro smarrito - errore 404" class="img-fluid" style="max-width: 400px;" />
        </div>
        <div class="text-md-start text-center">
            <p class="lead fw-bold">Sembra che tu abbia preso una rotta sbagliata nella Grand Line...</p>
            <p>La pagina che cerchi non esiste o è stata spostata.</p>
            <a href="http://www.theonepieceisreal.com:8081/TheOnePieceIsReal/" class="btn btn-primary mt-3">Torna alla Home</a>
        </div>
    </div>
</main>

<jsp:include page="footer.jsp" />
