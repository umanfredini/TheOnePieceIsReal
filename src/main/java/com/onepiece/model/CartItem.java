package model;

import java.sql.Timestamp;

public class CartItem {
    private int id;
    private int cartId;
    private int productId;
    private Integer variantId;
    private int quantity;
    private Timestamp addedAt;
    private Product product;

    public CartItem(int id, int cartId, int productId, Integer variantId, int quantity, Timestamp addedAt, Product product) {
        this.id = id;
        this.cartId = cartId;
        this.productId = productId;
        this.variantId = variantId;
        this.quantity = quantity;
        this.addedAt = addedAt;
        this.product = product;
    }
    
    public CartItem(int id, int cartId, Product prodotto, int quantity, String taglia) {
        this.id = id;
        this.cartId = cartId;
        this.productId = prodotto.getId();
        this.variantId = taglia != null ? taglia.hashCode() : null;
        this.quantity = quantity;
        this.addedAt = new Timestamp(System.currentTimeMillis());
    }
    
    // Getters e Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getCartId() { return cartId; }
    public void setCartId(int cartId) { this.cartId = cartId; }
    
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    
    public Integer getVariantId() { return variantId; }
    public void setVariantId(Integer variantId) { this.variantId = variantId; }
    
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    
    public Timestamp getAddedAt() { return addedAt; }
    public void setAddedAt(Timestamp addedAt) { this.addedAt = addedAt; }
    
    public Product getProduct() {return product;}
    public void setProduct(Product product) {this.product = product;}

}

