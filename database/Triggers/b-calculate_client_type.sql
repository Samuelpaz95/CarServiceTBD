DROP PROCEDURE IF EXISTS updateClientType;
DELIMITER $$ CREATE PROCEDURE updateClientType() BEGIN
UPDATE Client AS C,
  (
    SELECT CI, IF( COUNT(CI) >= 4, 'A', IF(COUNT(CI) = 3, 'B', NULL) ) as client_type
    FROM Client
      INNER JOIN (SELECT id, client_id FROM Vehicle) V ON client_id = Client.CI
      INNER JOIN (SELECT completion_date, vehicle_id 
                  FROM Diagnosis 
                  WHERE completion_date IS NOT NULL AND YEAR(completion_date) = YEAR(NOW())) D ON vehicle_id = V.id
    GROUP BY D.completion_date, CI
  ) AS CT
SET C.client_type = CT.client_type WHERE C.CI = CT.CI;
END$$ 
DELIMITER ;

DROP TRIGGER IF EXISTS calculateClientTypeOnUpdate;
DELIMITER $$ CREATE TRIGGER calculateClientTypeOnUpdate
AFTER UPDATE ON Invoice FOR EACH ROW
BEGIN
  IF NEW.date IS NOT NULL AND YEAR(NEW.date) = YEAR(NOW()) THEN
    CALL updateClientType();
  END IF;
END$$
DELIMITER ;

DROP TRIGGER IF EXISTS calculateClientTypeOnInsert;
DELIMITER $$ CREATE TRIGGER calculateClientTypeOnInsert
AFTER INSERT ON Invoice FOR EACH ROW
BEGIN
  IF NEW.date IS NOT NULL AND YEAR(NEW.date) = YEAR(NOW()) THEN
    CALL updateClientType();
  END IF;
END$$
DELIMITER ;