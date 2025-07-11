<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="header.jsp" />

<main class="container mt-5" role="main">
    <h1 class="mb-4 text-center">Dashboard Amministratore</h1>

    <section class="row text-center" role="region" aria-label="Statistiche generali">
        <div class="col-md-4 mb-3">
                           <div class="card-body">
                    <h5 class="card-title">Totale Utenti</h5>
                    <p class="card-text display-6 text-primary">
                        <c:out value="${userCount}" default="0"/>
                    </p>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-3">
            <div class="card shadow-sm border-success">
                <div class="card-body">
                    <h5 class="card-title">Totale Ordini</h5>
                    <p class="card-text display-6 text-success">
                        <c:out value="${orderCount}" default="0"/>
                    </p>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-3">
            <div class="card shadow-sm border-warning">
                <div class="card-body">
                    <h5 class="card-title">Totale Prodotti</h5>
                    <p class="card-text display-6 text-warning">
                        <c:out value="${productCount}" default="0"/>
                    </p>
                </div>
            </div>
        </div>
    </section>
</main>

<jsp:include page="footer.jsp" />