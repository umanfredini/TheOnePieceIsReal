<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="header.jsp" />

<main class="container mt-5 text-center" role="main">
    <h1 class="mb-4 text-success">Operazione completata</h1>

    <div class="alert alert-success" role="alert">
        <c:out value="${successMessage}" default="L'operazione è stata completata con successo." />
    </div>

    <a href="index.jsp" class="btn btn-outline-primary mt-3">Torna alla Home</a>
</main>

<jsp:include page="footer.jsp" />