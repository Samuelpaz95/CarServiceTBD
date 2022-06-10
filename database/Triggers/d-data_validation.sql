DROP TRIGGER IF EXISTS dataValidation;
DELIMITER $$ CREATE TRIGGER dataValidation
BEFORE INSERT ON Client FOR EACH ROW 
BEGIN 
  IF NEW.first_name = '' OR NEW.first_name REGEXP '[0-9]' OR NEW.first_name REGEXP '[^a-zA-Z0-9]' THEN
    signal sqlstate '45000' set message_text = 'first_name invalid value';
  END IF;
  IF NEW.last_name = '' OR NEW.last_name REGEXP '[0-9]' OR NEW.last_name REGEXP '[^a-zA-Z0-9]' THEN
    signal sqlstate '45000' set message_text = 'last_name invalid value';
  END IF;
  IF NEW.phone_number / 1000000 <= 1 THEN -- debe tener mas de 7 digitos
    signal sqlstate '45000' set message_text = 'phone_number invalid value';
  END IF;
  IF NEW.email NOT REGEXP '^[^@]+@[^@]+\.[^@]{2,}$' THEN 
    signal sqlstate '45000' set message_text = 'Insert a valid email';
  END IF;
  SET NEW.client_type = NULL;
END$$
DELIMITER ;