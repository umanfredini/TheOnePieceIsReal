// Gestione wishlist per utente con sessionStorage
function getWishlistState() {
    var userId = getCurrentUserId();
    if (!userId) {
        return {};
    }
    var wishlist = sessionStorage.getItem('wishlist_' + userId);
    return wishlist ? JSON.parse(wishlist) : {};
}

function setWishlistState(wishlist) {
    var userId = getCurrentUserId();
    if (!userId) {
        return;
    }
    sessionStorage.setItem('wishlist_' + userId, JSON.stringify(wishlist));
}

// Sistema di batch per ottimizzare le chiamate AJAX
var wishlistBatch = {
    operations: [],
    timeout: null,
    delay: 500, // 500ms di delay per raggruppare operazioni
    
    add: function(productId, action) {
        // Rimuovi operazioni duplicate per lo stesso prodotto
        this.operations = this.operations.filter(op => op.productId !== productId);
        
        // Aggiungi nuova operazione
        this.operations.push({
            productId: productId,
            action: action,
            timestamp: Date.now()
        });
        
        // Programma l'esecuzione batch
        this.scheduleBatch();
    },
    
    scheduleBatch: function() {
        // Cancella timeout precedente
        if (this.timeout) {
            clearTimeout(this.timeout);
        }
        
        // Programma nuovo timeout
        this.timeout = setTimeout(() => {
            this.executeBatch();
        }, this.delay);
    },
    
    executeBatch: function() {
        if (this.operations.length === 0) return;
        
        console.log('Eseguendo batch di', this.operations.length, 'operazioni wishlist');
        
        // Raggruppa operazioni per tipo
        var addOperations = this.operations.filter(op => op.action === 'add');
        var removeOperations = this.operations.filter(op => op.action === 'remove');
        
        // Esegui operazioni in batch
        var promises = [];
        
        if (addOperations.length > 0) {
            promises.push(this.executeBatchOperation('add', addOperations.map(op => op.productId)));
        }
        
        if (removeOperations.length > 0) {
            promises.push(this.executeBatchOperation('remove', removeOperations.map(op => op.productId)));
        }
        
        // Esegui tutte le operazioni in parallelo
        Promise.all(promises).then(() => {
            console.log('Batch wishlist completato');
            this.operations = [];
        }).catch(error => {
            console.error('Errore nel batch wishlist:', error);
            this.operations = [];
        });
    },
    
    executeBatchOperation: function(action, productIds) {
        var csrfToken = '';
        var csrfInput = document.querySelector('input[name="csrfToken"]');
        if (csrfInput) {
            csrfToken = csrfInput.value;
        }
        
        var formData = 'action=' + action + '&productIds=' + productIds.join(',');
        if (csrfToken) {
            formData += '&csrfToken=' + csrfToken;
        }
        
        return fetch(getContextPath() + '/WishlistServlet', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: formData
        }).then(response => response.json());
    }
};

// Funzione ottimizzata per toggle wishlist
function toggleWishlistOptimized(productId) {
    console.log('=== TOGGLE WISHLIST OTTIMIZZATO ===');
    
    // Gestisci eventi
    if (event) {
        event.preventDefault();
        event.stopPropagation();
    }
    
    // Controllo admin
    var isAdmin = typeof isUserAdmin !== 'undefined' ? isUserAdmin : false;
    if (isAdmin) {
        if (typeof showToast !== 'undefined') {
            showToast('Gli amministratori non possono utilizzare la wishlist!', 'error');
        }
        return;
    }
    
    // Stato attuale
    var wishlist = getWishlistState();
    var isInWishlist = wishlist[productId];
    
    // Trova bottone
    var wishlistBtn = document.querySelector('[data-product-id="' + productId + '"] .wishlist-btn');
    
    if (isInWishlist) {
        // Rimuovi - UI immediata
        if (wishlistBtn) wishlistBtn.classList.remove('active');
        delete wishlist[productId];
        setWishlistState(wishlist);
        wishlistBatch.add(productId, 'remove');
        if (typeof showToast !== 'undefined') showToast('Prodotto rimosso dalla wishlist!', 'success');
    } else {
        // Aggiungi - UI immediata
        if (wishlistBtn) wishlistBtn.classList.add('active');
        wishlist[productId] = true;
        setWishlistState(wishlist);
        wishlistBatch.add(productId, 'add');
        if (typeof showToast !== 'undefined') showToast('Prodotto aggiunto alla wishlist!', 'success');
    }
}

