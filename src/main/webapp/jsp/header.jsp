<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>The One Piece Is Real</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/main.css?v=20241201">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/layout.css?v=20241201">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/search-forms.css?v=20241201">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/image-fixes.css?v=${System.currentTimeMillis()}">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/image-error.css?v=${System.currentTimeMillis()}">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/mobile-menu-fixes.css?v=${System.currentTimeMillis()}">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/admin-responsive.css?v=${System.currentTimeMillis()}">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/checkout.css?v=${System.currentTimeMillis()}">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/background-music.css?v=${System.currentTimeMillis()}">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/wishlist-buttons.css?v=${System.currentTimeMillis()}">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/scripts/main.js" type="module" defer></script>
    <script src="${pageContext.request.contextPath}/scripts/toast.js" type="module" defer></script>
    <script src="${pageContext.request.contextPath}/scripts/image-handler.js" defer></script>
    <script src="${pageContext.request.contextPath}/scripts/background-music.js" defer></script>
    <script src="${pageContext.request.contextPath}/scripts/wishlist-manager.js" defer></script>
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
        
        <!-- Menu hamburger per mobile -->
        <button class="mobile-menu-toggle" id="mobileMenuToggle" aria-label="Apri menu">
            <span class="hamburger-line"></span>
            <span class="hamburger-line"></span>
            <span class="hamburger-line"></span>
        </button>
        
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
                                <li class="dropdown">
                                    <a href="#" class="dropdown-toggle" data-bs-toggle="dropdown">
                                        <i class="fas fa-tachometer-alt"></i> Admin
                                    </a>
                                    <ul class="dropdown-menu">
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/DashboardServlet">
                                            <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                                        </a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/AdminProductServlet">
                                            <i class="fas fa-box me-2"></i>Gestione Prodotti
                                        </a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/AdminOrderServlet">
                                            <i class="fas fa-shopping-cart me-2"></i>Gestione Ordini
                                        </a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/AdminUserServlet">
                                            <i class="fas fa-users me-2"></i>Gestione Utenti
                                        </a></li>
                                        <li><hr class="dropdown-divider"></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/jsp/logout.jsp">
                                            <i class="fas fa-store me-2"></i>Vai al Negozio
                                        </a></li>
                                    </ul>
                                </li>
                            </c:when>
                            <c:otherwise>
                                <li><a href="${pageContext.request.contextPath}/ProfileServlet"><i class="fas fa-user-circle"></i> Profilo</a></li>
                            </c:otherwise>
                        </c:choose>
                        <li><a href="${pageContext.request.contextPath}/jsp/logout.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                    </c:otherwise>
                </c:choose>
                
                <!-- Menu normale - nascosto per admin nelle pagine admin -->
                <!-- Debug: URI = ${request.requestURI}, Path = ${request.servletPath} -->
                <c:choose>
                    <c:when test="${sessionScope.isAdmin and (request.requestURI.contains('Admin') or request.requestURI.contains('Dashboard') or request.requestURI.contains('admin') or request.servletPath.contains('Admin') or request.servletPath.contains('Dashboard') or request.servletPath.contains('admin'))}">
                        <!-- Nascosto per admin nelle pagine admin -->
                    </c:when>
                    <c:otherwise>
                        <li><a href="${pageContext.request.contextPath}/catalog"><i class="fas fa-th-large"></i> Catalogo</a></li>
                        <li><a href="${pageContext.request.contextPath}/CartServlet"><i class="fas fa-shopping-cart"></i> Carrello</a></li>
                        <li><a href="${pageContext.request.contextPath}/WishlistServlet"><i class="fas fa-heart"></i> Wishlist</a></li>
                        <li><a href="${pageContext.request.contextPath}/"><i class="fas fa-home"></i> Home</a></li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </nav>
    </div>
</header>

<!-- Menu mobile -->
<nav class="mobile-menu" id="mobileMenu">
    <div class="mobile-menu-content">
        <c:choose>
            <c:when test="${empty sessionScope.utente}">
                <a href="${pageContext.request.contextPath}/jsp/register.jsp" class="mobile-menu-item">
                    <i class="fas fa-user-plus"></i>
                    <span>Registrazione</span>
                </a>
                <a href="${pageContext.request.contextPath}/jsp/login.jsp" class="mobile-menu-item">
                    <i class="fas fa-sign-in-alt"></i>
                    <span>Login</span>
                </a>
            </c:when>
            <c:otherwise>
                <c:choose>
                    <c:when test="${sessionScope.isAdmin}">
                        <a href="${pageContext.request.contextPath}/DashboardServlet" class="mobile-menu-item">
                            <i class="fas fa-tachometer-alt"></i>
                            <span>Dashboard</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/AdminProductServlet" class="mobile-menu-item">
                            <i class="fas fa-box"></i>
                            <span>Gestione Prodotti</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/AdminOrderServlet" class="mobile-menu-item">
                            <i class="fas fa-shopping-cart"></i>
                            <span>Gestione Ordini</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/AdminUserServlet" class="mobile-menu-item">
                            <i class="fas fa-users"></i>
                            <span>Gestione Utenti</span>
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/ProfileServlet" class="mobile-menu-item">
                            <i class="fas fa-user-circle"></i>
                            <span>Profilo</span>
                        </a>
                    </c:otherwise>
                </c:choose>
        <a href="${pageContext.request.contextPath}/jsp/logout.jsp" class="mobile-menu-item">
            <i class="fas fa-sign-out-alt"></i>
            <span>Logout</span>
        </a>
    </c:otherwise>
</c:choose>

<!-- Menu normale mobile - nascosto per admin nelle pagine admin -->
<!-- Debug: URI = ${request.requestURI}, Path = ${request.servletPath} -->
<c:choose>
    <c:when test="${sessionScope.isAdmin and (request.requestURI.contains('Admin') or request.requestURI.contains('Dashboard') or request.requestURI.contains('admin') or request.servletPath.contains('Admin') or request.servletPath.contains('Dashboard') or request.servletPath.contains('admin'))}">
        <!-- Nascosto per admin nelle pagine admin -->
    </c:when>
    <c:otherwise>
        <a href="${pageContext.request.contextPath}/catalog" class="mobile-menu-item">
            <i class="fas fa-th-large"></i>
            <span>Catalogo</span>
        </a>
        <a href="${pageContext.request.contextPath}/CartServlet" class="mobile-menu-item">
            <i class="fas fa-shopping-cart"></i>
            <span>Carrello</span>
        </a>
        <a href="${pageContext.request.contextPath}/WishlistServlet" class="mobile-menu-item">
            <i class="fas fa-heart"></i>
            <span>Wishlist</span>
        </a>
        <a href="${pageContext.request.contextPath}/" class="mobile-menu-item">
            <i class="fas fa-home"></i>
            <span>Home</span>
        </a>
    </c:otherwise>
</c:choose>
    </div>
</nav>

<!-- Includi messaggi flash -->
<jsp:include page="flash-message.jsp" />