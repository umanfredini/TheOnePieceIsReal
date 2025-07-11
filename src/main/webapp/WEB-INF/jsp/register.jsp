<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="header.jsp" />

<main class="container mt-5" role="main">
    <h1 class="mb-4 text-center">Registrazione</h1>

    <section class="row justify-content-center" role="form" aria-label="Modulo di registrazione">
        <div class="col-md-6">
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger text-center" role="alert">
                    <c:out value="${errorMessage}" />
                </div>
            </c:if>

            <form action="RegisterServlet" method="post" class="card p-4 shadow-sm">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />

                <div class="mb-3">
                    <label for="username" class="form-label">Username</label>
                    <input type="text" id="username" name="username" placeholder="Username" class="form-control" required />
                </div>

                <div class="mb-3">
                    <label for="email" class="form-label">Email</label>
                    <input type="email" id="email" name="email" placeholder="Email" class="form-control" required />
                </div>

                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" id="password" name="password" placeholder="Password" class="form-control" required />
                </div>

                <div class="mb-3">
                    <label for="shippingAddress" class="form-label">Indirizzo di spedizione</label>
                    <input type="text" id="shippingAddress" name="shippingAddress" placeholder="Indirizzo di spedizione" class="form-control" required />
                </div>

                <div class="d-grid">
                    <button type="submit" class="btn btn-success btn-lg">Registrati</button>
                </div>
            </form>
        </div>
    </section>
</main>

<jsp:include page="footer.jsp" />