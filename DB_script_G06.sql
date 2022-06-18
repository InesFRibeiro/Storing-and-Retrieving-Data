-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema te
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `te` DEFAULT CHARACTER SET utf8 ;
-- -----------------------------------------------------
-- Schema te
-- -----------------------------------------------------
USE `te` ;

-- -----------------------------------------------------
-- Table `te`.`Addresses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `te`.`Addresses` (
  `Address_ID` INT NOT NULL UNIQUE,
  `address` VARCHAR(60) NULL,
  `city` VARCHAR(30) NULL,
  `county` VARCHAR(35) NULL,
  `district` VARCHAR(20) NULL,
  `zip_code` VARCHAR(8) NOT NULL UNIQUE,
  PRIMARY KEY (`Address_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `te`.`Customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `te`.`Customers` (
  `customer_ID` INT NOT NULL AUTO_INCREMENT UNIQUE,
  `first_name` VARCHAR(15) NULL,
  `last_name` VARCHAR(15) NULL,
  `phone_number` INT NULL UNIQUE,
  `email` VARCHAR(45) NULL UNIQUE,
  `nif` INT NULL UNIQUE,
  `singular` TINYINT NULL, /* is it a person or company?*/
  `Address_ID` INT NOT NULL,
  PRIMARY KEY (`customer_ID`),
  CONSTRAINT `fk_customer_address`
    FOREIGN KEY (`Address_ID`)
    REFERENCES `te`.`Addresses` (`Address_ID`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `te`.`Car_models`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `te`.`Car_models` (
  `Model_ID` INT NOT NULL UNIQUE,
  `manufacturer_name` VARCHAR(15) NULL,
  `model_name` VARCHAR(15) NULL,
  `category` VARCHAR(20) NULL,
  PRIMARY KEY (`Model_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `te`.`Stands`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `te`.`Stands` (
  `Stand_ID` INT NOT NULL UNIQUE,
  `name` VARCHAR(30) NULL,
  `email` VARCHAR(50) NULL UNIQUE,
  `phone_number` INT NULL UNIQUE,
  `nif` INT NULL UNIQUE,
  `employee_number` INT NULL,
  `Address_ID` INT NOT NULL,
  PRIMARY KEY (`Stand_ID`),
  CONSTRAINT `fk_stand_address`
    FOREIGN KEY (`Address_ID`)
    REFERENCES `te`.`Addresses` (`Address_ID`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `te`.`Cars_for_sale`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `te`.`Cars_for_sale` (
  `Car_for_sale_ID` INT NOT NULL UNIQUE,
  `hp` INT NULL,
  `state` VARCHAR(5) NULL,
  `type_of_fuel` VARCHAR(15) NULL,
  `color` VARCHAR(10) NULL,
  `number_doors` INT NULL,
  `number_seats` INT NULL,
  `registration_year` INT NULL,
  `price` INT NULL,
  `current_mileage` INT NULL,
  `Model_ID` INT NOT NULL,
  `Stand_ID` INT NOT NULL,
  PRIMARY KEY (`Car_for_sale_ID`),
  CONSTRAINT `fk_car_for_sale_model`
    FOREIGN KEY (`Model_ID`)
    REFERENCES `te`.`Car_models` (`Model_ID`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_car_for_sale_stand`
    FOREIGN KEY (`Stand_ID`)
    REFERENCES `te`.`Stands` (`Stand_ID`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `te`.`Car_features`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `te`.`Car_features` (
  `Car_features_ID` INT NOT NULL UNIQUE,
  `air_conditioning` TINYINT NULL,
  `parking_sensors` TINYINT NULL,
  `bluetooth` TINYINT NULL,
  `radio` TINYINT NULL,
  `gps` TINYINT NULL,
  PRIMARY KEY (`Car_features_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `te`.`Employees`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `te`.`Employees` (
  `Employee_ID` INT NOT NULL UNIQUE,
  `first_name` VARCHAR(15) NULL,
  `last_name` VARCHAR(15) NULL,
  `email` VARCHAR(50) NULL UNIQUE,
  `phone_number` INT NULL UNIQUE,
  `nif` INT NULL UNIQUE,
  `Stand_ID` INT NOT NULL,
  `job_title` VARCHAR(20) NULL,
  `salary` INT NULL,
  `seniority` INT NULL,
  `Address_ID` INT NOT NULL,
  PRIMARY KEY (`Employee_ID`),
  CONSTRAINT `fk_Stand_ID`
    FOREIGN KEY (`Stand_ID`)
    REFERENCES `te`.`Stands` (`Stand_ID`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_employee_address`
    FOREIGN KEY (`Address_ID`)
    REFERENCES `te`.`Addresses` (`Address_ID`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `te`.`Cars_sold`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `te`.`Cars_sold` (
  `Car_sold_ID` INT NOT NULL UNIQUE,
  `Customer_ID` INT NOT NULL,
  `Car_for_sale_ID` INT NOT NULL UNIQUE,
  `agreed_price` INT NULL,
  `date_sold` DATE NULL,
  `prompt_payment` TINYINT NULL,
  `monthly_payment_amount` FLOAT NULL,
  `number_due_payments` INT NULL,
  `Employee_ID` INT NOT NULL,
  `paid` TINYINT NULL,
  `total_amount_paid` FLOAT NULL,
  `service_rating` TINYINT NULL,
  PRIMARY KEY (`Car_sold_ID`),
  CONSTRAINT `fk_car_sold_customer`
    FOREIGN KEY (`Customer_ID`)
    REFERENCES `te`.`Customers` (`customer_ID`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_car_sold_car_for_sale`
    FOREIGN KEY (`Car_for_sale_ID`)
    REFERENCES `te`.`Cars_for_sale` (`Car_for_sale_ID`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_car_sold_employee`
    FOREIGN KEY (`Employee_ID`)
    REFERENCES `te`.`Employees` (`Employee_ID`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
    CONSTRAINT `ck_rating` CHECK (`service_rating` BETWEEN 1 AND 5))
ENGINE = InnoDB;


-------------------------------------------------
-- Table `te`.`Customer_Payments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `te`.`Customer_Payments` (
  `Customer_Payments_ID` INT NOT NULL UNIQUE,
  `Car_sold_ID` INT NOT NULL,
  `Customer_ID` INT NOT NULL,
  `payment_date` DATE NULL,
  `amount_paid` FLOAT NULL,
  PRIMARY KEY (`Customer_Payments_ID`),
  CONSTRAINT `fk_payment_customer`
    FOREIGN KEY (`Customer_ID`)
    REFERENCES `te`.`Customers` (`customer_ID`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_payment_car_sold`
    FOREIGN KEY (`Car_sold_ID`)
    REFERENCES `te`.`Cars_sold` (`Car_sold_ID`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `te`.`Cars_for_sale_has_Car_features`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `te`.`Cars_for_sale_has_Car_features` (
  `Car_for_sale_ID` INT NOT NULL UNIQUE,
  `Car_features_ID` INT NOT NULL UNIQUE,
  PRIMARY KEY (`Car_for_sale_ID`, `Car_features_ID`),
  CONSTRAINT `fk_Cars_for_sale_has_Car_features_Cars_for_sale1`
    FOREIGN KEY (`Car_for_sale_ID`)
    REFERENCES `te`.`Cars_for_sale` (`Car_for_sale_ID`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Cars_for_sale_has_Car_features_Car_features1`
    FOREIGN KEY (`Car_features_ID`)
    REFERENCES `te`.`Car_features` (`Car_features_ID`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `te`.`log`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `te`.`log` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Car_sold_ID` INT NOT NULL,
  `Stand_ID` INT NOT NULL,
  `state` VARCHAR(5) NULL,
  `type_of_fuel` VARCHAR(15) NULL,
  `registration_year` INT NULL,
  `current_mileage` INT NULL,
  `manufacturer_name` VARCHAR(15) NULL,
  `model_name` VARCHAR(15) NULL,
  `category` VARCHAR(20) NULL,
  `price` INT NULL,
  `agreed_price` INT NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Triggers
-- -----------------------------------------------------

DELIMITER $$
USE `te`$$
CREATE TRIGGER  `te` . `UPDATE_cars_for_sale`
 AFTER INSERT ON `Cars_sold` 
 FOR EACH ROW 
 BEGIN 
 DELETE FROM Cars_for_sale WHERE Car_for_sale_ID= NEW.Car_for_sale_ID;
 END$$
 
DELIMITER ;
 

DELIMITER $$
USE `te`$$
CREATE TRIGGER  `te` . `cars_sold_UPDATE`
 AFTER INSERT ON `Customer_Payments` 
 FOR EACH ROW 
BEGIN 
    IF (select agreed_price from Cars_sold cs where cs.Car_sold_ID = new.Car_sold_ID) = new.amount_paid THEN
		UPDATE Cars_sold cs
		SET number_due_payments = 0, 
			prompt_payment = 1,
			paid = 1,
			total_amount_paid = new.amount_paid
			where cs.Car_sold_ID = new.Car_sold_ID ;
    ELSEIF (select number_due_payments from Cars_sold cs where cs.Car_sold_ID = new.Car_sold_ID) > 1 THEN
		UPDATE Cars_sold cs
		SET number_due_payments = number_due_payments - 1, 
			total_amount_paid = total_amount_paid + new.amount_paid  
			where cs.Car_sold_ID = new.Car_sold_ID ;
	ELSE
		UPDATE Cars_sold cs
		SET number_due_payments = 0, 
			paid = 1,
			total_amount_paid = total_amount_paid + new.amount_paid
			where cs.Car_sold_ID = new.Car_sold_ID ;
	END IF;
END$$
DELIMITER ;

DELIMITER $$
USE `te`$$
CREATE TRIGGER  `te` . `log_changes`
 BEFORE DELETE ON `Cars_for_sale` 
 FOR EACH ROW 
BEGIN 
    INSERT INTO log (Car_sold_ID, Stand_ID, state, type_of_fuel, registration_year, current_mileage, manufacturer_name, model_name, category, price, agreed_price) VALUES
    ((SELECT Car_sold_ID FROM Cars_sold cs WHERE cs.Car_for_sale_ID = old.Car_for_sale_ID),
    old.Stand_ID,
    old.state,
    old.type_of_fuel,
    old.registration_year,
    old.current_mileage,
    (SELECT cm.manufacturer_name FROM Car_models cm WHERE old.Model_ID=cm.Model_ID),
    (SELECT cm.model_name FROM Car_models cm WHERE old.Model_ID=cm.Model_ID ),
    (SELECT cm.category FROM Car_models cm WHERE old.Model_ID=cm.Model_ID),
    old.price,
    (SELECT agreed_price FROM Cars_sold cs WHERE cs.Car_for_sale_ID = old.Car_for_sale_ID));
       
END$$

DELIMITER ;

-- -----------------------------------------------------
-- Insert Data
-- -----------------------------------------------------

insert into `Addresses` (`address_id`,`address`, `city`, `county`,`district`,`zip_code`) values
(1, 'Rotunda Nossa Senhora dos Remédios, nº15', 'Carcavelos', 'Cascais', 'Lisboa', '2775-595'),
(2, 'Largo do Infante Santo, nº13', 'Santarém', 'Santarém', 'Santarém', '2009-002'),
(3, 'Rua Francisco Clemente, nº10', 'Leiria', 'Leiria', 'Leiria', '2419-004'),
(4, 'Estrada de Benfica, nº29', 'Carcavelos', 'Cascais', 'Lisboa', '2775-293'),
(5, 'Estrada de Monsanto, nº12', 'Carcavelos', 'Cascais', 'Lisboa', '2775-990'),
(6, 'Calçada do Tojal, nº17', 'Carcavelos', 'Cascais', 'Lisboa', '2775-333'),
(7, 'Caminho das Pedreiras, nº24', 'Carcavelos', 'Cascais', 'Lisboa', '2775-899'),
(8, 'Caminho Velho do Outeiro, nº22', 'Carcavelos', 'Cascais', 'Lisboa', '2775-144'),
(9, 'Largo da Igreja, nº30', 'Carcavelos', 'Cascais', 'Lisboa', '2775-627'),
(10, 'Praça Professor Santos Andrea, nº8', 'Santarém', 'Santarém', 'Santarém', '2009-376'),
(11, 'Calçada da Glória, nº1', 'Santarém', 'Santarém', 'Santarém', '2009-656'),
(12, 'Rua da Judiaria, nº14', 'Santarém', 'Santarém', 'Santarém', '2009-842'),
(13, 'Rua da Madalena, nº10', 'Santarém', 'Santarém', 'Santarém', '2009-631'),
(14, 'Rua de Barros Queirós, nº11', 'Santarém', 'Santarém', 'Santarém', '2009-269'),
(15, 'Rua de Santa Cruz do Castelo, nº25', 'Santarém', 'Santarém', 'Santarém', '2009-351'),
(16, 'Rua de Santa Justa, nº22', 'Leiria', 'Leiria', 'Leiria', '2419-510'),
(17, 'Rua de Santa Marinha, nº14', 'Leiria', 'Leiria', 'Leiria', '2419-265'),
(18, 'Rua de Santiago, nº8', 'Leiria', 'Leiria', 'Leiria', '2419-847'),
(19, 'Rua de Santo António da Sé, nº16', 'Leiria', 'Leiria', 'Leiria', '2419-288'),
(20, 'Rua de Santo Estêvão, nº23', 'Leiria', 'Leiria', 'Leiria', '2419-528'),
(21, 'Rua de São Gens, nº20', 'Leiria', 'Leiria', 'Leiria', '2419-880'),
(22, 'Rua de São Pedro Mártir, nº27', 'Leiria', 'Leiria', 'Leiria', '2419-933'),
(23, 'Rua do Arco da Graça, nº2', 'Leiria', 'Leiria', 'Leiria', '2419-461'),
(24, 'Avenida Álvares Cabral, nº26', 'Albufeira', 'Albufeira', 'Faro', '8000-075'),
(25, 'Avenida Engenheiro Duarte Pacheco, nº13', 'Cascais', 'Cascais', 'Lisboa', '2775-629'),
(26, 'Avenida Pedro Álvares Cabral, nº16', 'Estoril', 'Cascais', 'Lisboa', '2775-632'),
(27, 'Beco da Pedreira da Caneja, nº5', 'Oeiras', 'Oeiras', 'Lisboa', '2775-727'),
(28, 'Estrada dos Prazeres, nº22', 'Porto', 'Porto', 'Porto', '1800-345'),
(29, 'Pátio Caetano de Carvalho, nº23', 'Porto', 'Porto', 'Porto', '1800-445'),
(30, 'Rua Ferreira Borges, nº27', 'Porto', 'Portugal', 'Porto', '1800-555'),
(31, 'Rua Fernando Assis Pacheco, nº16', 'Porto', 'Porto', 'Porto', '1800-735'),
(32, 'Rua dos Sete Moinhos, nº29', 'Carcavelos', 'Cascais', 'Lisboa', '2775-777'),
(33, 'Rua Dom João V, nº6', 'Faro', 'Faro', 'Faro', '8000-375'),
(34, 'Rua do Sol ao Rato, nº10', 'Albufeira', 'Albufeira', 'Faro', '8000-458'),
(35, 'Rua do Garcia, nº30', 'Albufeira', 'Albufeira', 'Faro', '8000-985'),
(36, 'Rua do Cabo, nº24', 'Cascais', 'Cascais', 'Lisboa', '2775-827'),
(37, 'Rua do Arco do Carvalhão, nº38', 'Cascais', 'Cascais', 'Lisboa', '2775-929'),
(38, 'Rua de São Joaquim, nº13', 'Beja', 'Beja', 'Beja', '7800-457'),
(39, 'Rua de Santa Isabel, nº16', 'Beja', 'Beja', 'Beja', '7800-887'),
(40, 'Rua de Dom Dinis, nº5', 'Beja', 'Beja', 'Beja', '7800-959'),
(41, 'Travessa Arrábida, nº32', 'Santarém', 'Santarém', 'Santarém', '2009-451'),
(42, 'Travessa de Campo de Ourique, nº7', 'Santarém', 'Santarém', 'Santarém', '2009-661'),
(43, 'Travessa de São Caetano, nº4', 'Leiria', 'Leiria', 'Leiria', '2419-761');


insert into `Car_models` (`Model_ID`,`manufacturer_name`, `model_name`, `category`) values
(1, 'RENAULT', '207', 'TDE'), 
(2, 'LOTUS', '207', 'TDI'), 
(3, 'ABARTH', '207', 'TURBO'), 
(4, 'FORD', 'FTYPE', 'TDE'), 
(5, 'BENTLEY', '1008', 'TDE'), 
(6, 'AUDI', 'FTYPE', 'GTI'), 
(7, 'SUZUKI', 'SERIE 2', 'TDI'), 
(8, 'MINI', 'SPORT', 'GTI'), 
(9, 'JAGUAR', 'SERIE 1', 'TDE'), 
(10, 'JAGUAR', '1008', 'GTI'), 
(11, 'SEAT', '1008', 'TURBO'), 
(12, 'SEAT', 'FTYPE', 'TURBO'), 
(13, 'SEAT', 'SERIE 2', 'TURBO'), 
(14, 'MERCEDES', 'SERIE 3', 'GTI'), 
(15, 'SMART', '1008', 'AMG'), 
(16, 'HONDA', 'SERIE 2', 'AMG'), 
(17, 'SMART', '207', 'OPC'), 
(18, 'FERRARI', '408', 'TDI'), 
(19, 'FIAT', 'SERIE 1', 'GTI'), 
(20, 'FORD', 'FTYPE', 'AMG');



insert into `Car_features` (`Car_features_ID`, `air_conditioning`, `parking_sensors`, `bluetooth`,`radio`,`gps`) values
(1, 0, 0, 0, 1, 0),
(2, 0, 1, 1, 1, 0),
(3, 1, 0, 1, 0, 0),
(4, 1, 0, 0, 1, 1),
(5, 1, 1, 1, 0, 0),
(6, 0, 1, 0, 1, 0),
(7, 1, 0, 0, 0, 0),
(8, 1, 1, 0, 1, 0),
(9, 0, 0, 1, 0, 1),
(10, 1, 1, 1, 1, 1),
(11, 1, 0, 0, 0, 1),
(12, 0, 1, 1, 0, 1),
(13, 0, 0, 1, 1, 0),
(14, 1, 1, 0, 0, 0),
(15, 0, 1, 1, 0, 0),
(16, 1, 0, 1, 0, 0),
(17, 1, 0, 1, 1, 1),
(18, 0, 0, 1, 1, 1),
(19, 0, 1, 1, 0, 1),
(20, 0, 1, 0, 1, 0),
(21, 1, 1, 0, 0, 1),
(22, 0, 1, 1, 0, 0),
(23, 1, 1, 1, 1, 0),
(24, 1, 1, 0, 1, 0),
(25, 0, 1, 0, 0, 0),
(26, 1, 0, 1, 1, 0),
(27, 0, 1, 1, 0, 1),
(28, 0, 0, 0, 1, 0),
(29, 0, 1, 0, 0, 0),
(30, 0, 0, 0, 1, 1),
(31, 0, 1, 0, 0, 0),
(32, 0, 1, 0, 0, 0),
(33, 0, 0, 0, 0, 1),
(34, 0, 1, 1, 0, 1),
(35, 0, 0, 0, 0, 1),
(36, 1, 1, 1, 0, 1),
(37, 0, 0, 1, 1, 1),
(38, 0, 0, 0, 0, 1),
(39, 0, 0, 1, 1, 1),
(40, 1, 0, 1, 0, 0),
(41, 1, 0, 1, 1, 1),
(42, 0, 0, 1, 1, 1),
(43, 0, 0, 1, 1, 1),
(44, 0, 0, 0, 1, 0),
(45, 1, 1, 0, 1, 0),
(46, 1, 0, 1, 0, 0),
(47, 0, 1, 0, 0, 1),
(48, 1, 0, 0, 0, 0),
(49, 0, 1, 1, 1, 0),
(50, 0, 1, 1, 1, 1),
(51, 1, 0, 1, 1, 0),
(52, 0, 0, 1, 0, 0),
(53, 1, 0, 1, 0, 1),
(54, 0, 0, 0, 1, 0),
(55, 1, 1, 1, 1, 0),
(56, 1, 1, 0, 0, 1),
(57, 1, 0, 0, 0, 0), 
(58, 0, 1, 1, 0, 1),
(59, 1, 1, 0, 0, 0),
(60, 1, 0, 0, 0, 1);


insert into `Stands` (`Stand_ID`, `name`, `email`, `phone_number`, `nif`, `employee_number`, `Address_ID`) values
(1, 'TurboEmpire Carcavelos', 'turboempirecarcavelos@turboempire.pt',214456234, 566762277, 4, 1),
(2, 'TurboEmpire Santarém', 'turboempiresantarem@turboempire.pt', 243446274, 517544008, 4, 2),
(3, 'TurboEmpire Leiria', 'turboempireleiria@turboempire.pt', 244457248, 593764250, 4, 3);


insert into `Employees` (`Employee_ID`,`first_name`, `last_name`, `email`,`phone_number`,`nif`,`Stand_ID`,`job_title`,`salary`,`seniority`,`Address_ID`) values
(1,'Carla', 'Albuquerque', 'carla_albuquerque@turboempire.com', 918814421, 277863677, 1, 'Manager', 3400, 2013, 4),  
(2,'Ines', 'Pombo', 'ines_pombo@turboempire.com', 922831352, 278101794, 1, 'Assistant', 1150, 2018, 6), 
(3,'Miguel', 'Henriques', 'miguel_henriques@turboempire.com', 928270865, 272279754, 1, 'Assistant', 1300, 2015, 7), 
(4,'Diogo', 'Santos', 'diogo_santos@turboempire.com', 911418412, 277929876, 1, 'Assistant', 1400, 2013, 8), 
(5,'Bruna', 'Albuquerque', 'bruna_albuquerque@turboempire.com', 937370268, 273412666, 2, 'Manager', 3050, 2020, 10), 
(6,'Diogo', 'Vizoso', 'diogo_vizoso@turboempire.com', 919047106, 274478060, 2, 'Assistant', 1400, 2013, 13), 
(7,'Miguel', 'Vinagre', 'miguel_vinagre@turboempire.com', 932043606, 272110181, 2, 'Assistant', 1150, 2018, 14), 
(8,'Manuel', 'Albuquerque', 'manuel_albuquerque@turboempire.com', 918507060, 276980845, 2, 'Assistant', 1350, 2014, 15), 
(9,'Nuno', 'Costa', 'nuno_costa@turboempire.com', 918923028, 272953681, 3, 'Manager', 3400, 2013, 16), 
(10,'Bruna', 'Dias', 'bruna_dias@turboempire.com', 930450069, 274017459, 3, 'Assistant', 1300, 2015, 18), 
(11,'Carolina', 'Jesus', 'carolina_jesus@turboempire.com', 932748628, 270471301, 3, 'Assistant', 1250, 2016, 19), 
(12,'Joao', 'Vasconcelos', 'joao_vasconcelos@turboempire.com', 923242490, 277839515, 3, 'Assistant', 1400, 2013, 20);



insert into `Customers` (`customer_ID`, `first_name`, `last_name`, `phone_number`, `email`, `nif`, `singular`, `Address_ID`) values
(1, 'Carlos', 'Lda', 936478628, 'carlos_lda@gmail.com', 272330968, 0, 24),
(2, 'Daniel', 'Pereira', 911278047, 'daniel_pereira@gmail.com', 275749347, 1, 25),
(3, 'Goncalo', 'Lda', 920971541, 'goncalo_lda@gmail.com', 270257296, 0, 26),
(4, 'Bruna', 'Conde', 916558332, 'bruna_conde@gmail.com', 272387894, 1, 27),
(5, 'Joao', 'Pereira', 915276529, 'joao_pereira@gmail.com', 273226349, 1, 28),
(6, 'Miguel', 'Jesus', 912728291, 'miguel_jesus@gmail.com', 270843914, 1, 29),
(7, 'Jorge', 'Amorim', 927197786, 'jorge_amorim@gmail.com', 278187846, 1, 30),
(8, 'Soraia', 'Santos', 914579157, 'soraia_santos@gmail.com', 272245669, 1, 31),
(9, 'Sergio', 'Neto', 910817487, 'sergio_neto@gmail.com', 275683475, 1, 32),
(10, 'Soraia', 'Neto', 920511936, 'soraia_neto@gmail.com', 273486733, 1, 33),
(11, 'Joao', 'Conde', 917821438, 'joao_conde@gmail.com', 272043943, 1, 34),
(12, 'Bruno', 'Cunha', 918213162, 'bruno_cunha@gmail.com', 272760943, 1, 35),
(13, 'Carlota', 'Silva', 918089466, 'carlota_silva@gmail.com', 278915015, 1, 36),
(14, 'Joao', 'Lda', 916495881, 'joao_lda@gmail.com', 272231313, 0, 37),
(15, 'Silvia', 'Lda', 917999945, 'silvia_lda@gmail.com', 273686104, 0, 38),
(16, 'Carlota', 'Vinagre', 925943844, 'carlota_vinagre@gmail.com', 277679141, 1, 39),
(17, 'Carla', 'Jesus', 916567179, 'carla_jesus@gmail.com', 276682035, 1, 40),
(18, 'Goncalo', 'Henriques', 915326386, 'goncalo_henriques@gmail.com', 276382746, 1, 41),
(19, 'Vasco', 'Neto', 918526497, 'vasco_neto@gmail.com', 276731414, 1, 42),
(20, 'Silvia', 'Carvalho', 921985726, 'silvia_carvalho@gmail.com', 274553679, 1, 43);



insert into `Cars_for_sale` (`Car_for_sale_ID`, `hp`, `state`, `type_of_fuel`, `color`, `number_doors`, `number_seats`, `registration_year`, `price`, `current_mileage`, `Model_ID`, `Stand_ID`) values
(1, 76, 'Used', 'Gasoline', 'Red', 3, 5, 2019, 35806, 44302, 1, 1),
(2, 245, 'New', 'Electric', 'Red', 3, 2, 2016, 15594, 8, 14, 1),
(3, 123, 'New', 'Gasoline', 'Red', 5, 4, 1997, 39530, 26, 2, 1),
(4, 218, 'New', 'Diesel', 'White', 3, 5, 2009, 41595, 118, 16, 1),
(5, 103, 'New', 'Gasoline', 'Black', 3, 4, 2017, 21358, 137, 4, 1),
(6, 392, 'Used', 'Gasoline', 'Green', 3, 5, 2016, 48507, 13025, 10, 1),
(7, 356, 'New', 'Gasoline', 'Blue', 5, 4, 2021, 29361, 44, 2, 1),
(8, 172, 'Used', 'Electric', 'Black', 5, 4, 2020, 55548, 46987, 9, 1),
(9, 185, 'Used', 'Electric', 'White', 5, 5, 2020, 58877, 29454, 3, 1),
(10, 303, 'New', 'Gasoline', 'Red', 3, 4, 2018, 16416, 131, 15, 1),
(11, 277, 'Used', 'Electric', 'Blue', 5, 2, 2017, 38373, 29557, 20, 1),
(12, 254, 'New', 'Electric', 'Red', 5, 4, 2014, 50135, 100, 10, 1),
(13, 147, 'New', 'Gasoline', 'Red', 5, 2, 2009, 44442, 6, 14, 1),
(14, 287, 'Used', 'Electric', 'Red', 3, 2, 2018, 36132, 27146, 19, 1),
(15, 219, 'Used', 'Gasoline', 'Blue', 5, 4, 2015, 14379, 38200, 18, 1),
(16, 111, 'New', 'Gasoline', 'Red', 3, 5, 2005, 17652, 85, 11, 1),
(17, 372, 'New', 'Electric', 'Red', 5, 2, 1995, 15910, 29, 13, 1),
(18, 175, 'New', 'Electric', 'Blue', 5, 4, 2008, 33633, 115, 5, 1),
(19, 349, 'New', 'Electric', 'Blue', 3, 4, 2002, 30908, 124, 13, 1),
(20, 294, 'New', 'Electric', 'Blue', 3, 5, 2005, 16627, 33, 10, 1),
(21, 347, 'Used', 'Electric', 'White', 5, 5, 2012, 40335, 14955, 7, 2),
(22, 371, 'New', 'Electric', 'Red', 5, 2, 1997, 54013, 129, 18, 2),
(23, 117, 'Used', 'Diesel', 'Green', 3, 4, 2005, 50914, 45767, 14, 2),
(24, 236, 'Used', 'Electric', 'Green', 3, 4, 2020, 56475, 1331, 12, 2),
(25, 382, 'New', 'Diesel', 'Green', 3, 4, 1995, 35676, 87, 11, 2),
(26, 282, 'New', 'Gasoline', 'White', 3, 4, 2016, 27402, 59, 18, 2),
(27, 251, 'New', 'Diesel', 'White', 3, 4, 1996, 56427, 21, 6, 2),
(28, 370, 'New', 'Gasoline', 'Blue', 5, 5, 2004, 25283, 144, 5, 2),
(29, 192, 'Used', 'Diesel', 'Blue', 3, 2, 2004, 42612, 15434, 3, 2),
(30, 323, 'New', 'Electric', 'Blue', 5, 5, 2004, 29938, 132, 12, 2),
(31, 312, 'New', 'Electric', 'Green', 5, 4, 2001, 39522, 66, 8, 2),
(32, 65, 'New', 'Diesel', 'Red', 3, 5, 2021, 27869, 30, 18, 2),
(33, 278, 'New', 'Electric', 'White', 3, 4, 1997, 58364, 101, 6, 2),
(34, 260, 'Used', 'Diesel', 'Blue', 3, 5, 2000, 54549, 49951, 2, 2),
(35, 345, 'New', 'Gasoline', 'Red', 3, 4, 2021, 54871, 43, 12, 2),
(36, 221, 'Used', 'Diesel', 'Blue', 5, 2, 2011, 45948, 18092, 12, 2),
(37, 352, 'New', 'Gasoline', 'Blue', 3, 5, 2015, 21184, 111, 20, 2),
(38, 388, 'New', 'Diesel', 'White', 5, 5, 2010, 52948, 9, 1, 2),
(39, 217, 'Used', 'Gasoline', 'Green', 5, 4, 2019, 51310, 37907, 3, 2),
(40, 347, 'New', 'Electric', 'Black', 5, 2, 2020, 15521, 125, 8, 2),
(41, 216, 'Used', 'Diesel', 'Red', 5, 2, 2018, 41254, 6761, 15, 3),
(42, 164, 'New', 'Electric', 'Green', 3, 2, 2012, 44951, 5, 1, 3),
(43, 118, 'Used', 'Diesel', 'Black', 5, 2, 2006, 36490, 49329, 2, 3),
(44, 160, 'Used', 'Gasoline', 'Blue', 5, 5, 2008, 50605, 25130, 5, 3),
(45, 174, 'Used', 'Electric', 'Green', 5, 2, 2009, 14287, 9602, 4, 3),
(46, 234, 'Used', 'Electric', 'White', 5, 5, 2006, 21472, 4763, 12, 3),
(47, 75, 'Used', 'Diesel', 'Black', 3, 4, 2018, 19832, 5143, 11, 3),
(48, 387, 'Used', 'Gasoline', 'Green', 5, 4, 1996, 57601, 4333, 12, 3),
(49, 210, 'Used', 'Gasoline', 'Blue', 3, 4, 2007, 35157, 38129, 13, 3),
(50, 100, 'New', 'Diesel', 'White', 3, 5, 1996, 18403, 46, 2, 3),
(51, 121, 'New', 'Gasoline', 'White', 3, 4, 2005, 28065, 134, 14, 3),
(52, 354, 'Used', 'Gasoline', 'Black', 5, 4, 2006, 27143, 18405, 13, 3),
(53, 297, 'Used', 'Diesel', 'Red', 3, 2, 2015, 10668, 41318, 20, 3),
(54, 231, 'Used', 'Diesel', 'White', 5, 4, 2004, 26138, 9211, 15, 3),
(55, 371, 'New', 'Electric', 'Green', 5, 4, 2002, 41838, 98, 2, 3),
(56, 91, 'Used', 'Gasoline', 'Blue', 5, 4, 2021, 36202, 44968, 15, 3),
(57, 357, 'Used', 'Electric', 'Green', 5, 5, 2002, 19847, 29273, 15, 3),
(58, 103, 'Used', 'Diesel', 'Red', 3, 2, 2019, 53158, 32965, 6, 3),
(59, 133, 'New', 'Diesel', 'White', 3, 5, 1995, 32349, 131, 15, 3),
(60, 291, 'Used', 'Electric', 'White', 5, 2, 1994, 56664, 18179, 12, 3);


insert into `Cars_for_sale_has_Car_features` (`Car_for_sale_ID`, `Car_features_ID`) values
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10),
(11, 11),
(12, 12),
(13, 13),
(14, 14),
(15, 15),
(16, 16),
(17, 17),
(18, 18),
(19, 19),
(20, 20),
(21, 21),
(22, 22),
(23, 23),
(24, 24),
(25, 25),
(26, 26),
(27, 27),
(28, 28),
(29, 29),
(30, 30),
(31, 31),
(32, 32),
(33, 33),
(34, 34),
(35, 35),
(36, 36),
(37, 37),
(38, 38),
(39, 39),
(40, 40),
(41, 41),
(42, 42),
(43, 43),
(44, 44),
(45, 45),
(46, 46),
(47, 47),
(48, 48),
(49, 49),
(50, 50),
(51, 51),
(52, 52),
(53, 53),
(54, 54),
(55, 55),
(56, 56),
(57, 57),
(58, 58),
(59, 59),
(60, 60);


INSERT INTO `te`.`cars_sold` (`Car_sold_ID`, `Customer_ID`, `Car_for_sale_ID`, `agreed_price`, `date_sold`, `prompt_payment`, `monthly_payment_amount`, `number_due_payments`, `Employee_ID`, `paid`, `total_amount_paid`, `service_rating`) VALUES 
(1, 1, 43, 36490, '2020-02-25', 1, 0, 0, 12, 1, 36490, 5),
(2, 1, 54, 26138, '2020-02-25', 1, 0, 0, 12, 1, 26138, 5),
(3, 2, 38, 52948, '2020-03-02', 0, 529.48, 79, 6, 0, 11119.08, 4),
(4, 3, 23, 50814, '2020-04-26', 1, 0, 0, 8, 1, 50814, 5),
(5, 3, 25, 35576, '2020-04-26', 1, 0, 0, 8, 1, 35576, 5),
(6, 3, 27, 56327, '2020-04-26', 1, 0, 0, 8, 1, 56327, 5),
(7, 3, 29, 42512, '2020-04-26', 1, 0, 0, 8, 1, 42512, 5),
(8, 4, 12, 50135, '2020-05-05', 0, 501.35, 80, 1, 0, 10027, NULL),
(9, 5, 60, 54664, '2020-05-20', 0, 546.64, 81, 9, 0, 10386.16, 5),
(10, 6, 17, 13910, '2020-06-01', 1, 0, 0, 4, 1, 13910, 3),
(11, 7, 59, 32349, '2020-07-02', 0, 323.49, 82, 10, 0, 5822.82, 4),
(12, 8, 48, 57601, '2020-08-03', 0, 576.01, 83, 10, 0, 9792.17, 3),
(13, 9, 50, 18403, '2020-08-27', 1, 0, 0, 9, 1, 18403, NULL),
(14, 10, 3, 39530, '2020-09-29', 0, 395.3, 85, 3, 0, 5929.5, 4),
(15, 11, 22, 54013, '2020-10-13', 0, 540.13, 85, 6, 0, 8101.95, 3),
(16, 12, 33, 58364, '2020-11-27', 0, 583.64, 87, 6, 0, 7587.32, NULL),
(17, 13, 34, 54549, '2020-12-15', 0, 545.49, 88, 8, 0, 6545.88, 4),
(18, 14, 37, 20184, '2021-01-03', 1, 0, 0, 6, 1, 20184, 5),
(19, 14, 36, 44948, '2021-01-03', 1, 0, 0, 6, 1, 44948, 5),
(20, 14, 21, 40335, '2021-01-03', 1, 0, 0, 6, 1, 40335, 5),
(21, 15, 2, 15594, '2021-02-15', 1, 0, 0, 3, 1, 15594, 4),
(22, 15, 6, 48507, '2021-02-15', 1, 0, 0, 3, 1, 48507, 4),
(23, 16, 26, 27402, '2021-03-07', 0, 274.02, 90, 8, 0, 2740.2, NULL),
(24, 17, 16, 14652, '2021-03-08', 1, 0, 0, 4, 1, 14652, 5),
(25, 18, 20, 16627, '2021-04-12', 1, 0, 0, 4, 1, 16627, 5),
(26, 19, 51, 28065, '2021-05-15', 0, 280.65, 93, 11, 0, 1964.55, 4),
(27, 20, 46, 21472, '2021-06-21', 0, 214.72, 94, 12, 0, 1288.32, 4),
(28, 1, 52, 25143, '2021-07-22', 1, 0, 0, 12, 1, 25143, 5),
(29, 1, 49, 33157, '2021-07-22', 1, 0, 0, 12, 1, 33157, 5);

insert into `Customer_Payments` (`Customer_Payments_ID`, `Car_sold_ID`, `Customer_ID`, `payment_date`,`amount_paid`) values
(1, 1, 1, '2020-02-25', 36490),
(2, 2, 1, '2020-02-25', 26138),
(3, 3, 2, '2020-03-02', 529.48),
(4, 3, 2, '2020-04-02', 529.48),
(5, 4, 3, '2020-04-26', 50814),
(6, 5, 3, '2020-04-26', 35576),
(7, 6, 3, '2020-04-26', 56327),
(8, 7, 3, '2020-04-26', 42512),
(9, 3, 2, '2020-05-02', 529.48),
(10, 8, 4, '2020-05-05', 501.35),
(11, 9, 5, '2020-05-20', 546.64),
(12, 10, 6, '2020-06-01', 13910),
(13, 3, 2, '2020-06-02', 529.48),
(14, 8, 4, '2020-06-05', 501.35),
(15, 9, 5, '2020-06-20', 546.64),
(16, 3, 2, '2020-07-02', 529.48),
(17, 11, 7, '2020-07-02', 323.49),
(18, 8, 4, '2020-07-05', 501.35),
(19, 9, 5, '2020-07-20', 546.64),
(20, 3, 2, '2020-08-02', 529.48),
(21, 11, 7, '2020-08-02', 323.49),
(22, 12, 8, '2020-08-03', 576.01),
(23, 8, 4, '2020-08-05', 501.35),
(24, 9, 5, '2020-08-20', 546.64),
(25, 13, 9, '2020-08-27', 18403),
(26, 3, 2, '2020-09-02', 529.48),
(27, 11, 7, '2020-09-02', 323.49),
(28, 12, 8, '2020-09-03', 576.01),
(29, 8, 4, '2020-09-05', 501.35),
(30, 9, 5, '2020-09-20', 546.64),
(31, 14, 10, '2020-09-29', 395.3),
(32, 3, 2, '2020-10-02', 529.48),
(33, 11, 7, '2020-10-02', 323.49),
(34, 12, 8, '2020-10-03', 576.01),
(35, 8, 4, '2020-10-05', 501.35),
(36, 15, 11, '2020-10-13', 540.13),
(37, 9, 5, '2020-10-20', 546.64),
(38, 14, 10, '2020-10-29', 395.3),
(39, 3, 2, '2020-11-02', 529.48),
(40, 11, 7, '2020-11-02', 323.49),
(41, 12, 8, '2020-11-03', 576.01),
(42, 8, 4, '2020-11-05', 501.35),
(43, 15, 11, '2020-11-13', 540.13),
(44, 9, 5, '2020-11-20', 546.64),
(45, 16, 12, '2020-11-27', 583.64),
(46, 14, 10, '2020-11-29', 395.3),
(47, 3, 2, '2020-12-02', 529.48),
(48, 11, 7, '2020-12-02', 323.49),
(49, 12, 8, '2020-12-03', 576.01),
(50, 8, 4, '2020-12-05', 501.35),
(51, 15, 11, '2020-12-13', 540.13),
(52, 17, 13, '2020-12-15', 545.49),
(53, 9, 5, '2020-12-20', 546.64),
(54, 16, 12, '2020-12-27', 583.64),
(55, 14, 10, '2020-12-29', 395.3),
(56, 3, 2, '2021-01-02', 529.48),
(57, 11, 7, '2021-01-02', 323.49),
(58, 12, 8, '2021-01-03', 576.01),
(59, 18, 14, '2021-01-03', 20184),
(60, 19, 14, '2021-01-03', 44948),
(61, 20, 14, '2021-01-03', 40335),
(62, 8, 4, '2021-01-05', 501.35),
(63, 15, 11, '2021-01-13', 540.13),
(64, 17, 13, '2021-01-15', 545.49),
(65, 9, 5, '2021-01-20', 546.64),
(66, 16, 12, '2021-01-27', 583.64),
(67, 14, 10, '2021-01-29', 395.3),
(68, 3, 2, '2021-02-02', 529.48),
(69, 11, 7, '2021-02-02', 323.49),
(70, 12, 8, '2021-02-03', 576.01),
(71, 8, 4, '2021-02-05', 501.35),
(72, 15, 11, '2021-02-13', 540.13),
(73, 17, 13, '2021-02-15', 545.49),
(74, 21, 15, '2021-02-15', 15594),
(75, 22, 15, '2021-02-15', 48507),
(76, 9, 5, '2021-02-20', 546.64),
(77, 16, 12, '2021-02-27', 583.64),
(78, 14, 10, '2021-02-28', 395.3),
(79, 3, 2, '2021-03-02', 529.48),
(80, 11, 7, '2021-03-02', 323.49),
(81, 12, 8, '2021-03-03', 576.01),
(82, 8, 4, '2021-03-05', 501.35),
(83, 23, 16, '2021-03-07', 274.02),
(84, 24, 17, '2021-03-08', 14652),
(85, 15, 11, '2021-03-13', 540.13),
(86, 17, 13, '2021-03-15', 545.49),
(87, 9, 5, '2021-03-20', 546.64),
(88, 16, 12, '2021-03-27', 583.64),
(89, 14, 10, '2021-03-29', 395.3),
(90, 3, 2, '2021-04-02', 529.48),
(91, 11, 7, '2021-04-02', 323.49),
(92, 12, 8, '2021-04-03', 576.01),
(93, 8, 4, '2021-04-05', 501.35),
(94, 23, 16, '2021-04-07', 274.02),
(95, 25, 18, '2021-04-12', 16627),
(96, 15, 11, '2021-04-13', 540.13),
(97, 17, 13, '2021-04-15', 545.49),
(98, 9, 5, '2021-04-20', 546.64),
(99, 16, 12, '2021-04-27', 583.64),
(100, 14, 10, '2021-04-29', 395.3),
(101, 3, 2, '2021-05-02', 529.48),
(102, 11, 7, '2021-05-02', 323.49),
(103, 12, 8, '2021-05-03', 576.01),
(104, 8, 4, '2021-05-05', 501.35),
(105, 23, 16, '2021-05-07', 274.02),
(106, 15, 11, '2021-05-13', 540.13),
(107, 17, 13, '2021-05-15', 545.49),
(108, 26, 19, '2021-05-15', 280.65),
(109, 9, 5, '2021-05-20', 546.64),
(110, 16, 12, '2021-05-27', 583.64),
(111, 14, 10, '2021-05-29', 395.3),
(112, 3, 2, '2021-06-02', 529.48),
(113, 11, 7, '2021-06-02', 323.49),
(114, 12, 8, '2021-06-03', 576.01),
(115, 8, 4, '2021-06-05', 501.35),
(116, 23, 16, '2021-06-07', 274.02),
(117, 15, 11, '2021-06-13', 540.13),
(118, 26, 19, '2021-06-15', 280.65),
(119, 17, 13, '2021-06-15', 545.49),
(120, 9, 5, '2021-06-20', 546.64),
(121, 27, 20, '2021-06-21', 214.72),
(122, 16, 12, '2021-06-27', 583.64),
(123, 14, 10, '2021-06-29', 395.3),
(124, 3, 2, '2021-07-02', 529.48),
(125, 11, 7, '2021-07-02', 323.49),
(126, 12, 8, '2021-07-03', 576.01),
(127, 8, 4, '2021-07-05', 501.35),
(128, 23, 16, '2021-07-07', 274.02),
(129, 15, 11, '2021-07-13', 540.13),
(130, 26, 19, '2021-07-15', 280.65),
(131, 17, 13, '2021-07-15', 545.49),
(132, 9, 5, '2021-07-20', 546.64),
(133, 27, 20, '2021-07-21', 214.72),
(134, 28, 1, '2021-07-22', 25143),
(135, 29, 1, '2021-07-22', 33157),
(136, 16, 12, '2021-07-27', 583.64),
(137, 14, 10, '2021-07-29', 395.3),
(138, 3, 2, '2021-08-02', 529.48),
(139, 11, 7, '2021-08-02', 323.49),
(140, 12, 8, '2021-08-03', 576.01),
(141, 8, 4, '2021-08-05', 501.35),
(142, 23, 16, '2021-08-07', 274.02),
(143, 15, 11, '2021-08-13', 540.13),
(144, 26, 19, '2021-08-15', 280.65),
(145, 17, 13, '2021-08-15', 545.49),
(146, 9, 5, '2021-08-20', 546.64),
(147, 27, 20, '2021-08-21', 214.72),
(148, 16, 12, '2021-08-27', 583.64),
(149, 14, 10, '2021-08-29', 395.3),
(150, 11, 7, '2021-09-02', 323.49),
(151, 12, 8, '2021-09-03', 576.01),
(152, 8, 4, '2021-09-05', 501.35),
(153, 23, 16, '2021-09-07', 274.02),
(154, 15, 11, '2021-09-13', 540.13),
(155, 26, 19, '2021-09-15', 280.65),
(156, 17, 13, '2021-09-15', 545.49),
(157, 9, 5, '2021-09-20', 546.64),
(158, 27, 20, '2021-09-21', 214.72),
(159, 16, 12, '2021-09-27', 583.64),
(160, 14, 10, '2021-09-29', 395.3),
(161, 3, 2, '2021-10-02', 529.48),
(162, 11, 7, '2021-10-02', 323.49),
(163, 12, 8, '2021-10-03', 576.01),
(164, 8, 4, '2021-10-05', 501.35),
(165, 23, 16, '2021-10-07', 274.02),
(166, 15, 11, '2021-10-13', 540.13),
(167, 26, 19, '2021-10-15', 280.65),
(168, 17, 13, '2021-10-15', 545.49),
(169, 9, 5, '2021-10-20', 546.64),
(170, 27, 20, '2021-10-21', 214.72),
(171, 16, 12, '2021-10-27', 583.64),
(172, 14, 10, '2021-10-29', 395.3),
(173, 3, 2, '2021-11-02', 529.48),
(174, 11, 7, '2021-11-02', 323.49),
(175, 12, 8, '2021-11-03', 576.01),
(176, 8, 4, '2021-11-05', 501.35),
(177, 23, 16, '2021-11-07', 274.02),
(178, 15, 11, '2021-11-13', 540.13),
(179, 26, 19, '2021-11-15', 280.65),
(180, 17, 13, '2021-11-15', 545.49),
(181, 9, 5, '2021-11-20', 546.64),
(182, 27, 20, '2021-11-21', 214.72),
(183, 16, 12, '2021-11-27', 583.64),
(184, 14, 10, '2021-11-29', 395.3),
(185, 3, 2, '2021-12-02', 529.48),
(186, 11, 7, '2021-12-02', 323.49),
(187, 12, 8, '2021-12-03', 576.01),
(188, 8, 4, '2021-12-05', 501.35),
(189, 23, 16, '2021-12-07', 274.02),
(190, 15, 11, '2021-12-13', 540.13);


-- -----------------------------------------------------
-- Invoice
-- -----------------------------------------------------

#Invoice example for Customer with ID = 19 and date = 2021-05-15
#There is only 1 car per invoice
CREATE VIEW invoice_details AS
SELECT concat(l.manufacturer_name, ', ', l.model_name) AS Product, l.price AS 'Price', 
1 AS Quantity, (l.price*1) AS Amount
FROM log l, customers c, Cars_sold cs
WHERE cs.Customer_ID = c.customer_ID AND l.Car_sold_ID = cs.Car_sold_ID
AND c.customer_ID = 19 AND cs.date_sold = '2021-05-15';

#The tax rate is merely informative for tax purposes. The price already includes VAT
CREATE VIEW invoice_heading_total AS
SELECT cs.Car_sold_ID AS 'Invoice Number', cs.date_sold AS 'Date of Issue',
concat(c.`first_name`, ' ', c.`last_name`) as 'Client Name', a1.address AS 'Street address',
concat(a1.county, ', ', a1.city, ', ', a1.district) AS 'County, City, District', a1.zip_code AS 'ZIP Code',
s.name AS 'Company Name', a2.address AS 'Street', s.phone_number AS 'Phone Number', s.email AS email,
'www.turboempirecars.pt', inv.Amount AS 'Subtotal', (l.price - l.agreed_price) AS 'Discount', 
'23%' AS '(TAX RATE)', ROUND((l.price - (l.price/1.23)),2) AS TAX, l.agreed_price AS TOTAL,
IF(cs.prompt_payment = 1, concat('Prompt payment due ', cs.date_sold), concat('First payment of ', cs.monthly_payment_amount, ' due by ', cs.date_sold, ' ,', ' after that pay', ' ', cs.monthly_payment_amount, ' ', 'every 30D until the payment is completed'))
AS 'Payment terms'
FROM customers c, addresses a1, addresses a2, stands s, cars_sold cs, log l, invoice_details inv
WHERE c.Address_ID = a1.Address_ID AND s.Address_ID = a2.Address_ID AND c.Customer_ID = cs.Customer_ID
AND cs.Car_sold_ID = l.Car_sold_ID AND l.Stand_ID = s.Stand_ID AND c.customer_ID = 19 AND cs.date_sold = '2021-05-15';
