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

                            <form id="addToCartForm" action="${pageContext.request.contextPath}/ProductServlet" method="post" class="card p-3">
                <input type="hidden" name="action" value="add" />
                <input type="hidden" name="productId" value="${product.id}" />
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />

                <!-- Sezione Varianti - Mostra solo se esistono varianti -->
                <c:choose>
                    <c:when test="${not empty variants}">
                        <div class="mb-3">
                            <label for="variant" class="form-label">
                                <c:choose>
                                    <c:when test="${variants[0].variantType == 'color'}">Colore</c:when>
                                    <c:when test="${variants[0].variantType == 'size'}">Taglia</c:when>
                                    <c:otherwise>Variante</c:otherwise>
                                </c:choose>
                            </label>
                            <select name="variantId" id="variant" class="form-select" required>
                                <c:forEach var="variant" items="${variants}">
                                    <option value="${variant.id}">
                                        ${variant.variantName}
                                        <c:if test="${variant.stockQuantity <= 0}"> - Non disponibile</c:if>
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- Prodotto senza varianti - mostra informazioni di stock -->
                        <div class="mb-3">
                            <div class="alert alert-info">
                                <i class="fas fa-info-circle me-2"></i>
                                <strong>Prodotto singolo</strong> - Nessuna variante disponibile
                            </div>
                        </div>
                        <!-- Campo hidden per prodotti senza varianti -->
                        <input type="hidden" name="variantId" value="" disabled />
                    </c:otherwise>
                </c:choose>

                <div class="mb-3">
                    <label for="quantity" class="form-label">Quantità</label>
                    <input type="number" name="quantity" id="quantity" class="form-control" min="1" max="${product.stockQuantity}" value="1" required />
                </div>

                <div class="d-grid">
                    <c:choose>
                        <c:when test="${not empty variants}">
                            <!-- Per prodotti con varianti, controlla se almeno una variante è disponibile -->
                            <c:set var="hasAvailableVariant" value="false" />
                            <c:forEach var="variant" items="${variants}">
                                <c:if test="${variant.stockQuantity > 0}">
                                    <c:set var="hasAvailableVariant" value="true" />
                                </c:if>
                            </c:forEach>
                            <button type="button" class="btn btn-primary add-to-cart-btn" 
                                    <c:if test="${!hasAvailableVariant}">disabled</c:if>>
                                <c:choose>
                                    <c:when test="${hasAvailableVariant}">Aggiungi al carrello</c:when>
                                    <c:otherwise>Nessuna variante disponibile</c:otherwise>
                                </c:choose>
                            </button>
                        </c:when>
                        <c:otherwise>
                            <!-- Per prodotti senza varianti, usa lo stock del prodotto -->
                            <button type="button" class="btn btn-primary add-to-cart-btn" 
                                    <c:if test="${product.stockQuantity == 0}">disabled</c:if>>
                                <c:choose>
                                    <c:when test="${product.stockQuantity > 0}">Aggiungi al carrello</c:when>
                                    <c:otherwise>Non disponibile</c:otherwise>
                                </c:choose>
                            </button>
                        </c:otherwise>
                    </c:choose>
                </div>
            </form>
        </div>
    </div>
</main>

<!-- Overlay per modals -->
<div id="modalOverlay" class="modal-overlay" style="display: none;">
    <div class="modal-container">
        <!-- Modal di conferma aggiunta al carrello -->
        <div id="cartConfirmationModal" class="custom-modal success-modal" style="display: none;">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-check-circle"></i> Prodotto aggiunto al carrello!
                </h5>
                <button type="button" class="modal-close" onclick="hideModal('cartConfirmationModal')">&times;</button>
            </div>
            <div class="modal-body">
                <div class="text-center">
                    <i class="fas fa-shopping-cart modal-icon success-icon"></i>
                    <p><strong>${product.name}</strong> è stato aggiunto al tuo carrello.</p>
                    <small>Puoi continuare a navigare o visualizzare il carrello.</small>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="hideModal('cartConfirmationModal')">
                    <i class="fas fa-arrow-left"></i> Continua a navigare
                </button>
                <a href="${pageContext.request.contextPath}/CartServlet" class="btn btn-primary">
                    <i class="fas fa-shopping-cart"></i> Vai al carrello
                </a>
            </div>
        </div>

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
<script>
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
                hideModal('cartConfirmationModal');
                hideModal('cartErrorModal');
            }
        });
    }
});

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
                alert('Seleziona una variante del prodotto');
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
            for (let [key, value] of formData.entries()) {
                console.log(key + ': ' + value);
            }
            
            console.log('Invio richiesta a:', addToCartForm.action);
            
            // Invia la richiesta AJAX
            console.log('Invio richiesta AJAX a:', addToCartForm.action);
            
            fetch(addToCartForm.action, {
                method: 'POST',
                body: new URLSearchParams(formData),
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })
            .then(response => {
                console.log('Risposta ricevuta:', response.status, response.statusText);
                console.log('Headers risposta:', response.headers);
                
                if (!response.ok) {
                    throw new Error('Errore HTTP: ' + response.status + ' - ' + response.statusText);
                }
                return response.text(); // Prima leggiamo come testo per debug
            })
            .then(data => {
                console.log('Dati ricevuti (raw):', data);
                console.log('Tipo dati:', typeof data);
                console.log('Lunghezza dati:', data.length);
                
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
                    // Mostra il modal di successo
                    showModal('cartConfirmationModal');
                    
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
