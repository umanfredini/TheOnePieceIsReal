<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="header.jsp" />

<main class="container mt-5 text-center" role="main">
    <h1 class="mb-4 text-success">Ordine Confermato!</h1>

    <div class="mb-4">
        <img src="images/celebration_ship.gif" alt="Nave in festa" class="img-fluid" style="max-height: 300px;" />
    </div>

    <p class="lead">Grazie per il tuo acquisto! Il tuo ordine è stato registrato con successo.</p>
    <p>Riceverai una email di conferma con i dettagli dell'ordine.</p>

    <div class="mt-4 d-flex justify-content-center gap-3">
        <a href="index.jsp" class="btn btn-outline-primary">Torna alla Home</a>
        <a href="OrderHistoryServlet" class="btn btn-primary">Visualizza Storico Ordini</a>
    </div>
</main>

<jsp:include page="footer.jsp" />