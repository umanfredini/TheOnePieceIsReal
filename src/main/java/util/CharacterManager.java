package util;

import java.util.*;
import java.util.stream.Collectors;

/**
 * Classe per gestire i personaggi associati ai prodotti
 * Gestisce il parsing del campo is_featured che contiene i nomi dei personaggi
 */
public class CharacterManager {
    
    private static final String CHARACTER_SEPARATOR = ", ";
    
    /**
     * Converte una stringa di personaggi in una lista
     * @param charactersString Stringa con personaggi separati da virgola (es: "Luffy, Ace, Sabo")
     * @return Lista di nomi dei personaggi
     */
    public static List<String> parseCharacters(String charactersString) {
        if (charactersString == null || charactersString.trim().isEmpty()) {
            return new ArrayList<>();
        }
        
        return Arrays.stream(charactersString.split(CHARACTER_SEPARATOR))
                .map(String::trim)
                .filter(name -> !name.isEmpty())
                .collect(Collectors.toList());
    }
    
    /**
     * Converte una lista di personaggi in una stringa
     * @param characters Lista di nomi dei personaggi
     * @return Stringa con personaggi separati da virgola
     */
    public static String formatCharacters(List<String> characters) {
        if (characters == null || characters.isEmpty()) {
            return null;
        }
        
        return characters.stream()
                .filter(name -> name != null && !name.trim().isEmpty())
                .sorted()
                .collect(Collectors.joining(CHARACTER_SEPARATOR));
    }
    
    /**
     * Verifica se un prodotto ha più di un personaggio (è featured)
     * @param charactersString Stringa con personaggi
     * @return true se il prodotto ha più di un personaggio
     */
    public static boolean isFeatured(String charactersString) {
        List<String> characters = parseCharacters(charactersString);
        return characters.size() > 1;
    }
    
    /**
     * Conta il numero di personaggi associati
     * @param charactersString Stringa con personaggi
     * @return Numero di personaggi
     */
    public static int getCharacterCount(String charactersString) {
        return parseCharacters(charactersString).size();
    }
    
    /**
     * Verifica se un prodotto contiene un personaggio specifico
     * @param charactersString Stringa con personaggi
     * @param characterName Nome del personaggio da cercare
     * @return true se il personaggio è presente
     */
    public static boolean containsCharacter(String charactersString, String characterName) {
        if (characterName == null || characterName.trim().isEmpty()) {
            return false;
        }
        
        List<String> characters = parseCharacters(charactersString);
        return characters.stream()
                .anyMatch(name -> name.equalsIgnoreCase(characterName.trim()));
    }
    
    /**
     * Trova tutti i personaggi che iniziano con un prefisso
     * @param charactersString Stringa con personaggi
     * @param prefix Prefisso da cercare
     * @return Lista di personaggi che iniziano con il prefisso
     */
    public static List<String> findCharactersByPrefix(String charactersString, String prefix) {
        if (prefix == null || prefix.trim().isEmpty()) {
            return new ArrayList<>();
        }
        
        List<String> characters = parseCharacters(charactersString);
        return characters.stream()
                .filter(name -> name.toLowerCase().startsWith(prefix.toLowerCase()))
                .collect(Collectors.toList());
    }
    
    /**
     * Ottiene il personaggio principale (il primo nella lista)
     * @param charactersString Stringa con personaggi
     * @return Nome del personaggio principale o null se vuoto
     */
    public static String getPrimaryCharacter(String charactersString) {
        List<String> characters = parseCharacters(charactersString);
        return characters.isEmpty() ? null : characters.get(0);
    }
    
    /**
     * Ottiene tutti i personaggi tranne quello principale
     * @param charactersString Stringa con personaggi
     * @return Lista di personaggi secondari
     */
    public static List<String> getSecondaryCharacters(String charactersString) {
        List<String> characters = parseCharacters(charactersString);
        if (characters.size() <= 1) {
            return new ArrayList<>();
        }
        return characters.subList(1, characters.size());
    }
    
