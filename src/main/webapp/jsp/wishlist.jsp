<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="header.jsp" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/carousel.css">
<meta name="csrf-token" content="${sessionScope.csrfToken}">

<!-- ID utente per gestione wishlist per-utente -->
<c:if test="${not empty sessionScope.utente}">
    <meta name="user-id" content="${sessionScope.utente.id}">
</c:if>

<main class="container mt-5" role="main">
    <div class="collection-header">
        <h1 class="mb-4 text-center gradient-text">🏴‍☠️ La mia Collezione</h1>
        <p class="text-center text-muted">I tuoi tesori One Piece preferiti</p>
    </div>

    <section class="products-grid" role="region" aria-label="Collezione prodotti">
        <c:choose>
            <c:when test="${not empty wishlist}">
                <c:forEach var="product" items="${wishlist}">
                    <div class="product-card btn-danger active" data-product-id="${product.id}" data-category="${product.category}">
                        <!-- Click sul prodotto per andare al dettaglio -->
                        <div class="product-click-area" onclick="goToProductDetail(${product.id})">
                            <img src="${pageContext.request.contextPath}/styles/images/prodotti/${product.imageUrl}" 
                                 alt="${product.name}" class="product-image">
                            
                            <div class="product-info">
                                <h3 class="product-title gradient-text">${product.name}</h3>
                                <div class="product-price">€${product.price}</div>
                            </div>
                        </div>
                        
                        <!-- Bottoni azioni (non propagano il click) -->
                        <div class="product-actions" onclick="event.stopPropagation()">
                            <button class="wishlist-btn active" onclick="toggleWishlist('${product.id}')" 
                                    data-product-id="${product.id}" title="Rimuovi dalla wishlist">
                                <i class="fas fa-heart"></i>
                            </button>
                        </div>
                        
                        <div class="product-actions-bottom" onclick="event.stopPropagation()">
                            <button class="cart-btn btn-gradient-success" onclick="addToCart(${product.id})">
                                <i class="fas fa-shopping-cart"></i>
                            </button>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="empty-collection">
                    <div class="empty-collection-content">
                        <i class="fas fa-heart-broken" style="font-size: 4rem; color: #ff6b6b; margin-bottom: 20px;"></i>
                        <h3>🏴‍☠️ La tua collezione è vuota</h3>
                        <p>Non hai ancora salvato nessun tesoro One Piece nella tua collezione.</p>
                        <a href="${pageContext.request.contextPath}/catalog" class="btn btn-primary">
                            <i class="fas fa-search"></i> Esplora Prodotti
                        </a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </section>
</main>

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

.collection-header {
    background: transparent;
    padding: 2rem;
    border-radius: 15px;
    margin-bottom: 2rem;
    text-align: center;
}

.collection-header h1 {
    font-family: 'Pirata One', 'Bangers', cursive;
    color: #f1c40f;
    text-shadow: 3px 3px 0px #2c3e50, 6px 6px 10px rgba(0, 0, 0, 0.3);
    letter-spacing: 2px;
    margin-bottom: 0.5rem;
    font-size: 2.5rem;
}

.collection-header p {
    color: #2c3e50;
    font-weight: 500;
    font-size: 1.1rem;
}

.empty-collection {
    grid-column: 1 / -1;
    text-align: center;
    padding: 4rem 2rem;
    background: linear-gradient(135deg, #8B4513, #A0522D);
    border-radius: 15px;
    border: 3px solid #DAA520;
    color: white;
}

.empty-collection-content h3 {
    color: #FFD700;
    margin-bottom: 1rem;
}

@keyframes cardDisappear {
    from {
        opacity: 1;
        transform: scale(1);
    }
    to {
        opacity: 0;
        transform: scale(0.8);
    }
}
</style>

<script type="module">
// Importa la funzione showToast
import { showToast } from '${pageContext.request.contextPath}/scripts/toast.js';

// La wishlist ora usa la funzione standard toggleWishlist dal wishlist-manager.js
function toggleWishlistInPage(productId) {
    // Usa la funzione standard toggleWishlist
    toggleWishlist(productId);
    
    // Rimuovi la card dalla pagina dopo un breve delay
    setTimeout(() => {
        const card = document.querySelector(`[data-product-id="${productId}"]`);
        if (card && !card.querySelector('.wishlist-btn').classList.contains('active')) {
            card.style.animation = 'cardDisappear 0.5s ease-out';
            setTimeout(() => {
                card.remove();
                // Se non ci sono più card, mostra il messaggio vuoto
                if (document.querySelectorAll('.product-card').length === 0) {
                    document.querySelector('.wishlist-container').innerHTML = `
                        <div class="text-center py-5">
                            <i class="fas fa-heart-broken fa-3x text-muted mb-3"></i>
                            <h3>La tua wishlist è vuota</h3>
                            <p class="text-muted">Aggiungi alcuni prodotti per iniziare!</p>
                            <a href="${pageContext.request.contextPath}/catalog" class="btn btn-primary">
                                <i class="fas fa-shopping-bag me-2"></i>Vai al Catalogo
                            </a>
                        </div>
                    `;
                }
            }, 500);
        }
    }, 1000);
}

window.goToProductDetail = function(productId) {
    window.location.href = '${pageContext.request.contextPath}/ProductServlet?action=detail&id=' + productId;
}

window.addToCart = function(productId) {
    const formData = new FormData();
    formData.append('action', 'add');
    formData.append('productId', productId);
    formData.append('quantity', '1');
    formData.append('csrfToken', document.querySelector('meta[name="csrf-token"]').getAttribute('content'));
    
    fetch(window.location.origin + '/TheOnePieceIsReal/CartServlet', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            showToast('Prodotto aggiunto al carrello! 🛒', 'success');
        } else {
            showToast(data.error || 'Errore durante l\'aggiunta al carrello', 'error');
        }
    })
    .catch(error => {
        console.error('Errore:', error);
        showToast('Errore di connessione', 'error');
    });
}

// Funzione showToast gestita da toast.js
</script>

<jsp:include page="footer.jsp" />