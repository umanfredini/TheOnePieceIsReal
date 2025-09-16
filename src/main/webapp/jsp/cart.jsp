<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="header.jsp" />
<script src="${pageContext.request.contextPath}/scripts/cart.js" defer></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/treasure-chest.css">

<style>
/* Override solo per l'header - palette One Piece */
.treasure-chest-header {
    background: transparent !important;
    border: none !important;
    box-shadow: none !important;
}

.treasure-chest-header h1 {
    font-family: 'Pirata One', 'Bangers', cursive !important;
    color: #f1c40f !important;
    text-shadow: 3px 3px 0px #2c3e50, 6px 6px 10px rgba(0, 0, 0, 0.3) !important;
    letter-spacing: 2px !important;
    font-size: 2.5rem !important;
}

.treasure-chest-header p {
    color: #2c3e50 !important;
    font-weight: 500 !important;
    font-size: 1.1rem !important;
}
</style>

<main class="container mt-5" role="main">
    <div class="treasure-chest-header">
        <h1 class="mb-4 text-center gradient-text">🏴‍☠️ Il tuo Tesoro</h1>
        <p class="text-center text-muted">I tuoi preziosi One Piece nel carrello</p>
    </div>

    <section role="region" aria-label="Contenuto del carrello" class="treasure-chest-container">
        <c:choose>
            <c:when test="${not empty cart.items}">
                <form action="${pageContext.request.contextPath}/CartServlet" method="post" id="cartForm">
                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />
                    <input type="hidden" name="productId" id="productIdToRemove" value="" />
                    
                    <div class="treasure-items">
                        <c:forEach var="item" items="${cart.items}">
                            <div class="treasure-item" data-product-id="${item.productId}">
                                <div class="treasure-item-image">
                                    <img src="${pageContext.request.contextPath}/styles/images/prodotti/${item.product.imageUrl}" 
                                         alt="${item.product.name}" 
                                         onerror="this.src='${pageContext.request.contextPath}/styles/images/altro/zoro-lost.gif'" />
                                </div>
                                <div class="treasure-item-info">
                                    <h4 class="treasure-item-title">${item.product.name}</h4>
                                    <div class="treasure-item-category">${item.product.category}</div>
                                    <c:if test="${not empty item.variantId}">
                                        <div class="treasure-item-variant">Variante ${item.variantId}</div>
                                    </c:if>
                                </div>
                                <div class="treasure-item-quantity">
                                    <label>Quantità:</label>
                                    <input type="number" 
                                           id="quantity_${item.productId}" 
                                           name="quantity_${item.productId}" 
                                           value="${item.quantity}" 
                                           min="1" 
                                           max="${item.product.stockQuantity}"
                                           class="treasure-quantity-input" 
                                           data-product-id="${item.productId}" />
                                </div>
                                <div class="treasure-item-price">
                                    <div class="unit-price">Prezzo unitario: <fmt:formatNumber value="${item.product.price}" type="currency" currencySymbol="€" /></div>
                                    <div class="total-price">Totale: <span id="item-total-${item.productId}" class="item-total"><fmt:formatNumber value="${item.product.price.doubleValue() * item.quantity}" type="currency" currencySymbol="€" /></span></div>
                                </div>
                                <div class="treasure-item-actions">
                                    <button type="submit" name="action" value="remove" onclick="setProductId('${item.productId}')" class="treasure-remove-btn">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </form>

                <div class="treasure-summary">
                    <div class="treasure-summary-content">
                        <h5 class="treasure-summary-title">Riepilogo Tesoro</h5>
                        <p class="treasure-summary-text">
                            <strong>Totale articoli:</strong> <span id="cart-items-count">${cart.items.size()}</span><br>
                            <strong>Totale ordine:</strong> <span id="cart-total">€ <fmt:formatNumber value="${cart.total}" type="currency" currencySymbol="€" /></span>
                        </p>
                    </div>
                    <div class="treasure-checkout">
                        <a href="${pageContext.request.contextPath}/CheckoutServlet" class="treasure-checkout-btn" <c:if test="${cart.items.size() == 0}">style="pointer-events: none; opacity: 0.5;"</c:if>>
                            <i class="fas fa-shipping-fast"></i> Procedi al Checkout
                        </a>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="alert alert-info text-center" role="alert" style="position: relative; z-index: 10;">
                    <i class="fas fa-shopping-cart fa-3x mb-3" style="color: #FFD700;"></i>
                    <h4>Il tuo tesoro è vuoto</h4>
                    <p class="mb-3">Non hai ancora aggiunto nessun prodotto al carrello.</p>
                    <a href="${pageContext.request.contextPath}/catalog" class="btn btn-primary" style="position: relative; z-index: 11; pointer-events: auto;">
                        <i class="fas fa-search me-2"></i>Esplora i prodotti
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </section>
</main>

