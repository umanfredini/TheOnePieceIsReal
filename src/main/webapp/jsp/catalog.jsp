<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- ID utente per gestione wishlist per-utente -->
<c:if test="${not empty sessionScope.utente}">
    <meta name="user-id" content="${sessionScope.utente.id}">
</c:if>
<jsp:include page="header.jsp" />
<script src="${pageContext.request.contextPath}/scripts/wishlist-manager.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/carousel.css">

<style>
/* Griglia prodotti come homepage */
.products-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    gap: 2rem;
    padding: 2rem 0;
}

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

/* Gli stili wishlist sono ora gestiti da wishlist-buttons.css */

/* Stili per la paginazione */
.pagination {
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    border-radius: 8px;
    overflow: hidden;
}

.pagination .page-link {
    border: none;
    padding: 12px 16px;
    color: #495057;
    background-color: #fff;
    transition: all 0.3s ease;
    font-weight: 500;
}

.pagination .page-link:hover {
    background-color: #e9ecef;
    color: #007bff;
    transform: translateY(-1px);
    box-shadow: 0 2px 8px rgba(0, 123, 255, 0.2);
}

.pagination .page-item.active .page-link {
    background: linear-gradient(135deg, #007bff, #0056b3);
    color: white;
    border: none;
    box-shadow: 0 2px 8px rgba(0, 123, 255, 0.3);
}

.pagination .page-item.disabled .page-link {
    background-color: #f8f9fa;
    color: #6c757d;
    cursor: not-allowed;
    opacity: 0.6;
}

.pagination-info {
    background: #f8f9fa;
    padding: 8px 16px;
    border-radius: 6px;
    border: 1px solid #dee2e6;
}

.pagination-jump {
    background: #f8f9fa;
    padding: 8px 16px;
    border-radius: 6px;
    border: 1px solid #dee2e6;
}

.pagination-jump .form-control {
    border: 1px solid #ced4da;
    border-radius: 4px;
    text-align: center;
}

.pagination-jump .form-control:focus {
    border-color: #007bff;
    box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
}

/* Responsive per paginazione */
@media (max-width: 768px) {
    .d-flex.justify-content-between {
        flex-direction: column;
        gap: 20px;
    }
    
    .pagination {
        justify-content: center;
    }
    
    .pagination-info,
    .pagination-jump {
        text-align: center;
    }
    
    .pagination-jump form {
        justify-content: center;
    }
}

/* Animazioni per transizioni pagina */
.card {
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.card:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15) !important;
}

