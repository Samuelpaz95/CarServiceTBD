DROP PROCEDURE IF EXISTS calculateTimeouts;
DELIMITER $$ CREATE PROCEDURE calculateTimeouts() BEGIN
UPDATE Assistance,
  (
    SELECT Assistance.id,
      MINUTE(SUBTIME(checkin_time, start_time)) >= 10 AS late
    FROM Assistance
      INNER JOIN Assigned_to ON Assigned_to.id = assigned_to_id
      INNER JOIN Workshift ON Workshift.id = workshift_id
  ) AS T
SET Assistance.late = T.late
WHERE Assistance.id = T.id;
END$$ 
DELIMITER ;

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