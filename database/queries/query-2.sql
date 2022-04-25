SELECT name,
  car_model,
  unit_price,
  (count - stock) AS count
FROM Spare
  INNER JOIN Diagnosis_spare ON spare_id = Spare.id
  AND stock < count
  INNER JOIN Diagnosis ON diagnosis_id = Diagnosis.id
  INNER JOIN Vehicle ON vehicle_id = Vehicle.id
  INNER JOIN Client ON client_id = CI;
SELECT name,
  type,
  unit_price,
  (count - stock) AS count
FROM Supplie
  INNER JOIN Diagnosis_supplie ON supplie_id = Supplie.id
  AND stock < count
  INNER JOIN Diagnosis ON diagnosis_id = Diagnosis.id
  INNER JOIN Vehicle ON vehicle_id = Vehicle.id
  INNER JOIN Client ON client_id = CI;