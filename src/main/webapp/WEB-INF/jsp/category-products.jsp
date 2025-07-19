<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:include page="header.jsp" />

<main class="container-fluid mt-4" role="main">
    <!-- Header della categoria -->
    <div class="category-header mb-4">
        <div class="container">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="index.jsp">Home</a></li>
                    <li class="breadcrumb-item active" aria-current="page">${categoryName != null ? categoryName : 'Catalogo Prodotti'}</li>
                </ol>
            </nav>
            <h1 class="category-title">${categoryName != null ? categoryName : 'Catalogo Prodotti'}</h1>
            <p class="category-description">${categoryName != null ? 'Scopri la nostra collezione di ' + categoryName.toLowerCase() + ' One Piece' : 'Scopri tutti i nostri prodotti One Piece'}</p>
        </div>
    </div>

    <div class="container">
        <div class="row">
            <!-- Sidebar filtri -->
            <aside class="col-lg-3 mb-4">
                <div class="filters-sidebar">
                    <h3 class="filters-title">Filtri</h3>
                    
                    <!-- Filtro prezzo -->
                    <div class="filter-section mb-3">
                        <h5>Prezzo</h5>
                        <div class="price-range">
                            <input type="range" class="form-range" id="priceRange" min="0" max="200" value="${param.maxPrice != null ? param.maxPrice : 200}">
                            <div class="price-labels d-flex justify-content-between">
                                <span>€0</span>
                                <span id="priceValue">€${param.maxPrice != null ? param.maxPrice : 200}</span>
                                <span>€200</span>
                            </div>
                        </div>
                    </div>

                    <!-- Filtro personaggi -->
                    <div class="filter-section mb-3">
                        <h5>Personaggi</h5>
                        <div class="character-filters">
                            <c:forEach var="character" items="${characters}">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" 
                                           id="char_${character.id}" 
                                           name="characters" 
                                           value="${character.id}"
                                           <c:if test="${paramValues.characters != null && fn:contains(paramValues.characters, character.id)}">checked</c:if>>
                                    <label class="form-check-label" for="char_${character.id}">
                                        ${character.name}
                                    </label>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- Filtro disponibilità -->
                    <div class="filter-section mb-3">
                        <h5>Disponibilità</h5>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="inStock" name="inStock" value="true"
                                   <c:if test="${param.inStock == 'true'}">checked</c:if>>
                            <label class="form-check-label" for="inStock">
                                Solo prodotti disponibili
                            </label>
                        </div>
                    </div>

                    <!-- Filtro featured -->
                    <div class="filter-section mb-3">
                        <h5>Speciali</h5>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="featured" name="featured" value="true"
                                   <c:if test="${param.featured == 'true'}">checked</c:if>>
                            <label class="form-check-label" for="featured">
                                Solo prodotti multi-personaggio
                            </label>
                        </div>
                    </div>

                    <!-- Pulsanti filtri -->
                    <div class="filter-actions">
                        <button type="button" class="btn btn-primary w-100 mb-2" onclick="applyFilters()">
                            Applica Filtri
                        </button>
                        <button type="button" class="btn btn-outline-secondary w-100" onclick="clearFilters()">
                            Cancella Filtri
                        </button>
                    </div>
                </div>
            </aside>

            <!-- Contenuto principale -->
            <div class="col-lg-9">
                <!-- Barra superiore -->
                <div class="products-header mb-4">
                    <div class="row align-items-center">
                        <div class="col-md-6">
                            <p class="results-count mb-0">
                                <c:choose>
                                    <c:when test="${not empty products}">
                                        ${products.size()} prodotto<c:if test="${products.size() != 1}">i</c:if> trovati
                                    </c:when>
                                    <c:otherwise>
                                        Nessun prodotto trovato
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                        <div class="col-md-6 text-end">
                            <div class="sort-controls">
                                <label for="sortSelect" class="form-label me-2">Ordina per:</label>
                                <select class="form-select form-select-sm d-inline-block w-auto" id="sortSelect" onchange="sortProducts(this.value)">
                                    <option value="name" <c:if test="${param.sort == 'name'}">selected</c:if>>Nome</option>
                                    <option value="price_asc" <c:if test="${param.sort == 'price_asc'}">selected</c:if>>Prezzo crescente</option>
                                    <option value="price_desc" <c:if test="${param.sort == 'price_desc'}">selected</c:if>>Prezzo decrescente</option>
                                    <option value="newest" <c:if test="${param.sort == 'newest'}">selected</c:if>>Più recenti</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>


                
                <!-- Griglia prodotti -->
                <div class="products-grid">
                    <c:choose>
                        <c:when test="${not empty products}">
                            <div class="row">
                                <c:forEach var="product" items="${products}">
                                    <div class="col-xl-3 col-lg-4 col-md-6 mb-4">
                                        <div class="product-card">
                                            <div class="product-image">
                                                <img src="${product.imageUrl}" class="img-fluid" alt="${product.name}">
                                                <div class="product-overlay">
                                                    <div class="product-actions">
                                                        <button class="btn btn-sm btn-primary" onclick="addToCart(${product.id})">
                                                            <i class="fas fa-shopping-cart"></i> Aggiungi
                                                        </button>
                                                        <button class="btn btn-sm btn-outline-primary" onclick="addToWishlist(${product.id})">
                                                            <i class="fas fa-heart"></i>
                                                        </button>
                                                        <a href="ProductServlet?id=${product.id}" class="btn btn-sm btn-outline-secondary">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                    </div>
                                                </div>
                                                <c:if test="${product.featured}">
                                                    <div class="featured-badge">
                                                        <span class="badge bg-warning">In Evidenza</span>
                                                    </div>
                                                </c:if>
                                                <c:if test="${product.stockQuantity <= 0}">
                                                    <div class="out-of-stock-badge">
                                                        <span class="badge bg-danger">Esaurito</span>
                                                    </div>
                                                </c:if>
                                            </div>
                                            <div class="product-info">
                                                <h5 class="product-title">
                                                    <a href="ProductServlet?id=${product.id}">${product.name}</a>
                                                </h5>
                                                <div class="product-characters mb-2">
                                                    <c:forEach var="character" items="${productCharacters[product.id]}" varStatus="status">
                                                        <c:if test="${status.index < 3}">
                                                            <span class="badge bg-primary me-1">${character.name}</span>
                                                        </c:if>
                                                        <c:if test="${status.index == 2 && fn:length(productCharacters[product.id]) > 3}">
                                                            <c:set var="moreCount" value="${fn:length(productCharacters[product.id]) - 3}" />
                                                            <span class="badge bg-secondary">+${moreCount}</span>
                                                        </c:if>
                                                    </c:forEach>
                                                </div>
                                                <div class="product-price">
                                                    <span class="price">€<fmt:formatNumber value="${product.price}" pattern="#,##0.00" /></span>
                                                    <c:if test="${product.stockQuantity > 0}">
                                                        <span class="stock-info text-success">
                                                            <i class="fas fa-check-circle"></i> Disponibile
                                                        </span>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="no-products">
                                <div class="text-center py-5">
                                    <i class="fas fa-search fa-3x text-muted mb-3"></i>
                                    <h3>Nessun prodotto trovato</h3>
                                    <p class="text-muted">Prova a modificare i filtri o cerca un'altra categoria</p>
                                    <a href="ProductServlet" class="btn btn-primary">Torna al catalogo</a>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Paginazione -->
                <c:if test="${totalPages > 1}">
                    <nav aria-label="Paginazione prodotti" class="mt-4">
                        <ul class="pagination justify-content-center">
                            <li class="page-item <c:if test="${currentPage == 1}">disabled</c:if>">
                                <a class="page-link" href="?category=${param.category}&page=${currentPage - 1}">Precedente</a>
                            </li>
                            <c:forEach begin="1" end="${totalPages}" var="page">
                                <li class="page-item <c:if test="${currentPage == page}">active</c:if>">
                                    <a class="page-link" href="?category=${param.category}&page=${page}">${page}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item <c:if test="${currentPage == totalPages}">disabled</c:if>">
                                <a class="page-link" href="?category=${param.category}&page=${currentPage + 1}">Successiva</a>
                            </li>
                        </ul>
                    </nav>
                </c:if>
            </div>
        </div>
    </div>
