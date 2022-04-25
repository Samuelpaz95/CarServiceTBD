SELECT name AS turn,
  start_time,
  end_time,
  CONCAT(first_name, " ", last_name) AS Assigned_to
FROM Workshift
  INNER JOIN Assigned_to ON workshift_id = Workshift.id
  AND MONTH(Assigned_to.date) = MONTH(NOW())
  AND YEAR(Assigned_to.date) = YEAR(NOW())
  INNER JOIN Employee ON employee_id = CI
  AND first_name LIKE "Jorge%"
  AND last_name Like "Chávez%";