// Sostituisci la funzione toggleWishlist con quella ottimizzata
function toggleWishlist(productId) {
    return toggleWishlistOptimized(productId);
}

function getCurrentUserId() {
    // Prova a ottenere l'ID utente da vari metodi
    var userIdElement = document.querySelector('[data-user-id]');
    if (userIdElement) {
        return userIdElement.getAttribute('data-user-id');
    }
    
    // Fallback: cerca in meta tag
    var userIdMeta = document.querySelector('meta[name="user-id"]');
    if (userIdMeta) {
        return userIdMeta.getAttribute('content');
    }
    
    return null;
}

function updateWishlistButton(productId, isInWishlist) {
    // Cerca bottoni in vari modi per compatibilità con homepage e catalogo
    var wishlistBtn = document.querySelector('[onclick="toggleWishlist(\'' + productId + '\')"]') || 
                     document.querySelector('[onclick="toggleWishlist(' + productId + ')"]') ||
                     document.querySelector('[data-product-id="' + productId + '"] .wishlist-btn') ||
                     document.querySelector('[data-product-id="' + productId + '"]') ||
                     document.querySelector('.product-card[data-product-id="' + productId + '"] .wishlist-btn') ||
                     document.querySelector('.products-grid .product-card[data-product-id="' + productId + '"] .wishlist-btn');
    
    console.log('Cercando bottone per productId:', productId);
    console.log('Bottone trovato:', wishlistBtn);
    
    if (wishlistBtn) {
        var icon = wishlistBtn.querySelector('i');
        console.log('Icona trovata:', icon);
        
        // FEEDBACK IMMEDIATO - Standard: cerchio bianco + cuore bianco/rosso
        if (isInWishlist) {
            // STATO: Prodotto IN wishlist - Cuore rosso
            icon.className = 'fas fa-heart';
            wishlistBtn.classList.add('active');
            wishlistBtn.classList.remove('adding');
            
            // Animazione cuore
            wishlistBtn.classList.add('adding');
            setTimeout(() => {
                wishlistBtn.classList.remove('adding');
            }, 600);
        } else {
            // STATO: Prodotto NON in wishlist - Cuore grigio
            icon.className = 'fas fa-heart';
            wishlistBtn.classList.remove('active');
            wishlistBtn.classList.remove('adding');
        }
        
        console.log('Wishlist button updated:', productId, 'isInWishlist:', isInWishlist, 'classes:', wishlistBtn.className);
    } else {
        console.warn('Wishlist button not found for product:', productId);
        console.log('Tutti i bottoni disponibili:', document.querySelectorAll('.wishlist-btn'));
    }
}

// Inizializza stato wishlist al caricamento della pagina
document.addEventListener('DOMContentLoaded', function() {
    // Prima sincronizza con il server se l'utente è loggato
    var userId = getCurrentUserId();
    if (userId) {
        syncWishlistFromServer();
    } else {
        // Se non loggato, inizializza solo con stato locale
        initializeLocalWishlist();
    }
});

function syncWishlistFromServer() {
    // Controlla se abbiamo già sincronizzato di recente (cache di 30 secondi)
    var lastSync = sessionStorage.getItem('wishlist_last_sync');
    var now = Date.now();
    if (lastSync && (now - parseInt(lastSync)) < 30000) {
        console.log('Sincronizzazione wishlist saltata - cache valida');
        initializeLocalWishlist();
        return;
    }
    
    console.log('Sincronizzazione wishlist dal server...');
    
    // Chiama il server per ottenere la wishlist dell'utente
    fetch(window.location.origin + '/TheOnePieceIsReal/WishlistServlet', {
        method: 'GET',
        headers: {
            'X-Requested-With': 'XMLHttpRequest'
        }
    })
    .then(response => response.json())
    .then(data => {
        if (data.success && data.wishlist) {
            // Sincronizza lo stato locale con quello del server
            var serverWishlist = {};
            data.wishlist.forEach(function(product) {
                serverWishlist[product.id] = true;
            });
            setWishlistState(serverWishlist);
            
            // Salva timestamp sincronizzazione
            sessionStorage.setItem('wishlist_last_sync', now.toString());
            
            // Aggiorna l'UI
            initializeLocalWishlist();
        }
    })
    .catch(error => {
        console.error('Errore nella sincronizzazione wishlist:', error);
        // Fallback: usa solo stato locale
        initializeLocalWishlist();
    });
}

