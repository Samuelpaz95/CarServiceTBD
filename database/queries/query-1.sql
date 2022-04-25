SELECT first_name,
  last_name,
  age,
  address,
  email,
  phone_number,
  completion_date AS repair_completion_date
FROM Employee
  INNER JOIN Task ON employee_id = CI
  INNER JOIN Repair ON repair_id = Repair.id
  INNER JOIN Diagnosis ON Repair.diagnosis_id = Diagnosis.id
  AND YEAR(completion_date) = YEAR(NOW())
  AND Task.title LIKE "%Cambio de anillas%"
  AND position_id IN (
    SELECT id
    FROM Job_position
    WHERE title LIKE "MECANICO"
  )
  AND vehicle_id IN (
    SELECT id
    FROM Vehicle
    WHERE client_id IN (
        SELECT CI
        FROM Client
        WHERE first_name LIKE "Carlos%"
          AND last_name LIKE "Sejas%"
      )
      AND model_id IN (
        SELECT id
        FROM vehicle_model
        WHERE brand Like "Mazda%"
      )
  );