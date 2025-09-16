// WebContent/scripts/main.js

console.log('🚀 MAIN.JS CARICATO!');

/**
 * Inizializza gli event listeners globali
 */
document.addEventListener('DOMContentLoaded', () => {
    console.log('📄 DOM CONTENT LOADED - Inizializzazione...');
    // Gestione logout
    const logoutBtn = document.getElementById('logout-btn');
    if(logoutBtn) {
        logoutBtn.addEventListener('click', handleLogout);
    }
    
    // Inizializza player musica
    // initMusicPlayer(); // Rimosso sistema musicale complesso
    
    // Inizializza menu mobile
    console.log('🔄 Inizializzando menu mobile...');
    initMobileMenu();
    console.log('✅ Menu mobile inizializzazione completata');
    
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
    console.log('🔧 Inizializzazione menu mobile...');
    const mobileMenuToggle = document.getElementById('mobileMenuToggle');
    const mobileMenu = document.getElementById('mobileMenu');
    
    console.log('📱 Elementi trovati:', {
        toggle: mobileMenuToggle,
        menu: mobileMenu,
        toggleExists: !!mobileMenuToggle,
        menuExists: !!mobileMenu
    });
    
    if (mobileMenuToggle && mobileMenu) {
        console.log('✅ Menu mobile inizializzato correttamente');
        
        // Gestione click sul toggle - versione semplificata
        mobileMenuToggle.addEventListener('click', (e) => {
            console.log('🖱️ Click su menu hamburger!', e);
            
            // Toggle semplice come nel test
            if (mobileMenu.classList.contains('active')) {
                mobileMenu.classList.remove('active');
                mobileMenuToggle.classList.remove('active');
                document.body.classList.remove('menu-open');
                console.log('📤 Menu chiuso');
            } else {
                mobileMenu.classList.add('active');
                mobileMenuToggle.classList.add('active');
                document.body.classList.add('menu-open');
                console.log('📥 Menu aperto');
            }
        });
        
        // Chiudi menu quando si clicca su un link
        const mobileMenuItems = mobileMenu.querySelectorAll('.mobile-menu-item');
        mobileMenuItems.forEach(item => {
            item.addEventListener('click', () => {
                mobileMenu.classList.remove('active');
                mobileMenuToggle.classList.remove('active');
                document.body.classList.remove('menu-open');
                console.log('📤 Menu chiuso per click su link');
            });
        });
        
        // Chiudi menu con tasto ESC
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape' && mobileMenu.classList.contains('active')) {
                mobileMenu.classList.remove('active');
                mobileMenuToggle.classList.remove('active');
                document.body.classList.remove('menu-open');
                console.log('📤 Menu chiuso con ESC');
            }
        });
        
        // Gestione resize della finestra
        window.addEventListener('resize', () => {
            if (window.innerWidth > 768 && mobileMenu.classList.contains('active')) {
                mobileMenu.classList.remove('active');
                mobileMenuToggle.classList.remove('active');
                document.body.classList.remove('menu-open');
                console.log('📤 Menu chiuso per resize');
            }
        });
        
    } else {
        console.log('❌ Elementi menu mobile non trovati');
        console.log('🔍 Ricerca elementi...');
        console.log('Toggle ID:', document.getElementById('mobileMenuToggle'));
        console.log('Menu ID:', document.getElementById('mobileMenu'));
    }
}

/**
 * Apre/chiude il menu mobile
 */
function toggleMobileMenu(toggle, menu) {
    const isActive = menu.classList.contains('active');
    console.log('🔄 Toggle menu - Stato attuale:', isActive ? 'APERTO' : 'CHIUSO');
    
    if (isActive) {
        console.log('📤 Chiudendo menu...');
        closeMobileMenu(toggle, menu);
    } else {
        console.log('📥 Aprendo menu...');
        openMobileMenu(toggle, menu);
    }
}

/**
 * Apre il menu mobile
 */
function openMobileMenu(toggle, menu) {
    console.log('🚀 Aprendo menu mobile...');
    console.log('📋 Elementi prima dell\'apertura:', {
        toggle: toggle,
        menu: menu,
        toggleClasses: toggle.className,
        menuClasses: menu.className
    });
    
    toggle.classList.add('active');
    menu.classList.add('active');
    document.body.classList.add('menu-open');
    
    console.log('✅ Classi aggiunte:', {
        toggleClasses: toggle.className,
        menuClasses: menu.className,
        bodyClasses: document.body.className
    });
    
    // Debug CSS dopo l'apertura
    setTimeout(() => {
        const menuStyle = window.getComputedStyle(menu);
        console.log('🎨 CSS del menu dopo apertura:', {
            display: menuStyle.display,
            visibility: menuStyle.visibility,
            opacity: menuStyle.opacity,
            transform: menuStyle.transform,
            zIndex: menuStyle.zIndex
        });
    }, 100);
    
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
    return window.innerWidth <= 768 || 
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