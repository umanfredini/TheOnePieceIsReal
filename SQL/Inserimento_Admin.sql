-- Script per inserire l'amministratore nel database
-- Username: admin
-- Password: admin (criptata con SHA-256)
-- Hash SHA-256 di "admin": 8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918

USE onepiece;

-- Inserimento dell'amministratore
INSERT INTO users (
    email, 
    password_hash, 
    username, 
    is_admin, 
    is_active, 
    shipping_address
) VALUES (
    'admin@onepiece.com',
    '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918',
    'admin',
    TRUE,
    TRUE,
    'Indirizzo amministratore - The One Piece is Real'
);

-- Verifica dell'inserimento
SELECT 
    id,
    email,
    username,
    is_admin,
    is_active,
    created_at
FROM users 
WHERE username = 'admin';
