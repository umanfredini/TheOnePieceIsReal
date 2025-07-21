-- =====================================================
-- TRIGGERS FINALE - SISTEMA CON VARIANTI
-- =====================================================

USE onepiece;

-- 1. Trigger per aggiornare stock_quantity del prodotto base
DELIMITER //
CREATE TRIGGER update_product_stock_after_variant_change
AFTER UPDATE ON product_variants
FOR EACH ROW
BEGIN
    DECLARE total_stock INT;
    
    -- Calcola il totale dello stock di tutte le varianti
    SELECT SUM(stock_quantity) INTO total_stock
    FROM product_variants 
    WHERE product_id = NEW.product_id;
    
    -- Aggiorna lo stock del prodotto base
    UPDATE products 
    SET stock_quantity = COALESCE(total_stock, 0)
    WHERE id = NEW.product_id;
END//
DELIMITER ;

-- 2. Trigger per aggiornare stock_quantity del prodotto base dopo inserimento variante
DELIMITER //
CREATE TRIGGER update_product_stock_after_variant_insert
AFTER INSERT ON product_variants
FOR EACH ROW
BEGIN
    DECLARE total_stock INT;
    
    -- Calcola il totale dello stock di tutte le varianti
    SELECT SUM(stock_quantity) INTO total_stock
    FROM product_variants 
    WHERE product_id = NEW.product_id;
    
    -- Aggiorna lo stock del prodotto base
    UPDATE products 
    SET stock_quantity = COALESCE(total_stock, 0)
    WHERE id = NEW.product_id;
END//
DELIMITER ;

-- 3. Trigger per aggiornare stock_quantity del prodotto base dopo eliminazione variante
DELIMITER //
CREATE TRIGGER update_product_stock_after_variant_delete
AFTER DELETE ON product_variants
FOR EACH ROW
BEGIN
    DECLARE total_stock INT;
    
    -- Calcola il totale dello stock delle varianti rimanenti
    SELECT SUM(stock_quantity) INTO total_stock
    FROM product_variants 
    WHERE product_id = OLD.product_id;
    
    -- Aggiorna lo stock del prodotto base
    UPDATE products 
    SET stock_quantity = COALESCE(total_stock, 0)
    WHERE id = OLD.product_id;
END//
DELIMITER ;

-- 4. Trigger per aggiornare stock quando si crea un ordine
DELIMITER //
CREATE TRIGGER update_stock_after_order
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    -- Se l'ordine ha una variante, aggiorna lo stock della variante
    IF NEW.variant_id IS NOT NULL THEN
        UPDATE product_variants 
        SET stock_quantity = stock_quantity - NEW.quantity
        WHERE id = NEW.variant_id;
    ELSE
        -- Altrimenti aggiorna lo stock del prodotto base
        UPDATE products 
        SET stock_quantity = stock_quantity - NEW.quantity
        WHERE id = NEW.product_id;
    END IF;
END//
DELIMITER ;

-- 5. Trigger per aggiornare stock quando si aggiunge al carrello (opzionale)
DELIMITER //
CREATE TRIGGER reserve_stock_on_cart_add
AFTER INSERT ON cart_items
FOR EACH ROW
BEGIN
    -- Questo trigger può essere usato per "riservare" lo stock
    -- Implementazione opzionale per evitare sovraprenotazioni
    DECLARE current_stock INT;
    
    IF NEW.variant_id IS NOT NULL THEN
        SELECT stock_quantity INTO current_stock
        FROM product_variants 
        WHERE id = NEW.variant_id;
        
        -- Verifica disponibilità
        IF current_stock < NEW.quantity THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Stock insufficiente per questa variante';
        END IF;
    ELSE
        SELECT stock_quantity INTO current_stock
        FROM products 
        WHERE id = NEW.product_id;
        
        -- Verifica disponibilità
        IF current_stock < NEW.quantity THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Stock insufficiente per questo prodotto';
        END IF;
    END IF;
END//
DELIMITER ;

-- 6. Trigger per aggiornare timestamp di modifica del carrello
DELIMITER //
CREATE TRIGGER update_cart_modified_at
AFTER INSERT ON cart_items
FOR EACH ROW
BEGIN
    UPDATE carts 
    SET modified_at = CURRENT_TIMESTAMP
    WHERE id = NEW.cart_id;
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER update_cart_modified_at_update
AFTER UPDATE ON cart_items
FOR EACH ROW
BEGIN
    UPDATE carts 
    SET modified_at = CURRENT_TIMESTAMP
    WHERE id = NEW.cart_id;
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER update_cart_modified_at_delete
AFTER DELETE ON cart_items
FOR EACH ROW
BEGIN
    UPDATE carts 
    SET modified_at = CURRENT_TIMESTAMP
    WHERE id = OLD.cart_id;
END//
DELIMITER ;

-- 7. Trigger per soft delete dei prodotti
DELIMITER //
CREATE TRIGGER soft_delete_product
BEFORE DELETE ON products
FOR EACH ROW
BEGIN
    -- Invece di eliminare, marca come eliminato
    UPDATE products 
    SET deleted_at = CURRENT_TIMESTAMP, active = FALSE
    WHERE id = OLD.id;
    
    -- Previeni l'eliminazione effettiva
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Usa soft delete invece di eliminare fisicamente';
END//
DELIMITER ;

-- 8. Trigger per soft delete degli ordini
DELIMITER //
CREATE TRIGGER soft_delete_order
BEFORE DELETE ON orders
FOR EACH ROW
BEGIN
    -- Invece di eliminare, marca come eliminato
    UPDATE orders 
    SET deleted_at = CURRENT_TIMESTAMP
    WHERE id = OLD.id;
    
    -- Previeni l'eliminazione effettiva
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Usa soft delete invece di eliminare fisicamente';
END//
DELIMITER ;

-- 9. Trigger per soft delete degli utenti
DELIMITER //
CREATE TRIGGER soft_delete_user
BEFORE DELETE ON users
FOR EACH ROW
BEGIN
    -- Invece di eliminare, marca come eliminato
    UPDATE users 
    SET deleted_at = CURRENT_TIMESTAMP, is_active = FALSE
    WHERE id = OLD.id;
    
    -- Previeni l'eliminazione effettiva
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Usa soft delete invece di eliminare fisicamente';
END//
DELIMITER ;

-- 10. Trigger per validazione prezzo variante
DELIMITER //
CREATE TRIGGER validate_variant_price
BEFORE INSERT ON product_variants
FOR EACH ROW
BEGIN
    DECLARE base_price DECIMAL(10,2);
    
    -- Verifica che il modificatore di prezzo non sia troppo alto
    IF NEW.price_modifier > 100.00 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Il modificatore di prezzo non può superare 100.00';
    END IF;
    
    -- Verifica che il modificatore di prezzo non renda il prezzo negativo
    SELECT price INTO base_price FROM products WHERE id = NEW.product_id;
    
    IF (base_price + NEW.price_modifier) < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Il prezzo finale non può essere negativo';
    END IF;
END//
DELIMITER ;

-- 11. Trigger per validazione stock variante
DELIMITER //
CREATE TRIGGER validate_variant_stock
BEFORE INSERT ON product_variants
FOR EACH ROW
BEGIN
    -- Verifica che lo stock non sia negativo
    IF NEW.stock_quantity < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lo stock non può essere negativo';
    END IF;
END//
DELIMITER ;

-- 12. Trigger per aggiornare updated_at del prodotto
DELIMITER //
CREATE TRIGGER update_product_timestamp
BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
    SET NEW.updated_at = CURRENT_TIMESTAMP;
END//
DELIMITER ; 