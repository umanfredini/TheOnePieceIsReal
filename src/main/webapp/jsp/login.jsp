<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="header.jsp" />

<main class="container mt-5" role="main">
    <h1 class="mb-4 text-center">Accesso Utente</h1>

    <section class="row justify-content-center" role="form" aria-label="Modulo di login">
        <div class="col-md-6">
            <c:if test="${not empty loginError}">
                <div class="alert alert-danger text-center" role="alert">
                    <c:out value="${loginError}" />
                </div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger text-center" role="alert">
                    <c:out value="${errorMessage}" />
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/LoginServlet" method="post" class="card p-4 shadow-sm">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />

                <div class="mb-3">
                    <label for="email" class="form-label">Email</label>
                    <input type="email" id="email" name="email" class="form-control" required />
                </div>

                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" id="password" name="password" class="form-control" required />
                </div>

                <div class="d-grid">
                    <button type="submit" class="btn btn-primary btn-lg">Login</button>
                </div>
            </form>
        </div>
    </section>
</main>

<jsp:include page="footer.jsp" />