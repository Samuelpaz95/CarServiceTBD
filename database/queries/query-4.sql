SELECT checkin_time,
  checkout_time,
  Assistance.date,
  name,
  start_time,
  end_time
FROM Assistance
  INNER JOIN Employee ON employee_id = CI
  INNER JOIN Assigned_to ON assigned_to_id = Assigned_to.id
  INNER JOIN Workshift ON workshift_id = Workshift.id
  AND first_name LIKE "Jorge%"
  AND last_name LIKE "Chávez%"
  AND MONTH(Assistance.date) = 2
  AND YEAR(Assistance.date) = 2022;