// WebContent/scripts/products.js

/**
 * Applica filtri al catalogo prodotti in base a categoria, personaggio e prezzo
 */
function applyProductFilters() {
    const selectedCategory = document.getElementById('category-filter').value;
    const selectedCharacter = document.getElementById('character-filter').value;
    // Converte i valori min/max in numeri, usando 0 e Number.MAX_SAFE_INTEGER come fallback
    const minPrice = parseFloat(document.getElementById('price-min').value) || 0;
    const maxPrice = parseFloat(document.getElementById('price-max').value) || Number.MAX_SAFE_INTEGER;

    document.querySelectorAll('.product-card').forEach(card => { // Utilizzo di una arrow function per la concisione
        const category = card.dataset.category;
        const character = card.dataset.character;
        const price = parseFloat(card.dataset.price);
        
        // Controlla la corrispondenza dei filtri
        const categoryMatch = selectedCategory === 'all' || category === selectedCategory;
        const characterMatch = selectedCharacter === 'all' || character === selectedCharacter;
        const priceMatch = price >= minPrice && price <= maxPrice;
        
        // Mostra o nasconde la card in base ai filtri
        card.style.display = categoryMatch && characterMatch && priceMatch 
            ? 'block' 
            : 'none';
    });
}

// Funzione rimossa: initVivreCardHover() - non più necessaria dopo l'uniformazione delle product card

// Inizializzazione: aggiunge event listeners al caricamento del DOM
document.addEventListener('DOMContentLoaded', () => {
    // Listener per il pulsante "Applica filtri"
    document.getElementById('apply-filters')?.addEventListener('click', applyProductFilters);
    
    // Inizializza l'effetto hover per tutte le Vivre Card
    initVivreCardHover(); // Chiamata diretta della funzione di inizializzazione
});
