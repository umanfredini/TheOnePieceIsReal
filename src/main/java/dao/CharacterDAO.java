package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import model.Character;
import util.DBConnection;

public class CharacterDAO {
    private final Connection connection;

    public CharacterDAO(Connection connection) {
        this.connection = connection;
    }
    
    public CharacterDAO() throws SQLException {
        this.connection = DBConnection.getConnection();
    }

    public boolean create(Character character) throws SQLException {
        String sql = "INSERT INTO characters (name, description, image_url) VALUES (?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, character.getName());
            stmt.setString(2, character.getDescription());
            stmt.setString(3, character.getImageUrl());
            int rowsInserted = stmt.executeUpdate();
            return rowsInserted > 0;
        }
    }

    public Character read(int id) throws SQLException {
        String sql = "SELECT * FROM characters WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return extractCharacter(rs);
            }
        }
        return null;
    }

    public Character findByName(String name) throws SQLException {
        String sql = "SELECT * FROM characters WHERE name = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, name);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return extractCharacter(rs);
            }
        }
        return null;
    }

    public boolean update(Character character) throws SQLException {
        String sql = "UPDATE characters SET name = ?, description = ?, image_url = ? WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, character.getName());
            stmt.setString(2, character.getDescription());
            stmt.setString(3, character.getImageUrl());
            stmt.setInt(4, character.getId());
            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM characters WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    public List<Character> findAll() throws SQLException {
        List<Character> characters = new ArrayList<>();
        String sql = "SELECT * FROM characters ORDER BY name";
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                characters.add(extractCharacter(rs));
            }
        }
        return characters;
    }

    public List<Character> findByProductId(int productId) throws SQLException {
        List<Character> characters = new ArrayList<>();
        String sql = "SELECT c.* FROM characters c " +
                     "JOIN product_characters pc ON c.id = pc.character_id " +
                     "WHERE pc.product_id = ? " +
                     "ORDER BY pc.is_primary DESC, c.name";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                characters.add(extractCharacter(rs));
            }
        }
        return characters;
    }

    public List<Character> findPrimaryByProductId(int productId) throws SQLException {
        List<Character> characters = new ArrayList<>();
        String sql = "SELECT c.* FROM characters c " +
                     "JOIN product_characters pc ON c.id = pc.character_id " +
                     "WHERE pc.product_id = ? AND pc.is_primary = TRUE " +
                     "ORDER BY c.name";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                characters.add(extractCharacter(rs));
            }
        }
        return characters;
    }

    public boolean addCharacterToProduct(int characterId, int productId, boolean isPrimary) throws SQLException {
        String sql = "INSERT INTO product_characters (product_id, character_id, is_primary) VALUES (?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            stmt.setInt(2, characterId);
            stmt.setBoolean(3, isPrimary);
            int rowsInserted = stmt.executeUpdate();
            return rowsInserted > 0;
        }
    }

    public boolean removeCharacterFromProduct(int characterId, int productId) throws SQLException {
        String sql = "DELETE FROM product_characters WHERE product_id = ? AND character_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            stmt.setInt(2, characterId);
            int rowsDeleted = stmt.executeUpdate();
            return rowsDeleted > 0;
        }
    }

    public List<Character> searchByName(String searchTerm) throws SQLException {
        List<Character> characters = new ArrayList<>();
        String sql = "SELECT * FROM characters WHERE name LIKE ? ORDER BY name";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, "%" + searchTerm + "%");
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                characters.add(extractCharacter(rs));
            }
        }
        return characters;
    }

    private Character extractCharacter(ResultSet rs) throws SQLException {
        return new Character(
            rs.getInt("id"),
            rs.getString("name"),
            rs.getString("description"),
            rs.getString("image_url")
        );
    }
} 