function initializeLocalWishlist() {
    // Per utenti non loggati, non inizializzare i bottoni wishlist
    var userId = getCurrentUserId();
    if (!userId) {
        console.log('Utente non loggato - bottoni wishlist non inizializzati');
        return;
    }
    
    var wishlist = getWishlistState();
    Object.keys(wishlist).forEach(function(productId) {
        if (wishlist[productId]) {
            updateWishlistButton(productId, true);
        }
    });
    
    // Inizializza anche i bottoni del carosello se presenti
    initializeCarouselWishlist();
    
    // Inizializza i bottoni della homepage
    initializeHomepageWishlist();
    
    // Inizializza i bottoni del catalogo
    initializeCatalogWishlist();
}

// Funzione per inizializzare i bottoni wishlist del carosello
function initializeCarouselWishlist() {
    // Solo per utenti loggati
    var userId = getCurrentUserId();
    if (!userId) {
        console.log('initializeCarouselWishlist: Utente non loggato, skip');
        return;
    }
    
    var wishlist = getWishlistState();
    var carouselButtons = document.querySelectorAll('.product-actions .wishlist-btn');
    
    carouselButtons.forEach(function(btn) {
        var productId = btn.getAttribute('data-product-id');
        if (productId && wishlist[productId]) {
            // STATO: Prodotto IN wishlist - Cuore rosso
            btn.classList.add('active');
        } else {
            // STATO: Prodotto NON in wishlist - Cuore grigio
            btn.classList.remove('active');
        }
    });
}

// Funzione per inizializzare i bottoni wishlist del catalogo
function initializeCatalogWishlist() {
    // Solo per utenti loggati
    var userId = getCurrentUserId();
    if (!userId) {
        console.log('initializeCatalogWishlist: Utente non loggato, skip');
        return;
    }
    
    var wishlist = getWishlistState();
    var catalogButtons = document.querySelectorAll('.catalog-container .wishlist-btn');
    
    console.log('initializeCatalogWishlist: Inizializzando', catalogButtons.length, 'bottoni wishlist nel catalogo');
    console.log('initializeCatalogWishlist: Stato wishlist per utente', userId, ':', wishlist);
    
    catalogButtons.forEach(function(btn) {
        var productCard = btn.closest('.product-card');
        var productId = productCard ? productCard.getAttribute('data-product-id') : null;
        
        if (productId && wishlist[productId]) {
            // STATO: Prodotto IN wishlist - Cuore rosso
            btn.classList.add('active');
            console.log('Catalogo - Prodotto', productId, 'IN wishlist - cuore rosso');
        } else {
            // STATO: Prodotto NON in wishlist - Cuore grigio
            btn.classList.remove('active');
            console.log('Catalogo - Prodotto', productId, 'NON in wishlist - cuore grigio');
        }
    });
}

// Funzione per inizializzare i bottoni wishlist della homepage
function initializeHomepageWishlist() {
    // Solo per utenti loggati
    var userId = getCurrentUserId();
    if (!userId) {
        console.log('initializeHomepageWishlist: Utente non loggato, skip');
        return;
    }
    
    var wishlist = getWishlistState();
    var homepageButtons = document.querySelectorAll('.products-grid .wishlist-btn');
    
    console.log('initializeHomepageWishlist: Inizializzando', homepageButtons.length, 'bottoni wishlist');
    console.log('initializeHomepageWishlist: Stato wishlist per utente', userId, ':', wishlist);
    
    homepageButtons.forEach(function(btn) {
        var productCard = btn.closest('.product-card');
        var productId = productCard ? productCard.getAttribute('data-product-id') : null;
        
        if (productId && wishlist[productId]) {
            // STATO: Prodotto IN wishlist - Cuore rosso
            btn.classList.add('active');
            console.log('Prodotto', productId, 'IN wishlist - cuore rosso');
        } else {
            // STATO: Prodotto NON in wishlist - Cuore grigio
            btn.classList.remove('active');
            console.log('Prodotto', productId, 'NON in wishlist - cuore grigio');
        }
    });
}

