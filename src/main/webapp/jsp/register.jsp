<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="header.jsp" />
<script src="${pageContext.request.contextPath}/scripts/validation.js"></script>

<style>
/* Stili One Piece per registrazione */

h1 {
    font-family: 'Pirata One', 'Bangers', cursive;
    color: #f1c40f;
    text-shadow: 3px 3px 0px #2c3e50;
    letter-spacing: 2px;
}

.card {
    background: rgba(255, 255, 255, 0.95);
    border: 3px solid #f1c40f;
    border-radius: 20px;
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
}

.form-label {
    font-family: 'Bangers', cursive;
    color: #2c3e50;
    font-weight: bold;
    text-transform: uppercase;
    letter-spacing: 1px;
}

.form-control {
    border: 2px solid #bdc3c7;
    border-radius: 12px;
    transition: all 0.3s ease;
}

.form-control:focus {
    border-color: #3498db;
    box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.2);
}

.btn-success {
    background: linear-gradient(135deg, #2ecc71, #27ae60);
    border: none;
    border-radius: 12px;
    font-family: 'Bangers', cursive;
    font-weight: bold;
    text-transform: uppercase;
    letter-spacing: 1px;
    box-shadow: 0 6px 12px rgba(46, 204, 113, 0.3);
    transition: all 0.3s ease;
}

.btn-success:hover {
    background: linear-gradient(135deg, #27ae60, #229954);
    transform: translateY(-2px);
    box-shadow: 0 8px 16px rgba(46, 204, 113, 0.4);
}

.alert-danger {
    background: linear-gradient(135deg, #e74c3c, #c0392b);
    color: white;
    border: none;
    border-radius: 12px;
}

.error-message {
    color: #e74c3c;
    font-size: 0.875rem;
    margin-top: 0.25rem;
    display: none;
}

.form-control.is-invalid {
    border-color: #e74c3c;
    box-shadow: 0 0 0 0.2rem rgba(231, 76, 60, 0.25);
}
</style>

<main class="container mt-5" role="main">
    <h1 class="mb-4 text-center">Registrazione</h1>

    <section class="row justify-content-center" role="form" aria-label="Modulo di registrazione">
        <div class="col-md-6">
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger text-center" role="alert">
                    <c:out value="${errorMessage}" />
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/RegisterServlet" method="post" class="card p-4 shadow-sm" name="registration-form" id="registration-form">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />

                <div class="mb-3">
                    <label for="username" class="form-label">Username</label>
                    <input type="text" id="username" name="username" placeholder="Username" class="form-control" required />
                    <div class="error-message" id="username-error"></div>
                </div>

                <div class="mb-3">
                    <label for="email" class="form-label">Email</label>
                    <input type="email" id="email" name="email" placeholder="Email" class="form-control" required />
                    <div class="error-message" id="email-error"></div>
                </div>

                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" id="password" name="password" placeholder="Password" class="form-control" required />
                    <div class="error-message" id="password-error"></div>
                </div>

                <div class="mb-3">
                    <label for="confirmPassword" class="form-label">Conferma Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Conferma Password" class="form-control" required />
                    <div class="error-message" id="confirmPassword-error"></div>
                </div>

                <div class="mb-3">
                    <label for="shippingAddress" class="form-label">Indirizzo di spedizione</label>
                    <input type="text" id="shippingAddress" name="shippingAddress" placeholder="Indirizzo di spedizione" class="form-control" required />
                    <div class="error-message" id="shippingAddress-error"></div>
                </div>

                <div class="d-grid">
                    <button type="submit" class="btn btn-success btn-lg">Registrati</button>
                </div>
            </form>
        </div>
    </section>
</main>

<jsp:include page="footer.jsp" />