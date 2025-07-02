package com.onepiece.model;

import java.sql.Timestamp;
import java.util.List;

public class Cart {
    private int id;
    private int userId;
    private Timestamp createdAt;
    private Timestamp modifiedAt;
    private List<CartItem> items;

    public Cart(int id, int userId, Timestamp createdAt, Timestamp modifiedAt) {
        this.id = id;
        this.userId = userId;
        this.createdAt = createdAt;
        this.modifiedAt = modifiedAt;
    }
    
    // Getters e Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public Timestamp getModifiedAt() { return modifiedAt; }
    public void setModifiedAt(Timestamp modifiedAt) { this.modifiedAt = modifiedAt; }
    
    public List<CartItem> getItems() { return items; }
    public void setItems(List<CartItem> items) { this.items = items; }
}

