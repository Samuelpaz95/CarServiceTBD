-- Client
CREATE TABLE IF NOT EXISTS Client(
    CI INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    phone_number INT NOT NULL,
    email VARCHAR(255) NOT NULL,
    client_type VARCHAR(1)
) ENGINE = INNODB;
-- vehicle_model
CREATE TABLE IF NOT EXISTS vehicle_model(
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    brand VARCHAR(100) NOT NULL,
    year INT(4) NOT NULL,
    type VARCHAR(100) NOT NULL -- BAGONETA, AUTOMOVIL, CAMIONETA; CAMION
) ENGINE = INNODB;
-- Vehicle
CREATE TABLE IF NOT EXISTS Vehicle(
    id INT AUTO_INCREMENT PRIMARY KEY,
    chassis_code VARCHAR(255) NOT NULL,
    plate_code VARCHAR(20) NOT NULL,
    color VARCHAR(50) NOT NULL,
    model_id INT NOT NULL,
    client_id INT NOT NULL,
    FOREIGN KEY (client_id) REFERENCES Client(CI),
    FOREIGN KEY (model_id) REFERENCES vehicle_model(id)
) ENGINE = INNODB;
-- Consultation
CREATE TABLE IF NOT EXISTS Consultation(
    id INT AUTO_INCREMENT PRIMARY KEY,
    reception_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    client_id INT NOT NULL,
    vehicle_id INT NOT NULL,
    FOREIGN KEY (client_id) REFERENCES Client(CI),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicle(id)
) ENGINE = INNODB;
-- Details
CREATE TABLE IF NOT EXISTS Detail(
    id INT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(100) NOT NULL,
    description TEXT,
    consultation_id INT NOT NULL,
    FOREIGN KEY (consultation_id) REFERENCES Consultation(id)
) ENGINE = INNODB;
-- Diagnosis
CREATE TABLE IF NOT EXISTS Diagnosis(
    id INT AUTO_INCREMENT PRIMARY KEY,
    diagnosis_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completion_date DATE,
    vehicle_id INT NOT NULL,
    FOREIGN KEY (vehicle_id) REFERENCES Vehicle(id)
) ENGINE = INNODB;
-- Repari_type
CREATE TABLE IF NOT EXISTS Repair_type(
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    standar_price DOUBLE NOT NULL
) ENGINE = INNODB;
-- Repair
CREATE TABLE IF NOT EXISTS Repair(
    id INT AUTO_INCREMENT PRIMARY KEY,
    description TEXT,
    finish_date DATETIME,
    repair_type_id INT NOT NULL,
    diagnosis_id INT NOT NULL,
    FOREIGN KEY (repair_type_id) REFERENCES Repair_type(id),
    FOREIGN KEY (diagnosis_id) REFERENCES Diagnosis(id)
) ENGINE = INNODB;
-- Invoice
CREATE TABLE IF NOT EXISTS Invoice(
    code INT AUTO_INCREMENT PRIMARY KEY,
    total_const DOUBLE NOT NULL,
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    diagnosis_id INT NOT NULL,
    FOREIGN KEY (diagnosis_id) REFERENCES Diagnosis(id)
) ENGINE = INNODB;
-- Spare
CREATE TABLE IF NOT EXISTS Spare(
    id INT AUTO_INCREMENT PRIMARY KEY,
    sku_code VARCHAR(100) NOT NULL,
    name VARCHAR(100) NOT NULL,
    car_model VARCHAR(100) NOT NULL,
    stock INT,
    unit_price DOUBLE NOT NULL
) ENGINE = INNODB;
-- Diagnosis_spare
CREATE TABLE IF NOT EXISTS Diagnosis_spare(
    diagnosis_id INT NOT NULL,
    spare_id INT NOT NULL,
    PRIMARY KEY (diagnosis_id, spare_id),
    FOREIGN KEY (diagnosis_id) REFERENCES Diagnosis(id),
    FOREIGN KEY (spare_id) REFERENCES Spare(id)
) ENGINE = INNODB;
-- Supplie
CREATE TABLE IF NOT EXISTS Supplie(
    id INT AUTO_INCREMENT PRIMARY KEY,
    sku_code VARCHAR(100) NOT NULL,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(100) NOT NULL,
    stock INT,
    unit_price DOUBLE NOT NULL
) ENGINE = INNODB;
-- Diagnosis_supplie
CREATE TABLE IF NOT EXISTS Diagnosis_supplie(
    diagnosis_id INT NOT NULL,
    supplie_id INT NOT NULL,
    PRIMARY KEY (diagnosis_id, supplie_id),
    FOREIGN KEY (diagnosis_id) REFERENCES Diagnosis(id),
    FOREIGN KEY (supplie_id) REFERENCES Supplie(id)
) ENGINE = INNODB;
-- Repair_equipment
CREATE TABLE IF NOT EXISTS Repair_equipment(
    id INT AUTO_INCREMENT PRIMARY KEY,
    sku_code VARCHAR(100) NOT NULL,
    unit_price DOUBLE NOT NULL,
    count INT,
    usage_cost DOUBLE NOT NULL,
    usage_type VARCHAR(100) NOT NULL,
    usage_description TEXT,
    purchase_date DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE = INNODB;
-- Position
CREATE TABLE IF NOT EXISTS Job_position(
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    hourly_rate DOUBLE NOT NULL
) ENGINE = INNODB;
-- Employee
CREATE TABLE IF NOT EXISTS Employee(
    CI INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    age INT,
    address VARCHAR(255) NOT NULL,
    email VARCHAR(200) NOT NULL,
    phone_number INT NOT NULL,
    addmission_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    position_id INT NOT NULL,
    FOREIGN KEY (position_id) REFERENCES Job_position(id)
) ENGINE = INNODB;
-- Task
CREATE TABLE IF NOT EXISTS Task(
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    diagnosis_id INT NOT NULL,
    employee_id INT,
    FOREIGN KEY (diagnosis_id) REFERENCES Diagnosis(id),
    FOREIGN KEY (employee_id) REFERENCES Employee(CI) ON DELETE
    SET NULL
) ENGINE = INNODB;
-- Repair_equipment_task
CREATE TABLE IF NOT EXISTS Repair_equipment_task(
    task_id INT NOT NULL,
    repair_equipment_id INT NOT NULL,
    PRIMARY KEY (task_id, repair_equipment_id),
    FOREIGN KEY (task_id) REFERENCES Task(id),
    FOREIGN KEY (repair_equipment_id) REFERENCES Repair_equipment(id)
) ENGINE = INNODB;
-- Monthly_bonus
CREATE TABLE IF NOT EXISTS Monthly_bonus(
    id INT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(100) NOT NULL,
    description TEXT,
    bonus_porcentage DOUBLE NOT NULL,
    employee_id INT NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES Employee(CI)
) ENGINE = INNODB;
-- Workshift
CREATE TABLE IF NOT EXISTS Workshift(
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    start_time TIME NOT NULL,
    end_time TIME NOT NULL
) ENGINE = INNODB;
-- Assigned_to
CREATE TABLE IF NOT EXISTS Assigned_to(
    id INT AUTO_INCREMENT PRIMARY KEY,
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    employee_id INT NOT NULL,
    workshift_id INT NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES Employee(CI) ON DELETE CASCADE,
    FOREIGN KEY (workshift_id) REFERENCES Workshift(id)
) ENGINE = INNODB;
-- Salary_payment
CREATE TABLE IF NOT EXISTS Salary_payment(
    id INT AUTO_INCREMENT PRIMARY KEY,
    total_salary DOUBLE NOT NULL,
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    salary_detail TEXT NOT NULL,
    employee_id INT NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES Employee(CI)
) ENGINE = INNODB;
-- Assistance
CREATE TABLE IF NOT EXISTS Assistance(
    id INT AUTO_INCREMENT PRIMARY KEY,
    checkin_time TIME NOT NULL,
    checkout_time TIME NOT NULL,
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    employee_id INT NOT NULL,
    assigned_to_id INT,
    FOREIGN KEY (employee_id) REFERENCES Employee(CI) ON DELETE CASCADE,
    FOREIGN KEY (assigned_to_id) REFERENCES Assigned_to(id) ON DELETE
    SET NULL
) ENGINE = INNODB;