package com.onepiece.model;

import java.math.BigDecimal;

public class OrderItem {
    private int id;
    private int orderId;
    private int productId;
    private Integer variantId;
    private String variantName;
    private BigDecimal unitPrice;
    private int quantity;

    public OrderItem(int id, int orderId, int productId, Integer variantId, String variantName, BigDecimal unitPrice, int quantity) {
        this.id = id;
        this.orderId = orderId;
        this.productId = productId;
        this.variantId = variantId;
        this.variantName = variantName;
        this.unitPrice = unitPrice;
        this.quantity = quantity;
    }
    
    // Getters e Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }
    
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    
    public Integer getVariantId() { return variantId; }
    public void setVariantId(Integer variantId) { this.variantId = variantId; }
    
    public String getVariantName() { return variantName; }
    public void setVariantName(String variantName) { this.variantName = variantName; }
    
    public BigDecimal getUnitPrice() { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice) { this.unitPrice = unitPrice; }
    
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
}