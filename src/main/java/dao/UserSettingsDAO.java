package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import model.UserSettings;
import util.DBConnection;

public class UserSettingsDAO {
    private final Connection connection;

    public UserSettingsDAO(Connection connection) {
        this.connection = connection;
    }
    
    public UserSettingsDAO() throws SQLException {
    	this.connection = DBConnection.getConnection();
    }

    public void save(UserSettings setting) throws SQLException {
        String sql = "REPLACE INTO user_settings (user_id, setting_key, setting_value) VALUES (?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, setting.getUserId());
            stmt.setString(2, setting.getSettingKey());
            stmt.setString(3, setting.getSettingValue());
            stmt.executeUpdate();
        }
    }

    public List<UserSettings> findByUserId(int userId) throws SQLException {
        List<UserSettings> settings = new ArrayList<>();
        String sql = "SELECT * FROM user_settings WHERE user_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                settings.add(new UserSettings(
                        rs.getInt("user_id"),
                        rs.getString("setting_key"),
                        rs.getString("setting_value")
                ));
            }
        }
        return settings;
    }

    public void delete(int userId, String settingKey) throws SQLException {
        String sql = "DELETE FROM user_settings WHERE user_id = ? AND setting_key = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setString(2, settingKey);
            stmt.executeUpdate();
        }
    }
}