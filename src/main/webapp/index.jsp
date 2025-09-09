<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="dao.ProductDAO" %>
<%@ page import="model.Product" %>
<%@ page import="java.util.List" %>

<%
    // Carica i prodotti in evidenza se non sono già presenti
    if (request.getAttribute("featuredProducts") == null) {
        try {
            ProductDAO productDAO = new ProductDAO();
            List<Product> featuredProducts = productDAO.getFeaturedProducts(6);
            request.setAttribute("featuredProducts", featuredProducts);
        } catch (Exception e) {
            // Log dell'errore per debug
            System.err.println("Errore nel caricamento prodotti in evidenza: " + e.getMessage());
            e.printStackTrace();
            // In caso di errore, lascia featuredProducts vuoto
            request.setAttribute("featuredProducts", new java.util.ArrayList<>());
            // Imposta un flag per mostrare un messaggio di errore
            request.setAttribute("databaseError", true);
            request.setAttribute("databaseErrorMessage", "Database non disponibile. Verificare che MySQL sia in esecuzione.");
        }
    }
%>

<jsp:include page="jsp/header.jsp" />

<!-- Token CSRF per le operazioni AJAX -->
<input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />

<!-- Menu hamburger per mobile -->
<button class="mobile-menu-toggle" id="mobileMenuToggle">
    <span class="hamburger-line"></span>
    <span class="hamburger-line"></span>
    <span class="hamburger-line"></span>
</button>

<!-- Menu mobile -->
<nav class="mobile-menu" id="mobileMenu">
    <div class="mobile-menu-content">
        <c:choose>
            <c:when test="${empty sessionScope.utente}">
                <a href="${pageContext.request.contextPath}/jsp/login.jsp" class="mobile-menu-item">
                    <i class="fas fa-user"></i>
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
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/ProfileServlet" class="mobile-menu-item">
                            <i class="fas fa-user"></i>
                            <span>Profilo</span>
                        </a>
                    </c:otherwise>
                </c:choose>
            </c:otherwise>
        </c:choose>
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
    </div>
</nav>

