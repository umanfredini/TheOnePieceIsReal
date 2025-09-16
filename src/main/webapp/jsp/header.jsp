<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>The One Piece Is Real</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/main.css?v=20241201">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/layout.css?v=${System.currentTimeMillis()}">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/responsive.css?v=20241202">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/search-forms.css?v=20241201">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/image-fixes.css?v=${System.currentTimeMillis()}">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/image-error.css?v=${System.currentTimeMillis()}">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/mobile-menu-fixes.css?v=${System.currentTimeMillis()}">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/admin-responsive.css?v=${System.currentTimeMillis()}">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/checkout.css?v=${System.currentTimeMillis()}">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/background-music.css?v=${System.currentTimeMillis()}">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/wishlist-buttons.css?v=${System.currentTimeMillis()}">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/catalogo.css?v=20241206">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/scripts/main.js" defer></script>
    <script src="${pageContext.request.contextPath}/scripts/toast.js" type="module" defer></script>
    
    <!-- Debug e fallback per il menu mobile -->
    <script>
        console.log('🔍 HEADER.JSP: Script caricati');
        document.addEventListener('DOMContentLoaded', () => {
            console.log('🔍 HEADER.JSP: DOM Content Loaded');
            
            // Fallback per il menu mobile se main.js non funziona
            setTimeout(() => {
                const mobileMenuToggle = document.getElementById('mobileMenuToggle');
                const mobileMenu = document.getElementById('mobileMenu');
                console.log('🔍 HEADER.JSP: Elementi menu mobile:', {
                    toggle: mobileMenuToggle,
                    menu: mobileMenu,
                    toggleExists: !!mobileMenuToggle,
                    menuExists: !!mobileMenu
                });
                
                // Se gli elementi esistono ma non hanno listener, aggiungi fallback
                if (mobileMenuToggle && mobileMenu) {
                    // Verifica se ha già un listener (se main.js ha funzionato)
                    const hasListener = mobileMenuToggle.onclick !== null || 
                                      mobileMenuToggle.getAttribute('data-listener-added') === 'true';
                    
                    if (!hasListener) {
                        console.log('🔄 HEADER.JSP: Aggiungendo fallback per menu mobile');
                        mobileMenuToggle.setAttribute('data-listener-added', 'true');
                        
                        mobileMenuToggle.addEventListener('click', (e) => {
                            console.log('🖱️ FALLBACK: Click su menu hamburger!');
                            
                            if (mobileMenu.classList.contains('active')) {
                                mobileMenu.classList.remove('active');
                                mobileMenuToggle.classList.remove('active');
                                document.body.classList.remove('menu-open');
                                console.log('📤 FALLBACK: Menu chiuso');
                            } else {
                                mobileMenu.classList.add('active');
                                mobileMenuToggle.classList.add('active');
                                document.body.classList.add('menu-open');
                                console.log('📥 FALLBACK: Menu aperto');
                            }
                        });
                    }
                }
            }, 1000);
        });
    </script>
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
            <ul class="${sessionScope.isAdmin ? 'admin-menu' : ''}">
                <c:choose>
                    <c:when test="${empty sessionScope.utente}">
                        <li><a href="${pageContext.request.contextPath}/jsp/register.jsp"><i class="fas fa-user-plus"></i> Registrazione</a></li>
                        <li><a href="${pageContext.request.contextPath}/jsp/login.jsp"><i class="fas fa-sign-in-alt"></i> Login</a></li>
                    </c:when>
                    <c:otherwise>
                        <c:choose>
                            <c:when test="${sessionScope.isAdmin}">
                                <li><a href="${pageContext.request.contextPath}/DashboardServlet">
                                    <i class="fas fa-tachometer-alt"></i> Dashboard Amministratore
                                </a></li>
                                <li><a href="${pageContext.request.contextPath}/AdminProductServlet">
                                    <i class="fas fa-box"></i> Gestione Prodotti
                                </a></li>
                                <li><a href="${pageContext.request.contextPath}/AdminOrderServlet">
                                    <i class="fas fa-shopping-cart"></i> Gestione Ordini
                                </a></li>
                                <li><a href="${pageContext.request.contextPath}/AdminUserServlet">
                                    <i class="fas fa-users"></i> Gestione Utenti
                                </a></li>
                                <li><a href="${pageContext.request.contextPath}/jsp/logout.jsp">
                                    <i class="fas fa-store"></i> Torna al Negozio
                                </a></li>
                            </c:when>
                            <c:otherwise>
                                <li><a href="${pageContext.request.contextPath}/ProfileServlet"><i class="fas fa-user-circle"></i> Profilo</a></li>
                            </c:otherwise>
                        </c:choose>
                        <c:if test="${not sessionScope.isAdmin}">
                            <li><a href="${pageContext.request.contextPath}/jsp/logout.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
                        </c:if>
                    </c:otherwise>
                </c:choose>
                
                <!-- Menu normale - solo per utenti non admin -->
                <c:if test="${not sessionScope.isAdmin}">
                    <li><a href="${pageContext.request.contextPath}/catalog"><i class="fas fa-th-large"></i> Catalogo</a></li>
                    <li><a href="${pageContext.request.contextPath}/CartServlet"><i class="fas fa-shopping-cart"></i> Carrello</a></li>
                    <li><a href="${pageContext.request.contextPath}/WishlistServlet"><i class="fas fa-heart"></i> Wishlist</a></li>
                    <li><a href="${pageContext.request.contextPath}/"><i class="fas fa-home"></i> Home</a></li>
                </c:if>
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
                            <span>Dashboard Amministratore</span>
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
                        <a href="${pageContext.request.contextPath}/jsp/logout.jsp" class="mobile-menu-item">
                            <i class="fas fa-store"></i>
                            <span>Torna al Negozio</span>
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/ProfileServlet" class="mobile-menu-item">
                            <i class="fas fa-user-circle"></i>
                            <span>Profilo</span>
                        </a>
                    </c:otherwise>
                </c:choose>
        <c:if test="${not sessionScope.isAdmin}">
            <a href="${pageContext.request.contextPath}/jsp/logout.jsp" class="mobile-menu-item">
                <i class="fas fa-sign-out-alt"></i>
                <span>Logout</span>
            </a>
        </c:if>
    </c:otherwise>
</c:choose>

<!-- Menu normale mobile - solo per utenti non admin -->
<c:if test="${not sessionScope.isAdmin}">
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
</c:if>
    </div>
</nav>

<!-- Includi messaggi flash -->
<jsp:include page="flash-message.jsp" />