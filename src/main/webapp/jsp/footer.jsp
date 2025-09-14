nte <!-- Footer -->
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
            <a href="${pageContext.request.contextPath}/TrackingServlet" class="tracking-link">
                <i class="fas fa-ship"></i> Traccia Ordine
            </a>
        </div>
    </div>
</footer>

<style>
/* Stile per il link tracking nel footer - BOTTONE GRADEVOLE CON BARCA */
.tracking-link {
    display: inline-block;
    margin-top: 15px;
    padding: 15px 25px;
    background: linear-gradient(135deg, #ffd700, #ffed4e);
    color: #000000;
    text-decoration: none;
    border-radius: 25px;
    font-weight: 700;
    font-size: 1.1rem;
    text-transform: uppercase;
    letter-spacing: 1px;
    transition: all 0.3s ease;
    box-shadow: 0 6px 20px rgba(255, 215, 0, 0.5);
    border: 3px solid #000000;
    position: relative;
    overflow: hidden;
    animation: subtle-glow 2s ease-in-out infinite;
    text-shadow: 1px 1px 3px rgba(0, 0, 0, 0.4);
    font-family: 'Arial', sans-serif;
    min-width: 220px;
    text-align: center;
}

.tracking-link::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
    transition: left 0.6s;
}

.tracking-link:hover::before {
    left: 100%;
}

.tracking-link:hover {
    background: linear-gradient(135deg, #ffff00, #ffd700);
    transform: translateY(-2px) scale(1.02);
    box-shadow: 0 8px 25px rgba(255, 215, 0, 0.7);
    color: #000000;
    text-decoration: none;
    border-color: #ffff00;
}

.tracking-link:active {
    transform: translateY(-1px) scale(1.01);
}

.tracking-link i {
    margin-right: 8px;
    font-size: 1.2rem;
    filter: drop-shadow(1px 1px 2px rgba(0, 0, 0, 0.4));
    color: #000000;
}

@keyframes subtle-glow {
    0%, 100% {
        box-shadow: 0 6px 20px rgba(255, 215, 0, 0.5);
        transform: scale(1);
        border-color: #000000;
    }
    50% {
        box-shadow: 0 8px 25px rgba(255, 215, 0, 0.7);
        transform: scale(1.01);
        border-color: #ffff00;
    }
}

</style>

<!-- Script per menu mobile -->
<script>
document.addEventListener('DOMContentLoaded', function() {
    const mobileMenuToggle = document.getElementById('mobileMenuToggle');
    const mobileMenu = document.getElementById('mobileMenu');
    
    if (mobileMenuToggle && mobileMenu) {
        mobileMenuToggle.addEventListener('click', function() {
            mobileMenuToggle.classList.toggle('active');
            mobileMenu.classList.toggle('active');
            
            // Prevenire scroll del body quando il menu è aperto
            if (mobileMenu.classList.contains('active')) {
                document.body.classList.add('menu-open');
            } else {
                document.body.classList.remove('menu-open');
            }
        });
        
        // Chiudi menu quando si clicca su un link
        const mobileMenuItems = mobileMenu.querySelectorAll('.mobile-menu-item');
        mobileMenuItems.forEach(item => {
            item.addEventListener('click', function() {
                mobileMenuToggle.classList.remove('active');
                mobileMenu.classList.remove('active');
                document.body.classList.remove('menu-open');
            });
        });
        
        // Chiudi menu quando si clicca fuori
        mobileMenu.addEventListener('click', function(e) {
            if (e.target === mobileMenu) {
                mobileMenuToggle.classList.remove('active');
                mobileMenu.classList.remove('active');
                document.body.classList.remove('menu-open');
            }
        });
        
        // Chiudi menu con tasto ESC
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape' && mobileMenu.classList.contains('active')) {
                mobileMenuToggle.classList.remove('active');
                mobileMenu.classList.remove('active');
                document.body.classList.remove('menu-open');
            }
        });
    }
});
</script>

</body>
</html>