</main>

<!-- CSS personalizzato per la pagina -->
<style>
.category-header {
    background: linear-gradient(135deg, #1e3a8a, #3b82f6);
    color: white;
    padding: 2rem 0;
    margin-bottom: 2rem;
}

.category-title {
    font-size: 2.5rem;
    font-weight: bold;
    margin-bottom: 0.5rem;
}

.category-description {
    font-size: 1.1rem;
    opacity: 0.9;
}

.filters-sidebar {
    background: white;
    border-radius: 10px;
    padding: 1.5rem;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    position: sticky;
    top: 20px;
}

.filters-title {
    font-size: 1.3rem;
    margin-bottom: 1.5rem;
    color: #1e3a8a;
}

.filter-section h5 {
    font-size: 1rem;
    margin-bottom: 0.75rem;
    color: #333;
}

.price-range {
    padding: 0.5rem 0;
}

.price-labels {
    font-size: 0.9rem;
    color: #666;
}

.character-filters {
    max-height: 200px;
    overflow-y: auto;
}

.form-check {
    margin-bottom: 0.5rem;
}

.form-check-label {
    font-size: 0.9rem;
}

.filter-actions {
    border-top: 1px solid #eee;
    padding-top: 1rem;
    margin-top: 1rem;
}

.products-header {
    background: white;
    padding: 1rem;
    border-radius: 8px;
    box-shadow: 0 2px 5px rgba(0,0,0,0.05);
}

.results-count {
    font-weight: 500;
    color: #666;
}

.product-card {
    background: white;
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    transition: all 0.3s ease;
    height: 100%;
}

.product-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 25px rgba(0,0,0,0.15);
}

