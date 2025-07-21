package model;

import java.math.BigDecimal;

public class ProductVariant {
    private int id;
    private int productId;
    private String variantName;
    private String variantType; // "color" per maglie, "size" per cosplay
    private int stockQuantity;
    private BigDecimal priceModifier; // Modificatore di prezzo per la variante
    
    // Costruttori
    public ProductVariant() {}
    
    public ProductVariant(int productId, String variantName, String variantType, int stockQuantity, BigDecimal priceModifier) {
        this.productId = productId;
        this.variantName = variantName;
        this.variantType = variantType;
        this.stockQuantity = stockQuantity;
        this.priceModifier = priceModifier;
    }
    
    public ProductVariant(int id, int productId, String variantName, String variantType, int stockQuantity, BigDecimal priceModifier) {
        this.id = id;
        this.productId = productId;
        this.variantName = variantName;
        this.variantType = variantType;
        this.stockQuantity = stockQuantity;
        this.priceModifier = priceModifier;
    }
    
    // Getters e Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getProductId() {
        return productId;
    }
    
    public void setProductId(int productId) {
        this.productId = productId;
    }
    
    public String getVariantName() {
        return variantName;
    }
    
    public void setVariantName(String variantName) {
        this.variantName = variantName;
    }
    
    public String getVariantType() {
        return variantType;
    }
    
    public void setVariantType(String variantType) {
        this.variantType = variantType;
    }
    
    public int getStockQuantity() {
        return stockQuantity;
    }
    
    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }
    
    public BigDecimal getPriceModifier() {
        return priceModifier;
    }
    
    public void setPriceModifier(BigDecimal priceModifier) {
        this.priceModifier = priceModifier;
    }
    
    // Metodi di utilità
    public boolean isColorVariant() {
        return "color".equals(variantType);
    }
    
    public boolean isSizeVariant() {
        return "size".equals(variantType);
    }
    
    public boolean isAvailable() {
        return stockQuantity > 0;
    }
    
    public boolean hasStock(int quantity) {
        return stockQuantity >= quantity;
    }
    
    // Metodi per calcolo prezzo
    public BigDecimal getFinalPrice(BigDecimal basePrice) {
        if (priceModifier != null) {
            return basePrice.add(priceModifier);
        }
        return basePrice;
    }
    
    // Override di toString per debug
    @Override
    public String toString() {
        return "ProductVariant{" +
                "id=" + id +
                ", productId=" + productId +
                ", variantName='" + variantName + '\'' +
                ", variantType='" + variantType + '\'' +
                ", stockQuantity=" + stockQuantity +
                ", priceModifier=" + priceModifier +
                '}';
    }
    
    // Override di equals e hashCode
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        
        ProductVariant that = (ProductVariant) o;
        
        if (id != that.id) return false;
        if (productId != that.productId) return false;
        if (stockQuantity != that.stockQuantity) return false;
        if (variantName != null ? !variantName.equals(that.variantName) : that.variantName != null) return false;
        if (variantType != null ? !variantType.equals(that.variantType) : that.variantType != null) return false;
        return priceModifier != null ? priceModifier.equals(that.priceModifier) : that.priceModifier == null;
    }
    
    @Override
    public int hashCode() {
        int result = id;
        result = 31 * result + productId;
        result = 31 * result + (variantName != null ? variantName.hashCode() : 0);
        result = 31 * result + (variantType != null ? variantType.hashCode() : 0);
        result = 31 * result + stockQuantity;
        result = 31 * result + (priceModifier != null ? priceModifier.hashCode() : 0);
        return result;
    }
}