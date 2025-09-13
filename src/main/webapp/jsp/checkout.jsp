<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="header.jsp" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/css/grand-line-route.css">

<main class="grand-line-route" role="main">
    <div class="ship-animation"></div>
    <div class="route-header">
        <h1 class="gradient-text">🏴‍☠️ Rotta del Grand Line</h1>
        <p class="route-subtitle">Naviga verso il tuo tesoro One Piece</p>
    </div>
    
    <!-- Messaggio per ospiti -->
    <c:if test="${isGuest}">
        <div class="alert alert-checkout alert-info text-center" role="alert">
            <i class="fas fa-info-circle me-2"></i>
            <strong>Ordine come ospite</strong> - Puoi completare l'ordine senza registrarti. 
            Ti verrà fornito un tracking ID per seguire il tuo ordine.
        </div>
    </c:if>
    
    <div class="checkout-container">
        <!-- Sezione Form -->
        <div class="checkout-form-section">
            <!-- Riepilogo Ordine -->
            <section class="form-section checkout-step" role="region" aria-label="Riepilogo ordine">
                <h3><i class="fas fa-shopping-cart"></i> Riepilogo Ordine</h3>
                
                
                <c:choose>
                    <c:when test="${not empty cart.items}">
                        <div class="summary-table">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Prodotto</th>
                                        <th>Quantità</th>
                                        <th>Prezzo</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${cart.items}">
                                        <tr>
                                            <td><c:out value="${item.product.name}" /></td>
                                            <td><c:out value="${item.quantity}" /></td>
                                            <td>€ <fmt:formatNumber value="${item.product.price.doubleValue() * item.quantity}" type="currency" currencySymbol="€" /></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-warning">
                            <i class="fas fa-exclamation-triangle"></i>
                            <strong>Nessun prodotto nel carrello</strong><br>
                            Torna al <a href="${pageContext.request.contextPath}/CartServlet">carrello</a> per aggiungere prodotti.
                        </div>
                    </c:otherwise>
                </c:choose>
            </section>

            <!-- Form Checkout -->
            <section class="form-section checkout-step" role="region" aria-label="Modulo di checkout">
                <h3><i class="fas fa-shipping-fast"></i> Informazioni di Spedizione</h3>
                <form action="${pageContext.request.contextPath}/CheckoutServlet" method="post" class="checkout-form">
                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}" />

                    <!-- Nota simulazione -->
                    <div class="simulation-note">
                        <span style="font-size: 1.2rem; margin-right: 8px;">⚠️</span>
                        <i class="fas fa-info-circle"></i>
                        <strong>Modalità Simulazione:</strong> Questo è un ambiente di test. I dati di pagamento sono precompilati per facilitare i test.
                    </div>

                    <div class="mb-3">
                        <label for="address" class="form-label">Indirizzo di spedizione</label>
                        <input type="text" id="address" name="address" class="form-control" 
                               value="Via dei Pirati 123, East Blue, Grand Line" required />
                    </div>

                    <div class="mb-3">
                        <label for="shipping-option" class="form-label">Opzione di spedizione</label>
                        <select id="shipping-option" name="shippingOption" class="form-select" required>
                            <option value="standard" selected>Spedizione Standard (3-5 giorni) - €5.00</option>
                            <option value="express">Spedizione Express (1-2 giorni) - €12.00</option>
                            <option value="premium">Spedizione Premium (24 ore) - €20.00</option>
                            <option value="same-day">Consegna Same Day - €35.00</option>
                        </select>
                    </div>

                    <!-- Sezione Pagamento Simulato -->
                    <div class="payment-simulation">
                        <div style="position: absolute; top: -10px; left: 20px; background: #6c757d; color: white; padding: 5px 15px; border-radius: 20px; font-size: 0.8rem; font-weight: 600; z-index: 10; box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);">
                            💳 SIMULAZIONE
                        </div>
                        <h5 class="mb-3">
                            <i class="fas fa-credit-card me-2"></i>Dati di Pagamento (Simulazione)
                        </h5>
                        
                        <div class="mb-3">
                            <label for="cardHolder" class="form-label">Intestatario carta</label>
                            <input type="text" id="cardHolder" name="cardHolder" class="form-control" 
                                   value="Monkey D. Luffy" required />
                        </div>

                        <div class="mb-3">
                            <label for="cardNumber" class="form-label">Numero carta</label>
                            <input type="text" id="cardNumber" name="cardNumber" class="form-control" 
                                   value="4111111111111111" maxlength="19" required />
                            <small class="form-text text-muted">
                                <i class="fas fa-info-circle me-1"></i>Carta di test per simulazione (sempre approvata)
                            </small>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="cardExpiry" class="form-label">Scadenza (MM/YY)</label>
                                    <input type="text" id="cardExpiry" name="cardExpiry" class="form-control" 
                                           value="12/25" maxlength="5" required />
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="cardCvv" class="form-label">CVV</label>
                                    <input type="text" id="cardCvv" name="cardCvv" class="form-control" 
                                           value="123" maxlength="3" required />
                                </div>
                            </div>
                        </div>
                    </div> <!-- Fine sezione pagamento simulato -->

                    <div class="d-grid">
                        <button type="submit" class="btn btn-checkout">
                            <i class="fas fa-shipping-fast"></i> Conferma Ordine
                        </button>
                    </div>
                </form>
            </section>
        </div> <!-- Fine checkout-form-section -->
    </div> <!-- Fine checkout-container -->

</main>


<jsp:include page="footer.jsp" />