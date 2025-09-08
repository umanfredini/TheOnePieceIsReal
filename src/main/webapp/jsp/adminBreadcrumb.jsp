<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<nav aria-label="breadcrumb" class="mb-4">
    <ol class="breadcrumb">
        <li class="breadcrumb-item">
            <a href="${pageContext.request.contextPath}/DashboardServlet">
                <i class="fas fa-tachometer-alt me-1"></i>Dashboard
            </a>
        </li>
        <c:choose>
            <c:when test="${param.page == 'products'}">
                <li class="breadcrumb-item active" aria-current="page">
                    <i class="fas fa-box me-1"></i>Gestione Prodotti
                </li>
            </c:when>
            <c:when test="${param.page == 'orders'}">
                <li class="breadcrumb-item active" aria-current="page">
                    <i class="fas fa-shopping-cart me-1"></i>Gestione Ordini
                </li>
            </c:when>
            <c:when test="${param.page == 'users'}">
                <li class="breadcrumb-item active" aria-current="page">
                    <i class="fas fa-users me-1"></i>Gestione Utenti
                </li>
            </c:when>
            <c:when test="${param.page == 'dashboard'}">
                <li class="breadcrumb-item active" aria-current="page">
                    <i class="fas fa-tachometer-alt me-1"></i>Dashboard
                </li>
            </c:when>
            <c:otherwise>
                <li class="breadcrumb-item active" aria-current="page">
                    <i class="fas fa-cog me-1"></i>Amministrazione
                </li>
            </c:otherwise>
        </c:choose>
    </ol>
</nav>

<style>
.breadcrumb {
    background: linear-gradient(135deg, #8B4513, #A0522D);
    border: 2px solid #DAA520;
    border-radius: 10px;
    padding: 1rem;
    margin-bottom: 2rem;
}

.breadcrumb-item a {
    color: #FFD700;
    text-decoration: none;
    font-weight: bold;
}

.breadcrumb-item a:hover {
    color: #FFF;
    text-decoration: underline;
}

.breadcrumb-item.active {
    color: #FFF;
    font-weight: bold;
}

.breadcrumb-item + .breadcrumb-item::before {
    color: #DAA520;
    content: ">";
}
</style>