<!-- Layout principale -->
<div class="main-container">
    <!-- Sidebar di ricerca -->
    <aside class="search-sidebar">
        <h3>🔍 Ricerca Prodotti</h3>
        <form class="search-form" action="${pageContext.request.contextPath}/catalog" method="get">
            <!-- Ricerca per tipologia -->
            <div class="form-group">
                <label for="category">Tipologia Prodotto</label>
                <select id="category" name="category" class="form-select">
                    <option value="">Tutte le categorie</option>
                    <option value="Figure">Figure</option>
                    <option value="Abbigliamento">Abbigliamento</option>
                    <option value="Cosplay">Cosplay</option>
                    <option value="Poster">Poster</option>
                    <option value="Quadro">Quadro</option>
                    <option value="Pelouche">Pelouche</option>
                    <option value="Navi">Navi</option>
                    <option value="Gadget">Gadget</option>
                </select>
            </div>

            <!-- Ricerca per personaggio -->
            <div class="form-group character-menu">
                <label for="character">Personaggio</label>
                <select id="character" name="personaggio" class="form-select">
                    <option value="">Tutti i personaggi</option>
                    
                    <!-- Cappello di Paglia -->
                    <optgroup label="🍃 Cappello di Paglia">
                        <option value="Luffy">Luffy</option>
                        <option value="Zoro">Zoro</option>
                        <option value="Nami">Nami</option>
                        <option value="Usopp">Usopp</option>
                        <option value="Sanji">Sanji</option>
                        <option value="Chopper">Chopper</option>
                        <option value="Robin">Robin</option>
                        <option value="Franky">Franky</option>
                        <option value="Brook">Brook</option>
                        <option value="Jinbei">Jinbei</option>
                    </optgroup>
                    
                    <!-- Imperatori -->
                    <optgroup label="👑 Imperatori">
                        <option value="Shanks">Shanks</option>
                        <option value="Kaido">Kaido</option>
                        <option value="Barbabianca">Barbabianca</option>
                        <option value="Barbanera">Barbanera</option>
                    </optgroup>
                    
                    <!-- Altri -->
                    <optgroup label="⚔️ Altri">
                        <option value="Law">Law</option>
                        <option value="Kidd">Kidd</option>
                        <option value="Ace">Ace</option>
                        <option value="Sabo">Sabo</option>
                        <option value="Roger">Roger</option>
                    </optgroup>
                </select>
            </div>

            <button type="submit" class="search-btn">
                <i class="fas fa-search"></i> Cerca
            </button>
        </form>
    </aside>

    <!-- Contenuto principale -->
    <main class="main-content">
        <!-- Carosello prodotti in evidenza -->
        <section class="featured-products">
            <h2 class="gradient-text">Prodotti in Evidenza</h2>
            
            <!-- Messaggio di errore database -->
            <c:if test="${databaseError}">
                <div class="database-error-message">
                    <div class="error-icon">
                        <i class="fas fa-exclamation-triangle"></i>
                    </div>
                    <div class="error-content">
                        <h3>Database Non Disponibile</h3>
                        <p>${databaseErrorMessage}</p>                      
                    </div>
                </div>
            </c:if>
            
            <div class="carousel-container carousel-gradient">
                <div class="carousel-track">
                    <!-- Controllo se ci sono prodotti -->
                    <c:choose>
                        <c:when test="${not empty featuredProducts}">
                            <!-- Prodotti duplicati per effetto infinito -->
                            <c:forEach var="product" items="${featuredProducts}" varStatus="status" end="4">
                                <div class="product-card product-card-gradient" data-product-id="${product.id}" data-category="${product.category}">
                                    <!-- Click sul prodotto per andare al dettaglio -->
                                    <div class="product-click-area" onclick="goToProductDetail(${product.id})">
                                        <img src="${pageContext.request.contextPath}/styles/images/prodotti/${product.imageUrl}" 
                                             alt="${product.name}" class="product-image product-image-gradient">
                                        
                                        <div class="product-info">
                                            <h3 class="product-title gradient-text">${product.name}</h3>
                                            <div class="product-price">€${product.price}</div>
                                        </div>
                                        
                                        <!-- Overlay rimosso per design più pulito -->
                                    </div>
                                    
                                    <!-- Bottoni azioni (non propagano il click) -->
                                    <c:if test="${not empty sessionScope.utente and not sessionScope.isAdmin}">
                                        <div class="product-actions" onclick="event.stopPropagation()">
                                            <button class="wishlist-btn btn-gradient-primary" onclick="toggleWishlist(${product.id})" 
                                                    data-product-id="${product.id}">
                                                <i class="fas fa-heart"></i>
                                            </button>
                                        </div>
                                    </c:if>
                                    
                                    <div class="product-actions-bottom" onclick="event.stopPropagation()">
                                        <button class="cart-btn btn-gradient-success" onclick="addToCart(${product.id})">
                                            <i class="fas fa-shopping-cart"></i>
                                        </button>
                                    </div>
                                </div>
                            </c:forEach>
                            
                            <!-- Duplicazione per effetto infinito -->
                            <c:forEach var="product" items="${featuredProducts}" varStatus="status" end="4">
                                <div class="product-card product-card-gradient" data-product-id="${product.id}" data-category="${product.category}">
                                    <!-- Click sul prodotto per andare al dettaglio -->
                                    <div class="product-click-area" onclick="goToProductDetail(${product.id})">
                                        <img src="${pageContext.request.contextPath}/styles/images/prodotti/${product.imageUrl}" 
                                             alt="${product.name}" class="product-image product-image-gradient">
                                        
                                        <div class="product-info">
                                            <h3 class="product-title gradient-text">${product.name}</h3>
                                            <div class="product-price">€${product.price}</div>
                                        </div>
                                        
                                        <!-- Overlay rimosso per design più pulito -->
                                    </div>
                                    
                                    <!-- Bottoni azioni (non propagano il click) -->
                                    <c:if test="${not empty sessionScope.utente and not sessionScope.isAdmin}">
                                        <div class="product-actions" onclick="event.stopPropagation()">
                                            <button class="wishlist-btn btn-gradient-primary" onclick="toggleWishlist(${product.id})" 
                                                    data-product-id="${product.id}">
                                                <i class="fas fa-heart"></i>
                                            </button>
                                        </div>
                                    </c:if>
                                    
                                    <div class="product-actions-bottom" onclick="event.stopPropagation()">
                                        <button class="cart-btn btn-gradient-success" onclick="addToCart(${product.id})">
                                            <i class="fas fa-shopping-cart"></i>
                                        </button>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <!-- Messaggio quando non ci sono prodotti -->
                            <div class="no-products-message">
                                <div class="no-products-content">
                                    <i class="fas fa-ship" style="font-size: 3rem; color: #ff6b6b; margin-bottom: 20px;"></i>
                                    <h3>🏴‍☠️ Nessun prodotto disponibile</h3>
                                    <p>Al momento non ci sono prodotti in evidenza. Torna presto per nuove scoperte!</p>
                                    <a href="${pageContext.request.contextPath}/catalog" class="hero-btn primary">Esplora Tutti i Prodotti</a>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <!-- Controlli carosello rimossi per design più pulito -->
            </div>
        </section>
    </main>
