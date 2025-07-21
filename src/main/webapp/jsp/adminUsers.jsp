<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="header.jsp" />

<main class="container mt-5" role="main">
    <h1 class="mb-4 text-center">Gestione Utenti</h1>

    <section role="region" aria-label="Tabella utenti" class="table-responsive">
        <c:choose>
    <c:when test="${not empty users}">
        <table class="table table-striped table-bordered">
            <thead class="table-dark">
                <tr>
                    <th scope="col">Username</th>
                    <th scope="col">Email</th>
                    <th scope="col">Ruolo</th>
                    <th scope="col">Attivo</th>
                    <th scope="col">Ultimo accesso</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="user" items="${users}">
                    <tr>
                        <td><c:out value="${user.username}" /></td>
                        <td><c:out value="${user.email}" /></td>
                        <td>
                            <c:choose>
                                <c:when test="${user.role == 'admin'}">
                                    <span class="badge bg-danger"><c:out value="${user.role}" /></span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary"><c:out value="${user.role}" /></span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${user.isActive}">
                                    <span class="badge bg-success">Attivo</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-danger">Disattivo</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td><c:out value="${user.lastLogin}" /></td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:when>
    <c:otherwise>
        <div class="alert alert-info text-center" role="alert">
            Nessun utente registrato.
        </div>
    </c:otherwise>
</c:choose>
    </section>
</main>

<jsp:include page="footer.jsp" />
