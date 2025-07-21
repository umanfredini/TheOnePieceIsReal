// WebContent/scripts/checkout.js

import { showError, hideError } from './main.js';

// Opzioni di spedizione simulate
let shippingOptions = [];

// Carica opzioni di spedizione
async function loadShippingOptions() {
    try {
        const response = await fetch('/TheOnePieceIsReal/SimulatedShippingServlet?action=options');
        const data = await response.json();
        if (data.success) {
            shippingOptions = data.options;
            populateShippingSelect();
        }
    } catch (error) {
        console.error('Errore caricamento opzioni spedizione:', error);
    }
}

// Popola il select delle opzioni di spedizione
function populateShippingSelect() {
    const select = document.getElementById('shipping-option');
    if (select && shippingOptions.length > 0) {
        select.innerHTML = '<option value="">Seleziona opzione di spedizione</option>';
        shippingOptions.forEach(option => {
            const optionElement = document.createElement('option');
            optionElement.value = option;
            optionElement.textContent = option;
            select.appendChild(optionElement);
        });
    }
}

// Mappa delle tappe del Grand Line
const GRAND_LINE_STOPS = [
    { name: "East Blue", progress: 0 },
    { name: "Reverse Mountain", progress: 25 },
    { name: "Water 7", progress: 40 },
    { name: "Marineford", progress: 55 },
    { name: "New World", progress: 70 },
    { name: "Dressrosa", progress: 85 },
    { name: "Wano", progress: 100 }
];

/**
 * Anima la nave lungo il percorso del Grand Line
 * @param {number} progressPercent - La percentuale di progresso (0-100)
 */
function animateShipProgress(progressPercent) {
    const ship = document.getElementById('grand-line-ship');
    const progressBar = document.getElementById('grand-line-progress');
    
    if (ship && progressBar) {
        progressBar.style.width = `${progressPercent}%`;
        
        // Calcola posizione nave (offset per centrare l'icona)
        const shipPosition = progressPercent - 2;
        ship.style.left = `calc(${shipPosition}% - 20px)`; // 20px è metà larghezza dell'icona per centrarla
        
        // Aggiorna label tappa corrente
        const currentStop = GRAND_LINE_STOPS.reduce((prev, curr) => 
            curr.progress <= progressPercent ? curr : prev
        );
        
        document.getElementById('current-stop').textContent = currentStop.name;
    }
}

/**
 * Validazione form checkout
 * @returns {boolean} True se il form è valido, false altrimenti
 */
function validateCheckoutForm() {
    let isValid = true;
    const requiredFields = [
        'fullname', 'email', 'address', 'city', 'zip', 'card-number', 'card-expiry', 'card-cvv'
    ];

    requiredFields.forEach(field => { // Utilizzo di una arrow function per la concisione
        const input = document.getElementById(field);
        if (!input.value.trim()) {
            showError(input, 'Campo obbligatorio');
            isValid = false;
        } else {
            hideError(input);
            
            // Validazioni specifiche
            if (field === 'email' && !validateEmail(input.value)) {
                showError(input, 'Email non valida');
                isValid = false;
            }
            
            if (field === 'card-number' && !validateCardNumber(input.value)) {
                showError(input, 'Numero carta non valido');
                isValid = false;
            }
        }
    });

    return isValid;
}

/**
 * Helper: validazione email
 * @param {string} email - L'indirizzo email da validare
 * @returns {boolean} True se l'email è valida, false altrimenti
 */
function validateEmail(email) {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(email);
}

/**
 * Helper: validazione numero carta (formato base)
 * @param {string} number - Il numero della carta da validare
 * @returns {boolean} True se il numero della carta è valido, false altrimenti
 */
function validateCardNumber(number) {
    // Rimuove spazi e trattini
    const cleanNumber = number.replace(/[\s-]/g, '');
    
    // Verifica lunghezza (13-19 cifre)
    if (!/^\d{13,19}$/.test(cleanNumber)) {
        return false;
    }
    
    // Algoritmo di Luhn per validazione
    let sum = 0;
    let isEven = false;
    
    for (let i = cleanNumber.length - 1; i >= 0; i--) {
        let digit = parseInt(cleanNumber[i]);
        
        if (isEven) {
            digit *= 2;
            if (digit > 9) {
                digit -= 9;
            }
        }
        
        sum += digit;
        isEven = !isEven;
    }
    
    return sum % 10 === 0;
}

// Inizializzazione checkout
document.addEventListener('DOMContentLoaded', () => {
    // Carica opzioni di spedizione
    loadShippingOptions();
    
    // Listener per il form di checkout
    document.getElementById('checkout-form')?.addEventListener('submit', async function (e) {
        e.preventDefault();
        
        if (!validateCheckoutForm()) {
            animateShipProgress(0); // Reset animazione se errore
            return;
        }
        
        // Simula processo di pagamento e spedizione
        await simulatePaymentAndShipping();
    });
});