/* Stili per il messaggio "nessun prodotto" */
.alert-info {
    background: linear-gradient(135deg, #d1ecf1, #bee5eb);
    border: 1px solid #bee5eb;
    color: #0c5460;
    border-radius: 10px;
    padding: 30px;
    text-align: center;
    font-size: 1.1rem;
}

.alert-info::before {
    content: '🔍';
    font-size: 2rem;
    display: block;
    margin-bottom: 15px;
}

</style>

<main class="container mt-5" role="main">
    <h1 class="mb-4 text-center">Catalogo Prodotti</h1>
    
    <!-- Informazioni paginazione -->
    <c:if test="${totalPages > 1}">
        <div class="alert alert-light text-center mb-4" role="alert">
            <i class="fas fa-info-circle me-2"></i>
            Mostrando ${products.size()} prodotti su ${totalProducts} totali 
            (Pagina ${currentPage} di ${totalPages})
        </div>
    </c:if>

    <!-- Filtri dinamici -->
    <form method="get" action="${pageContext.request.contextPath}/catalog" class="row mb-4">
        <div class="col-md-3">
            <label for="category" class="form-label">Categoria</label>
            <select name="category" id="category" class="form-select">
                <option value="">Tutte</option>
                <c:forEach var="cat" items="${categories}">
                    <option value="${cat}" <c:if test="${param.category == cat}">selected</c:if>>${cat}</option>
                </c:forEach>
            </select>
        </div>
        <div class="col-md-3">
            <label for="personaggio" class="form-label">Personaggio</label>
            <select name="personaggio" id="personaggio" class="form-select">
                <option value="">Tutti</option>
                <c:forEach var="character" items="${characters}">
                    <option value="${character}" <c:if test="${param.personaggio == character}">selected</c:if>>${character}</option>
                </c:forEach>
            </select>
        </div>
        <div class="col-md-3">
            <label for="maxPrice" class="form-label">Prezzo massimo</label>
            <input type="number" name="maxPrice" id="maxPrice" class="form-control" 
                   value="${param.maxPrice != null ? param.maxPrice : ''}" 
                   placeholder="Es. 50" min="0" step="0.01" />
        </div>
        <div class="col-md-3 d-flex align-items-end gap-2">
            <button type="submit" class="btn btn-outline-primary flex-grow-1">
                <i class="fas fa-filter me-1"></i>Filtra
            </button>
            <a href="${pageContext.request.contextPath}/catalog" class="btn btn-outline-secondary">
                <i class="fas fa-times"></i>
            </a>
        </div>
    </form>



    <!-- Lista prodotti con design Homepage -->
    <section class="products-grid" role="region" aria-label="Lista prodotti">
        <c:choose>
            <c:when test="${not empty products}">
                <c:forEach var="product" items="${products}">
                    <div class="product-card" data-product-id="${product.id}" data-category="${product.category}">
                        <!-- Click sul prodotto per andare al dettaglio -->
                        <div class="product-click-area" onclick="goToProductDetail(${product.id})">
                            <img src="${pageContext.request.contextPath}/styles/images/prodotti/${product.imageUrl}" 
                                 alt="${product.name}" class="product-image">
                            
                            <div class="product-info">
                                <h3 class="product-title">${product.name}</h3>
                                <div class="product-price">€${product.price}</div>
                            </div>
                        </div>
                        
                        <!-- Bottoni azioni (non propagano il click) -->
                        <c:if test="${not empty sessionScope.utente}">
                            <div class="product-actions" onclick="event.stopPropagation()">
                                <button class="wishlist-btn" onclick="toggleWishlist(${product.id})" 
                                        data-product-id="${product.id}">
                                    <i class="fas fa-heart"></i>
                                </button>
                            </div>
                        </c:if>
                        
                        <div class="product-actions-bottom" onclick="event.stopPropagation()">
                            <button class="cart-btn" onclick="addToCart(${product.id})">
                                <i class="fas fa-shopping-cart"></i>
                            </button>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="alert alert-info text-center" role="alert">
                    Nessun prodotto disponibile al momento.
                </div>
            </c:otherwise>
        </c:choose>
    </section>

    <!-- Token CSRF per le operazioni AJAX -->
    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />

    <!-- Paginazione -->
    <c:if test="${totalPages > 1}">
        <nav aria-label="Paginazione prodotti" class="mt-5">
            <div class="d-flex justify-content-between align-items-center">
                <!-- Informazioni pagine -->
                <div class="pagination-info">
                    <small class="text-muted">
                        Pagina ${currentPage} di ${totalPages} 
                        (${totalProducts} prodotti totali)
                    </small>
                </div>
                
                <!-- Controlli paginazione -->
                <ul class="pagination pagination-lg mb-0">
                    <!-- Pulsante Precedente -->
                    <li class="page-item ${hasPrevPage ? '' : 'disabled'}">
                        <c:choose>
                            <c:when test="${hasPrevPage}">
                                <c:url var="prevPageUrl" value="/catalog">
                                    <c:param name="page" value="${currentPage - 1}" />
                                    <c:if test="${not empty param.category}">
                                        <c:param name="category" value="${param.category}" />
                                    </c:if>
                                    <c:if test="${not empty param.personaggio}">
                                        <c:param name="personaggio" value="${param.personaggio}" />
                                    </c:if>
                                    <c:if test="${not empty param.maxPrice}">
                                        <c:param name="maxPrice" value="${param.maxPrice}" />
                                    </c:if>
                                </c:url>
                                <a class="page-link" href="${prevPageUrl}" aria-label="Pagina precedente">
                                    <i class="fas fa-chevron-left"></i> Precedente
                                </a>
                            </c:when>
                            <c:otherwise>
                                <span class="page-link disabled">
                                    <i class="fas fa-chevron-left"></i> Precedente
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </li>
                    
                    <!-- Numeri delle pagine -->
                    <c:set var="startPage" value="${currentPage - 2}" />
                    <c:set var="endPage" value="${currentPage + 2}" />
                    <c:if test="${startPage < 1}">
                        <c:set var="startPage" value="1" />
                    </c:if>
                    <c:if test="${endPage > totalPages}">
                        <c:set var="endPage" value="${totalPages}" />
                    </c:if>
                    
                    <c:forEach var="pageNum" begin="${startPage}" end="${endPage}">
                        <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                            <c:url var="pageUrl" value="/catalog">
                                <c:param name="page" value="${pageNum}" />
                                <c:if test="${not empty param.category}">
                                    <c:param name="category" value="${param.category}" />
                                </c:if>
                                <c:if test="${not empty param.personaggio}">
                                    <c:param name="personaggio" value="${param.personaggio}" />
                                </c:if>
                                <c:if test="${not empty param.maxPrice}">
                                    <c:param name="maxPrice" value="${param.maxPrice}" />
                                </c:if>
                            </c:url>
                            <a class="page-link" href="${pageUrl}">
                                ${pageNum}
                            </a>
                        </li>
                    </c:forEach>
                    
                    <!-- Pulsante Successivo -->
                    <li class="page-item ${hasNextPage ? '' : 'disabled'}">
                        <c:choose>
                            <c:when test="${hasNextPage}">
                                <c:url var="nextPageUrl" value="/catalog">
                                    <c:param name="page" value="${currentPage + 1}" />
                                    <c:if test="${not empty param.category}">
                                        <c:param name="category" value="${param.category}" />
                                    </c:if>
                                    <c:if test="${not empty param.personaggio}">
                                        <c:param name="personaggio" value="${param.personaggio}" />
                                    </c:if>
                                    <c:if test="${not empty param.maxPrice}">
                                        <c:param name="maxPrice" value="${param.maxPrice}" />
                                    </c:if>
                                </c:url>
                                <a class="page-link" href="${nextPageUrl}" aria-label="Pagina successiva">
                                    Successivo <i class="fas fa-chevron-right"></i>
                                </a>
                            </c:when>
                            <c:otherwise>
                                <span class="page-link disabled">
                                    Successivo <i class="fas fa-chevron-right"></i>
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </li>
                </ul>
                
                <!-- Jump to page -->
                <div class="pagination-jump">
                    <form class="d-flex gap-2" onsubmit="return validateJumpPage()">
                        <label for="jumpPage" class="form-label mb-0 d-flex align-items-center">
                            <small>Vai a:</small>
                        </label>
                        <input type="number" id="jumpPage" name="page" class="form-control" 
                               min="1" max="${totalPages}" value="${currentPage}" 
                               style="width: 80px;" />
                        <button type="submit" class="btn btn-sm btn-outline-primary">Vai</button>
                    </form>
                </div>
            </div>
        </nav>
    </c:if>
</main>

<script>
// Script per migliorare l'esperienza paginazione
document.addEventListener('DOMContentLoaded', function() {
    // Scroll to top quando si cambia pagina
    var paginationLinks = document.querySelectorAll('.pagination .page-link');
    paginationLinks.forEach(function(link) {
        link.addEventListener('click', function() {
            // Scroll smooth to top
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        });
    });
    
    // Validazione input "Vai a pagina"
    var jumpPageInput = document.getElementById('jumpPage');
    if (jumpPageInput) {
        jumpPageInput.addEventListener('input', function() {
            var value = parseInt(this.value);
            var max = parseInt(this.getAttribute('max'));
            
            if (value > max) {
                this.value = max;
            } else if (value < 1) {
                this.value = 1;
            }
        });
    }
    
    // Reset paginazione quando si applicano filtri
    var filterForm = document.querySelector('form[action*="catalog"]');
    if (filterForm) {
        filterForm.addEventListener('submit', function() {
            // Rimuovi il parametro page quando si applicano filtri
            var pageInput = this.querySelector('input[name="page"]');
            if (pageInput) {
                pageInput.remove();
            }
        });
    }
    
    // Animazione per le card dei prodotti
    var productCards = document.querySelectorAll('.card');
    productCards.forEach(function(card, index) {
        card.style.animationDelay = (index * 0.1) + 's';
        card.style.animation = 'fadeInUp 0.6s ease-out forwards';
        card.style.opacity = '0';
    });
});

// Funzione per validare il jump to page
function validateJumpPage() {
    var input = document.getElementById('jumpPage');
    var value = parseInt(input.value);
    var max = parseInt(input.getAttribute('max'));
    
    if (value < 1 || value > max) {
        alert('Inserisci un numero di pagina valido tra 1 e ' + max);
        return false;
    }
    
    // Aggiungi i parametri di filtro correnti
    var url = new URL(window.location);
    url.searchParams.set('page', value);
    
    // Mantieni i filtri correnti
    var category = document.getElementById('category').value;
    var personaggio = document.getElementById('personaggio').value;
    var maxPrice = document.getElementById('maxPrice').value;
    
    if (category) url.searchParams.set('category', category);
    if (personaggio) url.searchParams.set('personaggio', personaggio);
    if (maxPrice) url.searchParams.set('maxPrice', maxPrice);
    
    window.location.href = url.toString();
    return false;
}

// Funzione per aggiungere al carrello
function addToCart(productId) {
    // Aggiungendo al carrello prodotto
    
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
        var errorMessage = 'Errore di connessione. Riprova.';
        
        // Se è una risposta HTTP con messaggio di errore
        if (error.message && error.message.includes('HTTP')) {
            errorMessage = 'Errore del server. Verifica che il database sia attivo.';
        }
        
        showToast(errorMessage, 'error');
    });
}