</div>

<!-- Footer -->
<footer class="main-footer">
    <div class="footer-content">
        <div class="footer-section">
            <h4>The One Piece Is Real</h4>
            <p>Il tuo negozio ufficiale di merchandising One Piece</p>
        </div>
        <div class="footer-section">
            <h4>Contatti</h4>
            <p>Email: info@onepieceisreal.it</p>
            <p>Tel: +39 123 456 7890</p>
        </div>
        <div class="footer-section">
            <h4>Spedizioni</h4>
            <p>Consegna in tutta Italia</p>
            <p>Spedizione gratuita sopra €50</p>
            <a href="${pageContext.request.contextPath}/TrackingServlet" class="tracking-link">
                <i class="fas fa-ship"></i> Traccia Ordine
            </a>
        </div>
    </div>
</footer>

<!-- Stili per il carosello funzionale -->
<style>
.product-click-area {
    cursor: pointer;
    position: relative;
    width: 100%;
    height: 100%;
}

.product-click-area:hover {
    transform: scale(1.02);
    transition: transform 0.2s ease;
}

.product-actions, .product-actions-bottom {
    position: absolute;
    z-index: 10;
}

.product-actions {
    top: 10px;
    right: 10px;
}

.product-actions-bottom {
    bottom: 10px;
    right: 10px;
}

