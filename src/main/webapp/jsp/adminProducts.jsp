<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="header.jsp" />

<main class="container mt-5" role="main">
    <jsp:include page="adminBreadcrumb.jsp">
        <jsp:param name="page" value="products" />
    </jsp:include>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1>Gestione Prodotti</h1>
        <div>
            <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addProductModal">
                <i class="fas fa-plus me-1"></i>Nuovo Prodotto
            </button>
        </div>
    </div>

    <!-- Statistiche rapide -->
    <div class="row mb-4">
        <div class="col-md-3">
            <div class="card bg-primary text-white">
                <div class="card-body text-center">
                    <h5 class="card-title">Totale Prodotti</h5>
                    <h3 class="mb-0">${products.size()}</h3>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card bg-success text-white">
                <div class="card-body text-center">
                    <h5 class="card-title">Attivi</h5>
                    <h3 class="mb-0">
                        <c:set var="activeCount" value="0"/>
                        <c:forEach var="product" items="${products}">
                            <c:if test="${product.isActive}">
                                <c:set var="activeCount" value="${activeCount + 1}"/>
                            </c:if>
                        </c:forEach>
                        ${activeCount}
                    </h3>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card bg-warning text-white">
                <div class="card-body text-center">
                    <h5 class="card-title">Scorte Basse</h5>
                    <h3 class="mb-0">
                        <c:set var="lowStockCount" value="0"/>
                        <c:forEach var="product" items="${products}">
                            <c:if test="${product.stockQuantity <= 5}">
                                <c:set var="lowStockCount" value="${lowStockCount + 1}"/>
                            </c:if>
                        </c:forEach>
                        ${lowStockCount}
                    </h3>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card bg-info text-white">
                <div class="card-body text-center">
                    <h5 class="card-title">Categorie</h5>
                    <h3 class="mb-0">
                        <c:set var="categories" value=""/>
                        <c:forEach var="product" items="${products}">
                            <c:if test="${!categories.contains(product.category)}">
                                <c:set var="categories" value="${categories},${product.category}"/>
                            </c:if>
                        </c:forEach>
                        ${categories.split(',').length - 1}
                    </h3>
                </div>
            </div>
        </div>
    </div>

    <!-- Tabella prodotti -->
    <section role="region" aria-label="Tabella prodotti" class="table-responsive">
        <c:choose>
            <c:when test="${not empty products}">
                <table class="table table-striped table-hover align-middle">
                    <thead class="table-dark">
                        <tr>
                            <th scope="col">Immagine</th>
                            <th scope="col">Nome</th>
                            <th scope="col">Categoria</th>
                            <th scope="col">Prezzo</th>
                            <th scope="col">Stock</th>
                            <th scope="col">Stato</th>
                            <th scope="col">Azioni</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="product" items="${products}">
                            <tr>
                                <td>
                                    <img src="${pageContext.request.contextPath}/styles/images/prodotti/${product.imageUrl}" 
                                         alt="${product.name}" class="img-thumbnail" style="width: 50px; height: 50px; object-fit: cover;">
                                </td>
                                <td>
                                    <strong><c:out value="${product.name}" /></strong>
                                </td>
                                <td>
                                    <span class="badge bg-secondary"><c:out value="${product.category}" /></span>
                                </td>
                                <td>
                                    <strong>€ <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="€" /></strong>
                                </td>
                                <td>
                                    <span class="badge 
                                        <c:choose>
                                            <c:when test="${product.stockQuantity <= 5}">bg-danger</c:when>
                                            <c:when test="${product.stockQuantity <= 10}">bg-warning</c:when>
                                            <c:otherwise>bg-success</c:otherwise>
                                        </c:choose>">
                                        ${product.stockQuantity}
                                    </span>
                                </td>
                                <td>
                                    <span class="badge 
                                        <c:choose>
                                            <c:when test="${product.isActive}">bg-success</c:when>
                                            <c:otherwise>bg-danger</c:otherwise>
                                        </c:choose>">
                                        <c:choose>
                                            <c:when test="${product.isActive}">Attivo</c:when>
                                            <c:otherwise>Non attivo</c:otherwise>
                                        </c:choose>
                                    </span>
                                </td>
                                <td>
                                    <div class="btn-group" role="group">
                                        <button type="button" class="btn btn-sm btn-outline-primary" 
                                                onclick="editProduct(${product.id})" title="Modifica">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <button type="button" class="btn btn-sm btn-outline-secondary dropdown-toggle" 
                                                data-bs-toggle="dropdown" aria-expanded="false">
                                            <i class="fas fa-cog"></i>
                                        </button>
                                        <ul class="dropdown-menu">
                                            <li><a class="dropdown-item" href="#" onclick="toggleProductStatus(${product.id})">
                                                <i class="fas fa-toggle-on me-2"></i>Cambia Stato
                                            </a></li>
                                            <li><a class="dropdown-item" href="#" onclick="updateStock(${product.id})">
                                                <i class="fas fa-boxes me-2"></i>Aggiorna Stock
                                            </a></li>
                                            <li><hr class="dropdown-divider"></li>
                                            <li><a class="dropdown-item text-danger" href="#" onclick="deleteProduct(${product.id})">
                                                <i class="fas fa-trash me-2"></i>Elimina
                                            </a></li>
                                        </ul>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="alert alert-info text-center" role="alert">
                    <i class="fas fa-box-open me-2"></i>
                    Nessun prodotto disponibile. 
                    <button class="btn btn-success btn-sm ms-2" data-bs-toggle="modal" data-bs-target="#addProductModal">
                        Aggiungi il primo prodotto
                    </button>
                </div>
            </c:otherwise>
        </c:choose>
    </section>
