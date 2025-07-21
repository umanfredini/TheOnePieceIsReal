package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.util.logging.Logger;

public class DBConnection {
    private static final Logger logger = Logger.getLogger(DBConnection.class.getName());
    private static final String URL = "jdbc:mysql://localhost:3306/onepiece?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&autoReconnect=true&useUnicode=true&characterEncoding=UTF-8&zeroDateTimeBehavior=convertToNull";
    private static final String USER = "root";
    private static final String PASSWORD = "Umberto50!";
    
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            logger.info("Driver MySQL caricato con successo");
        } catch (ClassNotFoundException e) {
            logger.severe("Errore nel caricamento del driver MySQL: " + e.getMessage());
            throw new RuntimeException("Driver MySQL non trovato", e);
        }
    }
    
    public static Connection getConnection() throws SQLException {
        logger.info("Tentativo di connessione al database...");
        logger.info("URL: " + URL);
        logger.info("User: " + USER);
        
        try {
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            logger.info("Connessione al database riuscita!");
            return conn;
        } catch (SQLException e) {
            logger.severe("Errore di connessione al database: " + e.getMessage());
            throw e;
        }
    }
    
    // Metodo per chiudere correttamente le connessioni e deregistrare il driver
    public static void cleanup() {
        try {
            // Chiudi il thread di cleanup delle connessioni abbandonate
            com.mysql.cj.jdbc.AbandonedConnectionCleanupThread.checkedShutdown();
            logger.info("Thread di cleanup MySQL chiuso correttamente");
        } catch (InterruptedException e) {
            logger.warning("Errore durante la chiusura del thread di cleanup MySQL: " + e.getMessage());
        }
        
        try {
            // Deregistra il driver MySQL
            java.sql.Driver driver = DriverManager.getDriver(URL);
            DriverManager.deregister(driver);
            logger.info("Driver MySQL deregistrato correttamente");
        } catch (SQLException e) {
            logger.warning("Errore durante la deregistrazione del driver MySQL: " + e.getMessage());
        }
    }
}