.wishlist-btn.active {
    background: linear-gradient(135deg, #dc3545, #e74c3c) !important;
    color: white !important;
}

/* Toast notifications */
.toast-notification {
    position: fixed;
    top: 20px;
    right: 20px;
    z-index: 9999;
    min-width: 300px;
    max-width: 500px;
    border-radius: 8px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    animation: slideInRight 0.3s ease;
    font-family: var(--font-body);
    opacity: 0;
    transform: translateX(100%);
    transition: all 0.3s ease;
}

.toast-notification.show {
    opacity: 1;
    transform: translateX(0);
}

.toast-content {
    display: flex;
    align-items: center;
    padding: 1rem 1.25rem;
    gap: 0.75rem;
}

.toast-notification.success {
    background: linear-gradient(135deg, #28a745, #20c997);
    color: white;
    border-left: 4px solid #1e7e34;
}

.toast-notification.error {
    background: linear-gradient(135deg, #dc3545, #e74c3c);
    color: white;
    border-left: 4px solid #c82333;
}

@keyframes slideInRight {
    from {
        transform: translateX(100%);
        opacity: 0;
    }
    to {
        transform: translateX(0);
        opacity: 1;
    }
}

/* Stile per il link tracking */
.tracking-link {
    display: inline-block;
    margin-top: 10px;
    padding: 8px 16px;
    background: linear-gradient(135deg, #ffd700, #ffed4e);
    color: #8B4513;
    text-decoration: none;
    border-radius: 20px;
    font-weight: bold;
    transition: all 0.3s ease;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
}

.tracking-link:hover {
    background: linear-gradient(135deg, #ffed4e, #fff);
    transform: translateY(-2px);
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
    color: #8B4513;
    text-decoration: none;
}
</style>

<!-- Scripts -->
<script src="${pageContext.request.contextPath}/scripts/main.js"></script>
<script src="${pageContext.request.contextPath}/scripts/cart.js"></script>
<script src="${pageContext.request.contextPath}/scripts/wishlist-manager.js"></script>

<script>
    // Funzioni per il carosello
    function moveCarousel(direction) {
        const track = document.querySelector('.carousel-track');
        const currentTransform = getComputedStyle(track).transform;
        const matrix = new DOMMatrix(currentTransform);
        const currentX = matrix.m41;
        
        const cardWidth = 280 + 32; // larghezza card + margin
        const newX = currentX + (direction * cardWidth * 3);
        
        track.style.transform = `translateX(${newX}px)`;
    }
    
    // Funzione per andare al dettaglio prodotto
    function goToProductDetail(productId) {
        window.location.href = '${pageContext.request.contextPath}/ProductServlet?action=detail&id=' + productId;
    }
    
    // Controllo wishlist - utilizza la logica del wishlist-manager.js
    function toggleWishlist(productId) {
        // La funzione è già definita nel wishlist-manager.js
        // Questa è solo un wrapper per compatibilità
        if (typeof window.toggleWishlist === 'function') {
            window.toggleWishlist(productId);
        }
    }
    
    // Controllo carrello
    function addToCart(productId) {
        event.preventDefault();
        event.stopPropagation();
        
        // Ottieni il token CSRF se presente
        var csrfToken = '';
        var csrfInput = document.querySelector('input[name="csrfToken"]');
        if (csrfInput) {
            csrfToken = csrfInput.value;
        }
        
        var formData = 'action=add&productId=' + productId + '&quantity=1';
        if (csrfToken) {
            formData += '&csrfToken=' + csrfToken;
        }
        
        fetch('${pageContext.request.contextPath}/CartServlet', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: formData
        })
        .then(function(response) {
            if (!response.ok) {
                throw new Error('Errore HTTP: ' + response.status);
            }
            return response.json();
        })
        .then(function(data) {
            if (data.success) {
                showToast('Prodotto aggiunto al carrello!', 'success');
                // Opzionale: aggiorna contatore carrello se presente
                var cartCounter = document.querySelector('.cart-counter');
                if (cartCounter && data.cartSize) {
                    cartCounter.textContent = data.cartSize;
                }
            } else {
                showToast(data.error || 'Errore durante l\'aggiunta al carrello', 'error');
            }
        })
        .catch(function(error) {
            console.error('Errore:', error);
            showToast('Errore di connessione. Riprova.', 'error');
        });
    }
    
    // Funzione per mostrare toast notifications
    function showToast(message, type) {
        var toast = document.createElement('div');
        type = type || 'info';
        toast.className = 'toast-notification ' + type;
        
        var iconClass = 'fas fa-info-circle';
        if (type === 'success') {
            iconClass = 'fas fa-check-circle';
        } else if (type === 'error') {
            iconClass = 'fas fa-times-circle';
        }
        
        toast.innerHTML = '<div class="toast-content">' +
            '<i class="' + iconClass + '"></i>' +
            '<span>' + message + '</span>' +
            '</div>';
        
        document.body.appendChild(toast);
        
        setTimeout(function() { toast.classList.add('show'); }, 100);
        
        setTimeout(function() {
            toast.classList.remove('show');
            setTimeout(function() { toast.remove(); }, 300);
        }, 3000);
    }
    
    // Script per menu mobile
    document.addEventListener('DOMContentLoaded', function() {
        const mobileMenuToggle = document.getElementById('mobileMenuToggle');
        const mobileMenu = document.getElementById('mobileMenu');
        
        if (mobileMenuToggle && mobileMenu) {
            mobileMenuToggle.addEventListener('click', function() {
                mobileMenuToggle.classList.toggle('active');
                mobileMenu.classList.toggle('active');
            });
            
            // Chiudi menu quando si clicca su un link
            const mobileMenuItems = mobileMenu.querySelectorAll('.mobile-menu-item');
            mobileMenuItems.forEach(item => {
                item.addEventListener('click', function() {
                    mobileMenuToggle.classList.remove('active');
                    mobileMenu.classList.remove('active');
                });
            });
        }
    });
</script>

</body>
</html> 