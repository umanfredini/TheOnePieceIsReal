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
        logger.info("Tentativo di connessione tramite DataSource...");
        
        try {
            Connection conn = dataSource.getConnection();
            logger.info("Connessione al database riuscita tramite DataSource!");
            return conn;
        } catch (SQLException e) {
            logger.severe("Errore di connessione al database: " + e.getMessage());
            throw e;
        }
    }
}