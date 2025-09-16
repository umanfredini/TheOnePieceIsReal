<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- ID utente per gestione wishlist per-utente -->
<c:if test="${not empty sessionScope.utente}">
    <meta name="user-id" content="${sessionScope.utente.id}">
</c:if>
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
            // In caso di errore, lascia featuredProducts vuoto
            request.setAttribute("featuredProducts", null);
        }
    }
%>

<jsp:include page="jsp/header.jsp" />

<!-- Flash Messages -->
<jsp:include page="jsp/flash-message.jsp" />

<!-- Token CSRF per le operazioni AJAX -->
<input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />

<!-- Menu hamburger rimosso - usa quello di header.jsp -->

<script>
    // Funzioni semplificate per i prodotti
    
    // Controllo wishlist - usa la funzione completa dal wishlist-manager.js
    // La funzione toggleWishlist è definita in wishlist-manager.js
    
    // Controllo carrello
    function addToCart(productId) {
        // Qui puoi aggiungere la logica AJAX per aggiungere al carrello
        console.log('Aggiungi al carrello prodotto:', productId);
    }
    
</script>

<!-- Menu mobile rimosso - usa quello di header.jsp -->

<!-- Layout principale -->
<div class="main-container">
    <!-- Sidebar di ricerca -->
    <aside class="search-sidebar">
        <h3>Ricerca Prodotti</h3>
        <form class="search-form" action="${pageContext.request.contextPath}/catalog" method="get" id="productSearchForm">
            <!-- Ricerca per tipologia -->
            <div class="form-group">
                <label for="category">Tipologia Prodotto</label>
                <select id="category" name="category" class="form-select" required>
                    <option value="">Tutte le categorie</option>
                    <option value="Figure">🧸 Figure</option>
                    <option value="Abbigliamento">👕 Abbigliamento</option>
                    <option value="Cosplay">🎭 Cosplay</option>
                    <option value="Poster">🖼️ Poster</option>
                    <option value="Quadro">🎨 Quadro</option>
                    <option value="Pelouche">🧸 Pelouche</option>
                    <option value="Navi">🚢 Navi</option>
                    <option value="Gadget">⚡ Gadget</option>
                </select>
            </div>

            <!-- Ricerca per personaggio -->
            <div class="form-group character-menu">
                <label for="character">Personaggio</label>
                <select id="character" name="personaggio" class="form-select">
                    <option value="">Tutti i personaggi</option>
                    
                    <!-- Cappello di Paglia -->
                    <optgroup label="🍃 Cappello di Paglia">
                        <option value="Luffy">🦸 Monkey D. Luffy</option>
                        <option value="Zoro">⚔️ Roronoa Zoro</option>
                        <option value="Nami">🧭 Nami</option>
                        <option value="Usopp">🏹 Usopp</option>
                        <option value="Sanji">👨‍🍳 Vinsmoke Sanji</option>
                        <option value="Chopper">🦌 Tony Tony Chopper</option>
                        <option value="Robin">📚 Nico Robin</option>
                        <option value="Franky">🤖 Franky</option>
                        <option value="Brook">💀 Brook</option>
                        <option value="Jinbei">🐟 Jinbei</option>
                    </optgroup>
                    
                    <!-- Imperatori -->
                    <optgroup label="👑 Imperatori">
                        <option value="Shanks">🍺 Shanks il Rosso</option>
                        <option value="Kaido">🐉 Kaido delle Cento Bestie</option>
                        <option value="Barbabianca">⚡ Barbabianca</option>
                        <option value="Barbanera">🌑 Marshall D. Teach</option>
                    </optgroup>
                    
                    <!-- Altri -->
                    <optgroup label="⚔️ Altri">
                        <option value="Law">🏥 Trafalgar D. Water Law</option>
                        <option value="Kidd">🧲 Eustass Kid</option>
                        <option value="Ace">🔥 Portgas D. Ace</option>
                        <option value="Sabo">💨 Sabo</option>
                        <option value="Roger">👑 Gol D. Roger</option>
                    </optgroup>
                </select>
            </div>

            <button type="submit" class="search-btn" id="searchButton">
                <i class="fas fa-search"></i> Cerca
            </button>
        </form>
        
        <!-- Indicatore di ricerca -->
        <div class="search-status" id="searchStatus" style="display: none;">
            <i class="fas fa-spinner fa-spin"></i>
            <span>Ricerca in corso...</span>
        </div>
    </aside>

    <!-- Contenuto principale -->
    <main class="main-content">
        <!-- Prodotti in evidenza -->
        <section class="featured-products">
            <h2 class="gradient-text">🌟 Prodotti in Evidenza</h2>
            
            <div class="products-grid-container">
                <div class="products-grid" id="debug-products-grid">
                <!-- Controllo se ci sono prodotti -->
                <c:choose>
                    <c:when test="${not empty featuredProducts}">
                        <!-- Mostra solo i primi 3 prodotti -->
                        <c:forEach var="product" items="${featuredProducts}" varStatus="status" begin="0" end="2">
                            <div class="product-card" data-product-id="${product.id}" data-category="${product.category}">
                                <!-- Click sul prodotto per andare al dettaglio -->
                                <div class="product-click-area" onclick="goToProductDetail('${product.id}')">
                                    <div class="product-image-container">
                                        <img src="${pageContext.request.contextPath}/styles/images/prodotti/${product.imageUrl}" 
                                             alt="${product.name}" class="product-image">
                                    </div>
                                    
                                    <div class="product-info">
                                        <h3 class="product-name">${product.name}</h3>
                                        <div class="product-price">€${product.price}</div>
                                    </div>
                                </div>
                                
                                <!-- Bottoni azioni (non propagano il click) -->
                                <c:if test="${not empty sessionScope.utente}">
                                    <div class="product-actions" onclick="event.stopPropagation()">
                                        <button class="wishlist-btn" onclick="toggleWishlist('${product.id}')" 
                                                data-product-id="${product.id}">
                                            <i class="fas fa-heart"></i>
                                        </button>
                                    </div>
                                </c:if>
                                
                                <div class="product-actions-bottom" onclick="event.stopPropagation()">
                                    <button class="cart-btn" onclick="addToCart('${product.id}')">
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
            </div>
        </section>
    </main>
