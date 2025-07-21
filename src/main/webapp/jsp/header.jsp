<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>The One Piece Is Real</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/main.css?v=${System.currentTimeMillis()}">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/music-player.css?v=${System.currentTimeMillis()}">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/image-fixes.css?v=${System.currentTimeMillis()}">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/image-error.css?v=${System.currentTimeMillis()}">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/mobile-menu-fixes.css?v=${System.currentTimeMillis()}">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/checkout.css?v=${System.currentTimeMillis()}">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="${pageContext.request.contextPath}/scripts/main.js" type="module" defer></script>
    <script src="${pageContext.request.contextPath}/scripts/toast.js" type="module" defer></script>
    <script src="${pageContext.request.contextPath}/scripts/music-player.js" defer></script>
    <script src="${pageContext.request.contextPath}/scripts/image-handler.js" defer></script>
</head>
<body>
<!-- Header principale One Piece -->
<header class="main-header">
    <div class="header-content">
        <!-- Logo e titolo -->
        <div class="header-brand">
            <div class="header-title">
                <h1 class="gradient-text">THE ONE PIECE IS REAL</h1>
                <div class="subtitle">One day we will find it and we can see it</div>
            </div>
        </div>
        <nav class="main-nav">
            <ul>
                <c:choose>
                    <c:when test="${empty sessionScope.utente}">
                        <li><a href="${pageContext.request.contextPath}/jsp/register.jsp"><i class="fas fa-user-plus"></i> Registrazione</a></li>
                        <li><a href="${pageContext.request.contextPath}/jsp/login.jsp"><i class="fas fa-sign-in-alt"></i> Login</a></li>
                    </c:when>
                    <c:otherwise>
                        <c:choose>
                            <c:when test="${sessionScope.isAdmin}">
                                <li><a href="${pageContext.request.contextPath}/DashboardServlet"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                            </c:when>
                            <c:otherwise>
                                <li><a href="${pageContext.request.contextPath}/ProfileServlet"><i class="fas fa-user-circle"></i> Profilo</a></li>
                            </c:otherwise>
                        </c:choose>
                        <li><a href="${pageContext.request.contextPath}/jsp/logout.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                    </c:otherwise>
                </c:choose>
                <li><a href="${pageContext.request.contextPath}/catalog"><i class="fas fa-th-large"></i> Catalogo</a></li>
                <li><a href="${pageContext.request.contextPath}/CartServlet"><i class="fas fa-shopping-cart"></i> Carrello</a></li>
                <li><a href="${pageContext.request.contextPath}/WishlistServlet"><i class="fas fa-heart"></i> Wishlist</a></li>
                <li><a href="${pageContext.request.contextPath}/"><i class="fas fa-home"></i> Home</a></li>
            </ul>
        </nav>
    </div>
</header>

<!-- Includi messaggi flash -->
<jsp:include page="flash-message.jsp" />

<main class="container-fluid" role="main">