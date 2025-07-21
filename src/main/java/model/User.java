package model;

import java.sql.Timestamp;

public class User {
    private int id;
    private String email;
    private String passwordHash;
    private String username;
    private boolean isAdmin;
    private boolean isActive;
    private String shippingAddress;
    private Timestamp createdAt;
    private Timestamp lastLogin;
    private Timestamp deletedAt;

    // Costruttore completo
    public User(int id, String email, String passwordHash, String username, boolean isAdmin, 
                boolean isActive, String shippingAddress, Timestamp createdAt, Timestamp lastLogin) {
        this.id = id;
        this.email = email;
        this.passwordHash = passwordHash;
        this.username = username;
        this.isAdmin = isAdmin;
        this.isActive = isActive;
        this.shippingAddress = shippingAddress;
        this.createdAt = createdAt;
        this.lastLogin = lastLogin;
    }

    // Costruttore per nuovo utente
    public User(String email, String passwordHash, String username) {
        this.email = email;
        this.passwordHash = passwordHash;
        this.username = username;
        this.isAdmin = false;
        this.isActive = true;
        this.createdAt = new Timestamp(System.currentTimeMillis());
    }

    // Costruttore vuoto
    public User() {
    }

    // Getters e Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public boolean isAdmin() { return isAdmin; }
    public void setAdmin(boolean admin) { isAdmin = admin; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }

    public String getShippingAddress() { return shippingAddress; }
    public void setShippingAddress(String shippingAddress) { this.shippingAddress = shippingAddress; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getLastLogin() { return lastLogin; }
    public void setLastLogin(Timestamp lastLogin) { this.lastLogin = lastLogin; }

    public Timestamp getDeletedAt() { return deletedAt; }
    public void setDeletedAt(Timestamp deletedAt) { this.deletedAt = deletedAt; }
}