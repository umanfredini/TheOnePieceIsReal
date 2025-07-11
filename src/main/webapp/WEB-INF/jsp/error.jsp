<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="header.jsp" />

<main class="container mt-5" role="main">
    <h1 class="mb-4 text-center text-danger">Si è verificato un errore</h1>

    <section role="alert" aria-live="assertive" class="alert alert-danger text-center">
        <c:out value="${errorMessage}" default="Si è verificato un errore imprevisto. Riprova più tardi o contatta l'assistenza." />
    </section>

    <div class="text-center mt-4">
        <a href="index.jsp" class="btn btn-outline-primary">Torna alla Home</a>
    </div>
</main>

<jsp:include page="footer.jsp" />