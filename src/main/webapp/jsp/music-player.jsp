<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Background Music Player -->
<div class="background-music-player" id="backgroundMusicPlayer">
    <div class="music-controls">
        <button class="music-btn" id="playPauseBtn" title="Play/Pause">
            <i class="fas fa-play" id="playPauseIcon"></i>
        </button>
        
        <div class="music-info">
            <p class="music-title">One Piece OST</p>
            <p class="music-status" id="musicStatus">Caricamento...</p>
        </div>
        
        <div class="volume-control">
            <i class="fas fa-volume-down" style="color: #FFD700; font-size: 12px;"></i>
            <input type="range" class="volume-slider" id="volumeSlider" min="0" max="100" value="30" title="Volume">
            <i class="fas fa-volume-up" style="color: #FFD700; font-size: 12px;"></i>
        </div>
        
        <div class="music-indicator" id="musicIndicator"></div>
    </div>
</div>

<script>
// Inizializza i controlli del player musicale
document.addEventListener('DOMContentLoaded', function() {
    const playPauseBtn = document.getElementById('playPauseBtn');
    const playPauseIcon = document.getElementById('playPauseIcon');
    const musicStatus = document.getElementById('musicStatus');
    const volumeSlider = document.getElementById('volumeSlider');
    const musicIndicator = document.getElementById('musicIndicator');
    
    // Aggiorna l'interfaccia quando il player è pronto
    function updatePlayerUI() {
        if (window.backgroundMusicPlayer) {
            const isPlaying = window.backgroundMusicPlayer.isMusicPlaying();
            const volume = Math.round(window.backgroundMusicPlayer.getVolume() * 100);
            
            // Aggiorna icona play/pause
            if (isPlaying) {
                playPauseIcon.className = 'fas fa-pause';
                musicStatus.textContent = 'In riproduzione';
                musicIndicator.classList.remove('paused');
            } else {
                playPauseIcon.className = 'fas fa-play';
                musicStatus.textContent = 'In pausa';
                musicIndicator.classList.add('paused');
            }
            
            // Aggiorna slider volume
            volumeSlider.value = volume;
        }
    }
    
    // Event listener per play/pause
    playPauseBtn.addEventListener('click', function() {
        if (window.backgroundMusicPlayer) {
            if (window.backgroundMusicPlayer.isMusicPlaying()) {
                window.backgroundMusicPlayer.pause();
            } else {
                window.backgroundMusicPlayer.resume();
            }
            updatePlayerUI();
        }
    });
    
    // Event listener per volume
    volumeSlider.addEventListener('input', function() {
        if (window.backgroundMusicPlayer) {
            const volume = this.value / 100;
            window.backgroundMusicPlayer.setVolume(volume);
        }
    });
    
    // Aggiorna l'interfaccia periodicamente
    setInterval(updatePlayerUI, 1000);
    
    // Aggiorna l'interfaccia quando il player è inizializzato
    setTimeout(updatePlayerUI, 2000);
});
</script>
