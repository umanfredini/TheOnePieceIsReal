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
                            <c:if test="${product.active}">
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
                        <c:set var="categoryCount" value="0"/>
                        <c:set var="categories" value=""/>
                        <c:forEach var="product" items="${products}">
                            <c:if test="${!categories.contains(product.category)}">
                                <c:set var="categories" value="${categories},${product.category}"/>
                                <c:set var="categoryCount" value="${categoryCount + 1}"/>
                            </c:if>
                        </c:forEach>
                        ${categoryCount}
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
                            <tr data-product-id="${product.id}">
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
                                            <c:when test="${product.active}">bg-success</c:when>
                                            <c:otherwise>bg-danger</c:otherwise>
                                        </c:choose>">
                                        <c:choose>
                                            <c:when test="${product.active}">Attivo</c:when>
                                            <c:otherwise>Non attivo</c:otherwise>
                                        </c:choose>
                                    </span>
                                </td>
                                <td>
                                    <div class="btn-group" role="group">
                                        <button type="button" class="btn btn-sm btn-outline-primary" 
                                                onclick="editProduct(this, '${product.id}')" title="Modifica">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <button type="button" class="btn btn-sm btn-outline-secondary dropdown-toggle" 
                                                data-bs-toggle="dropdown" aria-expanded="false">
                                            <i class="fas fa-cog"></i>
                                        </button>
                                        <ul class="dropdown-menu">
                                            <li><a class="dropdown-item" href="#" onclick="toggleProductStatus('${product.id}')">
                                                <i class="fas fa-toggle-on me-2"></i>Cambia Stato
                                            </a></li>
                                            <li><a class="dropdown-item" href="#" onclick="updateStock(this, '${product.id}')">
                                                <i class="fas fa-boxes me-2"></i>Aggiorna Stock
                                            </a></li>
                                            <li><hr class="dropdown-divider"></li>
                                            <li><a class="dropdown-item text-danger" href="#" onclick="deleteProduct('${product.id}')">
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

<!-- Modal Modifica Prodotto -->
<div class="modal fade" id="editProductModal" tabindex="-1" aria-labelledby="editProductModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editProductModalLabel">Modifica Prodotto</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="AdminProductServlet" method="post" enctype="multipart/form-data" id="editProductForm">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />
                <input type="hidden" name="action" value="update" />
                <input type="hidden" name="productId" id="editProductId" />
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="editProductName" class="form-label">Nome Prodotto *</label>
                                <input type="text" class="form-control" id="editProductName" name="name" required>
                                <div class="error-message" id="edit-name-error"></div>
                            </div>
                            <div class="mb-3">
                                <label for="editProductCategory" class="form-label">Categoria *</label>
                                <select class="form-select" id="editProductCategory" name="category" required>
                                    <option value="">Seleziona categoria</option>
                                    <option value="Figure">Figure</option>
                                    <option value="Maglie">Maglie</option>
                                    <option value="Poster">Poster</option>
                                    <option value="Accessori">Accessori</option>
                                    <option value="Cosplay">Cosplay</option>
                                    <option value="Quadri">Quadri</option>
                                    <option value="Navi">Navi</option>
                                </select>
                                <div class="error-message" id="edit-category-error"></div>
                            </div>
                            <div class="mb-3">
                                <label for="editProductPrice" class="form-label">Prezzo *</label>
                                <input type="number" class="form-control" id="editProductPrice" name="price" 
                                       step="0.01" min="0" required>
                                <div class="error-message" id="edit-price-error"></div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="editProductStock" class="form-label">Quantità Stock *</label>
                                <input type="number" class="form-control" id="editProductStock" name="stockQuantity" 
                                       min="0" required>
                                <div class="error-message" id="edit-stockQuantity-error"></div>
                            </div>
                            <div class="mb-3">
                                <label for="editProductDescription" class="form-label">Descrizione</label>
                                <textarea class="form-control" id="editProductDescription" name="description" rows="3"></textarea>
                            </div>
                            <div class="mb-3">
                                <label for="editProductImage" class="form-label">Nuova Immagine (opzionale)</label>
                                <input type="file" class="form-control" id="editProductImage" name="image" 
                                       accept="image/*">
                                <div class="error-message" id="edit-image-error"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annulla</button>
                    <button type="submit" class="btn btn-primary">Aggiorna Prodotto</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal Aggiorna Stock -->