</div>

<!-- Footer -->
<footer class="main-footer">
    <div class="footer-content">
        <div class="footer-section">
            <h4>🏴‍☠️ The One Piece Is Real</h4>
            <p>Il tuo negozio ufficiale di merchandising One Piece</p>
        </div>
        <div class="footer-section">
            <h4>📞 Contatti</h4>
            <p>Email: info@onepieceisreal.it</p>
            <p>Tel: +39 123 456 7890</p>
        </div>
        <div class="footer-section">
            <h4>🚢 Spedizioni</h4>
            <p>Consegna in tutta Italia</p>
            <a href="${pageContext.request.contextPath}/TrackingServlet" class="tracking-link">
                <i class="fas fa-ship"></i> Traccia Ordine
            </a>
        </div>
    </div>
    
</footer>

<!-- Stili per il carosello funzionale -->
<style>

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
</style>

<!-- Scripts -->
<script src="${pageContext.request.contextPath}/scripts/main.js"></script>
<script src="${pageContext.request.contextPath}/scripts/cart.js"></script>
<script src="${pageContext.request.contextPath}/scripts/wishlist-manager.js"></script>
<script>
    // Test se wishlist-manager.js è caricato
    console.log('=== TEST WISHLIST MANAGER ===');
    console.log('toggleWishlist function exists:', typeof toggleWishlist);
    console.log('window.backgroundMusicPlayer exists:', typeof window.backgroundMusicPlayer);
    
    // Test di base
    console.log('=== TEST BASE ===');
    console.log('Document ready state:', document.readyState);
    console.log('Window loaded:', window.loaded);
    
    // Test semplice
    function testFunction() {
        console.log('TEST FUNCTION CHIAMATA!');
        alert('TEST FUNCTION FUNZIONA!');
    }
    
    // Test dopo caricamento
    window.addEventListener('load', function() {
        console.log('=== WINDOW LOADED ===');
        console.log('Tutti i bottoni nella pagina:', document.querySelectorAll('button').length);
        
        // DEBUG: Analisi CSS applicato alla griglia prodotti
        console.log('=== DEBUG CSS GRIGLIA PRODOTTI ===');
        const productsGrid = document.getElementById('debug-products-grid');
        if (productsGrid) {
            const computedStyle = window.getComputedStyle(productsGrid);
            console.log('Elemento trovato:', productsGrid);
            console.log('Display:', computedStyle.display);
            console.log('Grid-template-columns:', computedStyle.gridTemplateColumns);
            console.log('Gap:', computedStyle.gap);
            console.log('Border:', computedStyle.border);
            console.log('Background:', computedStyle.background);
            console.log('Max-width:', computedStyle.maxWidth);
            console.log('Padding:', computedStyle.padding);
            console.log('Margin:', computedStyle.margin);
        } else {
            console.log('ERRORE: Elemento products-grid non trovato!');
        }
    });
    
    // Cattura errori JavaScript
    window.addEventListener('error', function(e) {
        console.error('=== ERRORE JAVASCRIPT ===');
        console.error('Errore:', e.error);
        console.error('Messaggio:', e.message);
        console.error('File:', e.filename);
        console.error('Linea:', e.lineno);
    });
