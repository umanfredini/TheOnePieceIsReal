package model;

import java.sql.Timestamp;

public class GuestCartItem {
    private int id;
    private int guestCartId;
    private int productId;
    private Integer productVariantId;
    private int quantity;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Relazioni
    private Product product;
    private ProductVariant productVariant;

    public GuestCartItem() {}

    public GuestCartItem(int id, int guestCartId, int productId, Integer productVariantId, 
                        int quantity, Timestamp createdAt, Timestamp updatedAt) {
        this.id = id;
        this.guestCartId = guestCartId;
        this.productId = productId;
        this.productVariantId = productVariantId;
        this.quantity = quantity;
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

    public int getGuestCartId() {
        return guestCartId;
    }

    public void setGuestCartId(int guestCartId) {
        this.guestCartId = guestCartId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public Integer getProductVariantId() {
        return productVariantId;
    }

    public void setProductVariantId(Integer productVariantId) {
        this.productVariantId = productVariantId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
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

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public ProductVariant getProductVariant() {
        return productVariant;
    }

    public void setProductVariant(ProductVariant productVariant) {
        this.productVariant = productVariant;
    }

    @Override
    public String toString() {
        return "GuestCartItem{" +
                "id=" + id +
                ", guestCartId=" + guestCartId +
                ", productId=" + productId +
                ", productVariantId=" + productVariantId +
                ", quantity=" + quantity +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
} 