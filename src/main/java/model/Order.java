package model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;

public class Order {
    private int id;
    private int userId;
    private String userEmail;
    private BigDecimal totalPrice;
    private Timestamp orderDate;
    private String shippingAddress;
    private String paymentMethod;
    private String status;
    private String trackingNumber;
    private String notes;
    private List<OrderItem> items;

    public Order(int id, int userId, BigDecimal totalprice, String shippingAddress, String paymentMethod, String status, String trackingnumber, String note, Timestamp orderDate, List<OrderItem> items) {
        this.id = id;
        this.userId = userId;
        this.shippingAddress = shippingAddress;
        this.paymentMethod = paymentMethod;
        this.status = status;
        this.orderDate = orderDate;
        this.items = items;
        this.totalPrice = totalprice;
        this.trackingNumber = trackingnumber;
        this.notes = note;
    }
    
    public Order(int id, int userId, String userEmail, BigDecimal totalprice, String shippingAddress, String paymentMethod, String status, String trackingnumber, String note, Timestamp orderDate, List<OrderItem> items) {
        this.id = id;
        this.userId = userId;
        this.userEmail = userEmail;
        this.shippingAddress = shippingAddress;
        this.paymentMethod = paymentMethod;
        this.status = status;
        this.orderDate = orderDate;
        this.items = items;
        this.totalPrice = totalprice;
        this.trackingNumber = trackingnumber;
        this.notes = note;
    }
    
    public Order() {
    	this.id = this.userId = 0;
    	this.totalPrice = null;
    	this.orderDate = null;
    	this.shippingAddress = this.paymentMethod = this.notes = this.status = this.trackingNumber = null;
    	this.items = null;
    }

	// Getters e Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getUserEmail() { return userEmail; }
    public void setUserEmail(String userEmail) { this.userEmail = userEmail; }
    
    public BigDecimal getTotalPrice() { return totalPrice; }
    public void setTotalPrice(BigDecimal totalPrice) { this.totalPrice = totalPrice; }
    
    public Timestamp getOrderDate() { return orderDate; }
    public void setOrderDate(Timestamp orderDate) { this.orderDate = orderDate; }
    
    public String getShippingAddress() { return shippingAddress; }
    public void setShippingAddress(String shippingAddress) { this.shippingAddress = shippingAddress; }
    
    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public String getTrackingNumber() { return trackingNumber; }
    public void setTrackingNumber(String trackingNumber) { this.trackingNumber = trackingNumber; }
    
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
    
    public List<OrderItem> getItems() { return items; }
    public void setItems(List<OrderItem> items) { this.items = items; }
}