/**
 * Funzionalità per le Product Cards
 * Gestisce click sui prodotti, aggiunta al carrello e wishlist
 */

// Importa showToast dal modulo toast.js
import { showToast } from './toast.js';

console.log('🛍️ PRODUCT-CARDS.JS CARICATO!');

/**
 * Naviga alla pagina dettagli del prodotto
 * @param {string|number} productId - ID del prodotto
 */
window.goToProductDetail = function(productId) {
    console.log('🔍 Navigazione al dettaglio prodotto:', productId);
    
    if (!productId) {
        console.error('❌ ID prodotto mancante');
        showToast('Errore: ID prodotto non valido', 'error');
        return;
    }
    
    // Costruisce l'URL per il dettaglio prodotto
    const contextPath = window.location.pathname.split('/')[1] || '';
    const productUrl = `/${contextPath}/ProductServlet?action=detail&id=${productId}`;
    
    console.log('🌐 URL prodotto:', productUrl);
    
    // Naviga alla pagina
    window.location.href = productUrl;
}

/**
 * Aggiunge un prodotto al carrello
 * @param {string|number} productId - ID del prodotto
 */
window.addToCart = function(productId) {
    console.log('🛒 Aggiunta al carrello prodotto:', productId);
    
    if (!productId) {
        console.error('❌ ID prodotto mancante');
        showToast('Errore: ID prodotto non valido', 'error');
        return;
    }
    
    // Gli utenti non loggati possono aggiungere al carrello (guest cart)
    console.log('🛒 Aggiunta al carrello - supporto per utenti guest');
    
    // Mostra loading
    const cartBtn = event.target.closest('.cart-btn');
    if (cartBtn) {
        cartBtn.disabled = true;
        cartBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
    }
    
    // Prepara i dati per la richiesta come URL-encoded
    const params = new URLSearchParams();
    params.append('action', 'add');
    params.append('productId', productId);
    params.append('quantity', '1');
    
    // Debug: mostra i dati che stiamo inviando
    console.log('📤 Dati da inviare:');
    for (let [key, value] of params.entries()) {
        console.log(`  ${key}: ${value}`);
    }
    
    // Aggiunge il token CSRF se disponibile (non obbligatorio per guest)
    const csrfToken = getCSRFToken();
    if (csrfToken) {
        params.append('csrfToken', csrfToken);
        console.log('🔐 Token CSRF aggiunto alla richiesta');
    } else {
        console.log('⚠️ Token CSRF non disponibile - richiesta senza token (guest user)');
    }
    
    // Invia la richiesta al CartServlet
    const contextPath = window.location.pathname.split('/')[1] || '';
    const cartUrl = `/${contextPath}/CartServlet`;
    console.log('🌐 URL richiesta:', cartUrl);
    
    fetch(cartUrl, {
        method: 'POST',
        headers: {
            'X-Requested-With': 'XMLHttpRequest',
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: params.toString()
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
        
        return response.text();
    })
    .then(data => {
        console.log('📦 Dati risposta raw:', data);
        console.log('📦 Tipo risposta:', typeof data);
        console.log('📦 Lunghezza risposta:', data.length);
        
        // Ripristina il bottone
        if (cartBtn) {
            cartBtn.disabled = false;
            cartBtn.innerHTML = '<i class="fas fa-shopping-cart"></i>';
        }
        
        // Prova a parsare come JSON se possibile
        let jsonData = null;
        try {
            jsonData = JSON.parse(data);
            console.log('📦 JSON parsato:', jsonData);
        } catch (e) {
            console.log('📦 Non è JSON, testo normale:', data);
        }
        
        // Verifica se la risposta contiene un errore
        if (data.includes('error') || data.includes('Errore') || data.includes('Exception')) {
            console.error('❌ Errore rilevato nella risposta:', data);
            throw new Error('Errore dal server: ' + data);
        }
        
        // Se è JSON e ha success: false
        if (jsonData && jsonData.success === false) {
            console.error('❌ Success false nel JSON:', jsonData);
            throw new Error(jsonData.error || 'Errore dal server');
        }
        
        // Successo
        showToast('Prodotto aggiunto al carrello! 🛒', 'success');
        
        // Aggiorna il contatore del carrello se presente
        updateCartCounter();
        
    })
    .catch(error => {
        console.error('❌ Errore aggiunta al carrello:', error);
        
        // Ripristina il bottone
        if (cartBtn) {
            cartBtn.disabled = false;
            cartBtn.innerHTML = '<i class="fas fa-shopping-cart"></i>';
        }
        
        showToast('Errore nell\'aggiunta al carrello. Riprova.', 'error');
    });
}

/**
 * Aggiunge/rimuove un prodotto dalla wishlist
 * @param {string|number} productId - ID del prodotto
 */
window.toggleWishlist = function(productId) {
    console.log('❤️ Toggle wishlist prodotto:', productId);
    
    if (!productId) {
        console.error('❌ ID prodotto mancante');
        showToast('Errore: ID prodotto non valido', 'error');
        return;
    }
    
    // Verifica se l'utente è loggato
    const isLoggedIn = checkUserLogin();
    if (!isLoggedIn) {
        console.log('👤 Utente non loggato, redirect al login');
        showToast('Devi effettuare il login per gestire la wishlist', 'warning');
        setTimeout(() => {
            const contextPath = window.location.pathname.split('/')[1] || '';
            window.location.href = `/${contextPath}/login`;
        }, 2000);
        return;
    }
    
    const wishlistBtn = event.target.closest('.wishlist-btn');
    const heartIcon = wishlistBtn.querySelector('i');
    
    // Mostra loading
    if (wishlistBtn) {
        wishlistBtn.disabled = true;
        heartIcon.className = 'fas fa-spinner fa-spin';
    }
    
    // Prepara i dati per la richiesta
    const formData = new FormData();
    formData.append('action', 'toggle');
    formData.append('productId', productId);
    
    // Aggiunge il token CSRF se disponibile
    const csrfToken = getCSRFToken();
    if (csrfToken) {
        formData.append('csrfToken', csrfToken);
    }
    
    // Invia la richiesta al WishlistServlet
    const contextPath = window.location.pathname.split('/')[1] || '';
    fetch(`/${contextPath}/WishlistServlet`, {
        method: 'POST',
        headers: {
            'X-Requested-With': 'XMLHttpRequest'
        },
        body: formData
    })
    .then(response => {
        console.log('📡 Risposta wishlist:', response.status);
        return response.text();
    })
    .then(data => {
        console.log('❤️ Dati wishlist:', data);
        
        // Ripristina il bottone
        if (wishlistBtn) {
            wishlistBtn.disabled = false;
        }
        
        // Verifica se la risposta contiene un errore
        if (data.includes('error') || data.includes('Errore')) {
            throw new Error('Errore dal server: ' + data);
        }
        
        // Determina se il prodotto è stato aggiunto o rimosso
        const isAdded = data.includes('aggiunto') || data.includes('added');
        
        if (isAdded) {
            heartIcon.className = 'fas fa-heart';
            heartIcon.style.color = '#ff6b6b';
            showToast('Prodotto aggiunto alla wishlist! ❤️', 'success');
        } else {
            heartIcon.className = 'far fa-heart';
            heartIcon.style.color = '#666';
            showToast('Prodotto rimosso dalla wishlist', 'info');
        }
        
    })
    .catch(error => {
        console.error('❌ Errore wishlist:', error);
        
        // Ripristina il bottone
        if (wishlistBtn) {
            wishlistBtn.disabled = false;
            heartIcon.className = 'far fa-heart';
            heartIcon.style.color = '#666';
        }
        
        showToast('Errore nella gestione della wishlist. Riprova.', 'error');
    });
}

/**
 * Verifica se l'utente è loggato
 * @returns {boolean} True se loggato, false altrimenti
 */
function checkUserLogin() {
    // Controlla se esiste un elemento che indica che l'utente è loggato
    const userElements = document.querySelectorAll('[data-user-logged]');
    const loginElements = document.querySelectorAll('.login-link, #login-btn');
    const logoutElements = document.querySelectorAll('.logout-link, #logout-btn');
    
    // Se ci sono elementi di logout e non di login, l'utente è loggato
    return logoutElements.length > 0 && loginElements.length === 0;
}

/**
 * Ottiene il token CSRF dalla sessione
 * @returns {string|null} Token CSRF o null se non disponibile
 */
function getCSRFToken() {
    // Cerca il token in un input hidden
    const csrfInput = document.querySelector('input[name="csrfToken"]');
    if (csrfInput) {
        return csrfInput.value;
    }
    
    // Cerca il token in un meta tag
    const csrfMeta = document.querySelector('meta[name="csrf-token"]');
    if (csrfMeta) {
        return csrfMeta.getAttribute('content');
    }
    
    console.warn('⚠️ Token CSRF non trovato');
    return null;
}

/**
 * Mostra una notifica all'utente
 * @param {string} message - Messaggio da mostrare
 * @param {string} type - Tipo di notifica (success, error, warning, info)
 */
// Funzione showNotification rimossa - usa showToast da toast.js

/**
 * Aggiorna il contatore del carrello
 */
function updateCartCounter() {
    const cartCounter = document.querySelector('.cart-counter, #cart-counter');
    if (cartCounter) {
        // Incrementa il contatore
        const currentCount = parseInt(cartCounter.textContent) || 0;
        cartCounter.textContent = currentCount + 1;
        
        // Aggiunge animazione
        cartCounter.style.transform = 'scale(1.2)';
        setTimeout(() => {
            cartCounter.style.transform = 'scale(1)';
        }, 200);
    }
}

// Inizializza le funzionalità quando il DOM è pronto
document.addEventListener('DOMContentLoaded', () => {
    console.log('🛍️ Product Cards inizializzate');
    
    // Aggiunge event listeners per migliorare l'accessibilità
    const productCards = document.querySelectorAll('.product-card');
    productCards.forEach(card => {
        // Aggiunge supporto per tasti Enter e Spazio
        card.addEventListener('keydown', (e) => {
            if (e.key === 'Enter' || e.key === ' ') {
                e.preventDefault();
                const productId = card.getAttribute('data-product-id');
                if (productId) {
                    goToProductDetail(productId);
                }
            }
        });
        
        // Aggiunge attributi per accessibilità
        card.setAttribute('tabindex', '0');
        card.setAttribute('role', 'button');
        card.setAttribute('aria-label', 'Visualizza dettagli prodotto');
    });
});