// Simula il processo completo di pagamento e spedizione
async function simulatePaymentAndShipping() {
    const resultsDiv = document.getElementById('checkout-results');
    if (!resultsDiv) return;
    
    resultsDiv.innerHTML = '<div class="text-center"><i class="fas fa-spinner fa-spin fa-2x"></i><p>Elaborazione pagamento...</p></div>';
    resultsDiv.style.display = 'block';
    
    try {
        // 1. Simula pagamento
        const paymentData = new FormData(document.getElementById('checkout-form'));
        const paymentResponse = await fetch('/TheOnePieceIsReal/SimulatedPaymentServlet', {
            method: 'POST',
            body: paymentData
        });
        
        const paymentResult = await paymentResponse.json();
        
        if (!paymentResult.success) {
            resultsDiv.innerHTML = `
                <div class="alert alert-danger">
                    <h5><i class="fas fa-times-circle"></i> Pagamento Fallito</h5>
                    <p><strong>Errore:</strong> ${paymentResult.error}</p>
                    <p><strong>Codice:</strong> ${paymentResult.code}</p>
                </div>
            `;
            return;
        }
        
        // 2. Simula spedizione
        resultsDiv.innerHTML = '<div class="text-center"><i class="fas fa-spinner fa-spin fa-2x"></i><p>Creazione spedizione...</p></div>';
        
        const shippingData = new FormData();
        shippingData.append('orderId', paymentResult.transactionId);
        shippingData.append('shippingOption', document.getElementById('shipping-option').value);
        shippingData.append('address', document.getElementById('address').value);
        
        const shippingResponse = await fetch('/TheOnePieceIsReal/SimulatedShippingServlet', {
            method: 'POST',
            body: shippingData
        });
        
        const shippingResult = await shippingResponse.json();
        
        if (shippingResult.success) {
            // 3. Mostra risultati completi
            resultsDiv.innerHTML = `
                <div class="alert alert-success">
                    <h5><i class="fas fa-check-circle"></i> Ordine Completato con Successo!</h5>
                    <div class="row">
                        <div class="col-md-6">
                            <h6>Dettagli Pagamento:</h6>
                            <p><strong>Transaction ID:</strong> ${paymentResult.transactionId}</p>
                            <p><strong>Importo:</strong> €${paymentResult.amount}</p>
                            <p><strong>Data:</strong> ${paymentResult.timestamp}</p>
                        </div>
                        <div class="col-md-6">
                            <h6>Dettagli Spedizione:</h6>
                            <p><strong>Tracking Number:</strong> ${shippingResult.trackingNumber}</p>
                            <p><strong>Consegna Stimata:</strong> ${shippingResult.estimatedDelivery}</p>
                            <p><strong>Stato:</strong> ${shippingResult.status}</p>
                            <p><strong>Località:</strong> ${shippingResult.currentLocation}</p>
                        </div>
                    </div>
                    <div class="mt-3">
                        <button class="btn btn-primary" onclick="trackOrder('${shippingResult.trackingNumber}')">
                            <i class="fas fa-search"></i> Traccia Ordine
                        </button>
                        <button class="btn btn-secondary" onclick="window.location.href='index.jsp'">
                            <i class="fas fa-home"></i> Torna alla Home
                        </button>
                    </div>
                </div>
            `;
            
            // Anima la nave al 100%
            animateShipProgress(100);
        }
        
    } catch (error) {
        resultsDiv.innerHTML = `
            <div class="alert alert-danger">
                <h5><i class="fas fa-exclamation-triangle"></i> Errore di Sistema</h5>
                <p>Si è verificato un errore durante l'elaborazione. Riprova più tardi.</p>
                <p><small>Dettagli: ${error.message}</small></p>
            </div>
        `;
    }
}

// Funzione per tracciare un ordine
async function trackOrder(trackingNumber) {
    const resultsDiv = document.getElementById('checkout-results');
    resultsDiv.innerHTML = '<div class="text-center"><i class="fas fa-spinner fa-spin fa-2x"></i><p>Caricamento tracking...</p></div>';
    
    try {
        const response = await fetch(`/TheOnePieceIsReal/SimulatedShippingServlet?action=track&orderId=${trackingNumber}`);
        const data = await response.json();
        
        if (data.success) {
            resultsDiv.innerHTML = `
                <div class="alert alert-info">
                    <h5><i class="fas fa-shipping-fast"></i> Tracking Ordine</h5>
                    <p><strong>Numero Tracking:</strong> ${data.trackingNumber}</p>
                    <p><strong>Stato Attuale:</strong> ${data.status}</p>
                    <p><strong>Località:</strong> ${data.currentLocation}</p>
                    <p><strong>Ultimo Aggiornamento:</strong> ${data.lastUpdate}</p>
                    <div class="progress mt-2">
                        <div class="progress-bar" role="progressbar" style="width: ${data.progress}%" 
                             aria-valuenow="${data.progress}" aria-valuemin="0" aria-valuemax="100">
                            ${data.progress}%
                        </div>
                    </div>
                </div>
            `;
        }
    } catch (error) {
        resultsDiv.innerHTML = `
            <div class="alert alert-danger">
                <h5><i class="fas fa-exclamation-triangle"></i> Errore Tracking</h5>
                <p>Impossibile caricare le informazioni di tracking.</p>
            </div>
        `;
    }
}
