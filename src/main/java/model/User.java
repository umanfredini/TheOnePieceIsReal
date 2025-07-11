package model;

import java.sql.Timestamp;

public class User {
    private int id;
    private String username;
    private String email;
    private String passwordHash;
    private boolean isAdmin;
    private boolean isActive;
    private String shippingAddress;
    private Timestamp createdAt;
    private Timestamp lastLogin;
    private String avatar;

    public User(int id, String email, String passwordHash, String username, boolean isAdmin, boolean isActive, String shippingAddress, Timestamp createdAt, Timestamp lastLogin, String avatar) {
        this.id = id;
        this.email = email;
        this.passwordHash = passwordHash;
        this.username = username;
        this.isAdmin = isAdmin;
        this.isActive = isActive;
        this.shippingAddress = shippingAddress;
        this.createdAt = createdAt;
        this.lastLogin = lastLogin;
        this.avatar = avatar;
    }
    
    // Costruttore vuoto
    public User() {
    	this.id = -1;
        this.email = this.passwordHash = this.username = this.shippingAddress = null;
        this.isActive = this.isAdmin = false;
        this.createdAt = this.lastLogin = null;
        this.avatar = null;
    }

    // Getters e Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }
    
    public boolean isAdmin() { return isAdmin; }
    public void setAdmin() { isAdmin = true; }
    public void removeAdmin() {isAdmin = false;}
    
    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
    
    public String getShippingAddress() { return shippingAddress; }
    public void setShippingAddress(String shippingAddress) { this.shippingAddress = shippingAddress; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public Timestamp getLastLogin() { return lastLogin; }
    public void setLastLogin(Timestamp lastLogin) { this.lastLogin = lastLogin; }
    
    public String getAvatar() {return avatar;}
    public void setAvatar(String avatar) {this.avatar = avatar;}

}