</script>

<script>
    // Caricamento semplice delle immagini
    document.addEventListener('DOMContentLoaded', function() {
        const productImages = document.querySelectorAll('.products-grid .product-image');
        
        // Preload semplice delle immagini
        productImages.forEach((img, index) => {
            if (img.complete && img.naturalHeight !== 0) {
                img.classList.remove('loading');
            } else {
                img.classList.add('loading');
                img.onload = () => {
                    img.classList.remove('loading');
                };
            }
        });
    });
    
    // Funzioni per i prodotti
    
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
    
        
        // Configurazione per il file wishlist-manager.js
        var isUserAdmin = <c:choose><c:when test="${sessionScope.isAdmin != null}">true</c:when><c:otherwise>false</c:otherwise></c:choose>;
        
        // DEBUG: Test bottoni wishlist
        console.log('=== DEBUG BOTTONI WISHLIST ===');
        console.log('DOMContentLoaded eseguito!');
        console.log('isUserAdmin:', isUserAdmin);
        
        // DEBUG: Analisi completa delle product card
        setTimeout(() => {
            console.log('=== ANALISI COMPLETA PRODUCT CARD ===');
            
            // 1. Analizza tutte le product card
            const productCards = document.querySelectorAll('.product-card');
            console.log('Product cards trovate:', productCards.length);
            
            productCards.forEach((card, index) => {
                const productId = card.getAttribute('data-product-id');
                console.log(`\n--- PRODUCT CARD ${index + 1} (ID: ${productId}) ---`);
                
                // 2. Analizza bottoni wishlist
                const wishlistBtn = card.querySelector('.wishlist-btn');
                if (wishlistBtn) {
                    console.log('Bottone wishlist trovato:', wishlistBtn);
                    console.log('- Classi:', wishlistBtn.className);
                    console.log('- Icona:', wishlistBtn.querySelector('i').className);
                    console.log('- Colore icona:', window.getComputedStyle(wishlistBtn.querySelector('i')).color);
                } else {
                    console.log('Nessun bottone wishlist trovato');
                }
                
                // 3. Analizza bottoni carrello
                const cartBtn = card.querySelector('.cart-btn');
                if (cartBtn) {
                    console.log('Bottone carrello trovato:', cartBtn);
                    console.log('- Classi:', cartBtn.className);
                    console.log('- Icona:', cartBtn.querySelector('i').className);
                    console.log('- Colore icona:', window.getComputedStyle(cartBtn.querySelector('i')).color);
                    console.log('- Content CSS:', window.getComputedStyle(cartBtn.querySelector('i'), '::before').content);
                    console.log('- HTML interno:', cartBtn.innerHTML);
                } else {
                    console.log('Nessun bottone carrello trovato');
                }
                
                // 4. Analizza stato wishlist
                if (typeof getWishlistState === 'function') {
                    const wishlistState = getWishlistState();
                    console.log('- Stato wishlist per questo prodotto:', wishlistState[productId]);
                }
            });
            
            // 5. Analizza tutti i bottoni nella pagina
            console.log('\n=== TUTTI I BOTTONI NELLA PAGINA ===');
            const allButtons = document.querySelectorAll('button');
            allButtons.forEach((btn, index) => {
                console.log(`Bottone ${index + 1}:`, {
                    classes: btn.className,
                    onclick: btn.getAttribute('onclick'),
                    icon: btn.querySelector('i')?.className
                });
            });
        }, 2000);
        
        // Test semplice
        setTimeout(() => {
            console.log('Test dopo 1 secondo...');
            const wishlistButtons = document.querySelectorAll('.wishlist-btn');
            console.log('Bottoni wishlist trovati:', wishlistButtons.length);
            
            if (wishlistButtons.length === 0) {
                console.log('NESSUN BOTTONE WISHLIST TROVATO!');
                console.log('Tutti i bottoni:', document.querySelectorAll('button'));
                console.log('Tutti gli elementi con classe wishlist:', document.querySelectorAll('[class*="wishlist"]'));
            } else {
                wishlistButtons.forEach((btn, index) => {
                    console.log(`Bottone ${index}:`, btn);
                    console.log(`- onclick:`, btn.getAttribute('onclick'));
                    console.log(`- data-product-id:`, btn.getAttribute('data-product-id'));
                    console.log(`- classList:`, btn.classList.toString());
                    
                    // Aggiungi listener di test
                    btn.addEventListener('click', function(e) {
                        console.log('CLICK DETECTED su bottone wishlist!', e);
                        console.log('Product ID dal data attribute:', this.getAttribute('data-product-id'));
                        alert('CLICK FUNZIONA! Product ID: ' + this.getAttribute('data-product-id'));
                    });
                });
            }
        }, 1000);
    });
    
    // Miglioramenti per la ricerca prodotti
    document.addEventListener('DOMContentLoaded', function() {
        const searchForm = document.getElementById('productSearchForm');
        const searchButton = document.getElementById('searchButton');
        const searchStatus = document.getElementById('searchStatus');
        const categorySelect = document.getElementById('category');
        const characterSelect = document.getElementById('character');
        
        // Animazione del bottone di ricerca
        if (searchForm) {
            searchForm.addEventListener('submit', function(e) {
                // Mostra indicatore di caricamento
                searchButton.classList.add('loading');
                searchStatus.style.display = 'flex';
                
                // Simula un piccolo delay per l'effetto visivo
                setTimeout(() => {
                    // Il form si invierà normalmente
                }, 300);
            });
        }
        
        // Effetti hover per i select
        const formSelects = document.querySelectorAll('.form-select');
        formSelects.forEach(select => {
            select.addEventListener('focus', function() {
                this.parentElement.classList.add('focused');
            });
            
            select.addEventListener('blur', function() {
                this.parentElement.classList.remove('focused');
            });
            
            // Animazione quando cambia valore
            select.addEventListener('change', function() {
                if (this.value) {
                    this.style.borderColor = '#28a745';
                    this.style.boxShadow = '0 0 0 3px rgba(40, 167, 69, 0.1)';
                    
                    // Reset dopo 2 secondi
                    setTimeout(() => {
                        this.style.borderColor = '';
                        this.style.boxShadow = '';
                    }, 2000);
                }
            });
        });
        
        // Validazione real-time
        if (categorySelect && characterSelect) {
            function validateForm() {
                const hasCategory = categorySelect.value !== '';
                const hasCharacter = characterSelect.value !== '';
                
                if (hasCategory || hasCharacter) {
                    searchButton.style.background = 'linear-gradient(135deg, #28a745, #20c997)';
                    searchButton.style.boxShadow = '0 4px 15px rgba(40, 167, 69, 0.3)';
                } else {
                    searchButton.style.background = 'linear-gradient(135deg, #ff6b6b, #ff8e8e)';
                    searchButton.style.boxShadow = '0 4px 15px rgba(255, 107, 107, 0.3)';
                }
            }
            
            categorySelect.addEventListener('change', validateForm);
            characterSelect.addEventListener('change', validateForm);
        }
        
        // Effetti di typing per i select
        formSelects.forEach(select => {
            select.addEventListener('keydown', function(e) {
                if (e.key === 'Enter') {
                    this.blur();
                    searchForm.submit();
                }
            });
        });
    });