</main>

<!-- Modal Aggiungi Prodotto -->
<div class="modal fade" id="addProductModal" tabindex="-1" aria-labelledby="addProductModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addProductModalLabel">Nuovo Prodotto</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="AdminProductServlet" method="post" enctype="multipart/form-data" id="addProductForm">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />
                <input type="hidden" name="action" value="add" />
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="productName" class="form-label">Nome Prodotto *</label>
                                <input type="text" class="form-control" id="productName" name="name" required>
                                <div class="error-message" id="name-error"></div>
                            </div>
                            <div class="mb-3">
                                <label for="productCategory" class="form-label">Categoria *</label>
                                <select class="form-select" id="productCategory" name="category" required>
                                    <option value="">Seleziona categoria</option>
                                    <option value="Figure">Figure</option>
                                    <option value="Maglie">Maglie</option>
                                    <option value="Poster">Poster</option>
                                    <option value="Accessori">Accessori</option>
                                    <option value="Cosplay">Cosplay</option>
                                    <option value="Quadri">Quadri</option>
                                    <option value="Navi">Navi</option>
                                </select>
                                <div class="error-message" id="category-error"></div>
                            </div>
                            <div class="mb-3">
                                <label for="productPrice" class="form-label">Prezzo *</label>
                                <input type="number" class="form-control" id="productPrice" name="price" 
                                       step="0.01" min="0" required>
                                <div class="error-message" id="price-error"></div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="productStock" class="form-label">Quantità Stock *</label>
                                <input type="number" class="form-control" id="productStock" name="stockQuantity" 
                                       min="0" required>
                                <div class="error-message" id="stockQuantity-error"></div>
                            </div>
                            <div class="mb-3">
                                <label for="productDescription" class="form-label">Descrizione</label>
                                <textarea class="form-control" id="productDescription" name="description" rows="3"></textarea>
                            </div>
                            <div class="mb-3">
                                <label for="productImage" class="form-label">Immagine</label>
                                <input type="file" class="form-control" id="productImage" name="image" 
                                       accept="image/*">
                                <div class="error-message" id="image-error"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annulla</button>
                    <button type="submit" class="btn btn-success">Salva Prodotto</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
// Validazione form prodotto
document.getElementById('addProductForm').addEventListener('submit', function(e) {
    let isValid = true;
    
    // Validazione nome
    const name = document.getElementById('productName').value.trim();
    if (name.length < 3) {
        showError(document.getElementById('productName'), 'Il nome deve avere almeno 3 caratteri');
        isValid = false;
    } else {
        hideError(document.getElementById('productName'));
    }
    
    // Validazione categoria
    const category = document.getElementById('productCategory').value;
    if (!category) {
        showError(document.getElementById('productCategory'), 'Seleziona una categoria');
        isValid = false;
    } else {
        hideError(document.getElementById('productCategory'));
    }
    
    // Validazione prezzo
    const price = parseFloat(document.getElementById('productPrice').value);
    if (isNaN(price) || price <= 0) {
        showError(document.getElementById('productPrice'), 'Inserisci un prezzo valido');
        isValid = false;
    } else {
        hideError(document.getElementById('productPrice'));
    }
    
    // Validazione stock
    const stock = parseInt(document.getElementById('productStock').value);
    if (isNaN(stock) || stock < 0) {
        showError(document.getElementById('productStock'), 'Inserisci una quantità valida');
        isValid = false;
    } else {
        hideError(document.getElementById('productStock'));
    }
    
    if (!isValid) {
        e.preventDefault();
    }
});

function showError(element, message) {
    const errorDiv = document.getElementById(element.name + '-error');
    if (errorDiv) {
        errorDiv.textContent = message;
        errorDiv.style.display = 'block';
        element.classList.add('is-invalid');
    }
}

function hideError(element) {
    const errorDiv = document.getElementById(element.name + '-error');
    if (errorDiv) {
        errorDiv.textContent = '';
        errorDiv.style.display = 'none';
        element.classList.remove('is-invalid');
    }
}

function editProduct(productId) {
    // Implementazione modifica prodotto
    alert('Funzionalità di modifica in sviluppo');
}

function toggleProductStatus(productId) {
    if (confirm('Sei sicuro di voler cambiare lo stato del prodotto?')) {
        const formData = new FormData();
        formData.append('action', 'toggleStatus');
        formData.append('productId', productId);
        formData.append('csrfToken', '${sessionScope.csrfToken}');
        
        fetch('AdminProductServlet', {
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

function deleteProduct(productId) {
    if (confirm('Sei sicuro di voler eliminare questo prodotto? Questa azione non può essere annullata.')) {
        const formData = new FormData();
        formData.append('action', 'delete');
        formData.append('productId', productId);
        formData.append('csrfToken', '${sessionScope.csrfToken}');
        
        fetch('AdminProductServlet', {
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

<style>
.error-message {
    color: #dc3545;
    font-size: 0.875rem;
    margin-top: 0.25rem;
    display: none;
}

.form-control.is-invalid {
    border-color: #dc3545;
    box-shadow: 0 0 0 0.2rem rgba(220, 53, 69, 0.25);
}
</style>

<jsp:include page="footer.jsp" />
