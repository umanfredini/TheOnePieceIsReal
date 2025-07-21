// WebContent/scripts/music-player.js

class MusicPlayer {
    constructor() {
        // Controlla se esiste già un'istanza audio globale
        if (window.globalAudio) {
            this.audio = window.globalAudio;
        } else {
            this.audio = new Audio();
            window.globalAudio = this.audio;
        }
        
        this.isPlaying = false;
        this.currentTrackIndex = 0;
        this.volume = 0.5;
        
        // Playlist con Overtaken sempre come prima
        this.playlist = [
            'One Piece OST Overtaken  EPIC VERSION (Drums of Liberation).mp3',
            'One Piece OST The Very Very Very Strongest  EPIC VERSION.mp3',
            '15.mp3',
            '40.mp3',
            '71.mp3',
            '86.mp3',
            '167.mp3',
            '181.mp3',
            '251.mp3',
            '267.mp3',
            '352.mp3'
        ];
        
        // Ripristina lo stato dal localStorage
        this.restoreState();
        
        this.initializePlayer();
        this.setupEventListeners();
        this.loadTrack(this.currentTrackIndex);
    }
    
    initializePlayer() {
        // Crea il player HTML se non esiste
        if (!document.getElementById('music-player')) {
            this.createPlayerHTML();
        }
        
        // Imposta il volume iniziale
        this.audio.volume = this.volume;
        
        // Gestisce la fine della canzone
        this.audio.addEventListener('ended', () => {
            this.nextTrack();
        });
        
        // Gestisce gli errori di caricamento
        this.audio.addEventListener('error', (e) => {
            console.error('Errore nel caricamento della canzone:', e);
            this.nextTrack(); // Passa alla prossima canzone
        });
        
        // Avvia automaticamente la riproduzione
        this.startAutoPlay();
    }
    
    createPlayerHTML() {
        const playerHTML = `
            <div id="music-player" class="music-player">
                <div class="music-controls">
                    <button id="prev-btn" class="control-btn" title="Precedente">
                        <i class="fas fa-step-backward"></i>
                    </button>
                    <button id="play-pause-btn" class="control-btn play-btn" title="Play/Pause">
                        <i class="fas fa-play"></i>
                    </button>
                    <button id="next-btn" class="control-btn" title="Successiva">
                        <i class="fas fa-step-forward"></i>
                    </button>
                </div>
                <div class="volume-control">
                    <button id="mute-btn" class="control-btn" title="Muto">
                        <i class="fas fa-volume-up"></i>
                    </button>
                    <input type="range" id="volume-slider" min="0" max="100" value="50" class="volume-slider">
                </div>
            </div>
        `;
        
        // Inserisci nel footer invece che nel body
        const footer = document.querySelector('footer');
        if (footer) {
            footer.insertAdjacentHTML('beforeend', playerHTML);
        } else {
            document.body.insertAdjacentHTML('beforeend', playerHTML);
        }
    }
    
    setupEventListeners() {
        // Play/Pause
        document.getElementById('play-pause-btn').addEventListener('click', () => {
            this.togglePlayPause();
        });
        
        // Precedente
        document.getElementById('prev-btn').addEventListener('click', () => {
            this.previousTrack();
        });
        
        // Successiva
        document.getElementById('next-btn').addEventListener('click', () => {
            this.nextTrack();
        });
        
        // Volume
        document.getElementById('volume-slider').addEventListener('input', (e) => {
            this.setVolume(e.target.value / 100);
        });
        
        // Muto
        document.getElementById('mute-btn').addEventListener('click', () => {
            this.toggleMute();
        });
        
        // Aggiorna progresso (rimosso per player semplificato)
        // this.audio.addEventListener('timeupdate', () => {
        //     this.updateProgress();
        // });
        
        // Gestisce i tasti da tastiera
        document.addEventListener('keydown', (e) => {
            this.handleKeyboardControls(e);
        });
    }
    