<div class="modal fade" id="updateStockModal" tabindex="-1" aria-labelledby="updateStockModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="updateStockModalLabel">Aggiorna Stock</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="AdminProductServlet" method="post" id="updateStockForm">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />
                <input type="hidden" name="action" value="updateStock" />
                <input type="hidden" name="productId" id="updateStockProductId" />
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="newStockQuantity" class="form-label">Nuova Quantità Stock *</label>
                        <input type="number" class="form-control" id="newStockQuantity" name="stockQuantity" 
                               min="0" required>
                        <div class="form-text">Stock attuale: <span id="currentStock"></span></div>
                        <div class="error-message" id="stock-error"></div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annulla</button>
                    <button type="submit" class="btn btn-warning">Aggiorna Stock</button>
                </div>
            </form>
        </div>
    </div>
</div>

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

// Validazione form modifica prodotto
document.getElementById('editProductForm').addEventListener('submit', function(e) {
    let isValid = true;
    
    // Validazione nome
    const name = document.getElementById('editProductName').value.trim();
    if (name.length < 3) {
        showError(document.getElementById('editProductName'), 'Il nome deve avere almeno 3 caratteri');
        isValid = false;
    } else {
        hideError(document.getElementById('editProductName'));
    }
    
    // Validazione categoria
    const category = document.getElementById('editProductCategory').value;
    if (!category) {
        showError(document.getElementById('editProductCategory'), 'Seleziona una categoria');
        isValid = false;
    } else {
        hideError(document.getElementById('editProductCategory'));
    }
    
    // Validazione prezzo
    const price = parseFloat(document.getElementById('editProductPrice').value);
    if (isNaN(price) || price <= 0) {
        showError(document.getElementById('editProductPrice'), 'Inserisci un prezzo valido');
        isValid = false;
    } else {
        hideError(document.getElementById('editProductPrice'));
    }
    
    // Validazione stock
    const stock = parseInt(document.getElementById('editProductStock').value);
    if (isNaN(stock) || stock < 0) {
        showError(document.getElementById('editProductStock'), 'Inserisci una quantità valida');
        isValid = false;
    } else {
        hideError(document.getElementById('editProductStock'));
    }
    
    if (!isValid) {
        e.preventDefault();
    }
});

// Validazione form aggiornamento stock
document.getElementById('updateStockForm').addEventListener('submit', function(e) {
    e.preventDefault();
    
    const stock = parseInt(document.getElementById('newStockQuantity').value);
    if (isNaN(stock) || stock < 0) {
        showError(document.getElementById('newStockQuantity'), 'Inserisci una quantità valida');
        return;
    } else {
        hideError(document.getElementById('newStockQuantity'));
    }
    
    // Invia la richiesta AJAX
    const formData = new FormData(this);
    
    fetch('AdminProductServlet', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            // Chiudi il modal
            const stockModal = bootstrap.Modal.getInstance(document.getElementById('updateStockModal'));
            stockModal.hide();
            // Ricarica la pagina
            location.reload();
        } else {
            alert('Errore: ' + data.error);
        }
    })
    .catch(error => {
        console.error('Errore:', error);
        alert('Errore di connessione');
    });
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

