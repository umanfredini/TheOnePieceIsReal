package com.onepiece.model;

public class UserSettings {
    private int userId;
    private String settingKey;
    private String settingValue;

    // Costruttori
    public UserSettings() {}
    
    public UserSettings(int userId, String settingKey, String settingValue) {
        this.userId = userId;
        this.settingKey = settingKey;
        this.settingValue = settingValue;
    }

    // Getters e Setters
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getSettingKey() { return settingKey; }
    public void setSettingKey(String settingKey) { this.settingKey = settingKey; }
    
    public String getSettingValue() { return settingValue; }
    public void setSettingValue(String settingValue) { this.settingValue = settingValue; }
}