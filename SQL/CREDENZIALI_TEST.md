# Credenziali di Test per TheOnePieceIsReal

## Amministratori

| Email | Username | Password | Indirizzo | Ruolo |
|-------|----------|----------|-----------|-------|
| admin@onepiece.com | admin | admin | Grand Line, New World | Amministratore |
| luffy.admin@onepiece.com | luffy_admin | admin | Thousand Sunny, Grand Line | Amministratore |
| zoro.admin@onepiece.com | zoro_admin | admin | Thousand Sunny, Grand Line | Amministratore |

## Utenti Normali (Password: "password")

### Personaggi One Piece
| Email | Username | Indirizzo | Stato |
|-------|----------|-----------|-------|
| nami@onepiece.com | nami | Cocoyasi Village, East Blue | Attivo |
| sanji@onepiece.com | sanji | Baratie, East Blue | Attivo |
| chopper@onepiece.com | chopper | Drum Island, Grand Line | Attivo |
| robin@onepiece.com | robin | Ohara, West Blue | Attivo |
| franky@onepiece.com | franky | Water 7, Grand Line | Attivo |
| brook@onepiece.com | brook | Thriller Bark, Grand Line | Attivo |
| jinbei@onepiece.com | jinbei | Fish-Man Island, Grand Line | Attivo |

### Utenti Inattivi
| Email | Username | Indirizzo | Stato |
|-------|----------|-----------|-------|
| ace@onepiece.com | ace | Marineford, Grand Line | Inattivo |
| sabo@onepiece.com | sabo | Baltigo, Grand Line | Inattivo |

### Utenti con Nomi Realistici
| Email | Username | Indirizzo | Stato |
|-------|----------|-----------|-------|
| mario.rossi@email.com | mario_rossi | Via Roma 123, Milano | Attivo |
| giulia.bianchi@email.com | giulia_bianchi | Corso Italia 456, Roma | Attivo |
| luca.verdi@email.com | luca_verdi | Piazza Duomo 789, Firenze | Attivo |
| anna.neri@email.com | anna_neri | Via Garibaldi 321, Napoli | Attivo |
| marco.ferrari@email.com | marco_ferrari | Corso Vittorio Emanuele 654, Torino | Attivo |

## Note Tecniche

- **Password Hash**: Tutte le password sono codificate con SHA-256
- **Hash "admin"**: `8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918`
- **Hash "password"**: `5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8`
- **Database**: `onepiece`
- **Tabella**: `users`

## Utilizzo

1. Eseguire lo script `Popolamento_Utenti_Test.sql`
2. Utilizzare le credenziali sopra per testare le funzionalità admin
3. Gli utenti inattivi possono essere utilizzati per testare la gestione degli stati utente
4. Gli utenti con nomi realistici sono utili per testare la ricerca e filtri

## Funzionalità Testabili

- **Login Admin**: Usare admin@onepiece.com / admin
- **Gestione Utenti**: Visualizzare, attivare/disattivare utenti
- **Gestione Ordini**: Creare ordini con diversi utenti
- **Dashboard**: Visualizzare statistiche con dati reali
- **Ricerca Utenti**: Testare filtri e ricerca