function editProduct(buttonElement, productId) {
    console.log('editProduct chiamata con ID:', productId);
    
    try {
        // Usa l'elemento passato per trovare la riga
        const row = buttonElement.closest('tr');
        console.log('Riga trovata:', row);
        
        if (!row) {
            alert('Errore: Riga del prodotto non trovata');
            return;
        }
        
        const cells = row.querySelectorAll('td');
        console.log('Celle trovate:', cells.length);
        
        // Estrai i dati del prodotto dalla tabella
        const name = cells[1].textContent.trim();
        const category = cells[2].querySelector('.badge').textContent.trim();
        const price = cells[3].textContent.replace('€', '').replace(',', '.').trim();
        const stock = cells[4].querySelector('.badge').textContent.trim();
        
        console.log('Dati estratti:', {name, category, price, stock});
        
        // Popola il form di modifica
        document.getElementById('editProductId').value = productId;
        document.getElementById('editProductName').value = name;
        document.getElementById('editProductCategory').value = category;
        document.getElementById('editProductPrice').value = price;
        document.getElementById('editProductStock').value = stock;
        
        // Mostra il modal
        const editModal = new bootstrap.Modal(document.getElementById('editProductModal'));
        editModal.show();
        console.log('Modal aperto');
    } catch (error) {
        console.error('Errore in editProduct:', error);
        alert('Errore nell\'apertura del modal di modifica: ' + error.message);
    }
}

function toggleProductStatus(productId) {
    console.log('toggleProductStatus chiamata con ID:', productId);
    
    if (confirm('Sei sicuro di voler cambiare lo stato del prodotto?')) {
        // Trova la riga del prodotto usando data-product-id
        const targetRow = document.querySelector(`tr[data-product-id="${productId}"]`);
        console.log('Riga trovata:', targetRow);
        
        if (!targetRow) {
            alert('Errore: Riga del prodotto non trovata per ID: ' + productId);
            return;
        }
        
        // Trova il badge dello status (6a colonna: Stato)
        const statusBadge = targetRow.querySelector('td:nth-child(6) .badge');
        console.log('Badge status trovato:', statusBadge);
        
        if (!statusBadge) {
            alert('Errore: Badge status non trovato');
            return;
        }
        
        // Cambia il display del badge
        const isCurrentlyActive = statusBadge.textContent.trim() === 'Attivo';
        console.log('Status attuale:', isCurrentlyActive ? 'Attivo' : 'Non attivo');
        
        if (isCurrentlyActive) {
            // Cambia da Attivo a Non attivo
            statusBadge.className = 'badge bg-danger';
            statusBadge.textContent = 'Non attivo';
        } else {
            // Cambia da Non attivo a Attivo
            statusBadge.className = 'badge bg-success';
            statusBadge.textContent = 'Attivo';
        }
        
        console.log('Status cambiato da', isCurrentlyActive ? 'Attivo' : 'Non attivo', 'a', isCurrentlyActive ? 'Non attivo' : 'Attivo');
    }
}

function updateStock(linkElement, productId) {
    console.log('updateStock chiamata con ID:', productId);
    
    try {
        // Usa l'elemento passato per trovare la riga
        const row = linkElement.closest('tr');
        console.log('Riga trovata per stock:', row);
        
        if (!row) {
            alert('Errore: Riga del prodotto non trovata per aggiornamento stock');
            return;
        }
        
        const cells = row.querySelectorAll('td');
        console.log('Celle trovate per stock:', cells.length);
        
        // Estrai lo stock attuale dal badge
        const currentStock = cells[4].querySelector('.badge').textContent.trim();
        console.log('Stock attuale:', currentStock);
        
        // Popola il form di aggiornamento stock
        document.getElementById('updateStockProductId').value = productId;
        document.getElementById('currentStock').textContent = currentStock;
        document.getElementById('newStockQuantity').value = currentStock;
        
        // Mostra il modal
        const stockModal = new bootstrap.Modal(document.getElementById('updateStockModal'));
        stockModal.show();
        console.log('Modal stock aperto');
    } catch (error) {
        console.error('Errore in updateStock:', error);
        alert('Errore nell\'apertura del modal di aggiornamento stock: ' + error.message);
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
