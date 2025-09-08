<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="header.jsp" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/vivre-cards.css">

<main class="container mt-5" role="main">
    <div class="collection-header">
        <h1 class="mb-4 text-center gradient-text">🏴‍☠️ La mia Collezione</h1>
        <p class="text-center text-muted">I tuoi tesori One Piece preferiti</p>
    </div>

    <section class="vivre-cards-container" role="region" aria-label="Collezione prodotti">
        <c:choose>
            <c:when test="${not empty wishlist}">
                <c:forEach var="product" items="${wishlist}">
                    <div class="vivre-card collection-card" data-product-id="${product.id}">
                        <div class="vivre-card-inner">
                            <div class="vivre-card-front">
                                <div class="vivre-card-image">
                                    <img src="${pageContext.request.contextPath}/styles/images/prodotti/${product.imageUrl}" 
                                         alt="Immagine di ${product.name}" 
                                         onerror="this.src='${pageContext.request.contextPath}/styles/images/altro/zoro-lost.gif'" />
                                    <div class="collection-badge">
                                        <i class="fas fa-heart"></i>
                                    </div>
                                </div>
                                <div class="vivre-card-info">
                                    <h3 class="vivre-card-title"><c:out value="${product.name}" /></h3>
                                    <div class="vivre-card-category">
                                        <span class="category-badge"><c:out value="${product.category}" /></span>
                                    </div>
                                    <div class="vivre-card-price">
                                        <span class="price-amount">€ <c:out value="${product.price}" /></span>
                                    </div>
                                </div>
                            </div>
                            <div class="vivre-card-back">
                                <div class="vivre-card-actions">
                                    <a href="${pageContext.request.contextPath}/ProductServlet?action=detail&id=${product.id}" 
                                       class="vivre-btn detail-btn">
                                        <i class="fas fa-eye"></i> Dettagli
                                    </a>
                                    <button onclick="addToCart(${product.id})" 
                                            class="vivre-btn cart-btn" 
                                            title="Aggiungi al carrello">
                                        <i class="fas fa-shopping-cart"></i> Carrello
                                    </button>
                                    <button onclick="removeFromWishlist(${product.id})" 
                                            class="vivre-btn remove-btn" 
                                            title="Rimuovi dalla collezione">
                                        <i class="fas fa-trash"></i> Rimuovi
                                    </button>
                                </div>
                            </div>
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
                        <a href="${pageContext.request.contextPath}/catalog" class="vivre-btn detail-btn">
                            <i class="fas fa-search"></i> Esplora Prodotti
                        </a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </section>
</main>

<style>
.collection-header {
    background: linear-gradient(135deg, #8B4513, #A0522D);
    padding: 2rem;
    border-radius: 15px;
    margin-bottom: 2rem;
    border: 3px solid #DAA520;
    box-shadow: 0 8px 25px rgba(0, 0, 0, 0.3);
}

.collection-badge {
    position: absolute;
    top: 10px;
    right: 10px;
    background: linear-gradient(135deg, #DC143C, #FF1493);
    color: white;
    width: 40px;
    height: 40px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
    animation: heartbeat 2s infinite;
}

@keyframes heartbeat {
    0%, 100% { transform: scale(1); }
    50% { transform: scale(1.1); }
}

.collection-card .vivre-card-front {
    background: linear-gradient(135deg, #2F4F4F, #556B2F);
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

.remove-btn {
    background: linear-gradient(135deg, #DC143C, #B22222);
    color: white;
}

.remove-btn:hover {
    background: linear-gradient(135deg, #B22222, #DC143C);
    transform: translateY(-2px);
    box-shadow: 0 6px 12px rgba(0, 0, 0, 0.4);
}
</style>

<script>
function removeFromWishlist(productId) {
    if (confirm('Sei sicuro di voler rimuovere questo prodotto dalla tua collezione?')) {
        const formData = new FormData();
        formData.append('action', 'remove');
        formData.append('productId', productId);
        formData.append('csrfToken', '${sessionScope.csrfToken}');
        
        fetch('${pageContext.request.contextPath}/WishlistServlet', {
            method: 'POST',
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // Rimuovi la card dalla pagina
                const card = document.querySelector(`[data-product-id="${productId}"]`);
                if (card) {
                    card.style.animation = 'cardDisappear 0.5s ease-out';
                    setTimeout(() => {
                        card.remove();
                        // Se non ci sono più card, mostra il messaggio vuoto
                        if (document.querySelectorAll('.vivre-card').length === 0) {
                            location.reload();
                        }
                    }, 500);
                }
                showToast('Prodotto rimosso dalla collezione', 'success');
            } else {
                showToast(data.error || 'Errore durante la rimozione', 'error');
            }
        })
        .catch(error => {
            console.error('Errore:', error);
            showToast('Errore di connessione', 'error');
        });
    }
}

function addToCart(productId) {
    const formData = new FormData();
    formData.append('action', 'add');
    formData.append('productId', productId);
    formData.append('quantity', '1');
    formData.append('csrfToken', '${sessionScope.csrfToken}');
    
    fetch('${pageContext.request.contextPath}/CartServlet', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            showToast('Prodotto aggiunto al carrello!', 'success');
        } else {
            showToast(data.error || 'Errore durante l\'aggiunta al carrello', 'error');
        }
    })
    .catch(error => {
        console.error('Errore:', error);
        showToast('Errore di connessione', 'error');
    });
}

function showToast(message, type) {
    const toast = document.createElement('div');
    toast.className = `toast-notification ${type}`;
    toast.innerHTML = `
        <div class="toast-content">
            <i class="fas fa-${type === 'success' ? 'check-circle' : 'times-circle'}"></i>
            <span>${message}</span>
        </div>
    `;
    document.body.appendChild(toast);
    
    setTimeout(() => toast.classList.add('show'), 100);
    setTimeout(() => {
        toast.classList.remove('show');
        setTimeout(() => toast.remove(), 300);
    }, 3000);
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
</script>

<jsp:include page="footer.jsp" />