</script>

<!-- Stili aggiuntivi per la ricerca -->
<style>
.search-status {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 0.5rem;
    margin-top: 1rem;
    padding: 0.75rem;
    background: rgba(255, 215, 0, 0.1);
    border: 1px solid rgba(255, 215, 0, 0.3);
    border-radius: 8px;
    color: #ff6b6b;
    font-weight: 600;
    animation: pulse 1.5s ease-in-out infinite;
}

@keyframes pulse {
    0%, 100% { opacity: 1; }
    50% { opacity: 0.7; }
}

.form-group.focused label::before {
    animation: bounce 0.6s ease;
}

@keyframes bounce {
    0%, 20%, 50%, 80%, 100% { transform: translateY(-50%) scale(1); }
    40% { transform: translateY(-50%) scale(1.2); }
    60% { transform: translateY(-50%) scale(1.1); }
}

/* Effetti per i personaggi famosi - COLORI LEGGIBILI */
.character-menu .form-select option[value="Luffy"] {
    background: #ffffff !important;
    color: #1a1a2e !important;
    font-weight: bold;
    border: 1px solid #ffd700;
}

.character-menu .form-select option[value="Shanks"] {
    background: #ffffff !important;
    color: #dc3545 !important;
    font-weight: bold;
    border: 1px solid #dc3545;
}

