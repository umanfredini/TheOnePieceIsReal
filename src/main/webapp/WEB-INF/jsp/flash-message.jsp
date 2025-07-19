<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Messaggi Flash -->
<c:if test="${not empty successMessage}">
    <div class="flash-message success-message" id="flashMessage">
        <div class="flash-content">
            <i class="fas fa-check-circle"></i>
            <span>${successMessage}</span>
            <button type="button" class="flash-close" onclick="closeFlashMessage()">
                <i class="fas fa-times"></i>
            </button>
        </div>
    </div>
</c:if>

<c:if test="${not empty errorMessage}">
    <div class="flash-message error-message" id="flashMessage">
        <div class="flash-content">
            <i class="fas fa-exclamation-circle"></i>
            <span>${errorMessage}</span>
            <button type="button" class="flash-close" onclick="closeFlashMessage()">
                <i class="fas fa-times"></i>
            </button>
        </div>
    </div>
</c:if>

<c:if test="${not empty warningMessage}">
    <div class="flash-message warning-message" id="flashMessage">
        <div class="flash-content">
            <i class="fas fa-exclamation-triangle"></i>
            <span>${warningMessage}</span>
            <button type="button" class="flash-close" onclick="closeFlashMessage()">
                <i class="fas fa-times"></i>
            </button>
        </div>
    </div>
</c:if>

<c:if test="${not empty infoMessage}">
    <div class="flash-message info-message" id="flashMessage">
        <div class="flash-content">
            <i class="fas fa-info-circle"></i>
            <span>${infoMessage}</span>
            <button type="button" class="flash-close" onclick="closeFlashMessage()">
                <i class="fas fa-times"></i>
            </button>
        </div>
    </div>
</c:if>

<style>
.flash-message {
    position: fixed;
    top: 20px;
    right: 20px;
    z-index: 9999;
    min-width: 300px;
    max-width: 500px;
    border-radius: 8px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    animation: slideInRight 0.3s ease;
    font-family: var(--font-body);
}

.flash-content {
    display: flex;
    align-items: center;
    padding: 1rem 1.25rem;
    gap: 0.75rem;
}

.flash-content i:first-child {
    font-size: 1.25rem;
    flex-shrink: 0;
}

.flash-content span {
    flex: 1;
    font-weight: 500;
}

.flash-close {
    background: none;
    border: none;
    color: inherit;
    cursor: pointer;
    padding: 0.25rem;
    border-radius: 4px;
    transition: background-color 0.2s ease;
    flex-shrink: 0;
}

.flash-close:hover {
    background-color: rgba(255, 255, 255, 0.2);
}

/* Tipi di messaggio */
.success-message {
    background: linear-gradient(135deg, #28a745, #20c997);
    color: white;
    border-left: 4px solid #1e7e34;
}

.error-message {
    background: linear-gradient(135deg, #dc3545, #e74c3c);
    color: white;
    border-left: 4px solid #c82333;
}

.warning-message {
    background: linear-gradient(135deg, #ffc107, #fd7e14);
    color: #212529;
    border-left: 4px solid #e0a800;
}

.info-message {
    background: linear-gradient(135deg, #17a2b8, #6f42c1);
    color: white;
    border-left: 4px solid #138496;
}

/* Animazioni */
@keyframes slideInRight {
    from {
        transform: translateX(100%);
        opacity: 0;
    }
    to {
        transform: translateX(0);
        opacity: 1;
    }
}

@keyframes slideOutRight {
    from {
        transform: translateX(0);
        opacity: 1;
    }
    to {
        transform: translateX(100%);
        opacity: 0;
    }
}

.flash-message.hiding {
    animation: slideOutRight 0.3s ease forwards;
}

/* Responsive */
@media (max-width: 768px) {
    .flash-message {
        top: 10px;
        right: 10px;
        left: 10px;
        min-width: auto;
        max-width: none;
    }
}
</style>

<script>
function closeFlashMessage() {
    const flashMessage = document.getElementById('flashMessage');
    if (flashMessage) {
        flashMessage.classList.add('hiding');
        setTimeout(() => {
            flashMessage.remove();
        }, 300);
    }
}

// Auto-close dopo 5 secondi
document.addEventListener('DOMContentLoaded', function() {
    const flashMessage = document.getElementById('flashMessage');
    if (flashMessage) {
        setTimeout(() => {
            closeFlashMessage();
        }, 5000);
    }
});
</script> 