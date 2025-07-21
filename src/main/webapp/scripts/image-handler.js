/**
 * Image Handler - Gestione immagini e correzione path
 * Corregge automaticamente i path delle immagini e gestisce il fallback
 */

class ImageHandler {
    constructor() {
        this.init();
    }

    init() {
        // Correggi tutti i path delle immagini al caricamento
        this.fixImagePaths();
        
        // Gestisci errori di caricamento immagini
        this.handleImageErrors();
        
        // Aggiungi loading state
        this.addLoadingStates();
    }

    /**
     * Corregge i path delle immagini che non usano il path corretto
     */
    fixImagePaths() {
        const images = document.querySelectorAll('img[src*="prodotti/"]');
        
        images.forEach(img => {
            const src = img.getAttribute('src');
            
            // Se l'immagine non ha il path completo, aggiungilo
            if (src && !src.includes('styles/images/prodotti/')) {
                const fileName = src.split('/').pop(); // Prendi solo il nome del file
                const correctPath = `${window.location.origin}${window.location.pathname.replace('/index.jsp', '')}/styles/images/prodotti/${fileName}`;
                img.setAttribute('src', correctPath);
            }
        });
    }

    /**
     * Gestisce gli errori di caricamento delle immagini
     */
    handleImageErrors() {
        const images = document.querySelectorAll('img');
        
        images.forEach(img => {
            img.addEventListener('error', (e) => {
                const target = e.target;
                
                // Aggiungi classe per fallback
                target.classList.add('image-error');
                
                // Se è un'immagine prodotto, prova a correggere il path
                if (target.src.includes('prodotti/')) {
                    this.tryFixProductImage(target);
                }
                
                // Mostra messaggio di errore
                this.showImageError(target);
            });
            
            img.addEventListener('load', (e) => {
                const target = e.target;
                target.classList.remove('image-error', 'loading');
                target.classList.add('image-loaded');
            });
        });
    }

    /**
     * Prova a correggere il path di un'immagine prodotto
     */
    tryFixProductImage(img) {
        const currentSrc = img.getAttribute('src');
        const fileName = currentSrc.split('/').pop();
        
        // Prova diversi path possibili
        const possiblePaths = [
            `${window.location.origin}${window.location.pathname.replace('/index.jsp', '')}/styles/images/prodotti/${fileName}`,
            `${window.location.origin}/TheOnePieceIsReal/styles/images/prodotti/${fileName}`,
            `${window.location.origin}/styles/images/prodotti/${fileName}`,
            `styles/images/prodotti/${fileName}`
        ];
        
        // Prova il primo path alternativo
        if (possiblePaths.length > 1) {
            img.setAttribute('src', possiblePaths[1]);
        }
    }

    /**
     * Mostra un messaggio di errore per immagini che non si caricano
     */
    showImageError(img) {
        // Crea un elemento per il messaggio di errore
        const errorDiv = document.createElement('div');
        errorDiv.className = 'image-error-message';
        errorDiv.innerHTML = `
            <div class="error-content">
                <i class="fas fa-exclamation-triangle"></i>
                <span>Immagine non disponibile</span>
            </div>
        `;
        
        // Inserisci il messaggio dopo l'immagine
        img.parentNode.insertBefore(errorDiv, img.nextSibling);
        
        // Nascondi l'immagine
        img.style.display = 'none';
    }

    /**
     * Aggiunge stati di caricamento alle immagini
     */
    addLoadingStates() {
        const images = document.querySelectorAll('img');
        
        images.forEach(img => {
            // Aggiungi classe loading inizialmente
            img.classList.add('loading');
            
            // Rimuovi loading quando l'immagine si carica
            img.addEventListener('load', () => {
                img.classList.remove('loading');
            });
        });
    }

    /**
     * Precarica le immagini per migliorare le performance
     */
    preloadImages(imageUrls) {
        imageUrls.forEach(url => {
            const img = new Image();
            img.src = url;
        });
    }

    /**
     * Lazy loading per le immagini
     */
    setupLazyLoading() {
        const images = document.querySelectorAll('img[data-src]');
        
        const imageObserver = new IntersectionObserver((entries, observer) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const img = entry.target;
                    img.src = img.dataset.src;
                    img.removeAttribute('data-src');
                    observer.unobserve(img);
                }
            });
        });
        
        images.forEach(img => imageObserver.observe(img));
    }
}

// Inizializza l'Image Handler quando il DOM è pronto
document.addEventListener('DOMContentLoaded', () => {
    window.imageHandler = new ImageHandler();
});

// Esporta per uso modulare
if (typeof module !== 'undefined' && module.exports) {
    module.exports = ImageHandler;
} 