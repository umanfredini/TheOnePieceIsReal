// WebContent/scripts/cart.js

import { showError, hideError } from './main.js';
import { showToast } from './toast.js';

/**
 * Aggiorna la quantità di un prodotto nel carrello tramite AJAX.
 * Se la nuova quantità è < 1, il prodotto viene rimosso.
 * @param {string} itemId - L'ID del prodotto da aggiornare.
 * @param {number} newQuantity - La nuova quantità del prodotto.
 */
function updateCartItem(itemId, newQuantity) {
    if (newQuantity < 1) {
        removeCartItem(itemId); // Rimuove l'articolo se la quantità è zero o negativa
        return;
    }

    fetch('/TheOnePieceIsReal/CartServlet', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: `action=update&prodottoId=${itemId}&quantita=${newQuantity}`
    })
    .then(response => response.json()) // Parsifica la risposta JSON
    .then(data => {
        if (data.success) {
            updateCartTotals(data.cartTotal);
            showToast('Carrello aggiornato con successo!', 'success');
        } else {
            showToast(data.message || 'Errore nell\'aggiornamento del carrello', 'error');
        }
    })
    .catch(error => {
        console.error('Cart update error:', error);
        showToast('Errore di connessione. Riprova.', 'error');
    });
}

/**
 * Rimuove un prodotto specifico dal carrello tramite AJAX.
 * @param {string} itemId - L'ID del prodotto da rimuovere.
 */
function removeCartItem(itemId) {
    fetch('/TheOnePieceIsReal/CartServlet', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: `action=remove&prodottoId=${itemId}`
    })
    .then(response => response.json()) // Parsifica la risposta JSON
    .then(data => {
        if (data.success) {
            document.getElementById(`cart-item-${itemId}`)?.remove();
            updateCartTotals(data.cartTotal);
            showToast('Prodotto rimosso dal carrello', 'success');
        } else {
            showToast(data.message || 'Errore nella rimozione del prodotto', 'error');
        }
    })
    .catch(error => {
        console.error('Remove item error:', error);
        showToast('Errore di connessione. Riprova.', 'error');
    });
}

/**
 * Svuota completamente il carrello tramite AJAX.
 */
function emptyCart() {
    fetch('/TheOnePieceIsReal/CartServlet', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'action=clear'
    })
    .then(response => response.json()) // Parsifica la risposta JSON
    .then(data => {
        if (data.success) {
            document.querySelectorAll('.cart-item').forEach(item => item.remove());
            updateCartTotals(0);
            showToast('Carrello svuotato con successo', 'success');
        } else {
            showToast(data.message || 'Errore nello svuotamento del carrello', 'error');
        }
    })
    .catch(error => {
        console.error('Empty cart error:', error);
        showToast('Errore di connessione. Riprova.', 'error');
    });
}

/**
 * Aggiorna i totali del carrello (prezzo totale e conteggio articoli) nella UI.
 * @param {number} total - Il nuovo prezzo totale del carrello.
 */
function updateCartTotals(total) {
    document.getElementById('cart-total').textContent = `€${total.toFixed(2)}`;
    // Aggiorna il conteggio degli articoli basandosi sugli elementi visibili nel carrello
    document.getElementById('cart-items-count').textContent = 
        document.querySelectorAll('.cart-item').length;
}

// Inizializzazione event listeners per gli elementi del carrello
document.addEventListener('DOMContentLoaded', () => {
    // Listener per gli input di quantità: aggiorna l'articolo quando la quantità cambia
    document.querySelectorAll('.quantity-input').forEach(input => {
        input.addEventListener('change', e => {
            updateCartItem(e.target.dataset.itemId, parseInt(e.target.value));
        });
    });

    // Listener per i pulsanti "Rimuovi articolo": rimuove l'articolo al click
    document.querySelectorAll('.remove-item-btn').forEach(btn => {
        btn.addEventListener('click', e => {
            removeCartItem(e.target.dataset.itemId);
        });
    });

    // Listener per il pulsante "Svuota carrello"
    document.getElementById('empty-cart-btn')?.addEventListener('click', emptyCart);
});