<script type="module">
// Importa la funzione showToast
import { showToast } from '${pageContext.request.contextPath}/scripts/toast.js';

window.setProductId = function(productId) {
    document.getElementById('productIdToRemove').value = productId;
}

// Funzione per aggiornare la quantità via AJAX
window.updateQuantity = function(productId, newQuantity) {
    const quantity = parseInt(newQuantity);
    const manualId = 'quantity_' + productId;
    let input = document.getElementById(manualId);
    
    // Se input è null, proviamo a trovarlo diversamente
    if (!input) {
        input = document.querySelector('#' + manualId);
        if (!input) {
            input = document.querySelector(`[data-product-id="${productId}"]`);
        }
    }
    
    if (!input) {
        console.error('Input non trovato per productId:', productId);
        return;
    }
    
    // Validazione
    if (isNaN(quantity) || quantity < 1) {
        if (quantity === 0) {
            removeCartItem(productId);
            return;
        }
        input.value = input.dataset.previousValue || 1;
        return;
    }
    
    // Evita richieste duplicate
    if (input.dataset.updating === 'true') {
        return;
    }
    
    input.dataset.updating = 'true';
    input.disabled = true;
    
    const csrfToken = document.querySelector('input[name="csrfToken"]').value;
    
    // Validazione parametri prima dell'invio
    if (!productId || productId === 'undefined' || productId === 'null') {
        console.error('productId non valido:', productId);
        return;
    }
    if (!quantity || quantity === 'undefined' || quantity === 'null') {
        console.error('quantity non valido:', quantity);
        return;
    }
    
    const requestBody = 'action=update&productId=' + productId + '&quantita=' + quantity + '&csrfToken=' + csrfToken;
    
    fetch('/TheOnePieceIsReal/CartServlet', {
        method: 'POST',
        headers: { 
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-Requested-With': 'XMLHttpRequest'
        },
        body: requestBody
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            // Aggiorna il totale dell'articolo
            if (data.itemTotal !== undefined) {
                updateItemTotal(productId, data.itemTotal);
            }
            // Aggiorna i totali del carrello
            updateCartTotals(data.cartTotal, data.itemsCount);
            input.dataset.previousValue = quantity;
            showToast('Quantità aggiornata!', 'success');
        } else {
            console.error('Errore nella risposta:', data);
            // Ripristina il valore precedente in caso di errore
            input.value = input.dataset.previousValue || 1;
            showToast(data.error || 'Errore nell\'aggiornamento', 'error');
        }
    })
    .catch(error => {
        console.error('Update quantity error:', error);
        input.value = input.dataset.previousValue || 1;
        showToast('Errore di connessione. Riprova.', 'error');
    })
    .finally(() => {
        input.disabled = false;
        input.dataset.updating = 'false';
    });
}