.product-image {
    position: relative;
    overflow: hidden;
    aspect-ratio: 1;
}

.product-image img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.3s ease;
}

.product-card:hover .product-image img {
    transform: scale(1.05);
}

.product-overlay {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0,0,0,0.7);
    display: flex;
    align-items: center;
    justify-content: center;
    opacity: 0;
    transition: opacity 0.3s ease;
}

.product-card:hover .product-overlay {
    opacity: 1;
}

.product-actions {
    display: flex;
    gap: 0.5rem;
    flex-direction: column;
}

.product-actions .btn {
    min-width: 120px;
}

.featured-badge {
    position: absolute;
    top: 10px;
    left: 10px;
}

.out-of-stock-badge {
    position: absolute;
    top: 10px;
    right: 10px;
}

.product-info {
    padding: 1rem;
}

.product-title {
    font-size: 1.1rem;
    margin-bottom: 0.5rem;
    line-height: 1.3;
}

.product-title a {
    color: #333;
    text-decoration: none;
}

.product-title a:hover {
    color: var(--deep-blue);
}

.product-characters {
    min-height: 1.5rem;
}

.product-price {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: 0.5rem;
}

.price {
    font-size: 1.2rem;
    font-weight: bold;
    color: var(--deep-blue);
}

.stock-info {
    font-size: 0.9rem;
}

.no-products {
    background: white;
    border-radius: 12px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}

@media (max-width: 768px) {
    .filters-sidebar {
        position: static;
        margin-bottom: 2rem;
    }
    
    .product-actions {
        flex-direction: row;
    }
    
    .product-actions .btn {
        min-width: auto;
        flex: 1;
    }
}
</style>

<!-- JavaScript per i filtri -->
<script>
document.addEventListener('DOMContentLoaded', function() {
    // Gestione slider prezzo
    const priceRange = document.getElementById('priceRange');
    const priceValue = document.getElementById('priceValue');
    
    if (priceRange && priceValue) {
        priceRange.addEventListener('input', function() {
            priceValue.textContent = '€' + this.value;
        });
    }
});