// Funzione per aggiungere un prodotto alla wishlist
function addToWishlist(productId) {
    console.log('=== AGGIUNGI A WISHLIST ===');
    console.log('addToWishlist chiamata con productId:', productId);
    
    // Controllo per admin
    var isAdmin = typeof isUserAdmin !== 'undefined' ? isUserAdmin : false;
    if (isAdmin) {
        if (typeof showToast !== 'undefined') {
            showToast('Gli amministratori non possono utilizzare la wishlist!', 'error');
        } else {
            alert('Gli amministratori non possono utilizzare la wishlist!');
        }
        return;
    }
    
    // Le funzioni wishlist vengono chiamate solo per utenti loggati
    
    // Aggiorna UI immediatamente
    updateWishlistButton(productId, true);
    
    // Ottieni il token CSRF se presente
    var csrfToken = '';
    var csrfInput = document.querySelector('input[name="csrfToken"]');
    if (csrfInput) {
        csrfToken = csrfInput.value;
    }
    
    var formData = 'action=add&productId=' + productId;
    if (csrfToken) {
        formData += '&csrfToken=' + csrfToken;
    }
    
    fetch(getContextPath() + '/WishlistServlet', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-Requested-With': 'XMLHttpRequest'
        },
        body: formData
    })
    .then(function(response) { return response.json(); })
    .then(function(data) {
                 if (data.success) {
                     // Aggiorna stato locale
                     var wishlist = getWishlistState();
                     wishlist[productId] = true;
                     setWishlistState(wishlist);
                     
                     if (typeof showToast !== 'undefined') {
                         showToast('Prodotto aggiunto alla wishlist!', 'success');
                     }
                     
                     // Reinizializza i bottoni della homepage
                     initializeHomepageWishlist();
                     initializeCatalogWishlist();
        } else {
            // Ripristina stato in caso di errore
            updateWishlistButton(productId, false);
            if (typeof showToast !== 'undefined') {
                showToast(data.error || 'Errore durante l\'aggiunta', 'error');
            }
        }
    })
    .catch(function(error) {
        console.error('Errore:', error);
        // Ripristina stato in caso di errore
        updateWishlistButton(productId, false);
        if (typeof showToast !== 'undefined') {
            showToast('Errore di connessione', 'error');
        }
    });
}

// Funzione per rimuovere un prodotto dalla wishlist
function removeFromWishlist(productId) {
    console.log('=== RIMUOVI DA WISHLIST ===');
    console.log('removeFromWishlist chiamata con productId:', productId);
    
    // Controllo per admin
    var isAdmin = typeof isUserAdmin !== 'undefined' ? isUserAdmin : false;
    if (isAdmin) {
        if (typeof showToast !== 'undefined') {
            showToast('Gli amministratori non possono utilizzare la wishlist!', 'error');
        } else {
            alert('Gli amministratori non possono utilizzare la wishlist!');
        }
        return;
    }
    
    // Le funzioni wishlist vengono chiamate solo per utenti loggati
    
    // Aggiorna UI immediatamente
    updateWishlistButton(productId, false);
    
    // Ottieni il token CSRF se presente
    var csrfToken = '';
    var csrfInput = document.querySelector('input[name="csrfToken"]');
    if (csrfInput) {
        csrfToken = csrfInput.value;
    }
    
    var formData = 'action=remove&productId=' + productId;
    if (csrfToken) {
        formData += '&csrfToken=' + csrfToken;
    }
    
    fetch(getContextPath() + '/WishlistServlet', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-Requested-With': 'XMLHttpRequest'
        },
        body: formData
    })
    .then(function(response) { return response.json(); })
    .then(function(data) {
                 if (data.success) {
                     // Aggiorna stato locale
                     var wishlist = getWishlistState();
                     wishlist[productId] = false;
                     setWishlistState(wishlist);
                     
                     if (typeof showToast !== 'undefined') {
                         showToast('Prodotto rimosso dalla wishlist!', 'info');
                     }
                     
                     // Reinizializza i bottoni della homepage
                     initializeHomepageWishlist();
                     initializeCatalogWishlist();
        } else {
            // Ripristina stato in caso di errore
            updateWishlistButton(productId, true);
            if (typeof showToast !== 'undefined') {
                showToast(data.error || 'Errore durante la rimozione', 'error');
            }
        }
    })
    .catch(function(error) {
        console.error('Errore:', error);
        // Ripristina stato in caso di errore
        updateWishlistButton(productId, true);
        if (typeof showToast !== 'undefined') {
            showToast('Errore di connessione', 'error');
        }
    });
}

