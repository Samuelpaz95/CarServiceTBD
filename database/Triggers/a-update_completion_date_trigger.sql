DROP TRIGGER IF EXISTS calculateRepairTotalPrice;
DELIMITER $$ CREATE TRIGGER calculateRepairTotalPrice
AFTER UPDATE ON Diagnosis FOR EACH ROW 
BEGIN 
  IF NEW.completion_date IS NOT NULL THEN 
    CALL getTotalCost();
  END IF;
END$$
DELIMITER ;