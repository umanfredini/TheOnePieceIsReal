// Gestione wishlist con sessionStorage
function getWishlistState() {
    var wishlist = sessionStorage.getItem('wishlist');
    return wishlist ? JSON.parse(wishlist) : {};
}

function setWishlistState(wishlist) {
    sessionStorage.setItem('wishlist', JSON.stringify(wishlist));
}

function updateWishlistButton(productId, isInWishlist) {
    // Cerca bottoni sia per onclick che per data-product-id (per il carosello)
    var wishlistBtn = document.querySelector('[onclick="toggleWishlist(' + productId + ')"]') || 
                     document.querySelector('[data-product-id="' + productId + '"]');
    
    if (wishlistBtn) {
        var icon = wishlistBtn.querySelector('i');
        if (isInWishlist) {
            icon.className = 'fas fa-heart';
            wishlistBtn.classList.add('btn-danger');
            wishlistBtn.classList.remove('btn-outline-danger');
            wishlistBtn.classList.add('active');
        } else {
            icon.className = 'far fa-heart';
            wishlistBtn.classList.remove('btn-danger');
            wishlistBtn.classList.add('btn-outline-danger');
            wishlistBtn.classList.remove('active');
        }
    }
}

// Inizializza stato wishlist al caricamento della pagina
document.addEventListener('DOMContentLoaded', function() {
    var wishlist = getWishlistState();
    Object.keys(wishlist).forEach(function(productId) {
        if (wishlist[productId]) {
            updateWishlistButton(productId, true);
        }
    });
    
    // Inizializza anche i bottoni del carosello se presenti
    initializeCarouselWishlist();
});

// Funzione per inizializzare i bottoni wishlist del carosello
function initializeCarouselWishlist() {
    var wishlist = getWishlistState();
    var carouselButtons = document.querySelectorAll('.product-actions .wishlist-btn');
    
    carouselButtons.forEach(function(btn) {
        var productId = btn.getAttribute('data-product-id');
        if (productId && wishlist[productId]) {
            var icon = btn.querySelector('i');
            icon.className = 'fas fa-heart';
            btn.classList.add('btn-danger');
            btn.classList.remove('btn-outline-danger');
            btn.classList.add('active');
        }
    });
}

// Funzione per gestire wishlist - esposta globalmente
function toggleWishlist(productId) {
    // Gestisci eventi se presenti
    if (event) {
        event.preventDefault();
        event.stopPropagation();
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
    
    var isLoggedIn = typeof isUserLoggedIn !== 'undefined' ? isUserLoggedIn : true; // Default true per compatibilità
    if (!isLoggedIn) {
        if (typeof showToast !== 'undefined') {
            showToast('Devi essere loggato per usare la wishlist!', 'error');
        } else {
            alert('Devi essere loggato per usare la wishlist!');
        }
        return;
    }
    
    // Cerca bottoni sia per onclick che per data-product-id (per il carosello)
    var wishlistBtn = document.querySelector('[onclick="toggleWishlist(' + productId + ')"]') || 
                     document.querySelector('[data-product-id="' + productId + '"]');
    var icon = wishlistBtn ? wishlistBtn.querySelector('i') : null;
    
    // Ottieni stato attuale
    var wishlist = getWishlistState();
    var currentState = wishlist[productId] || false;
    
    // Aggiorna stato locale immediatamente (ottimistico)
    wishlist[productId] = !currentState;
    setWishlistState(wishlist);
    
    // Aggiorna UI immediatamente
    updateWishlistButton(productId, wishlist[productId]);
    
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
        } else {
            // Ripristina stato precedente in caso di errore
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
        console.error('Errore:', error);
        // Ripristina stato precedente in caso di errore
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