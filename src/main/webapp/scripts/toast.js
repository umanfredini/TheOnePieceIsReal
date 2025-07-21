// WebContent/scripts/toast.js

/**
 * Sistema di notifiche toast
 */

let toastContainer = null;

/**
 * Inizializza il container per i toast
 */
function initToastContainer() {
    if (!toastContainer) {
        toastContainer = document.createElement('div');
        toastContainer.id = 'toast-container';
        toastContainer.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 10000;
            display: flex;
            flex-direction: column;
            gap: 10px;
        `;
        document.body.appendChild(toastContainer);
    }
}

/**
 * Mostra una notifica toast
 * @param {string} message - Il messaggio da mostrare
 * @param {string} type - Il tipo di toast (success, error, warning, info)
 * @param {number} duration - Durata in millisecondi (default: 3000)
 */
export function showToast(message, type = 'success', duration = 3000) {
    initToastContainer();
    
    const toast = document.createElement('div');
    toast.className = `toast toast-${type}`;
    toast.style.cssText = `
        background: ${getToastColor(type)};
        color: white;
        padding: 12px 20px;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        font-family: var(--font-body, sans-serif);
        font-size: 14px;
        font-weight: 500;
        min-width: 250px;
        max-width: 350px;
        transform: translateX(100%);
        opacity: 0;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        gap: 10px;
    `;
    
    // Icona per tipo
    const icon = document.createElement('i');
    icon.className = getToastIcon(type);
    icon.style.fontSize = '16px';
    toast.appendChild(icon);
    
    // Messaggio
    const text = document.createElement('span');
    text.textContent = message;
    toast.appendChild(text);
    
    // Pulsante chiudi
    const closeBtn = document.createElement('button');
    closeBtn.innerHTML = '&times;';
    closeBtn.style.cssText = `
        background: none;
        border: none;
        color: inherit;
        font-size: 18px;
        cursor: pointer;
        margin-left: auto;
        padding: 0;
        width: 20px;
        height: 20px;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 50%;
        transition: background-color 0.2s;
    `;
    closeBtn.onclick = () => removeToast(toast);
    closeBtn.onmouseenter = () => closeBtn.style.backgroundColor = 'rgba(255,255,255,0.2)';
    closeBtn.onmouseleave = () => closeBtn.style.backgroundColor = 'transparent';
    toast.appendChild(closeBtn);
    
    toastContainer.appendChild(toast);
    
    // Animazione entrata
    setTimeout(() => {
        toast.style.transform = 'translateX(0)';
        toast.style.opacity = '1';
    }, 10);
    
    // Auto-remove
    if (duration > 0) {
        setTimeout(() => removeToast(toast), duration);
    }
}

/**
 * Rimuove un toast
 */
function removeToast(toast) {
    toast.style.transform = 'translateX(100%)';
    toast.style.opacity = '0';
    setTimeout(() => {
        if (toast.parentNode) {
            toast.parentNode.removeChild(toast);
        }
    }, 300);
}

/**
 * Ottiene il colore per tipo di toast
 */
function getToastColor(type) {
    const colors = {
        success: 'linear-gradient(135deg, #28a745, #20c997)',
        error: 'linear-gradient(135deg, #dc3545, #e74c3c)',
        warning: 'linear-gradient(135deg, #ffc107, #fd7e14)',
        info: 'linear-gradient(135deg, #17a2b8, #6f42c1)'
    };
    return colors[type] || colors.info;
}

/**
 * Ottiene l'icona per tipo di toast
 */
function getToastIcon(type) {
    const icons = {
        success: 'fas fa-check-circle',
        error: 'fas fa-exclamation-circle',
        warning: 'fas fa-exclamation-triangle',
        info: 'fas fa-info-circle'
    };
    return icons[type] || icons.info;
}

// Inizializza il container al caricamento
document.addEventListener('DOMContentLoaded', initToastContainer); 