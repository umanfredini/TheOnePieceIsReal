<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="header.jsp" />

<main class="container mt-5" role="main">
    <div class="row">
        <div class="col-12">
            <h1 class="mb-4">Dettagli Utente</h1>
            
            <c:if test="${not empty utente}">
                <div class="card">
                    <div class="card-header">
                        <h3>Utente #${utente.id}</h3>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <h5>Informazioni Base</h5>
                                <table class="table table-borderless">
                                    <tr>
                                        <td><strong>Username:</strong></td>
                                        <td>${utente.username}</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Email:</strong></td>
                                        <td>${utente.email}</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Stato:</strong></td>
                                        <td>
                                            <span class="badge bg-${utente.active ? 'success' : 'danger'}">
                                                ${utente.active ? 'Attivo' : 'Inattivo'}
                                            </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><strong>Admin:</strong></td>
                                        <td>
                                            <span class="badge bg-${utente.admin ? 'warning' : 'secondary'}">
                                                ${utente.admin ? 'Sì' : 'No'}
                                            </span>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                            <div class="col-md-6">
                                <h5>Informazioni Aggiuntive</h5>
                                <table class="table table-borderless">
                                    <tr>
                                        <td><strong>Indirizzo:</strong></td>
                                        <td>${utente.shippingAddress}</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Data Creazione:</strong></td>
                                        <td>
                                            <fmt:formatDate value="${utente.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><strong>Ultimo Login:</strong></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty utente.lastLogin}">
                                                    <fmt:formatDate value="${utente.lastLogin}" pattern="dd/MM/yyyy HH:mm"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">Mai</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                        
                        <div class="mt-4">
                            <h5>Azioni</h5>
                            <div class="btn-group" role="group">
                                <a href="${pageContext.request.contextPath}/AdminUserServlet?action=toggle&id=${utente.id}" 
                                   class="btn btn-${utente.active ? 'warning' : 'success'}">
                                    <i class="fas fa-${utente.active ? 'ban' : 'check'}"></i>
                                    ${utente.active ? 'Disattiva' : 'Attiva'} Utente
                                </a>
                                
                                <c:if test="${!utente.admin}">
                                    <a href="${pageContext.request.contextPath}/AdminUserServlet?action=makeAdmin&id=${utente.id}" 
                                       class="btn btn-warning">
                                        <i class="fas fa-user-shield"></i>
                                        Rendi Admin
                                    </a>
                                </c:if>
                                
                                <a href="${pageContext.request.contextPath}/AdminUserServlet" 
                                   class="btn btn-secondary">
                                    <i class="fas fa-arrow-left"></i>
                                    Torna alla Lista
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>
            
            <c:if test="${empty utente}">
                <div class="alert alert-warning">
                    <i class="fas fa-exclamation-triangle"></i>
                    Utente non trovato.
                </div>
                <a href="${pageContext.request.contextPath}/AdminUserServlet" class="btn btn-primary">
                    <i class="fas fa-arrow-left"></i>
                    Torna alla Lista
                </a>
            </c:if>
        </div>
    </div>
</main>

<jsp:include page="footer.jsp" /> 