// Funzione per gestire wishlist - esposta globalmente
function toggleWishlist(productId) {
    console.log('=== DEBUG WISHLIST ===');
    console.log('toggleWishlist chiamata con productId:', productId);
    console.log('Event object:', event);
    
    // Gestisci eventi se presenti
    if (event) {
        event.preventDefault();
        event.stopPropagation();
        console.log('Event preventDefault e stopPropagation chiamati');
    }
    
    // Controllo per admin - gli admin non possono usare la wishlist
    var isAdmin = typeof isUserAdmin !== 'undefined' ? isUserAdmin : false;
    if (isAdmin) {
        if (typeof showToast !== 'undefined') {
            showToast('Gli amministratori non possono utilizzare la wishlist!', 'error');
        } else {
            alert('Gli amministratori non possono utilizzare la wishlist!');
        }
        return;
    }
    
    // La funzione toggleWishlist viene chiamata solo per utenti loggati
    // I bottoni wishlist sono visibili solo per utenti loggati
    
    // Cerca bottoni in vari modi per compatibilità con homepage e catalogo
    var wishlistBtn = document.querySelector('[onclick="toggleWishlist(\'' + productId + '\')"]') || 
                     document.querySelector('[onclick="toggleWishlist(' + productId + ')"]') ||
                     document.querySelector('[data-product-id="' + productId + '"] .wishlist-btn') ||
                     document.querySelector('[data-product-id="' + productId + '"]') ||
                     document.querySelector('.product-card[data-product-id="' + productId + '"] .wishlist-btn') ||
                     document.querySelector('.products-grid .product-card[data-product-id="' + productId + '"] .wishlist-btn');
    var icon = wishlistBtn ? wishlistBtn.querySelector('i') : null;
    
    console.log('Bottone trovato:', wishlistBtn);
    console.log('Icona trovata:', icon);
    console.log('Tutti i bottoni wishlist:', document.querySelectorAll('.wishlist-btn'));
    
    // Ottieni stato attuale
    var wishlist = getWishlistState();
    var currentState = wishlist[productId] || false;
    var newState = !currentState;
    
    // FEEDBACK IMMEDIATO - Aggiorna UI subito
    updateWishlistButton(productId, newState);
    
    // Aggiorna stato locale immediatamente (ottimistico)
    wishlist[productId] = newState;
    setWishlistState(wishlist);
    
    console.log('Stato wishlist aggiornato immediatamente:', productId, 'da', currentState, 'a', newState);
    
    // Ottieni il token CSRF se presente
    var csrfToken = '';
    var csrfInput = document.querySelector('input[name="csrfToken"]');
    if (csrfInput) {
        csrfToken = csrfInput.value;
    }
    
    var formData = 'action=toggle&productId=' + productId;
    if (csrfToken) {
        formData += '&csrfToken=' + csrfToken;
    }
    
    fetch(getContextPath() + '/WishlistServlet', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-Requested-With': 'XMLHttpRequest'
        },
        body: formData
    })
    .then(function(response) { return response.json(); })
    .then(function(data) {
        if (data.success) {
            // Aggiorna stato basato sulla risposta del server
            wishlist[productId] = data.inWishlist;
            setWishlistState(wishlist);
            updateWishlistButton(productId, data.inWishlist);
            
            if (data.inWishlist) {
                if (typeof showToast !== 'undefined') {
                    showToast('Prodotto aggiunto alla wishlist!', 'success');
                } else {
                    // Prodotto aggiunto alla wishlist
                }
            } else {
                if (typeof showToast !== 'undefined') {
                    showToast('Prodotto rimosso dalla wishlist!', 'info');
                } else {
                    // Prodotto rimosso dalla wishlist
                }
            }
            
            // Reinizializza i bottoni della homepage
            initializeHomepageWishlist();
        } else {
            // RIPRISTINA STATO PRECEDENTE in caso di errore
            console.warn('Errore server, ripristino stato precedente:', currentState);
            wishlist[productId] = currentState;
            setWishlistState(wishlist);
            updateWishlistButton(productId, currentState);
            if (typeof showToast !== 'undefined') {
                showToast(data.error || 'Errore durante l\'operazione', 'error');
            } else {
                console.error('Errore durante l\'operazione');
            }
        }
    })
    .catch(function(error) {
        console.error('Errore di connessione:', error);
        // RIPRISTINA STATO PRECEDENTE in caso di errore di rete
        console.warn('Errore rete, ripristino stato precedente:', currentState);
        wishlist[productId] = currentState;
        setWishlistState(wishlist);
        updateWishlistButton(productId, currentState);
        if (typeof showToast !== 'undefined') {
            showToast('Errore di connessione', 'error');
        }
    });
}

// Funzione helper per ottenere il context path
function getContextPath() {
    return window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2));
} 