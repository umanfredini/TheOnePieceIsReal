// WebContent/scripts/validation.js

import { showError, hideError } from './main.js';

/**
 * Validazione email
 * @param {string} email - L'indirizzo email da validare
 * @returns {boolean} True se l'email è valida, false altrimenti
 */
function validateEmail(email) {
    const re = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    return re.test(email);
}

/**
 * Validazione form di registrazione
 */
function validateRegistrationForm() {
    const form = document.forms['registration-form'];
    if(!form) return true;

    const password = form.password.value;
    const confirmPassword = form.confirmPassword.value;
    let isValid = true;

    // Validazione email
    if(!validateEmail(form.email.value)) {
        showError(form.email, 'Email non valida');
        isValid = false;
    } else {
        hideError(form.email);
    }

    // Validazione password
    if(password.length < 8) {
        showError(form.password, 'La password deve avere almeno 8 caratteri');
        isValid = false;
    } else {
        hideError(form.password);
    }

    // Conferma password
    if(password !== confirmPassword) {
        showError(form.confirmPassword, 'Le password non coincidono');
        isValid = false;
    } else {
        hideError(form.confirmPassword);
    }

    return isValid;
}

/**
 * Validazione form di login
 */
function validateLoginForm() {
    const form = document.forms['login-form'];
    if(!form) return true;

    let isValid = true;

    if(!form.email.value.trim()) {
        showError(form.email, 'Email obbligatoria');
        isValid = false;
    } else if(!validateEmail(form.email.value)) {
        showError(form.email, 'Email non valida');
        isValid = false;
    } else {
        hideError(form.email);
    }

    if(!form.password.value.trim()) {
        showError(form.password, 'Password obbligatoria');
        isValid = false;
    } else {
        hideError(form.password);
    }

    return isValid;
}

// Inizializzazione validazione form
document.forms['registration-form'] && document.forms['registration-form'].addEventListener('submit', function (e) {
    if(!validateRegistrationForm()) e.preventDefault();
});

document.forms['login-form'] && document.forms['login-form'].addEventListener('submit', function (e) {
    if(!validateLoginForm()) e.preventDefault();
});