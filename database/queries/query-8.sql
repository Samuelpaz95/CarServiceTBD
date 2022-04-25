SELECT COUNT(id) AS n_vehicles
FROM Vehicle
WHERE id IN (
    SELECT vehicle_id
    FROM Consultation
      INNER JOIN Client ON CI = client_id
      AND MONTH(reception_date) = MONTH(DATE_SUB(NOW(), INTERVAL 1 MONTH))
      AND first_name LIKE "juan%"
      AND last_name LIKE "Díaz%"
  );