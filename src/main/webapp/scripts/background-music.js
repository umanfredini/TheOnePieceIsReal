/**
 * Background Music Player - TheOnePieceIsReal
 * Sistema musicale semplice per riproduzione continua di sottofondo
 */

class BackgroundMusicPlayer {
    constructor() {
        this.audio = null;
        this.isPlaying = false;
        this.volume = 0.3; // Volume di sottofondo (30%)
        this.currentTrack = 'One Piece OST Overtaken  EPIC VERSION (Drums of Liberation).mp3';
        this.isInitialized = false;
        
        // Inizializza il player
        this.init();
    }
    
    init() {
        try {
            // Crea elemento audio
            this.audio = new Audio();
            this.audio.src = `${window.location.origin}${window.location.pathname.replace(/\/[^\/]*$/, '')}/styles/music/${this.currentTrack}`;
            this.audio.volume = this.volume;
            this.audio.loop = true;
            this.audio.preload = 'auto';
            
            // Event listeners
            this.audio.addEventListener('canplaythrough', () => {
                this.isInitialized = true;
                this.startBackgroundMusic();
            });
            
            this.audio.addEventListener('error', (e) => {
                console.warn('Errore nel caricamento della musica di sottofondo:', e);
            });
            
            this.audio.addEventListener('ended', () => {
                // Riproduci di nuovo in caso di fine (backup per il loop)
                this.audio.currentTime = 0;
                this.audio.play().catch(e => {
                    console.warn('Errore nella riproduzione automatica:', e);
                });
            });
            
            // Gestione visibilità pagina per pausa/ripresa
            document.addEventListener('visibilitychange', () => {
                if (document.hidden) {
                    this.pause();
                } else {
                    this.resume();
                }
            });
            
        } catch (error) {
            console.warn('Errore nell\'inizializzazione del player musicale:', error);
        }
    }
    
    startBackgroundMusic() {
        if (!this.isInitialized || !this.audio) return;
        
        // Prova a riprodurre automaticamente
        this.audio.play().then(() => {
            this.isPlaying = true;
        }).catch(error => {
            // Autoplay bloccato dal browser - aspetta interazione utente
            console.info('Autoplay bloccato dal browser. La musica partirà al primo click dell\'utente.');
            this.setupUserInteractionListener();
        });
    }
    
    setupUserInteractionListener() {
        // Listener per il primo click dell'utente
        const startMusic = () => {
            if (!this.isPlaying && this.audio) {
                this.audio.play().then(() => {
                    this.isPlaying = true;
                }).catch(e => {
                    console.warn('Errore nella riproduzione:', e);
                });
            }
            // Rimuovi i listener dopo il primo click
            document.removeEventListener('click', startMusic);
            document.removeEventListener('keydown', startMusic);
            document.removeEventListener('touchstart', startMusic);
        };
        
        document.addEventListener('click', startMusic, { once: true });
        document.addEventListener('keydown', startMusic, { once: true });
        document.addEventListener('touchstart', startMusic, { once: true });
    }
    
    pause() {
        if (this.audio && this.isPlaying) {
            this.audio.pause();
        }
    }
    
    resume() {
        if (this.audio && this.isInitialized && !this.isPlaying) {
            this.audio.play().then(() => {
                this.isPlaying = true;
            }).catch(e => {
                console.warn('Errore nella ripresa della musica:', e);
            });
        }
    }
    
    setVolume(volume) {
        if (this.audio) {
            this.volume = Math.max(0, Math.min(1, volume));
            this.audio.volume = this.volume;
        }
    }
    
    getVolume() {
        return this.volume;
    }
    
    isMusicPlaying() {
        return this.isPlaying;
    }
}

// Inizializza il player musicale globale
let backgroundMusicPlayer = null;

// Funzione di inizializzazione
function initBackgroundMusic() {
    if (!backgroundMusicPlayer) {
        backgroundMusicPlayer = new BackgroundMusicPlayer();
    }
}

// Inizializza quando il DOM è pronto
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initBackgroundMusic);
} else {
    initBackgroundMusic();
}

// Esporta per uso globale
window.backgroundMusicPlayer = backgroundMusicPlayer;
