DELIMITER //

-- 1. Trigger esistente: featured
CREATE TRIGGER after_product_featured_update
AFTER UPDATE ON products
FOR EACH ROW
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE cur_char_id INT;
    DECLARE char_cursor CURSOR FOR 
        SELECT character_id
        FROM product_characters
        WHERE product_id = NEW.id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    IF OLD.is_featured = FALSE AND NEW.is_featured = TRUE THEN
        OPEN char_cursor;
        read_loop: LOOP
            FETCH char_cursor INTO cur_char_id;
            IF done THEN
                LEAVE read_loop;
            END IF;
            INSERT INTO product_characters (product_id, character_id, is_primary)
            SELECT p.id, cur_char_id, FALSE
            FROM products p
            JOIN product_characters pc ON p.id = pc.product_id
            WHERE pc.character_id = cur_char_id
            AND p.id != NEW.id
            AND p.is_featured = FALSE
            ON DUPLICATE KEY UPDATE is_primary = FALSE;
        END LOOP;
        CLOSE char_cursor;
    END IF;
END//

-- 2. Trigger soft delete cascading su products
CREATE TRIGGER after_product_soft_delete
AFTER UPDATE ON products
FOR EACH ROW
BEGIN
    IF OLD.deleted_at IS NULL AND NEW.deleted_at IS NOT NULL THEN
        UPDATE product_variants SET deleted_at = NEW.deleted_at WHERE product_id = NEW.id;
        UPDATE product_characters SET deleted_at = NEW.deleted_at WHERE product_id = NEW.id;
        UPDATE cart_items SET deleted_at = NEW.deleted_at WHERE product_id = NEW.id;
        UPDATE wishlist SET deleted_at = NEW.deleted_at WHERE product_id = NEW.id;
        UPDATE order_items SET deleted_at = NEW.deleted_at WHERE product_id = NEW.id;
    END IF;
END//

-- 3. Trigger aggiornamento automatico updated_at
CREATE TRIGGER before_products_update
BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
    SET NEW.updated_at = CURRENT_TIMESTAMP;
END//

CREATE TRIGGER before_users_update
BEFORE UPDATE ON users
FOR EACH ROW
BEGIN
    SET NEW.updated_at = CURRENT_TIMESTAMP;
END//

CREATE TRIGGER before_characters_update
BEFORE UPDATE ON characters
FOR EACH ROW
BEGIN
    SET NEW.updated_at = CURRENT_TIMESTAMP;
END//

CREATE TRIGGER before_orders_update
BEFORE UPDATE ON orders
FOR EACH ROW
BEGIN
    SET NEW.updated_at = CURRENT_TIMESTAMP;
END//

-- 4. Trigger decremento automatico stock su order_items
CREATE TRIGGER after_order_item_insert
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    UPDATE products SET stock_quantity = stock_quantity - NEW.quantity WHERE id = NEW.product_id;
    IF NEW.variant_id IS NOT NULL THEN
        UPDATE product_variants SET stock_quantity = stock_quantity - NEW.quantity WHERE id = NEW.variant_id;
    END IF;
END//

-- 5. Trigger soft delete cascading su users
CREATE TRIGGER after_user_soft_delete
AFTER UPDATE ON users
FOR EACH ROW
BEGIN
    IF OLD.deleted_at IS NULL AND NEW.deleted_at IS NOT NULL THEN
        UPDATE carts SET deleted_at = NEW.deleted_at WHERE user_id = NEW.id;
        UPDATE wishlist SET deleted_at = NEW.deleted_at WHERE user_id = NEW.id;
        UPDATE orders SET deleted_at = NEW.deleted_at WHERE user_id = NEW.id;
    END IF;
END//

DELIMITER ;