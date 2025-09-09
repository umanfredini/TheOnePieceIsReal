-- Script per popolare il database con utenti e amministratori di test
-- Le password sono codificate con SHA-256 usando lo stesso algoritmo dell'applicazione

USE onepiece;

-- Inserimento utenti di test
INSERT INTO users (email, username, password_hash, shipping_address, is_admin, is_active, created_at) VALUES
-- Amministratori
('luffy.admin@onepiece.com', 'luffy_admin', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'Thousand Sunny, Grand Line', 1, 1, NOW()),
('zoro.admin@onepiece.com', 'zoro_admin', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'Thousand Sunny, Grand Line', 1, 1, NOW()),

-- Utenti normali
('nami@onepiece.com', 'nami', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 'Cocoyasi Village, East Blue', 0, 1, NOW()),
('sanji@onepiece.com', 'sanji', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 'Baratie, East Blue', 0, 1, NOW()),
('chopper@onepiece.com', 'chopper', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 'Drum Island, Grand Line', 0, 1, NOW()),
('robin@onepiece.com', 'robin', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 'Ohara, West Blue', 0, 1, NOW()),
('franky@onepiece.com', 'franky', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 'Water 7, Grand Line', 0, 1, NOW()),
('brook@onepiece.com', 'brook', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 'Thriller Bark, Grand Line', 0, 1, NOW()),
('jinbei@onepiece.com', 'jinbei', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 'Fish-Man Island, Grand Line', 0, 1, NOW()),

-- Utenti inattivi per test
('ace@onepiece.com', 'ace', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 'Marineford, Grand Line', 0, 0, NOW()),
('sabo@onepiece.com', 'sabo', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 'Baltigo, Grand Line', 0, 0, NOW()),

-- Utenti con nomi più realistici per test
('mario.rossi@email.com', 'mario_rossi', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 'Via Roma 123, Milano', 0, 1, NOW()),
('giulia.bianchi@email.com', 'giulia_bianchi', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 'Corso Italia 456, Roma', 0, 1, NOW()),
('luca.verdi@email.com', 'luca_verdi', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 'Piazza Duomo 789, Firenze', 0, 1, NOW()),
('anna.neri@email.com', 'anna_neri', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 'Via Garibaldi 321, Napoli', 0, 1, NOW()),
('marco.ferrari@email.com', 'marco_ferrari', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', 'Corso Vittorio Emanuele 654, Torino', 0, 1, NOW());

-- Verifica degli inserimenti
SELECT 
    id,
    email,
    username,
    shipping_address,
    is_admin,
    is_active,
    created_at
FROM users 
ORDER BY is_admin DESC, created_at ASC;

-- Statistiche finali
SELECT 
    'Totale Utenti' as Tipo,
    COUNT(*) as Quantita
FROM users
UNION ALL
SELECT 
    'Amministratori' as Tipo,
    COUNT(*) as Quantita
FROM users 
WHERE is_admin = 1
UNION ALL
SELECT 
    'Utenti Attivi' as Tipo,
    COUNT(*) as Quantita
FROM users 
WHERE is_active = 1
UNION ALL
SELECT 
    'Utenti Inattivi' as Tipo,
    COUNT(*) as Quantita
FROM users 
WHERE is_active = 0;
