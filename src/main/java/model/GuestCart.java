package model;

import java.sql.Timestamp;

public class GuestCart {
    private int id;
    private String sessionId;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public GuestCart() {}

    public GuestCart(int id, String sessionId, Timestamp createdAt, Timestamp updatedAt) {
        this.id = id;
        this.sessionId = sessionId;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Getters e Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getSessionId() {
        return sessionId;
    }

    public void setSessionId(String sessionId) {
        this.sessionId = sessionId;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    @Override
    public String toString() {
        return "GuestCart{" +
                "id=" + id +
                ", sessionId='" + sessionId + '\'' +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
} 