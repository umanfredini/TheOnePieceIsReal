<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="header.jsp" />

<!-- Messaggio di successo per aggiunta al carrello -->
<c:if test="${param.added == 'true'}">
    <div class="alert alert-success alert-dismissible fade show" role="alert" style="margin: 20px;">
        <i class="fas fa-check-circle me-2"></i>
        <strong>Prodotto aggiunto al carrello!</strong>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
</c:if>

<style>
/* Stili per modals personalizzati */
.modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.7);
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 9999;
}

.modal-container {
    position: relative;
    max-width: 500px;
    width: 90%;
}

.custom-modal {
    background: white;
    border-radius: 8px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
    overflow: hidden;
    animation: modalSlideIn 0.3s ease-out;
}

@keyframes modalSlideIn {
    from {
        opacity: 0;
        transform: translateY(-50px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.modal-header {
    padding: 20px;
    border-bottom: 1px solid #eee;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.success-modal .modal-header {
    background: linear-gradient(135deg, #28a745, #20c997);
    color: white;
}

.error-modal .modal-header {
    background: linear-gradient(135deg, #dc3545, #e74c3c);
    color: white;
}

.modal-title {
    margin: 0;
    font-size: 1.2rem;
    font-weight: 600;
}

.modal-close {
    background: none;
    border: none;
    color: white;
    font-size: 24px;
    cursor: pointer;
    padding: 0;
    width: 30px;
    height: 30px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 50%;
    transition: background-color 0.2s;
}

.modal-close:hover {
    background-color: rgba(255, 255, 255, 0.2);
}

.modal-body {
    padding: 30px 20px;
    text-align: center;
}

.modal-icon {
    font-size: 3rem;
    margin-bottom: 20px;
    display: block;
}

.success-icon {
    color: #28a745;
}

.error-icon {
    color: #dc3545;
}

.modal-footer {
    padding: 20px;
    border-top: 1px solid #eee;
    display: flex;
    gap: 10px;
    justify-content: flex-end;
}

.btn {
    padding: 10px 20px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    gap: 8px;
    font-weight: 500;
    transition: all 0.2s;
}

.btn-primary {
    background: linear-gradient(135deg, #007bff, #0056b3);
    color: white;
}

.btn-primary:hover {
    background: linear-gradient(135deg, #0056b3, #004085);
    transform: translateY(-1px);
}

.btn-secondary {
    background: #6c757d;
    color: white;
}

.btn-secondary:hover {
    background: #5a6268;
    transform: translateY(-1px);
}

/* Stili per i badge dei personaggi */
.character-badge {
    background: linear-gradient(135deg, #007bff, #0056b3) !important;
    border: none;
    font-weight: 500;
    padding: 0.5rem 0.75rem;
    margin: 0.25rem;
    border-radius: 20px;
    box-shadow: 0 2px 4px rgba(0, 123, 255, 0.2);
    transition: all 0.3s ease;
}

.character-badge:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0, 123, 255, 0.3);
}

/* ===== STILI ONE PIECE PER SEZIONE ACQUISTO ===== */

/* Pannello principale di acquisizione tesoro */
.treasure-acquisition-panel {
    background: #ffffff;
    border-radius: 12px;
    padding: 2rem;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
    border: 2px solid #ffd700;
    position: relative;
    overflow: hidden;
}

.treasure-acquisition-panel::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 3px;
    background: linear-gradient(90deg, #ffd700, #ffed4e, #ffd700);
    animation: subtleGlow 3s ease-in-out infinite;
    pointer-events: none;
}

@keyframes subtleGlow {
    0%, 100% { opacity: 0.7; }
    50% { opacity: 1; }
}

/* Header del pannello */
.treasure-panel-header {
    text-align: center;
    margin-bottom: 2rem;
    position: relative;
    z-index: 2;
}

.treasure-title {
    color: #2c3e50;
    font-family: 'Pirata One', cursive;
    font-size: 1.5rem;
    font-weight: bold;
    text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.1);
    margin: 0;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 0.5rem;
}

.treasure-title i {
    color: #ffd700;
    font-size: 1.3rem;
}

/* Form del tesoro */
.treasure-form {
    position: relative;
    z-index: 2;
}

/* Sezioni del form */
.treasure-variant-section,
.treasure-quantity-section {
    margin-bottom: 1.5rem;
}

/* Label del tesoro */
.treasure-label {
    display: block;
    color: #34495e;
    font-family: 'Pirata One', cursive;
    font-size: 1rem;
    font-weight: bold;
    margin-bottom: 0.8rem;
    text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.1);
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

.treasure-label i {
    color: #ffd700;
    font-size: 1.1rem;
}

/* Select del tesoro */
.treasure-select {
    width: 100%;
    padding: 12px 16px;
    background: #ffffff;
    border: 2px solid #ffd700;
    border-radius: 8px;
    color: #2c3e50;
    font-size: 1rem;
    font-weight: 500;
    box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.05);
    transition: all 0.3s ease;
}

.treasure-select:focus {
    outline: none;
    border-color: #ffed4e;
    box-shadow: 0 0 8px rgba(255, 215, 0, 0.3);
    transform: translateY(-1px);
}

.treasure-select option {
    background: #ffffff;
    color: #2c3e50;
    padding: 8px;
}

/* Banner informativo */
.treasure-info-banner {
    background: linear-gradient(135deg, #f8f9fa, #e9ecef);
    border: 1px solid #ffd700;
    border-radius: 8px;
    padding: 1rem;
    margin-bottom: 1.5rem;
    position: relative;
    overflow: hidden;
}

.treasure-info-content {
    display: flex;
    align-items: center;
    gap: 0.8rem;
    position: relative;
    z-index: 2;
}

.treasure-info-icon {
    color: #ffd700;
    font-size: 1.2rem;
}

.treasure-info-text {
    color: #2c3e50;
    font-weight: 500;
    text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.1);
}

/* Controlli quantità */
.treasure-quantity-controls {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    background: #ffffff;
    border: 2px solid #ffd700;
    border-radius: 8px;
    padding: 0.5rem;
    box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.05);
}

.treasure-quantity-btn {
    background: linear-gradient(135deg, #ffd700, #ffed4e);
    border: none;
    border-radius: 6px;
    color: #2c3e50;
    width: 40px;
    height: 40px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.1rem;
    font-weight: bold;
    cursor: pointer;
    transition: all 0.3s ease;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.treasure-quantity-btn:hover {
    background: linear-gradient(135deg, #ffed4e, #ffd700);
    transform: translateY(-1px);
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
}

.treasure-quantity-btn:active {
    transform: translateY(0);
    box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
}

.treasure-quantity-input {
    flex: 1;
    background: transparent;
    border: none;
    color: #2c3e50;
    font-size: 1.2rem;
    font-weight: bold;
    text-align: center;
    padding: 8px;
    outline: none;
    font-family: 'Pirata One', cursive;
}

.treasure-quantity-input::-webkit-outer-spin-button,
.treasure-quantity-input::-webkit-inner-spin-button {
    -webkit-appearance: none;
    margin: 0;
}

.treasure-quantity-input[type=number] {
    -moz-appearance: textfield;
}

/* Sezione azione */
.treasure-action-section {
    margin-top: 2rem;
}

/* Bottone di acquisizione */
.treasure-acquire-btn {
    width: 100%;
    padding: 14px 20px;
    background: linear-gradient(135deg, #28a745, #20c997);
    border: 2px solid #28a745;
    border-radius: 8px;
    color: #ffffff;
    font-family: 'Pirata One', cursive;
    font-size: 1.1rem;
    font-weight: bold;
    cursor: pointer;
    transition: all 0.3s ease;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    position: relative;
    overflow: hidden;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 0.6rem;
}

.treasure-acquire-btn:hover {
    background: linear-gradient(135deg, #20c997, #17a2b8);
    transform: translateY(-2px);
    box-shadow: 0 6px 16px rgba(0, 0, 0, 0.2);
    border-color: #20c997;
}

.treasure-acquire-btn:active {
    transform: translateY(-1px);
    box-shadow: 0 3px 8px rgba(0, 0, 0, 0.15);
}

.treasure-acquire-btn:disabled {
    background: linear-gradient(135deg, #6c757d, #adb5bd);
    border-color: #6c757d;
    color: #ffffff;
    cursor: not-allowed;
    transform: none;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.treasure-acquire-btn i {
    font-size: 1.2rem;
}

/* Responsive */
@media (max-width: 768px) {
    .modal-container {
        width: 95%;
        margin: 10px;
    }
    
    .modal-footer {
        flex-direction: column;
    }
    
    .btn {
        width: 100%;
        justify-content: center;
    }
    
    .treasure-acquisition-panel {
        padding: 1.5rem;
        margin: 1rem 0;
    }
    
    .treasure-title {
        font-size: 1.5rem;
    }
    
    .treasure-acquire-btn {
        font-size: 1.1rem;
        padding: 14px 20px;
    }
    
    .treasure-quantity-controls {
        flex-direction: column;
        gap: 0.3rem;
    }
    
    .treasure-quantity-btn {
        width: 100%;
        height: 35px;
    }
}
</style>

<main class="container mt-5" role="main">
    <div class="row">
        <div class="col-md-6 text-center">
            <img src="${pageContext.request.contextPath}/styles/images/prodotti/${product.imageUrl}" alt="${product.name}" class="img-fluid rounded shadow-sm" style="max-height: 400px;">
        </div>
        <div class="col-md-6">
            <h1 class="mb-3">${product.name}</h1>
            <h4 class="text-muted mb-3">
                <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="€" />
            </h4>
            <p class="mb-4">${product.description}</p>
            <ul class="list-group mb-3">
                <li class="list-group-item"><strong>Categoria:</strong> ${product.category}</li>
                <li class="list-group-item"><strong>Personaggi:</strong> 
                    <c:choose>
                        <c:when test="${not empty productCharacters}">
                            <c:forEach var="character" items="${productCharacters}">
                                <span class="badge character-badge">${character}</span>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <span class="text-muted">Nessun personaggio specifico</span>
                        </c:otherwise>
                    </c:choose>
                </li>
                <li class="list-group-item">
                    <strong>Tipo prodotto:</strong>
                    <c:choose>
                        <c:when test="${not empty variants}">
                            <span class="text-info">Prodotto con varianti</span>
                            <small class="d-block text-muted">
                                <c:choose>
                                    <c:when test="${variants[0].variantType == 'color'}">Colori disponibili</c:when>
                                    <c:when test="${variants[0].variantType == 'size'}">Taglie disponibili</c:when>
                                    <c:otherwise>Varianti disponibili</c:otherwise>
                                </c:choose>
                            </small>
                        </c:when>
                        <c:otherwise>
                            <span class="text-secondary">Prodotto singolo</span>
                        </c:otherwise>
                    </c:choose>
                </li>
                <li class="list-group-item">
                    <strong>Disponibilità:</strong>
                    <c:choose>
                        <c:when test="${not empty variants}">
                            <c:set var="availableCount" value="0" />
                            <c:forEach var="variant" items="${variants}">
                                <c:if test="${variant.stockQuantity > 0}">
                                    <c:set var="availableCount" value="${availableCount + 1}" />
                                </c:if>
                            </c:forEach>
                            <span class="text-success">${availableCount} di ${variants.size()} varianti disponibili</span>
                        </c:when>
                        <c:otherwise>
                            <c:choose>
                                <c:when test="${product.stockQuantity > 0}">
                                    <span class="text-success">Disponibile (${product.stockQuantity} pezzi)</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-danger">Non disponibile</span>
                                </c:otherwise>
                            </c:choose>
                        </c:otherwise>
                    </c:choose>
                </li>
            </ul>

            <!-- Sezione Acquisto con Stile One Piece -->
            <div class="treasure-acquisition-panel">
                <div class="treasure-panel-header">
                    <h3 class="treasure-title">
                        <i class="fas fa-shopping-cart"></i>
                        Aggiungi al Carrello
                    </h3>
                </div>
                
                <form id="addToCartForm" action="${pageContext.request.contextPath}/CartServlet" method="post" class="treasure-form">
                    <input type="hidden" name="action" value="add" />
                    <input type="hidden" name="productId" value="${product.id}" />
                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />

                    <!-- Sezione Varianti - Mostra solo se esistono varianti -->
                    <c:choose>
                        <c:when test="${not empty variants}">
                            <div class="treasure-variant-section">
                                <label for="variant" class="treasure-label">
                                    <i class="fas fa-palette"></i>
                                    <c:choose>
                                        <c:when test="${variants[0].variantType == 'color'}">Colore</c:when>
                                        <c:when test="${variants[0].variantType == 'size'}">Taglia</c:when>
                                        <c:otherwise>Variante</c:otherwise>
                                    </c:choose>
                                </label>
                                <select name="variantId" id="variant" class="treasure-select" required>
                                    <c:forEach var="variant" items="${variants}">
                                        <option value="${variant.id}">
                                            ${variant.variantName}
                                            <c:if test="${variant.stockQuantity <= 0}"> - Esaurito</c:if>
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- Prodotto senza varianti - mostra informazioni di stock -->
                            <div class="treasure-info-banner">
                                <div class="treasure-info-content">
                                    <i class="fas fa-info-circle treasure-info-icon"></i>
                                    <span class="treasure-info-text">
                                        <strong>Prodotto Singolo</strong> - Nessuna variante disponibile
                                    </span>
                                </div>
                            </div>
                            <!-- Campo hidden per prodotti senza varianti -->
                            <input type="hidden" name="variantId" value="" disabled />
                        </c:otherwise>
                    </c:choose>

                    <div class="treasure-quantity-section">
                        <label for="quantity" class="treasure-label">
                            <i class="fas fa-cubes"></i>
                            Quantità
                        </label>
                        <div class="treasure-quantity-controls">
                            <button type="button" class="treasure-quantity-btn" onclick="decreaseQuantity()">
                                <i class="fas fa-minus"></i>
                            </button>
                            <input type="number" name="quantity" id="quantity" class="treasure-quantity-input" 
                                   min="1" max="${product.stockQuantity}" value="1" required />
                            <button type="button" class="treasure-quantity-btn" onclick="increaseQuantity()">
                                <i class="fas fa-plus"></i>
                            </button>
                        </div>
                    </div>

                    <div class="treasure-action-section">
                        <c:choose>
                            <c:when test="${not empty variants}">
                                <!-- Per prodotti con varianti, controlla se almeno una variante è disponibile -->
                                <c:set var="hasAvailableVariant" value="false" />
                                <c:forEach var="variant" items="${variants}">
                                    <c:if test="${variant.stockQuantity > 0}">
                                        <c:set var="hasAvailableVariant" value="true" />
                                    </c:if>
                                </c:forEach>
                                <button type="button" class="treasure-acquire-btn add-to-cart-btn" 
                                        <c:if test="${!hasAvailableVariant}">disabled</c:if>>
                                    <c:choose>
                                        <c:when test="${hasAvailableVariant}">
                                            <i class="fas fa-shopping-cart"></i>
                                            Aggiungi al Carrello
                                        </c:when>
                                        <c:otherwise>
                                            <i class="fas fa-times-circle"></i>
                                            Non Disponibile
                                        </c:otherwise>
                                    </c:choose>
                                </button>
                            </c:when>
                            <c:otherwise>
                                <!-- Per prodotti senza varianti, usa lo stock del prodotto -->
                                <button type="button" class="treasure-acquire-btn add-to-cart-btn" 
                                        <c:if test="${product.stockQuantity == 0}">disabled</c:if>>
                                    <c:choose>
                                        <c:when test="${product.stockQuantity > 0}">
                                            <i class="fas fa-shopping-cart"></i>
                                            Aggiungi al Carrello
                                        </c:when>
                                        <c:otherwise>
                                            <i class="fas fa-times-circle"></i>
                                            Non Disponibile
                                        </c:otherwise>
                                    </c:choose>
                                </button>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </form>
            </div>
        </div>
    </div>
</main>

<!-- Overlay per modals -->
<div id="modalOverlay" class="modal-overlay" style="display: none;">
    <div class="modal-container">

        <!-- Modal di errore -->
        <div id="cartErrorModal" class="custom-modal error-modal" style="display: none;">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-exclamation-triangle"></i> Errore
                </h5>
                <button type="button" class="modal-close" onclick="hideModal('cartErrorModal')">&times;</button>
            </div>
            <div class="modal-body">
                <div class="text-center">
                    <i class="fas fa-times-circle modal-icon error-icon"></i>
                    <p id="errorMessage">Si è verificato un errore durante l'aggiunta al carrello.</p>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="hideModal('cartErrorModal')">Chiudi</button>
            </div>
        </div>
    </div>
</div>

<!-- Script per gestione aggiunta al carrello -->
<script type="module">
// Importa la funzione showToast
import { showToast } from '${pageContext.request.contextPath}/scripts/toast.js';

// Funzioni per gestire i modals personalizzati
function showModal(modalId) {
    const modalOverlay = document.getElementById('modalOverlay');
    const modal = document.getElementById(modalId);
    
    if (modalOverlay && modal) {
        modalOverlay.style.display = 'flex';
        modal.style.display = 'block';
        document.body.style.overflow = 'hidden'; // Previene lo scroll
    }
}

function hideModal(modalId) {
    const modalOverlay = document.getElementById('modalOverlay');
    const modal = document.getElementById(modalId);
    
    if (modalOverlay && modal) {
        modalOverlay.style.display = 'none';
        modal.style.display = 'none';
        document.body.style.overflow = 'auto'; // Ripristina lo scroll
    }
}

// Chiudi modal cliccando sull'overlay
document.addEventListener('DOMContentLoaded', function() {
    const modalOverlay = document.getElementById('modalOverlay');
    if (modalOverlay) {
        modalOverlay.addEventListener('click', function(e) {
            if (e.target === modalOverlay) {
                hideModal('cartErrorModal');
            }
        });
    }
});

// Funzioni per gestire i controlli di quantità
function increaseQuantity() {
    const quantityInput = document.getElementById('quantity');
    const maxQuantity = parseInt(quantityInput.getAttribute('max'));
    const currentQuantity = parseInt(quantityInput.value);
    
    if (currentQuantity < maxQuantity) {
        quantityInput.value = currentQuantity + 1;
        // Aggiungi effetto visivo
        quantityInput.style.transform = 'scale(1.1)';
        setTimeout(() => {
            quantityInput.style.transform = 'scale(1)';
        }, 200);
    }
}

function decreaseQuantity() {
    const quantityInput = document.getElementById('quantity');
    const minQuantity = parseInt(quantityInput.getAttribute('min'));
    const currentQuantity = parseInt(quantityInput.value);
    
    if (currentQuantity > minQuantity) {
        quantityInput.value = currentQuantity - 1;
        // Aggiungi effetto visivo
        quantityInput.style.transform = 'scale(1.1)';
        setTimeout(() => {
            quantityInput.style.transform = 'scale(1)';
        }, 200);
    }
}

document.addEventListener('DOMContentLoaded', function() {
    console.log('Script caricato');
    
    const addToCartForm = document.getElementById('addToCartForm');
    const addToCartButtons = document.querySelectorAll('.add-to-cart-btn');
    
    console.log('Form trovato:', addToCartForm);
    console.log('Pulsanti trovati:', addToCartButtons.length);
    
    const errorMessage = document.getElementById('errorMessage');

    addToCartButtons.forEach((button, index) => {
        console.log('Aggiungendo listener al pulsante', index);
        
        button.addEventListener('click', function(e) {
            e.preventDefault();
            console.log('Pulsante cliccato!');
            
            // Verifica che il form sia valido
            console.log('Verifica validità form...');
            if (!addToCartForm.checkValidity()) {
                console.log('Form non valido - campi mancanti o invalidi');
                addToCartForm.reportValidity();
                return;
            }
            
            // Verifica aggiuntiva per variantId se il prodotto ha varianti
            const variantSelect = addToCartForm.querySelector('select[name="variantId"]');
            if (variantSelect && variantSelect.required && (!variantSelect.value || variantSelect.value.trim() === '')) {
                console.log('Variante richiesta ma non selezionata');
                showToast('Seleziona una variante del prodotto', 'warning');
                return;
            }
            
            console.log('Form valido, procedo con l\'invio');
            
            // Disabilita il pulsante durante l'invio
            button.disabled = true;
            button.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Aggiungendo...';
            
            // Raccogli i dati del form come URL-encoded
            const formData = new URLSearchParams();
            formData.append('action', 'add');
            formData.append('productId', addToCartForm.querySelector('[name="productId"]').value);
            formData.append('quantity', addToCartForm.querySelector('[name="quantity"]').value);
            
            // Aggiungi variantId solo se non è vuoto e non è disabilitato
            const variantIdInput = addToCartForm.querySelector('[name="variantId"]:not([disabled])');
            if (variantIdInput && variantIdInput.value && variantIdInput.value.trim() !== '') {
                formData.append('variantId', variantIdInput.value.trim());
            }
            
            // Aggiungi il token CSRF se presente
            const csrfToken = addToCartForm.querySelector('[name="csrfToken"]');
            if (csrfToken && csrfToken.value) {
                formData.append('csrfToken', csrfToken.value);
            }
            
            // Debug: mostra i dati del form
            console.log('📤 Dati da inviare:');
            for (let [key, value] of formData.entries()) {
                console.log(`  ${key}: ${value}`);
            }
            
            // Costruisci l'URL esplicitamente - APPROCCIO DIRETTO
            const pathParts = window.location.pathname.split('/');
            const appContextPath = pathParts[1] || '';
            console.log('🔍 Debug URL construction:');
            console.log('  window.location.pathname:', window.location.pathname);
            console.log('  pathParts:', pathParts);
            console.log('  appContextPath extracted:', appContextPath);
            console.log('  appContextPath charCodes:', Array.from(appContextPath).map(c => c.charCodeAt(0)));
            
            // Costruisci l'URL in modo esplicito
            let cartUrl;
            if (appContextPath && appContextPath.trim() !== '') {
                // Costruisci l'URL pezzo per pezzo
                cartUrl = '/' + appContextPath.trim() + '/CartServlet';
                console.log('  Using appContextPath branch');
                console.log('  URL parts: "/" + "' + appContextPath.trim() + '" + "/CartServlet"');
            } else {
                cartUrl = '/CartServlet';
                console.log('  Using fallback branch');
            }
            
            console.log('🌐 URL richiesta:', cartUrl);
            
            // Invia la richiesta AJAX
            console.log('🚀 Invio richiesta AJAX a:', cartUrl);
            
            fetch(cartUrl, {
                method: 'POST',
                body: new URLSearchParams(formData),
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
            .then(response => {
                console.log('📡 Risposta server:', response.status, response.statusText);
                console.log('📡 Headers risposta:', response.headers);
                console.log('📡 Content-Type:', response.headers.get('content-type'));
                
                if (!response.ok) {
                    console.error('❌ Risposta HTTP non OK:', response.status, response.statusText);
                    // Per errori 400, proviamo a leggere il messaggio di errore
                    if (response.status === 400) {
                        return response.text().then(errorText => {
                            console.error('❌ Messaggio di errore 400:', errorText);
                            throw new Error(`Errore 400: ${errorText}`);
                        });
                    }
                    throw new Error(`HTTP ${response.status}: ${response.statusText}`);
                }
                return response.text(); // Prima leggiamo come testo per debug
            })
            .then(data => {
                console.log('📦 Dati risposta raw:', data);
                console.log('📦 Tipo risposta:', typeof data);
                console.log('📦 Lunghezza risposta:', data.length);
                
                // Prova a parsare come JSON
                let jsonData;
                try {
                    jsonData = JSON.parse(data);
                    console.log('JSON parsato con successo:', jsonData);
                } catch (e) {
                    console.error('Errore parsing JSON:', e);
                    console.error('Dati che causano errore:', data);
                    throw new Error('Risposta non valida dal server: ' + data.substring(0, 100));
                }
                
                if (jsonData.success) {
                    console.log('Operazione completata con successo!');
                    // Mostra notifica di successo
                    showToast('Prodotto aggiunto al carrello! 🛒', 'success');
                    
                    // Aggiorna il pulsante
                    button.disabled = false;
                    button.innerHTML = '<i class="fas fa-check"></i> Aggiunto al carrello';
                    
                    // Reset del form
                    addToCartForm.reset();
                    
                    // Ripristina il pulsante dopo 3 secondi
                    setTimeout(() => {
                        button.innerHTML = 'Aggiungi al carrello';
                    }, 3000);
                } else {
                    console.error('Errore dal server:', jsonData.error);
                    throw new Error(jsonData.error || 'Errore durante l\'aggiunta al carrello');
                }
            })
            .catch(error => {
                console.error('Errore:', error);
                
                // Mostra il modal di errore
                var errorMsg = error.message || 'Si è verificato un errore durante l\'aggiunta al carrello.';
                
                // Se è un errore di connessione al database
                if (errorMsg.includes('Errore di connessione al database') || 
                    errorMsg.includes('Impossibile connettersi al database')) {
                    errorMsg = 'Errore di connessione al database. Verifica che MySQL sia in esecuzione.';
                }
                
                errorMessage.textContent = errorMsg;
                showModal('cartErrorModal');
                
                // Ripristina il pulsante
                button.disabled = false;
                button.innerHTML = 'Aggiungi al carrello';
            });
        });
    });
});
</script>

<jsp:include page="footer.jsp" />
