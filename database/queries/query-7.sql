SELECT Vehicle.id,
  chassis_code,
  color,
  name,
  brand,
  vehicle_model.type,
  first_name as employee_name,
  last_name as employee_last_name,
  reception_date,
  completion_date
FROM Vehicle
  INNER JOIN vehicle_model ON model_id = vehicle_model.id
  AND type = "VAGONETA"
  AND (
    color = "rojo"
    OR color = "guindo"
  )
  INNER JOIN Consultation ON Consultation.vehicle_id = Vehicle.id
  INNER JOIN Detail ON consultation_id = Consultation.id
  AND description LIKE "%parachoque delantero%"
  INNER JOIN Diagnosis ON Diagnosis.vehicle_id = Vehicle.id
  AND completion_date IS NOT NULL
  INNER JOIN Repair ON diagnosis_id = Diagnosis.id
  INNER JOIN Task ON repair_id = Repair.id
  INNER JOIN Employee ON employee_id = Employee.CI;