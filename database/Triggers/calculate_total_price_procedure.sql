DROP PROCEDURE IF EXISTS getTotalCost;
DELIMITER $$ CREATE PROCEDURE getTotalCost() BEGIN
INSERT INTO Invoice (diagnosis_id, total_const)
SELECT Diagnosis.id,
  sum(standar_price) + sum(total_usage_cost) + sum(COALESCE(spare_cost, 0)) + sum(COALESCE(supplies_cost, 0)) AS total_cost
FROM Diagnosis
  INNER JOIN (
    SELECT standar_price,
      Repair.diagnosis_id,
      COALESCE(usage_cost, 0) * COALESCE(usage_count, 1) AS total_usage_cost
    FROM Repair
      INNER JOIN Repair_type ON Repair_type.id = repair_type_id
      LEFT JOIN Task ON Task.repair_id = Repair.id
      LEFT JOIN Repair_equipment_task AS RET ON RET.task_id = Task.id
      LEFT JOIN (
        SELECT id,
          usage_cost
        FROM Repair_equipment
      ) AS RE ON RE.id = RET.repair_equipment_id
  ) rep ON rep.diagnosis_id = Diagnosis.id
  LEFT JOIN (
    SELECT diagnosis_id,
      count * unit_price AS spare_cost
    FROM Diagnosis_spare
      INNER JOIN Spare ON Spare.id = spare_id
  ) AS spares ON spares.diagnosis_id = Diagnosis.id
  LEFT JOIN (
    SELECT diagnosis_id,
      count * unit_price AS supplies_cost
    FROM Diagnosis_supplie
      INNER JOIN Spare ON Spare.id = supplie_id
  ) AS supplies ON supplies.diagnosis_id = Diagnosis.id
  AND completion_date IS NOT NULL
WHERE Diagnosis.completion_date IS NOT NULL
GROUP BY Diagnosis.id
ON DUPLICATE KEY UPDATE total_const=total_const;
END$$
DELIMITER ;