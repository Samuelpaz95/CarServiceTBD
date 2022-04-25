SELECT *
FROM (
    SELECT first_name,
      last_name,
      age,
      Job_position.title,
      addmission_date,
      (
        HOUR(TIMEDIFF(start_time, end_time)) * hourly_rate * 30
      ) as monthly_salary
    FROM Employee
      INNER JOIN Job_position ON Job_position.id = position_id
      INNER JOIN Assigned_to ON employee_id = CI
      INNER JOIN Workshift ON workshift_id = Workshift.id
  ) AS employees -- WHERE monthly_salary BETWEEN 2200 AND 2400 -- (No hay ningun registro)
;