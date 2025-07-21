<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="header.jsp" />

<main class="container mt-5" role="main">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-6">
            <div class="error-container text-center">
                <%
                    int statusCode = pageContext.getErrorData() != null ? pageContext.getErrorData().getStatusCode() : 0;
                    String errorIcon = "fas fa-exclamation-triangle";
                    String errorTitle = "Ops! Si è verificato un errore";
                    String errorClass = "text-danger";
                    String errorDescription = "Si è verificato un errore imprevisto. Riprova più tardi o contatta l'assistenza.";
                    
                    switch (statusCode) {
                        case 404:
                            errorIcon = "fas fa-search";
                            errorTitle = "Mi sa che ti sei perso";
                            errorClass = "text-warning";
                            errorDescription = "Zoro si è perso di nuovo! La pagina che stai cercando non esiste o è stata spostata.";
                            break;
                        case 500:
                            errorIcon = "fas fa-bomb";
                            errorTitle = "Errore del Server";
                            errorClass = "text-danger";
                            errorDescription = "Il server ha incontrato un errore interno. I nostri tecnici sono al lavoro per risolverlo.";
                            break;
                        case 403:
                            errorIcon = "fas fa-ban";
                            errorTitle = "Accesso Negato";
                            errorClass = "text-warning";
                            errorDescription = "Non hai i permessi per accedere a questa risorsa.";
                            break;
                        case 401:
                            errorIcon = "fas fa-lock";
                            errorTitle = "Non Autorizzato";
                            errorClass = "text-info";
                            errorDescription = "Devi effettuare il login per accedere a questa risorsa.";
                            break;
                        case 400:
                            errorIcon = "fas fa-exclamation-circle";
                            errorTitle = "Richiesta Non Valida";
                            errorClass = "text-warning";
                            errorDescription = "La richiesta inviata non è valida o malformata.";
                            break;
                        default:
                            if (statusCode > 0) {
                                errorIcon = "fas fa-question-circle";
                                errorTitle = "Errore " + statusCode;
                                errorClass = "text-secondary";
                                errorDescription = "Si è verificato un errore con codice " + statusCode + ".";
                            }
                            break;
                    }
                %>
                
                <div class="error-icon mb-4">
                    <i class="<%= errorIcon %> fa-4x <%= errorClass %>"></i>
                </div>
                
                <h1 class="mb-4 <%= errorClass %>"><%= errorTitle %></h1>
                
                <% if (statusCode > 0) { %>
                    <div class="error-code mb-3">
                        <span class="badge bg-secondary fs-4"><%= statusCode %></span>
                    </div>
                <% } %>
                
                <div class="alert alert-info" role="alert">
                    <h5 class="alert-heading">Dettagli dell'errore:</h5>
                    <p class="mb-0">
                        <%= errorDescription %>
                    </p>
                    <c:if test="${not empty errorMessage}">
                        <hr>
                        <p class="mb-0">
                            <strong>Messaggio aggiuntivo:</strong> <c:out value="${errorMessage}" />
                        </p>
                    </c:if>
                </div>
                
                <% if (pageContext.getErrorData() != null && pageContext.getErrorData().getThrowable() != null) { %>
                    <div class="error-details mt-3">
                        <details>
                            <summary class="text-muted">Dettagli tecnici</summary>
                            <div class="mt-2 p-2 bg-light rounded">
                                <small class="text-muted">
                                    <strong>URI:</strong> <%= pageContext.getErrorData().getRequestURI() %><br>
                                    <strong>Errore:</strong> <%= pageContext.getErrorData().getThrowable().getMessage() %>
                                </small>
                            </div>
                        </details>
                    </div>
                <% } %>
                
                <div class="error-actions mt-4">
                    <a href="javascript:history.back()" class="btn btn-outline-secondary me-2">
                        <i class="fas fa-arrow-left"></i> Torna indietro
                    </a>
                    <a href="http://www.theonepieceisreal.com:8081/TheOnePieceIsReal/" class="btn btn-primary">
                        <i class="fas fa-home"></i> Torna alla Home
                    </a>
                </div>
                
                <div class="error-help mt-4">
                    <small class="text-muted">
                        Se il problema persiste, contatta l'assistenza tecnica.
                    </small>
                </div>
            </div>
        </div>
    </div>
</main>

<style>
.error-container {
    background: white;
    border-radius: 12px;
    padding: 2rem;
    box-shadow: 0 4px 15px rgba(0,0,0,0.1);
}

.error-icon {
    animation: pulse 2s infinite;
}

@keyframes pulse {
    0% { transform: scale(1); }
    50% { transform: scale(1.1); }
    100% { transform: scale(1); }
}

.error-actions .btn {
    min-width: 140px;
}

.alert-danger {
    border-left: 4px solid #dc3545;
    background-color: #f8d7da;
    border-color: #f5c6cb;
    color: #721c24;
}

.alert-heading {
    color: #721c24;
    font-weight: 600;
}
</style>

<jsp:include page="footer.jsp" />