<!-- Footer -->
<footer class="main-footer">
    <div class="footer-content">
        <div class="footer-section">
            <h4>The One Piece Is Real</h4>
            <p>Il tuo negozio ufficiale di merchandising One Piece</p>
        </div>
        <div class="footer-section">
            <h4>Contatti</h4>
            <p>Email: info@onepieceisreal.it</p>
            <p>Tel: +39 123 456 7890</p>
        </div>
        <div class="footer-section">
            <h4>Spedizioni</h4>
            <p>Consegna in tutta Italia</p>
            <p>Spedizione gratuita sopra €50</p>
            <a href="${pageContext.request.contextPath}/TrackingServlet" class="tracking-link">
                <i class="fas fa-ship"></i> Traccia Ordine
            </a>
        </div>
    </div>
    
    <!-- Background Music Player - Dentro il footer -->
    <div class="footer-music-section">
        <jsp:include page="music-player.jsp" />
    </div>
</footer>

<style>
/* Stile per il link tracking nel footer */
.tracking-link {
    display: inline-block;
    margin-top: 10px;
    padding: 8px 16px;
    background: linear-gradient(135deg, #ffd700, #ffed4e);
    color: #8B4513;
    text-decoration: none;
    border-radius: 20px;
    font-weight: bold;
    transition: all 0.3s ease;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
}

.tracking-link:hover {
    background: linear-gradient(135deg, #ffed4e, #fff);
    transform: translateY(-2px);
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
    color: #8B4513;
    text-decoration: none;
}

/* Sezione musicale del footer */
.footer-music-section {
    margin-top: 20px;
    display: flex;
    justify-content: center;
    align-items: center;
    width: 100%;
}

/* Override del player musicale per il footer */
.footer-music-section .background-music-player {
    margin: 0;
    max-width: 400px;
}
</style>

</main>
</body>
</html>