function applyFilters() {
    // Controlla se ci sono filtri attivi
    const maxPrice = document.getElementById('priceRange').value;
    const characters = document.querySelectorAll('input[name="characters"]:checked');
    const inStock = document.getElementById('inStock').checked;
    const featured = document.getElementById('featured').checked;
    
    // Se non ci sono filtri attivi, non fare nulla
    if ((maxPrice === '200' || maxPrice === '') && 
        characters.length === 0 && 
        !inStock && 
        !featured) {
        return; // Non fare nulla se non ci sono filtri
    }
    
    const form = document.createElement('form');
    form.method = 'GET';
    form.action = 'ProductServlet';
    
    // Aggiungi parametri esistenti
    const urlParams = new URLSearchParams(window.location.search);
    for (let [key, value] of urlParams) {
        if (key !== 'maxPrice' && key !== 'characters' && key !== 'inStock' && key !== 'featured') {
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = key;
            input.value = value;
            form.appendChild(input);
        }
    }
    
    // Aggiungi nuovi filtri solo se sono diversi dai valori di default
    if (maxPrice && maxPrice !== '200') {
        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = 'maxPrice';
        input.value = maxPrice;
        form.appendChild(input);
    }
    
    characters.forEach(char => {
        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = 'characters';
        input.value = char.value;
        form.appendChild(input);
    });
    
    if (inStock) {
        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = 'inStock';
        input.value = 'true';
        form.appendChild(input);
    }
    
    if (featured) {
        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = 'featured';
        input.value = 'true';
        form.appendChild(input);
    }
    
    document.body.appendChild(form);
    form.submit();
}

function clearFilters() {
    // Reimposta tutti i filtri ai valori di default
    const priceRange = document.getElementById('priceRange');
    if (priceRange) priceRange.value = '200';
    
    const priceValue = document.getElementById('priceValue');
    if (priceValue) priceValue.textContent = '€200';
    
    // Deseleziona tutti i checkbox
    const checkboxes = document.querySelectorAll('input[type="checkbox"]');
    checkboxes.forEach(checkbox => checkbox.checked = false);
    
    // Reimposta il select di ordinamento
    const sortSelect = document.getElementById('sortSelect');
    if (sortSelect) sortSelect.value = 'name';
    
    // Ricarica la pagina senza filtri
    window.location.href = 'ProductServlet';
}

function sortProducts(sortValue) {
    const urlParams = new URLSearchParams(window.location.search);
    urlParams.set('sort', sortValue);
    window.location.href = 'ProductServlet?' + urlParams.toString();
}

function addToCart(productId) {
    fetch('/TheOnePieceIsReal/CartServlet', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'action=add&productId=' + productId + '&quantity=1'
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            showNotification('Prodotto aggiunto al carrello!', 'success');
        } else {
            showNotification('Errore nell\'aggiunta al carrello', 'error');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showNotification('Errore nell\'aggiunta al carrello', 'error');
    });
}

function addToWishlist(productId) {
    fetch('/TheOnePieceIsReal/WishlistServlet', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'action=add&productId=' + productId
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            showNotification('Prodotto aggiunto ai preferiti!', 'success');
        } else {
            showNotification('Errore nell\'aggiunta ai preferiti', 'error');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showNotification('Errore nell\'aggiunta ai preferiti', 'error');
    });
}

function showNotification(message, type) {
    const notification = document.createElement('div');
    notification.className = `alert alert-${type === 'success' ? 'success' : 'danger'} notification`;
    notification.textContent = message;
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        z-index: 9999;
        min-width: 300px;
        animation: slideIn 0.3s ease;
    `;
    
    document.body.appendChild(notification);
    
    setTimeout(() => {
        notification.remove();
    }, 3000);
}

// CSS per le notifiche
const style = document.createElement('style');
style.textContent = `
@keyframes slideIn {
    from { transform: translateX(100%); opacity: 0; }
    to { transform: translateX(0); opacity: 1; }
}
`;
document.head.appendChild(style);
</script>

<jsp:include page="footer.jsp" /> 