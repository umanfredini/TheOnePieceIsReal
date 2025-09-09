<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="header.jsp" />

<main class="container mt-5" role="main">
    <jsp:include page="adminBreadcrumb.jsp">
        <jsp:param name="page" value="users" />
    </jsp:include>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1>Gestione Utenti</h1>
    </div>

    <!-- Statistiche rapide -->
    <div class="row mb-4">
        <div class="col-md-3">
            <div class="card bg-primary text-white">
                <div class="card-body text-center">
                    <h5 class="card-title">Totale Utenti</h5>
                    <h3 class="mb-0">${users != null ? users.size() : 0}</h3>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card bg-success text-white">
                <div class="card-body text-center">
                    <h5 class="card-title">Utenti Attivi</h5>
                    <h3 class="mb-0">
                        <c:set var="activeCount" value="0"/>
                        <c:if test="${users != null}">
                            <c:forEach var="user" items="${users}">
                                <c:if test="${user.getIsActive()}">
                                    <c:set var="activeCount" value="${activeCount + 1}"/>
                                </c:if>
                            </c:forEach>
                        </c:if>
                        ${activeCount}
                    </h3>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card bg-danger text-white">
                <div class="card-body text-center">
                    <h5 class="card-title">Amministratori</h5>
                    <h3 class="mb-0">
                        <c:set var="adminCount" value="0"/>
                        <c:if test="${users != null}">
                            <c:forEach var="user" items="${users}">
                                <c:if test="${user.getIsAdmin()}">
                                    <c:set var="adminCount" value="${adminCount + 1}"/>
                                </c:if>
                            </c:forEach>
                        </c:if>
                        ${adminCount}
                    </h3>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card bg-warning text-white">
                <div class="card-body text-center">
                    <h5 class="card-title">Utenti Inattivi</h5>
                    <h3 class="mb-0">
                        <c:set var="inactiveCount" value="0"/>
                        <c:if test="${users != null}">
                            <c:forEach var="user" items="${users}">
                                <c:if test="${!user.getIsActive()}">
                                    <c:set var="inactiveCount" value="${inactiveCount + 1}"/>
                                </c:if>
                            </c:forEach>
                        </c:if>
                        ${inactiveCount}
                    </h3>
                </div>
            </div>
        </div>
    </div>

    <!-- Filtri -->
    <div class="card mb-4">
        <div class="card-body">
            <form method="GET" action="AdminUserServlet" class="row g-3">
                <div class="col-md-4">
                    <label for="searchTerm" class="form-label">Cerca</label>
                    <input type="text" class="form-control" id="searchTerm" name="search" 
                           value="${param.search}" placeholder="Username o email">
                </div>
                <div class="col-md-3">
                    <label for="roleFilter" class="form-label">Ruolo</label>
                    <select class="form-select" id="roleFilter" name="role">
                        <option value="">Tutti i ruoli</option>
                        <option value="user" ${param.role == 'user' ? 'selected' : ''}>Utente</option>
                        <option value="admin" ${param.role == 'admin' ? 'selected' : ''}>Amministratore</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label for="statusFilter" class="form-label">Stato</label>
                    <select class="form-select" id="statusFilter" name="status">
                        <option value="">Tutti gli stati</option>
                        <option value="active" ${param.status == 'active' ? 'selected' : ''}>Attivo</option>
                        <option value="inactive" ${param.status == 'inactive' ? 'selected' : ''}>Inattivo</option>
                    </select>
                </div>
                <div class="col-md-2 d-flex align-items-end">
                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-search me-1"></i>Filtra
                        </button>
                        <a href="AdminUserServlet" class="btn btn-outline-secondary">
                            <i class="fas fa-times me-1"></i>Reset
                        </a>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Tabella utenti -->
    <section role="region" aria-label="Tabella utenti" class="table-responsive">
        <c:choose>
            <c:when test="${not empty users}">
                <table class="table table-striped table-hover align-middle">
                    <thead class="table-dark">
                        <tr>
                            <th scope="col">ID</th>
                            <th scope="col">Username</th>
                            <th scope="col">Email</th>
                            <th scope="col">Ruolo</th>
                            <th scope="col">Stato</th>
                            <th scope="col">Data Registrazione</th>
                            <th scope="col">Azioni</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:if test="${users != null}">
                            <c:forEach var="user" items="${users}">
                            <tr>
                                <td>
                                    <strong>#<c:out value="${user.id}" /></strong>
                                </td>
                                <td>
                                    <strong><c:out value="${user.username}" /></strong>
                                </td>
                                <td>
                                    <c:out value="${user.email}" />
                                </td>
                                <td>
                                    <span class="badge 
                                        <c:choose>
                                            <c:when test="${user.getIsAdmin()}">bg-danger</c:when>
                                            <c:otherwise>bg-secondary</c:otherwise>
                                        </c:choose>">
                                        <c:choose>
                                            <c:when test="${user.getIsAdmin()}">Amministratore</c:when>
                                            <c:otherwise>Utente</c:otherwise>
                                        </c:choose>
                                    </span>
                                </td>
                                <td>
                                    <span class="badge 
                                        <c:choose>
                                            <c:when test="${user.getIsActive()}">bg-success</c:when>
                                            <c:otherwise>bg-danger</c:otherwise>
                                        </c:choose>">
                                        <c:choose>
                                            <c:when test="${user.getIsActive()}">Attivo</c:when>
                                            <c:otherwise>Inattivo</c:otherwise>
                                        </c:choose>
                                    </span>
                                </td>
                                <td>
                                    <c:if test="${not empty user.createdAt}">
                                        <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy"/>
                                    </c:if>
                                </td>
                                <td>
                                    <div class="btn-group" role="group">
                                        <button type="button" class="btn btn-sm btn-outline-primary" 
                                                onclick="viewUserDetails(${user.id})" title="Dettagli">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                        <button type="button" class="btn btn-sm btn-outline-secondary dropdown-toggle" 
                                                data-bs-toggle="dropdown" aria-expanded="false">
                                            <i class="fas fa-cog"></i>
                                        </button>
                                        <ul class="dropdown-menu">
                                            <c:if test="${!user.getIsAdmin()}">
                                                <li><a class="dropdown-item" href="#" onclick="toggleUserRole(${user.id})">
                                                    <i class="fas fa-user-shield me-2"></i>Promuovi Admin
                                                </a></li>
                                            </c:if>
                                            <c:if test="${user.getIsAdmin()}">
                                                <li><a class="dropdown-item" href="#" onclick="toggleUserRole(${user.id})">
                                                    <i class="fas fa-user me-2"></i>Rimuovi Admin
                                                </a></li>
                                            </c:if>
                                            <li><a class="dropdown-item" href="#" onclick="toggleUserStatus(${user.id})">
                                                <i class="fas fa-toggle-on me-2"></i>Cambia Stato
                                            </a></li>
                                            <li><hr class="dropdown-divider"></li>
                                            <li><a class="dropdown-item text-danger" href="#" onclick="deleteUser(${user.id})">
                                                <i class="fas fa-trash me-2"></i>Elimina
                                            </a></li>
                                        </ul>
                                    </div>
                                </td>
                            </tr>
                            </c:forEach>
                        </c:if>
                        <c:if test="${users == null}">
                            <tr>
                                <td colspan="6" class="text-center text-muted">
                                    <i class="fas fa-exclamation-triangle me-2"></i>
                                    Errore nel caricamento degli utenti
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="alert alert-info text-center" role="alert">
                    <i class="fas fa-users me-2"></i>
                    Nessun utente trovato.
                </div>
            </c:otherwise>
        </c:choose>
    </section>
