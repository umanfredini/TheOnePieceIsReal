package util;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.logging.Logger;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class DBConnection {
    private static final Logger logger = Logger.getLogger(DBConnection.class.getName());
    private static DataSource dataSource;
    
    static {
        try {
            Context initContext = new InitialContext();
            Context envContext = (Context) initContext.lookup("java:comp/env");
            dataSource = (DataSource) envContext.lookup("jdbc/TheOnePieceIsReal");
            logger.info("DataSource configurato con successo");
        } catch (NamingException e) {
            logger.severe("Errore nella configurazione del DataSource: " + e.getMessage());
            throw new RuntimeException("DataSource non configurato correttamente", e);
        }
    }
    
    public static Connection getConnection() throws SQLException {
        long startTime = System.currentTimeMillis();
        logger.info("Tentativo di connessione tramite DataSource...");
        
        try {
            Connection conn = dataSource.getConnection();
            long endTime = System.currentTimeMillis();
            logger.info("Connessione al database riuscita tramite DataSource! Tempo: " + (endTime - startTime) + "ms");
            return conn;
        } catch (SQLException e) {
            long endTime = System.currentTimeMillis();
            logger.severe("Errore di connessione al database dopo " + (endTime - startTime) + "ms: " + e.getMessage());
            
            // Tentativo di riconnessione se il DataSource è chiuso
            if (e.getMessage().contains("Data source is closed")) {
                logger.info("Tentativo di reinizializzazione del DataSource...");
                try {
                    Context initContext = new InitialContext();
                    Context envContext = (Context) initContext.lookup("java:comp/env");
                    dataSource = (DataSource) envContext.lookup("jdbc/TheOnePieceIsReal");
                    logger.info("DataSource reinizializzato con successo");
                    
                    // Secondo tentativo di connessione
                    long retryStartTime = System.currentTimeMillis();
                    Connection conn = dataSource.getConnection();
                    long retryEndTime = System.currentTimeMillis();
                    logger.info("Connessione riuscita dopo reinizializzazione! Tempo: " + (retryEndTime - retryStartTime) + "ms");
                    return conn;
                } catch (Exception e2) {
                    long retryEndTime = System.currentTimeMillis();
                    logger.severe("Errore nella reinizializzazione del DataSource dopo " + (retryEndTime - startTime) + "ms: " + e2.getMessage());
                }
            }
            
            throw e;
        }
    }
    
    /**
     * Testa la connessione al database e restituisce informazioni sul pool
     */
    public static String testConnection() {
        long startTime = System.currentTimeMillis();
        try {
            Connection conn = getConnection();
            long endTime = System.currentTimeMillis();
            
            // Testa una query semplice
            conn.createStatement().executeQuery("SELECT 1");
            conn.close();
            
            return "Connessione OK - Tempo: " + (endTime - startTime) + "ms";
        } catch (SQLException e) {
            long endTime = System.currentTimeMillis();
            return "Errore connessione dopo " + (endTime - startTime) + "ms: " + e.getMessage();
        }
    }
    
    /**
     * Verifica se il DataSource è disponibile
     */
    public static boolean isDataSourceAvailable() {
        try {
            return dataSource != null;
        } catch (Exception e) {
            logger.warning("DataSource non disponibile: " + e.getMessage());
            return false;
        }
    }
}