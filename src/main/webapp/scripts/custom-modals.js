/**
 * Custom Modals - Alternativa a Bootstrap Modals
 * Gestisce modals personalizzati senza dipendenze esterne
 */

class CustomModal {
    constructor() {
        this.overlay = null;
        this.activeModal = null;
        this.init();
    }

    init() {
        // Crea overlay se non esiste
        if (!document.getElementById('modalOverlay')) {
            this.createOverlay();
        }
        
        this.overlay = document.getElementById('modalOverlay');
        
        // Event listener per chiudere cliccando sull'overlay
        this.overlay.addEventListener('click', (e) => {
            if (e.target === this.overlay) {
                this.hideAll();
            }
        });

        // Event listener per tasto ESC
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape' && this.activeModal) {
                this.hideAll();
            }
        });
    }

    createOverlay() {
        const overlay = document.createElement('div');
        overlay.id = 'modalOverlay';
        overlay.className = 'modal-overlay';
        overlay.style.display = 'none';
        
        const container = document.createElement('div');
        container.className = 'modal-container';
        overlay.appendChild(container);
        
        document.body.appendChild(overlay);
    }

    show(modalId, options = {}) {
        const modal = document.getElementById(modalId);
        if (!modal) {
            console.error(`Modal con ID '${modalId}' non trovato`);
            return;
        }

        // Nascondi tutti i modals attivi
        this.hideAll();

        // Mostra overlay e modal
        this.overlay.style.display = 'flex';
        modal.style.display = 'block';
        this.activeModal = modal;

        // Previeni scroll del body
        document.body.style.overflow = 'hidden';

        // Focus sul primo elemento focusabile
        const focusableElement = modal.querySelector('button, input, select, textarea, a[href]');
        if (focusableElement) {
            focusableElement.focus();
        }

        // Callback onShow se specificato
        if (options.onShow && typeof options.onShow === 'function') {
            options.onShow(modal);
        }

        console.log(`Modal '${modalId}' mostrato`);
    }

    hide(modalId) {
        const modal = document.getElementById(modalId);
        if (modal) {
            modal.style.display = 'none';
        }
        
        this.hideOverlay();
    }

    hideAll() {
        // Nascondi tutti i modals
        const modals = document.querySelectorAll('.custom-modal');
        modals.forEach(modal => {
            modal.style.display = 'none';
        });
        
        this.hideOverlay();
    }

    hideOverlay() {
        if (this.overlay) {
            this.overlay.style.display = 'none';
        }
        
        this.activeModal = null;
        document.body.style.overflow = 'auto';
    }

    // Metodi di utilità per tipi comuni di modal
    showSuccess(message, title = 'Successo', options = {}) {
        this.showMessage('success', message, title, options);
    }

    showError(message, title = 'Errore', options = {}) {
        this.showMessage('error', message, title, options);
    }

    showWarning(message, title = 'Attenzione', options = {}) {
        this.showMessage('warning', message, title, options);
    }

    showInfo(message, title = 'Informazione', options = {}) {
        this.showMessage('info', message, title, options);
    }

    showMessage(type, message, title, options = {}) {
        const modalId = `customMessageModal_${Date.now()}`;
        const modal = this.createMessageModal(modalId, type, message, title, options);
        
        document.body.appendChild(modal);
        this.show(modalId, options);
    }

    createMessageModal(modalId, type, message, title, options) {
        const modal = document.createElement('div');
        modal.id = modalId;
        modal.className = `custom-modal ${type}-modal`;
        
        const iconMap = {
            success: 'fas fa-check-circle',
            error: 'fas fa-times-circle',
            warning: 'fas fa-exclamation-triangle',
            info: 'fas fa-info-circle'
        };

        modal.innerHTML = `
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="${iconMap[type]}"></i> ${title}
                </h5>
                <button type="button" class="modal-close" onclick="customModal.hide('${modalId}')">&times;</button>
            </div>
            <div class="modal-body">
                <div class="text-center">
                    <i class="${iconMap[type]} modal-icon ${type}-icon"></i>
                    <p>${message}</p>
                </div>
            </div>
            <div class="modal-footer">
                ${options.showCancel ? 
                    `<button type="button" class="btn btn-secondary" onclick="customModal.hide('${modalId}')">${options.cancelText || 'Annulla'}</button>` : ''
                }
                <button type="button" class="btn btn-${type === 'error' ? 'danger' : type === 'success' ? 'success' : type === 'warning' ? 'warning' : 'primary'}" 
                        onclick="customModal.hide('${modalId}')">
                    ${options.confirmText || 'OK'}
                </button>
            </div>
        `;

        return modal;
    }

    // Metodo per conferma con callback
    confirm(message, title = 'Conferma', onConfirm, onCancel) {
        const modalId = `confirmModal_${Date.now()}`;
        const modal = document.createElement('div');
        modal.id = modalId;
        modal.className = 'custom-modal warning-modal';
        
        modal.innerHTML = `
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-question-circle"></i> ${title}
                </h5>
                <button type="button" class="modal-close" onclick="customModal.hide('${modalId}')">&times;</button>
            </div>
            <div class="modal-body">
                <div class="text-center">
                    <i class="fas fa-question-circle modal-icon warning-icon"></i>
                    <p>${message}</p>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="customModal.handleConfirm('${modalId}', false, ${onCancel ? '() => {' + onCancel.toString() + '}' : 'null'})">
                    Annulla
                </button>
                <button type="button" class="btn btn-warning" onclick="customModal.handleConfirm('${modalId}', true, ${onConfirm ? '() => {' + onConfirm.toString() + '}' : 'null'})">
                    Conferma
                </button>
            </div>
        `;

        document.body.appendChild(modal);
        this.show(modalId);
    }

    handleConfirm(modalId, confirmed, callback) {
        this.hide(modalId);
        
        if (callback && typeof callback === 'function') {
            if (confirmed) {
                callback();
            }
        }
        
        // Rimuovi il modal dal DOM
        const modal = document.getElementById(modalId);
        if (modal) {
            modal.remove();
        }
    }
}

// Inizializza il modal manager globale
const customModal = new CustomModal();

// Funzioni globali per compatibilità
function showModal(modalId) {
    customModal.show(modalId);
}

function hideModal(modalId) {
    customModal.hide(modalId);
}

// Esporta per uso in moduli
if (typeof module !== 'undefined' && module.exports) {
    module.exports = CustomModal;
} 