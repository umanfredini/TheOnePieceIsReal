-- Script per aggiornare la password dell'amministratore
-- Username: admin
-- Password: admin (criptata con SHA-256)
-- Hash SHA-256 di "admin": 8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918

USE onepiece;

-- Aggiorna la password dell'admin
UPDATE users 
SET password_hash = '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918'
WHERE username = 'admin' AND email = 'admin@onepiece.com';

-- Verifica dell'aggiornamento
SELECT 
    id,
    email,
    username,
    password_hash,
    is_admin,
    is_active,
    created_at
FROM users 
WHERE username = 'admin';