function removeCartItem(productId) {
    fetch('/TheOnePieceIsReal/CartServlet', {
        method: 'POST',
        headers: { 
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-Requested-With': 'XMLHttpRequest'
        },
        body: `action=remove&productId=${productId}&csrfToken=${document.querySelector('input[name="csrfToken"]').value}`
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            // Rimuovi l'elemento dal DOM
            const itemElement = document.querySelector(`[data-product-id="${productId}"]`);
            if (itemElement) {
                itemElement.style.opacity = '0.5';
                setTimeout(() => itemElement.remove(), 300);
            }
            // Aggiorna i totali
            updateCartTotals(data.cartTotal, data.itemsCount);
            
            // Se il carrello è vuoto, ricarica la pagina
            if (data.itemsCount === 0) {
                setTimeout(() => window.location.reload(), 500);
            }
        } else {
            showToast(data.message || 'Errore nella rimozione', 'error');
        }
    })
    .catch(error => {
        console.error('Remove item error:', error);
        showToast('Errore di connessione. Riprova.', 'error');
    });
}

function updateItemTotal(productId, newTotal) {
    const elementId = 'item-total-' + productId;
    const totalElement = document.getElementById(elementId);
    
    console.log('updateItemTotal chiamata:', productId, newTotal);
    console.log('Cercando elemento con ID:', elementId);
    console.log('Elemento trovato:', totalElement);
    
    if (totalElement) {
        // Formato consistente con JSP: € 29,97
        const formattedTotal = newTotal.toLocaleString('it-IT', {
            style: 'currency',
            currency: 'EUR',
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        });
        console.log('Aggiornando totale da', totalElement.textContent, 'a', formattedTotal);
        totalElement.textContent = formattedTotal;
    } else {
        console.error('Elemento non trovato per productId:', productId);
        // Debug: mostra tutti gli elementi con ID che contengono "item-total"
        const allItemTotals = document.querySelectorAll('[id*="item-total"]');
        console.log('Tutti gli elementi item-total trovati:', allItemTotals);
    }
}

function updateCartTotals(cartTotal, itemsCount) {
    const totalElement = document.getElementById('cart-total');
    const countElement = document.getElementById('cart-items-count');
    
    if (totalElement) {
        // Formato consistente con JSP: € 29,97
        const formattedTotal = cartTotal.toLocaleString('it-IT', {
            style: 'currency',
            currency: 'EUR',
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        });
        totalElement.textContent = formattedTotal;
    }
    
    if (countElement) {
        countElement.textContent = itemsCount;
    }
}

// Inizializzazione event listeners
document.addEventListener('DOMContentLoaded', function() {
    const inputs = document.querySelectorAll('.treasure-quantity-input');
    
    inputs.forEach(input => {
        
        input.addEventListener('focus', function() {
            this.dataset.previousValue = this.value;
        });
        
        input.addEventListener('change', function() {
            const productId = this.dataset.productId;
            if (productId) {
                updateQuantity(productId, this.value);
            } else {
                console.error('ProductId non trovato per input:', this.id);
                console.log('Provo a estrarre productId dall\'ID');
                const idParts = this.id.split('_');
                console.log('ID parts:', idParts);
                if (idParts.length > 1) {
                    const extractedProductId = idParts[1];
                    console.log('ProductId estratto dall\'ID:', extractedProductId);
                    updateQuantity(extractedProductId, this.value);
                }
            }
        });
        
        input.addEventListener('input', function() {
            // Debounce per evitare troppe richieste
            clearTimeout(this.inputTimeout);
            this.inputTimeout = setTimeout(() => {
                const productId = this.dataset.productId;
                if (productId) {
                    updateQuantity(productId, this.value);
                } else {
                    // Fallback: estrai dall'ID
                    const idParts = this.id.split('_');
                    if (idParts.length > 1) {
                        const extractedProductId = idParts[1];
                        updateQuantity(extractedProductId, this.value);
                    }
                }
            }, 500);
        });
    });
});

// Funzione showToast gestita da toast.js
</script>

<jsp:include page="footer.jsp" />