SELECT color,
  name,
  brand,
  year,
  Model.type,
  Detail.type AS detail_type,
  Detail.description AS fail_description,
  usage_cost AS repair_equipment_cost
FROM Vehicle
  INNER JOIN vehicle_model AS Model ON model_id = Model.id
  INNER JOIN Consultation ON Consultation.vehicle_id = Vehicle.id
  INNER JOIN Detail ON consultation_id = Consultation.id
  AND Detail.type LIKE "FALLA%"
  INNER JOIN Diagnosis ON Diagnosis.vehicle_id = Vehicle.id
  AND diagnosis_date BETWEEN DATE_SUB("2022-02-28", INTERVAL 15 DAY)
  AND "2022-02-28"
  INNER JOIN Repair ON diagnosis_id = Diagnosis.id
  INNER JOIN Task ON repair_id = Repair.id
  INNER JOIN Repair_equipment_task ON task_id = Task.id
  INNER JOIN Repair_equipment ON repair_equipment_id = Repair_equipment.id;