// Configurazione per il file wishlist-manager.js
    var isUserLoggedIn = ${sessionScope.utente != null ? true : false};
    var isUserAdmin = ${sessionScope.isAdmin != null ? sessionScope.isAdmin : false};
    
    // Inizializza wishlist per il catalogo
    document.addEventListener('DOMContentLoaded', function() {
        console.log('=== INIZIALIZZAZIONE WISHLIST CATALOGO ===');
        console.log('isUserLoggedIn:', isUserLoggedIn);
        console.log('isUserAdmin:', isUserAdmin);
        
        if (isUserLoggedIn && !isUserAdmin) {
            // Sincronizza con il server e inizializza i bottoni
            if (typeof syncWishlistFromServer === 'function') {
                syncWishlistFromServer();
            } else {
                // Fallback: inizializza solo con stato locale
                if (typeof initializeLocalWishlist === 'function') {
                    initializeLocalWishlist();
                }
            }
        } else {
            console.log('Utente non loggato o admin - wishlist non inizializzata');
        }
    });

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

// CSS per animazioni
var style = document.createElement('style');
style.textContent = 
    '@keyframes fadeInUp {' +
        'from {' +
            'opacity: 0;' +
            'transform: translateY(30px);' +
        '}' +
        'to {' +
            'opacity: 1;' +
            'transform: translateY(0);' +
        '}' +
    '}' +
    
    '.card {' +
        'opacity: 0;' +
    '}' +
    
    '.card.animated {' +
        'opacity: 1;' +
    '}' +
    
    '/* Toast notifications */' +
    '.toast-notification {' +
        'position: fixed;' +
        'top: 20px;' +
        'right: 20px;' +
        'background: white;' +
        'border-radius: 8px;' +
        'box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);' +
        'padding: 15px 20px;' +
        'z-index: 10000;' +
        'transform: translateX(100%);' +
        'transition: transform 0.3s ease;' +
        'max-width: 300px;' +
    '}' +
    
    '.toast-notification.show {' +
        'transform: translateX(0);' +
    '}' +
    
    '.toast-notification.success {' +
        'border-left: 4px solid #28a745;' +
    '}' +
    
    '.toast-notification.error {' +
        'border-left: 4px solid #dc3545;' +
    '}' +
    
    '.toast-notification.info {' +
        'border-left: 4px solid #17a2b8;' +
    '}' +
    
    '.toast-content {' +
        'display: flex;' +
        'align-items: center;' +
        'gap: 10px;' +
    '}' +
    
    '.toast-content i {' +
        'font-size: 1.2rem;' +
    '}' +
    
    '.toast-notification.success .toast-content i {' +
        'color: #28a745;' +
    '}' +
    
    '.toast-notification.error .toast-content i {' +
        'color: #dc3545;' +
    '}' +
    
    '.toast-notification.info .toast-content i {' +
        'color: #17a2b8;' +
    '}';
document.head.appendChild(style);

// Funzione per andare al dettaglio prodotto
function goToProductDetail(productId) {
    window.location.href = '${pageContext.request.contextPath}/ProductServlet?action=detail&id=' + productId;
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
</script>


<jsp:include page="footer.jsp" />