</main>

<script>
function viewUserDetails(userId) {
    // Implementazione visualizzazione dettagli utente
    alert('Funzionalità di visualizzazione dettagli in sviluppo');
}

function toggleUserRole(userId) {
    const action = confirm('Sei sicuro di voler cambiare il ruolo di questo utente?') ? 'toggleRole' : null;
    if (action) {
        const formData = new FormData();
        formData.append('action', action);
        formData.append('userId', userId);
        formData.append('csrfToken', '${sessionScope.csrfToken}');
        
        fetch('AdminUserServlet', {
            method: 'POST',
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                location.reload();
            } else {
                alert('Errore: ' + data.error);
            }
        })
        .catch(error => {
            console.error('Errore:', error);
            alert('Errore di connessione');
        });
    }
}

function toggleUserStatus(userId) {
    if (confirm('Sei sicuro di voler cambiare lo stato di questo utente?')) {
        const formData = new FormData();
        formData.append('action', 'toggleStatus');
        formData.append('userId', userId);
        formData.append('csrfToken', '${sessionScope.csrfToken}');
        
        fetch('AdminUserServlet', {
            method: 'POST',
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                location.reload();
            } else {
                alert('Errore: ' + data.error);
            }
        })
        .catch(error => {
            console.error('Errore:', error);
            alert('Errore di connessione');
        });
    }
}

function deleteUser(userId) {
    if (confirm('Sei sicuro di voler eliminare questo utente? Questa azione non può essere annullata.')) {
        const formData = new FormData();
        formData.append('action', 'delete');
        formData.append('userId', userId);
        formData.append('csrfToken', '${sessionScope.csrfToken}');
        
        fetch('AdminUserServlet', {
            method: 'POST',
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                location.reload();
            } else {
                alert('Errore: ' + data.error);
            }
        })
        .catch(error => {
            console.error('Errore:', error);
            alert('Errore di connessione');
        });
    }
}
</script>

<jsp:include page="footer.jsp" />