.character-menu .form-select option[value="Kaido"] {
    background: #ffffff !important;
    color: #6f42c1 !important;
    font-weight: bold;
    border: 1px solid #6f42c1;
}

/* Assicura che tutti i personaggi siano leggibili */
.character-menu .form-select option {
    background: #ffffff !important;
    color: #1a1a2e !important;
    padding: 8px 12px;
    font-weight: 500;
}

.character-menu .form-select optgroup {
    background: #f8f9fa !important;
    color: #ff6b6b !important;
    font-weight: bold;
    padding: 10px;
}

/* Hover effects per i personaggi */
.character-menu .form-select option:hover {
    background: #e9ecef !important;
    color: #1a1a2e !important;
}
</style>

<!-- Stili per il pulsante Traccia Ordine in homepage -->
<style>
/* Stile per il link tracking nel footer - BOTTONE GRADEVOLE CON BARCA */
.tracking-link {
    display: inline-block;
    margin-top: 15px;
    padding: 15px 25px;
    background: linear-gradient(135deg, #ffd700, #ffed4e);
    color: #000000;
    text-decoration: none;
    border-radius: 25px;
    font-weight: 700;
    font-size: 1.1rem;
    text-transform: uppercase;
    letter-spacing: 1px;
    transition: all 0.3s ease;
    box-shadow: 0 6px 20px rgba(255, 215, 0, 0.5);
    border: 3px solid #000000;
    position: relative;
    overflow: hidden;
    animation: subtle-glow 2s ease-in-out infinite;
    text-shadow: 1px 1px 3px rgba(0, 0, 0, 0.4);
    font-family: 'Arial', sans-serif;
    min-width: 220px;
    text-align: center;
}

.tracking-link::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
    transition: left 0.6s;
}

.tracking-link:hover::before {
    left: 100%;
}

.tracking-link:hover {
    background: linear-gradient(135deg, #ffff00, #ffd700);
    transform: translateY(-2px) scale(1.02);
    box-shadow: 0 8px 25px rgba(255, 215, 0, 0.7);
    color: #000000;
    text-decoration: none;
    border-color: #ffff00;
}

.tracking-link:active {
    transform: translateY(-1px) scale(1.01);
}

.tracking-link i {
    margin-right: 8px;
    font-size: 1.2rem;
    filter: drop-shadow(1px 1px 2px rgba(0, 0, 0, 0.4));
    color: #000000;
}

@keyframes subtle-glow {
    0%, 100% {
        box-shadow: 0 6px 20px rgba(255, 215, 0, 0.5);
        transform: scale(1);
        border-color: #000000;
    }
    50% {
        box-shadow: 0 8px 25px rgba(255, 215, 0, 0.7);
        transform: scale(1.01);
        border-color: #ffff00;
    }
}
</style>

</body>
</html> 