    /**
     * Crea una descrizione leggibile dei personaggi
     * @param charactersString Stringa con personaggi
     * @return Descrizione formattata (es: "Luffy, Ace e Sabo")
     */
    public static String getFormattedDescription(String charactersString) {
        List<String> characters = parseCharacters(charactersString);
        
        if (characters.isEmpty()) {
            return "Nessun personaggio associato";
        } else if (characters.size() == 1) {
            return characters.get(0);
        } else if (characters.size() == 2) {
            return characters.get(0) + " e " + characters.get(1);
        } else {
            String lastCharacter = characters.get(characters.size() - 1);
            List<String> otherCharacters = characters.subList(0, characters.size() - 1);
            return String.join(", ", otherCharacters) + " e " + lastCharacter;
        }
    }
    
    /**
     * Verifica se due prodotti hanno personaggi in comune
     * @param characters1 Stringa con personaggi del primo prodotto
     * @param characters2 Stringa con personaggi del secondo prodotto
     * @return true se ci sono personaggi in comune
     */
    public static boolean hasCommonCharacters(String characters1, String characters2) {
        List<String> chars1 = parseCharacters(characters1);
        List<String> chars2 = parseCharacters(characters2);
        
        return chars1.stream().anyMatch(chars2::contains);
    }
    
    /**
     * Ottiene i personaggi in comune tra due prodotti
     * @param characters1 Stringa con personaggi del primo prodotto
     * @param characters2 Stringa con personaggi del secondo prodotto
     * @return Lista di personaggi in comune
     */
    public static List<String> getCommonCharacters(String characters1, String characters2) {
        List<String> chars1 = parseCharacters(characters1);
        List<String> chars2 = parseCharacters(characters2);
        
        return chars1.stream()
                .filter(chars2::contains)
                .collect(Collectors.toList());
    }
    
    /**
     * Crea un tag HTML per mostrare i personaggi
     * @param charactersString Stringa con personaggi
     * @return Tag HTML formattato
     */
    public static String getHtmlTags(String charactersString) {
        List<String> characters = parseCharacters(charactersString);
        
        if (characters.isEmpty()) {
            return "<span class='badge bg-secondary'>Nessun personaggio</span>";
        }
        
        return characters.stream()
                .map(character -> "<span class='badge bg-primary'>" + character + "</span>")
                .collect(Collectors.joining(" "));
    }
    
    /**
     * Crea una classe CSS per il numero di personaggi
     * @param charactersString Stringa con personaggi
     * @return Classe CSS (es: "single-character", "multi-character")
     */
    public static String getCharacterClass(String charactersString) {
        int count = getCharacterCount(charactersString);
        
        if (count == 0) {
            return "no-character";
        } else if (count == 1) {
            return "single-character";
        } else if (count == 2) {
            return "dual-character";
        } else {
            return "multi-character";
        }
    }
    
    /**
     * Valida se una stringa di personaggi è nel formato corretto
     * @param charactersString Stringa da validare
     * @return true se il formato è valido
     */
    public static boolean isValidFormat(String charactersString) {
        if (charactersString == null) {
            return true; // NULL è valido
        }
        
        // Verifica che non ci siano virgole consecutive
        if (charactersString.contains(",,")) {
            return false;
        }
        
        // Verifica che non inizi o finisca con virgola
        if (charactersString.startsWith(",") || charactersString.endsWith(",")) {
            return false;
        }
        
        // Verifica che i nomi non siano vuoti
        List<String> characters = parseCharacters(charactersString);
        return characters.stream().allMatch(name -> !name.trim().isEmpty());
    }
    
    /**
     * Ottiene tutti i nomi dei personaggi disponibili dal database
     * @return Lista di tutti i nomi dei personaggi
     */
    public static List<String> getAllCharacterNames() {
        // Lista hardcoded dei personaggi disponibili nel database
        return Arrays.asList(
            "Luffy", "Zoro", "Nami", "Usopp", "Sanji", "Chopper", "Robin", "Franky", "Brook", "Jinbei",
            "Ace", "Sabo", "Law", "Kidd", "Shanks", "Barbabianca", "Barbanera", "Kaido", "Roger"
        );
    }
    
    /**
     * Alias per parseCharacters per compatibilità
     * @param charactersString Stringa con personaggi
     * @return Lista di nomi dei personaggi
     */
    public static List<String> parseCharacterNames(String charactersString) {
        return parseCharacters(charactersString);
    }
} 