    loadTrack(index) {
        if (index >= 0 && index < this.playlist.length) {
            this.currentTrackIndex = index;
            const trackPath = `styles/music/${this.playlist[index]}`;
            
            // Carica la canzone solo se è diversa da quella attuale
            if (this.audio.src !== window.location.origin + '/' + trackPath) {
                this.audio.src = trackPath;
                this.audio.load();
            }
            
            // Se era in riproduzione, continua a riprodurre
            if (this.isPlaying) {
                this.audio.play().catch(e => {
                    console.error('Errore nella riproduzione:', e);
                });
            }
            
            this.updateState();
        }
    }
    
    togglePlayPause() {
        if (this.isPlaying) {
            this.pause();
        } else {
            this.play();
        }
    }
    
    play() {
        this.audio.play().then(() => {
            this.isPlaying = true;
            this.updatePlayButton();
            this.updateState();
        }).catch(e => {
            console.error('Errore nella riproduzione:', e);
        });
    }
    
    pause() {
        this.audio.pause();
        this.isPlaying = false;
        this.updatePlayButton();
        this.updateState();
    }
    
    nextTrack() {
        let nextIndex = this.currentTrackIndex + 1;
        if (nextIndex >= this.playlist.length) {
            nextIndex = 0; // Torna alla prima canzone (Overtaken)
        }
        this.loadTrack(nextIndex);
    }
    
    previousTrack() {
        let prevIndex = this.currentTrackIndex - 1;
        if (prevIndex < 0) {
            prevIndex = this.playlist.length - 1; // Vai all'ultima canzone
        }
        this.loadTrack(prevIndex);
    }
    
    setVolume(volume) {
        this.volume = volume;
        this.audio.volume = volume;
        this.updateVolumeButton();
        this.updateState();
    }
    
    toggleMute() {
        if (this.audio.volume > 0) {
            this.audio.volume = 0;
            document.getElementById('volume-slider').value = 0;
        } else {
            this.audio.volume = this.volume;
            document.getElementById('volume-slider').value = this.volume * 100;
        }
        this.updateVolumeButton();
    }
    
    updatePlayButton() {
        const btn = document.getElementById('play-pause-btn');
        const icon = btn.querySelector('i');
        
        if (this.isPlaying) {
            icon.className = 'fas fa-pause';
            btn.title = 'Pausa';
        } else {
            icon.className = 'fas fa-play';
            btn.title = 'Play';
        }
    }
    
    updateVolumeButton() {
        const btn = document.getElementById('mute-btn');
        const icon = btn.querySelector('i');
        
        if (this.audio.volume === 0) {
            icon.className = 'fas fa-volume-mute';
            btn.title = 'Riattiva Audio';
        } else if (this.audio.volume < 0.5) {
            icon.className = 'fas fa-volume-down';
            btn.title = 'Volume Basso';
        } else {
            icon.className = 'fas fa-volume-up';
            btn.title = 'Volume Alto';
        }
    }
    
    // Metodi rimossi per player semplificato
    // updateProgress() e togglePlayerVisibility() non più necessari
    
    handleKeyboardControls(e) {
        // Controlli da tastiera solo se non si sta scrivendo in un input
        if (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA') {
            return;
        }
        
        switch(e.code) {
            case 'Space':
                e.preventDefault();
                this.togglePlayPause();
                this.showToast('Spazio: Play/Pause');
                break;
            case 'ArrowLeft':
                e.preventDefault();
                this.previousTrack();
                this.showToast('← Precedente');
                break;
            case 'ArrowRight':
                e.preventDefault();
                this.nextTrack();
                this.showToast('→ Successiva');
                break;
            case 'KeyM':
                e.preventDefault();
                this.toggleMute();
                this.showToast('M: Muto');
                break;
        }
    }
    
    showToast(message) {
        // Crea un toast temporaneo per mostrare i controlli da tastiera
        const toast = document.createElement('div');
        toast.className = 'music-toast';
        toast.textContent = message;
        document.body.appendChild(toast);
        
        // Mostra il toast
        setTimeout(() => toast.classList.add('show'), 100);
        
        // Nascondi e rimuovi il toast dopo 2 secondi
        setTimeout(() => {
            toast.classList.remove('show');
            setTimeout(() => document.body.removeChild(toast), 300);
        }, 2000);
    }
    
