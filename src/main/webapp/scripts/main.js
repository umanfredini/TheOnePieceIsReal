// WebContent/scripts/main.js

/**
 * Inizializza gli event listeners globali
 */
document.addEventListener('DOMContentLoaded', () => {
    // Gestione logout
    const logoutBtn = document.getElementById('logout-btn');
    if(logoutBtn) {
        logoutBtn.addEventListener('click', handleLogout);
    }
    
    // Inizializza player musica
    initMusicPlayer();
    
    // Inizializza menu mobile
    initMobileMenu();
    
    // Inizializza funzionalità mobile
    initMobileFeatures();
    
    // Inizializza gestione immagini
    if (window.imageHandler) {
        window.imageHandler.init();
    }
});

/**
 * Gestione logout con AJAX
 */
function handleLogout() {
    fetch('/TheOnePieceIsReal/LogoutServlet', {
        method: 'POST',
        credentials: 'same-origin'
    })
    .then(response => {
        if(response.redirected) {
            window.location.href = response.url;
        }
    })
    .catch(error => console.error('Logout error:', error));
}

/**
 * Mostra/nascondi messaggi di errore
 */
export function showError(inputElement, message) {
    const errorElement = inputElement.nextElementSibling;
    if(errorElement && errorElement.classList.contains('error-message')) {
        errorElement.textContent = message;
        errorElement.style.display = 'block';
        inputElement.classList.add('input-error');
    }
}

export function hideError(inputElement) {
    const errorElement = inputElement.nextElementSibling;
    if(errorElement && errorElement.classList.contains('error-message')) {
        errorElement.style.display = 'none';
        inputElement.classList.remove('input-error');
    }
}

/**
 * Inizializza il menu mobile
 */
function initMobileMenu() {
    const mobileMenuToggle = document.getElementById('mobileMenuToggle');
    const mobileMenu = document.getElementById('mobileMenu');
    
    if (mobileMenuToggle && mobileMenu) {
        // Gestione click sul toggle
        mobileMenuToggle.addEventListener('click', () => {
            toggleMobileMenu(mobileMenuToggle, mobileMenu);
        });
        
        // Chiudi menu quando si clicca su un link
        const mobileMenuItems = mobileMenu.querySelectorAll('.mobile-menu-item');
        mobileMenuItems.forEach(item => {
            item.addEventListener('click', () => {
                closeMobileMenu(mobileMenuToggle, mobileMenu);
            });
        });
        
        // Chiudi menu quando si clicca fuori
        mobileMenu.addEventListener('click', (e) => {
            if (e.target === mobileMenu) {
                closeMobileMenu(mobileMenuToggle, mobileMenu);
            }
        });
        
        // Chiudi menu con tasto ESC
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape' && mobileMenu.classList.contains('active')) {
                closeMobileMenu(mobileMenuToggle, mobileMenu);
            }
        });
        
        // Gestione resize della finestra
        window.addEventListener('resize', () => {
            if (window.innerWidth > 992 && mobileMenu.classList.contains('active')) {
                closeMobileMenu(mobileMenuToggle, mobileMenu);
            }
        });
        
        // Prevenzione scroll quando menu è aperto
        mobileMenu.addEventListener('touchmove', (e) => {
            if (mobileMenu.classList.contains('active')) {
                e.preventDefault();
            }
        }, { passive: false });
    }
}

/**
 * Apre/chiude il menu mobile
 */
function toggleMobileMenu(toggle, menu) {
    const isActive = menu.classList.contains('active');
    
    if (isActive) {
        closeMobileMenu(toggle, menu);
    } else {
        openMobileMenu(toggle, menu);
    }
}

/**
 * Apre il menu mobile
 */
function openMobileMenu(toggle, menu) {
    toggle.classList.add('active');
    menu.classList.add('active');
    document.body.classList.add('menu-open');
    
    // Focus sul primo elemento del menu per accessibilità
    const firstItem = menu.querySelector('.mobile-menu-item');
    if (firstItem) {
        setTimeout(() => firstItem.focus(), 300);
    }
    
    // Annuncia l'apertura per screen reader
    announceToScreenReader('Menu mobile aperto');
}

/**
 * Chiude il menu mobile
 */
function closeMobileMenu(toggle, menu) {
    toggle.classList.remove('active');
    menu.classList.remove('active');
    document.body.classList.remove('menu-open');
    
    // Restituisce il focus al toggle
    toggle.focus();
    
    // Annuncia la chiusura per screen reader
    announceToScreenReader('Menu mobile chiuso');
}

/**
 * Annuncia messaggi per screen reader
 */
function announceToScreenReader(message) {
    const announcement = document.createElement('div');
    announcement.setAttribute('aria-live', 'polite');
    announcement.setAttribute('aria-atomic', 'true');
    announcement.style.position = 'absolute';
    announcement.style.left = '-10000px';
    announcement.style.width = '1px';
    announcement.style.height = '1px';
    announcement.style.overflow = 'hidden';
    announcement.textContent = message;
    
    document.body.appendChild(announcement);
    
    setTimeout(() => {
        document.body.removeChild(announcement);
    }, 1000);
}

/**
 * Controlla se il dispositivo è mobile
 */
function isMobileDevice() {
    return window.innerWidth <= 992 || 
           /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
}

/**
 * Inizializza funzionalità specifiche per mobile
 */
function initMobileFeatures() {
    if (isMobileDevice()) {
        // Aggiungi classe per stili specifici mobile
        document.body.classList.add('mobile-device');
        
        // Gestione touch per elementi interattivi
        const touchElements = document.querySelectorAll('.mobile-menu-item, .btn, .card');
        touchElements.forEach(element => {
            element.addEventListener('touchstart', () => {
                element.style.transform = 'scale(0.98)';
            });
            
            element.addEventListener('touchend', () => {
                element.style.transform = '';
            });
        });
    }
}