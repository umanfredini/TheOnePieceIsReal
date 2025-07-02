package com.onepiece.model;

import java.sql.Timestamp;

public class User {
    private int id;
    private String username;
    private String email;
    private String passwordHash;
    private String role;
    private boolean isActive;
    private String shippingAddress;
    private Timestamp createdAt;
    private Timestamp lastLogin;

    public User(int id, String email, String passwordHash, String username, String role, boolean isActive, String shippingAddress, Timestamp createdAt, Timestamp lastLogin) {
        this.id = id;
        this.email = email;
        this.passwordHash = passwordHash;
        this.username = username;
        this.role = role;
        this.isActive = isActive;
        this.shippingAddress = shippingAddress;
        this.createdAt = createdAt;
        this.lastLogin = lastLogin;
    }
    
    // Costruttore vuoto
    public User() {}

    // Getters e Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }
    
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    
    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
    
    public String getShippingAddress() { return shippingAddress; }
    public void setShippingAddress(String shippingAddress) { this.shippingAddress = shippingAddress; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public Timestamp getLastLogin() { return lastLogin; }
    public void setLastLogin(Timestamp lastLogin) { this.lastLogin = lastLogin; }
}