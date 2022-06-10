DROP TRIGGER IF EXISTS registerTimeout;
DELIMITER $$ CREATE TRIGGER registerTimeout
BEFORE INSERT ON Assistance FOR EACH ROW
BEGIN
    DECLARE lateValue BOOL;
    SELECT 
      SUBTIME(NEW.checkin_time, start_time) >= '00:10:00' AS timeouts INTO lateValue 
      FROM Assigned_to 
    INNER JOIN Workshift ON Workshift.id = workshift_id
    WHERE Assigned_to.id = NEW.Assigned_to_id;
    SET NEW.late = lateValue;
END$$
DELIMITER ;