    // Metodo pubblico per iniziare la riproduzione
    startPlayback() {
        this.play();
    }
    
    // Metodo pubblico per fermare la riproduzione
    stopPlayback() {
        this.pause();
    }
    
    // Metodo per avviare automaticamente la riproduzione
    startAutoPlay() {
        // Piccolo delay per assicurarsi che il browser permetta l'autoplay
        setTimeout(() => {
            this.play().catch(e => {
                console.log('Autoplay non permesso dal browser:', e);
                // Se l'autoplay non è permesso, mostra un messaggio
                this.showToast('Clicca Play per iniziare la musica');
                
                // Aggiungi listener per il primo click dell'utente
                const startPlaybackOnInteraction = () => {
                    this.play().catch(e => console.log('Errore riproduzione:', e));
                    document.removeEventListener('click', startPlaybackOnInteraction);
                    document.removeEventListener('keydown', startPlaybackOnInteraction);
                };
                
                document.addEventListener('click', startPlaybackOnInteraction, { once: true });
                document.addEventListener('keydown', startPlaybackOnInteraction, { once: true });
            });
        }, 1000);
    }
    
    // Salva lo stato nel localStorage
    saveState() {
        const state = {
            isPlaying: this.isPlaying,
            currentTrackIndex: this.currentTrackIndex,
            volume: this.volume,
            currentTime: this.audio.currentTime
        };
        localStorage.setItem('musicPlayerState', JSON.stringify(state));
    }
    
    // Ripristina lo stato dal localStorage
    restoreState() {
        try {
            const savedState = localStorage.getItem('musicPlayerState');
            if (savedState) {
                const state = JSON.parse(savedState);
                this.isPlaying = state.isPlaying || false;
                this.currentTrackIndex = state.currentTrackIndex || 0;
                this.volume = state.volume || 0.5;
                
                // Ripristina il volume
                this.audio.volume = this.volume;
                
                // Se era in riproduzione, riavvia automaticamente
                if (this.isPlaying) {
                    setTimeout(() => {
                        this.play().catch(e => {
                            console.log('Autoplay non permesso dal browser:', e);
                            this.isPlaying = false;
                        });
                    }, 500);
                }
            }
        } catch (e) {
            console.error('Errore nel ripristino dello stato:', e);
        }
    }
    
    // Aggiorna lo stato quando cambia
    updateState() {
        this.saveState();
    }
    
    // Aggiorna solo l'UI senza reinizializzare l'audio
    updateUI() {
        // Aggiorna i controlli UI
        this.updatePlayButton();
        this.updateVolumeButton();
        
        // Aggiorna il volume slider
        const volumeSlider = document.getElementById('volume-slider');
        if (volumeSlider) {
            volumeSlider.value = this.volume * 100;
        }
        
        // Se il player HTML non esiste, crealo
        if (!document.getElementById('music-player')) {
            this.createPlayerHTML();
            this.setupEventListeners();
        }
    }
}

// Inizializza il player quando il DOM è caricato
document.addEventListener('DOMContentLoaded', () => {
    // Controlla se esiste già un player globale
    if (!window.musicPlayer) {
        window.musicPlayer = new MusicPlayer();
    } else {
        // Se esiste già, aggiorna solo l'UI
        window.musicPlayer.updateUI();
    }
    
    // Salva lo stato del player nel localStorage prima di lasciare la pagina
    window.addEventListener('beforeunload', () => {
        if (window.musicPlayer) {
            window.musicPlayer.saveState();
        }
    });
    
    // Salva lo stato anche quando si naviga via JavaScript
    window.addEventListener('pagehide', () => {
        if (window.musicPlayer) {
            window.musicPlayer.saveState();
        }
    });
    
    // Previeni la distruzione del player durante la navigazione
    window.addEventListener('unload', (e) => {
        if (window.musicPlayer) {
            window.musicPlayer.saveState();
        }
    });
});