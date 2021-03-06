-- MySQL Script generated by MySQL Workbench
-- Mon 28 Jan 2019 03:23:35 PM EST
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='';

-- -----------------------------------------------------
-- Schema dean_qac
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema dean_qac
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `dean_qac` DEFAULT CHARACTER SET utf8 ;
USE `dean_qac` ;

-- -----------------------------------------------------
-- Table `dean_qac`.`site`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dean_qac`.`site` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `create_timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `update_timestamp` TIMESTAMP NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `uq_name` (`name` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dean_qac`.`technician`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dean_qac`.`technician` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `create_timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `update_timestamp` TIMESTAMP NOT NULL,
  `site_id` INT UNSIGNED NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_site_id` (`site_id` ASC),
  UNIQUE INDEX `uq_site_id_name` (`site_id` ASC, `name` ASC),
  CONSTRAINT `fk_technician_site_id`
    FOREIGN KEY (`site_id`)
    REFERENCES `dean_qac`.`site` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dean_qac`.`interview`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dean_qac`.`interview` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `create_timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `update_timestamp` TIMESTAMP NOT NULL,
  `site_id` INT UNSIGNED NOT NULL,
  `start_date` DATE NOT NULL,
  `uid` VARCHAR(10) NOT NULL,
  `barcode` VARCHAR(20) NOT NULL,
  `rank` TINYINT UNSIGNED NOT NULL,
  `duration` VARCHAR(256) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_site_id` (`site_id` ASC),
  UNIQUE INDEX `uq_site_id_uid_barcode_rank` (`site_id` ASC, `uid` ASC, `barcode` ASC, `rank` ASC),
  CONSTRAINT `fk_interview_site_id`
    FOREIGN KEY (`site_id`)
    REFERENCES `dean_qac`.`site` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dean_qac`.`stage`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dean_qac`.`stage` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `create_timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `update_timestamp` TIMESTAMP NOT NULL,
  `interview_id` INT UNSIGNED NOT NULL,
  `technician_id` INT UNSIGNED NULL,
  `name` VARCHAR(45) NOT NULL,
  `missing` TINYINT(1) NULL,
  `contraindicated` TINYINT(1) NULL,
  `comment` VARCHAR(1028) NULL,
  `qcdata` VARCHAR(512) NULL,
  `skip` VARCHAR(45) NULL,
  `duration` VARCHAR(1028) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_interview_id` (`interview_id` ASC),
  INDEX `fk_technician_id` (`technician_id` ASC),
  UNIQUE INDEX `uq_interview_id_technician_id_name` (`interview_id` ASC, `technician_id` ASC, `name` ASC),
  CONSTRAINT `fk_stage_interview_id`
    FOREIGN KEY (`interview_id`)
    REFERENCES `dean_qac`.`interview` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_stage_technician_id`
    FOREIGN KEY (`technician_id`)
    REFERENCES `dean_qac`.`technician` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `dean_qac`;

DELIMITER $$
USE `dean_qac`$$
CREATE DEFINER = CURRENT_USER TRIGGER `dean_qac`.`site_BEFORE_INSERT` BEFORE INSERT ON `site` FOR EACH ROW
BEGIN
SET NEW.create_timestamp = NOW();
END$$

USE `dean_qac`$$
CREATE DEFINER = CURRENT_USER TRIGGER `dean_qac`.`technician_BEFORE_INSERT` BEFORE INSERT ON `technician` FOR EACH ROW
BEGIN
SET NEW.create_timestamp = NOW();
END$$

USE `dean_qac`$$
CREATE DEFINER = CURRENT_USER TRIGGER `dean_qac`.`interview_BEFORE_INSERT` BEFORE INSERT ON `interview` FOR EACH ROW
BEGIN
SET NEW.create_timestamp = NOW();
END$$

USE `dean_qac`$$
CREATE DEFINER = CURRENT_USER TRIGGER `dean_qac`.`stage_BEFORE_INSERT` BEFORE INSERT ON `stage` FOR EACH ROW
BEGIN
SET NEW.create_timestamp = NOW();
IF NEW.technician_id IS NULL THEN
  SELECT COUNT(*) INTO @duplicate
  FROM stage
  WHERE interview_id = NEW.interview_id
  AND technician_id IS NULL
  AND name = NEW.name;
  IF @duplicate THEN
    SET @sql = CONCAT(
      "Duplicate entry'",
      NEW.interview_id, "-NULL-", NEW.name,
      " for key 'uq_interview_id_technician_id_name'"
     );
  END IF;
END IF;
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
