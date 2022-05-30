-- Adminer 4.8.1 MySQL 5.7.37 dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

CREATE DATABASE `carservices_db` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `carservices_db`;

CREATE TABLE `Assigned_to` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `employee_id` int(11) NOT NULL,
  `workshift_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `employee_id` (`employee_id`),
  KEY `workshift_id` (`workshift_id`),
  CONSTRAINT `Assigned_to_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `Employee` (`CI`) ON DELETE CASCADE,
  CONSTRAINT `Assigned_to_ibfk_2` FOREIGN KEY (`workshift_id`) REFERENCES `Workshift` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `Assistance` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `checkin_time` time NOT NULL,
  `checkout_time` time NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `employee_id` int(11) NOT NULL,
  `assigned_to_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `employee_id` (`employee_id`),
  KEY `assigned_to_id` (`assigned_to_id`),
  CONSTRAINT `Assistance_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `Employee` (`CI`) ON DELETE CASCADE,
  CONSTRAINT `Assistance_ibfk_2` FOREIGN KEY (`assigned_to_id`) REFERENCES `Assigned_to` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `Client` (
  `CI` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `phone_number` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `client_type` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`CI`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `Consultation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reception_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `client_id` int(11) NOT NULL,
  `vehicle_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `client_id` (`client_id`),
  KEY `vehicle_id` (`vehicle_id`),
  CONSTRAINT `Consultation_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `Client` (`CI`),
  CONSTRAINT `Consultation_ibfk_2` FOREIGN KEY (`vehicle_id`) REFERENCES `Vehicle` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `Detail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(100) NOT NULL,
  `description` text,
  `consultation_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `consultation_id` (`consultation_id`),
  CONSTRAINT `Detail_ibfk_1` FOREIGN KEY (`consultation_id`) REFERENCES `Consultation` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `Diagnosis` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `diagnosis_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `completion_date` date DEFAULT NULL,
  `deadline` datetime DEFAULT NULL,
  `vehicle_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `vehicle_id` (`vehicle_id`),
  CONSTRAINT `Diagnosis_ibfk_1` FOREIGN KEY (`vehicle_id`) REFERENCES `Vehicle` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `Diagnosis_spare` (
  `diagnosis_id` int(11) NOT NULL,
  `spare_id` int(11) NOT NULL,
  `count` int(11) DEFAULT NULL,
  PRIMARY KEY (`diagnosis_id`,`spare_id`),
  KEY `spare_id` (`spare_id`),
  CONSTRAINT `Diagnosis_spare_ibfk_1` FOREIGN KEY (`diagnosis_id`) REFERENCES `Diagnosis` (`id`),
  CONSTRAINT `Diagnosis_spare_ibfk_2` FOREIGN KEY (`spare_id`) REFERENCES `Spare` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `Diagnosis_supplie` (
  `diagnosis_id` int(11) NOT NULL,
  `supplie_id` int(11) NOT NULL,
  `count` int(11) DEFAULT NULL,
  PRIMARY KEY (`diagnosis_id`,`supplie_id`),
  KEY `supplie_id` (`supplie_id`),
  CONSTRAINT `Diagnosis_supplie_ibfk_1` FOREIGN KEY (`diagnosis_id`) REFERENCES `Diagnosis` (`id`),
  CONSTRAINT `Diagnosis_supplie_ibfk_2` FOREIGN KEY (`supplie_id`) REFERENCES `Supplie` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `Employee` (
  `CI` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `age` int(11) DEFAULT NULL,
  `address` varchar(255) NOT NULL,
  `email` varchar(200) NOT NULL,
  `phone_number` int(11) NOT NULL,
  `addmission_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `position_id` int(11) NOT NULL,
  PRIMARY KEY (`CI`),
  KEY `position_id` (`position_id`),
  CONSTRAINT `Employee_ibfk_1` FOREIGN KEY (`position_id`) REFERENCES `Job_position` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `Invoice` (
  `code` int(11) NOT NULL AUTO_INCREMENT,
  `total_const` double NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `diagnosis_id` int(11) NOT NULL,
  PRIMARY KEY (`code`),
  UNIQUE KEY `diagnosis_id_2` (`diagnosis_id`),
  KEY `diagnosis_id` (`diagnosis_id`),
  CONSTRAINT `Invoice_ibfk_1` FOREIGN KEY (`diagnosis_id`) REFERENCES `Diagnosis` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `Job_position` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `hourly_rate` double NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `Monthly_bonus` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(100) NOT NULL,
  `description` text,
  `bonus_porcentage` double NOT NULL,
  `employee_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `employee_id` (`employee_id`),
  CONSTRAINT `Monthly_bonus_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `Employee` (`CI`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `Repair` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` text,
  `finish_date` datetime DEFAULT NULL,
  `repair_type_id` int(11) NOT NULL,
  `diagnosis_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `repair_type_id` (`repair_type_id`),
  KEY `diagnosis_id` (`diagnosis_id`),
  CONSTRAINT `Repair_ibfk_1` FOREIGN KEY (`repair_type_id`) REFERENCES `Repair_type` (`id`),
  CONSTRAINT `Repair_ibfk_2` FOREIGN KEY (`diagnosis_id`) REFERENCES `Diagnosis` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `Repair_equipment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sku_code` varchar(100) NOT NULL,
  `unit_price` double NOT NULL,
  `count` int(11) DEFAULT NULL,
  `usage_cost` double NOT NULL,
  `usage_type` varchar(100) NOT NULL,
  `usage_description` text,
  `purchase_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `Repair_equipment_task` (
  `task_id` int(11) NOT NULL,
  `repair_equipment_id` int(11) NOT NULL,
  `usage_count` int(11) DEFAULT '1',
  PRIMARY KEY (`task_id`,`repair_equipment_id`),
  KEY `repair_equipment_id` (`repair_equipment_id`),
  CONSTRAINT `Repair_equipment_task_ibfk_1` FOREIGN KEY (`task_id`) REFERENCES `Task` (`id`),
  CONSTRAINT `Repair_equipment_task_ibfk_2` FOREIGN KEY (`repair_equipment_id`) REFERENCES `Repair_equipment` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `Repair_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `standar_price` double NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `Salary_payment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `total_salary` double NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `salary_detail` text NOT NULL,
  `employee_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `employee_id` (`employee_id`),
  CONSTRAINT `Salary_payment_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `Employee` (`CI`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `Spare` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sku_code` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `car_model` varchar(100) NOT NULL,
  `stock` int(11) DEFAULT NULL,
  `unit_price` double NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `Supplie` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sku_code` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `type` varchar(100) NOT NULL,
  `stock` int(11) DEFAULT NULL,
  `unit_price` double NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `Task` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `description` text,
  `diagnosis_id` int(11) NOT NULL,
  `employee_id` int(11) DEFAULT NULL,
  `repair_id` int(11) DEFAULT NULL,
  `completed_at` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `diagnosis_id` (`diagnosis_id`),
  KEY `employee_id` (`employee_id`),
  KEY `repair_id` (`repair_id`),
  CONSTRAINT `Task_ibfk_1` FOREIGN KEY (`diagnosis_id`) REFERENCES `Diagnosis` (`id`),
  CONSTRAINT `Task_ibfk_2` FOREIGN KEY (`employee_id`) REFERENCES `Employee` (`CI`) ON DELETE SET NULL,
  CONSTRAINT `Task_ibfk_3` FOREIGN KEY (`repair_id`) REFERENCES `Repair` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `Vehicle` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `chassis_code` varchar(255) NOT NULL,
  `plate_code` varchar(20) NOT NULL,
  `color` varchar(50) NOT NULL,
  `model_id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `client_id` (`client_id`),
  KEY `model_id` (`model_id`),
  CONSTRAINT `Vehicle_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `Client` (`CI`),
  CONSTRAINT `Vehicle_ibfk_2` FOREIGN KEY (`model_id`) REFERENCES `vehicle_model` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `vehicle_model` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `brand` varchar(100) NOT NULL,
  `year` int(4) NOT NULL,
  `type` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE `Workshift` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- 2022-05-30 22:14:25
