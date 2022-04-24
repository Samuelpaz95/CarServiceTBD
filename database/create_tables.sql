-- Client
CREATE TABLE IF NOT EXISTS Client(
    CI INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    phone_number INT,
    email VARCHAR(255) NOT NULL,
    client_type VARCHAR(1),
) ENGINE = INNODB;
-- vehicle_model
CREATE TABLE IF NOT EXISTS vehicle_model(
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    year INT(4),
    type VARCHAR(100),
) ENGINE = INNODB;
-- Vehicle
CREATE TABLE IF NOT EXISTS Vehicle(
    id INT AUTO_INCREMENT PRIMARY KEY,
    chassis_code VARCHAR(255) NOT NULL,
    plate_code VARCHAR(20) NOT NULL,
    brand VARCHAR(100) NOT NULL,
    color VARCHAR(50) NOT NULL,
    model_id INT,
    client_id INT,
    FOREIGN KEY (client_id) REFERENCES Client(CI) ON DELETE CASCADE,
    FOREIGN KEY (model_id) REFERENCES vehicle_model(id) ON DELETE
    SET NULL
) ENGINE = INNODB;
-- Consultation
CREATE TABLE IF NOT EXISTS Consultation(
    id INT AUTO_INCREMENT PRIMARY KEY,
    reception_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    client_id INT NOT NULL,
    vehicle_id INT,
    FOREIGN KEY (client_id) REFERENCES Client(CI) ON DELETE CASCADE,
    FOREIGN KEY (vehicle_id) REFERENCES Vehicle(id) ON DELETE
    SET NULL
) ENGINE = INNODB;
-- Details
CREATE TABLE IF NOT EXISTS Detail(
    id INT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(100) NOT NULL,
    description TEXT,
    consultation_id INT,
    FOREIGN KEY (consultation_id) REFERENCES Consultation(id) ON DELETE CASCADE
) ENGINE = INNODB;
--Diagnosis
CREATE TABLE IF NOT EXISTS Diagnosis(
    id INT AUTO_INCREMENT PRIMARY KEY,
    diagnosis_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completion_date DATE,
    vehicle_id INT,
    FOREIGN KEY (vehicle_id) REFERENCES Vehicle(id) ON DELETE CASCADE
) ENGINE = INNODB;