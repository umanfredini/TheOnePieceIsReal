<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="header.jsp" />

<main class="container mt-5 text-center" role="main">
    <h1 class="mb-4 text-success">Ordine Confermato!</h1>

    <p class="lead">Grazie per il tuo acquisto! Il tuo ordine è stato registrato con successo.</p>
    
    <!-- Mostra tracking ID se disponibile -->
    <c:if test="${not empty order.trackingNumber}">
        <div class="alert alert-info mt-3" role="alert">
            <h5><i class="fas fa-shipping-fast me-2"></i>Tracking ID</h5>
            <div class="d-flex align-items-center justify-content-center gap-2 mb-2">
                <strong id="trackingId">${order.trackingNumber}</strong>
                <button type="button" class="btn btn-sm btn-outline-primary" onclick="copyTrackingId()">
                    <i class="fas fa-copy"></i> Copia
                </button>
            </div>
            <div class="mt-2">
                <a href="${pageContext.request.contextPath}/TrackingServlet?action=search&trackingNumber=${order.trackingNumber}" 
                   class="btn btn-success btn-sm">
                    <i class="fas fa-ship me-1"></i> Traccia Ordine
                </a>
            </div>
            <small class="text-muted">Usa questo ID per tracciare il tuo ordine</small>
        </div>
    </c:if>
    
    <!-- Messaggio diverso per ospiti vs utenti registrati -->
    <c:choose>
        <c:when test="${isGuest}">
            <div class="alert alert-warning mt-3" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>
                <strong>Ordine come ospite</strong><br>
                Il tuo ordine è stato associato a un account di sistema. 
                <strong>Conserva il tracking ID sopra indicato</strong> per seguire la spedizione del tuo ordine.
            </div>
        </c:when>
        <c:otherwise>
            <p>Puoi visualizzare i dettagli del tuo ordine nella sezione "Storico Ordini".</p>
        </c:otherwise>
    </c:choose>

    <div class="mt-4 d-flex justify-content-center gap-3">
        <a href="${pageContext.request.contextPath}/" class="btn btn-outline-primary">Torna alla Home</a>
        <c:if test="${!isGuest}">
            <a href="${pageContext.request.contextPath}/OrderHistoryServlet" class="btn btn-primary">Visualizza Storico Ordini</a>
        </c:if>
    </div>
</main>

<script>
function copyTrackingId() {
    const trackingId = document.getElementById('trackingId').textContent;
    const button = event.target.closest('button');
    const originalText = button.innerHTML;
    
    // Funzione per mostrare feedback di successo
    function showSuccess() {
        button.innerHTML = '<i class="fas fa-check"></i> Copiato!';
        button.classList.remove('btn-outline-primary');
        button.classList.add('btn-success');
        
        setTimeout(function() {
            button.innerHTML = originalText;
            button.classList.remove('btn-success');
            button.classList.add('btn-outline-primary');
        }, 2000);
    }
    
    // Funzione per mostrare errore
    function showError() {
        button.innerHTML = '<i class="fas fa-times"></i> Errore!';
        button.classList.remove('btn-outline-primary');
        button.classList.add('btn-danger');
        
        setTimeout(function() {
            button.innerHTML = originalText;
            button.classList.remove('btn-danger');
            button.classList.add('btn-outline-primary');
        }, 2000);
    }
    
    // Metodo 1: API Clipboard moderna (se supportata e sicura)
    if (navigator.clipboard && window.isSecureContext) {
        navigator.clipboard.writeText(trackingId).then(function() {
            showSuccess();
        }).catch(function(err) {
            console.error('Errore API Clipboard: ', err);
            // Fallback al metodo alternativo
            fallbackCopy(trackingId);
        });
    } else {
        // Metodo 2: Fallback per browser più vecchi o HTTP
        fallbackCopy(trackingId);
    }
    
    // Metodo alternativo usando textarea temporanea
    function fallbackCopy(text) {
        try {
            // Crea un elemento textarea temporaneo
            const textArea = document.createElement('textarea');
            textArea.value = text;
            textArea.style.position = 'fixed';
            textArea.style.left = '-999999px';
            textArea.style.top = '-999999px';
            document.body.appendChild(textArea);
            
            // Seleziona e copia il testo
            textArea.focus();
            textArea.select();
            
            const successful = document.execCommand('copy');
            document.body.removeChild(textArea);
            
            if (successful) {
                showSuccess();
            } else {
                showError();
            }
        } catch (err) {
            console.error('Errore fallback copy: ', err);
            showError();
        }
    }
}
</script>

<jsp:include page="footer.jsp" />