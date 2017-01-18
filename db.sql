-- MySQL Script generated by MySQL Workbench
-- Fri 13 Jan 2017 12:04:33 PM EST
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema stumblephish
--
-- Stumblephish customizable phishing campaign application
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `stumblephish` DEFAULT CHARACTER SET utf8 ;
USE `stumblephish` ;



-- -----------------------------------------------------
-- Table `stumblephish`.`target`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `stumblephish`.`target` (
  `target_id` INT NOT NULL AUTO_INCREMENT,
  `target_fname` VARCHAR(255) NULL,
  `target_lname` VARCHAR(255) NULL,
  `target_email` VARCHAR(255) NOT NULL,
  `target_dept` VARCHAR(255) NULL,
  `target_title` VARCHAR(255) NULL,
  PRIMARY KEY (`target_id`),
  UNIQUE INDEX `target_id_UNIQUE` (`target_id` ASC))
ENGINE = InnoDB
COMMENT = 'The people who can be targeted in a campaign.';


-- -----------------------------------------------------
-- Table `stumblephish`.`email_template`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `stumblephish`.`email_template` (
  `email_template_id` INT NOT NULL AUTO_INCREMENT,
  `email_template_name` VARCHAR(255) NOT NULL,
  `email_template_html_text` TEXT NULL,
  `email_template_plain_text` TEXT NOT NULL,
  `email_template_subject` VARCHAR(255) NOT NULL,
  `email_template_sender_name` VARCHAR(255) NOT NULL,
  `email_template_sender_email` VARCHAR(255) NOT NULL,
  `email_template_replyto` VARCHAR(255) NULL,
  PRIMARY KEY (`email_template_id`))
ENGINE = InnoDB
COMMENT = 'Templates for phishing emails.';


-- -----------------------------------------------------
-- Table `stumblephish`.`web_template`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `stumblephish`.`web_template` (
  `web_template_id` INT NOT NULL AUTO_INCREMENT,
  `web_template_name` VARCHAR(255) NULL,
  `web_template_text` TEXT NULL,
  PRIMARY KEY (`web_template_id`))
ENGINE = InnoDB
COMMENT = 'Templates for web pages.';


-- -----------------------------------------------------
-- Table `stumblephish`.`campaign`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `stumblephish`.`campaign` (
  `campaign_id` INT NOT NULL AUTO_INCREMENT,
  `campaign_name` VARCHAR(255) NOT NULL,
  `campaign_start` DATETIME NOT NULL,
  `campaign_end` DATETIME NOT NULL,
  `email_template_id` INT NOT NULL,
  `landing_template_id` INT NOT NULL,
  `education_template_id` INT NOT NULL,
  UNIQUE INDEX `campaign_id_UNIQUE` (`campaign_id` ASC),
  PRIMARY KEY (`campaign_id`),
  INDEX `fk_campaign_1_idx` (`email_template_id` ASC),
  INDEX `fk_campaign_2_idx` (`landing_template_id` ASC),
  INDEX `fk_campaign_3_idx` (`education_template_id` ASC),
  CONSTRAINT `fk_campaign_1`
    FOREIGN KEY (`email_template_id`)
    REFERENCES `stumblephish`.`email_template` (`email_template_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_campaign_2`
    FOREIGN KEY (`landing_template_id`)
    REFERENCES `stumblephish`.`web_template` (`web_template_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_campaign_3`
    FOREIGN KEY (`education_template_id`)
    REFERENCES `stumblephish`.`web_template` (`web_template_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Phishing campaigns tracked by the Stumblephish system.';


-- -----------------------------------------------------
-- Table `stumblephish`.`token`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `stumblephish`.`token` (
  `token_id` INT NOT NULL AUTO_INCREMENT,
  `campaign_id` INT NOT NULL,
  `target_id` INT NOT NULL,
  `token_token` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`token_id`),
  INDEX `fk_token_1_idx` (`campaign_id` ASC),
  INDEX `fk_token_2_idx` (`target_id` ASC),
  CONSTRAINT `fk_token_1`
    FOREIGN KEY (`campaign_id`)
    REFERENCES `stumblephish`.`campaign` (`campaign_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_token_2`
    FOREIGN KEY (`target_id`)
    REFERENCES `stumblephish`.`target` (`target_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Unique tokens to disguise info.';


-- -----------------------------------------------------
-- Table `stumblephish`.`bite`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `stumblephish`.`bite` (
  `bite_id` INT NOT NULL AUTO_INCREMENT,
  `token_id` INT NOT NULL,
  `bite_when` DATETIME NOT NULL,
  `bite_browser_ua` VARCHAR(255) NULL,
  `bite_remote_addr` VARCHAR(15) NOT NULL,
  `bite_remote_addr_num` INT NOT NULL,
  `bite_post_vars` TEXT,
  PRIMARY KEY (`bite_id`),
  INDEX `fk_bite_1_idx` (`token_id` ASC),
  CONSTRAINT `fk_bite_1`
    FOREIGN KEY (`token_id`)
    REFERENCES `stumblephish`.`token` (`token_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Tracking hits by phishing targets when they land.';


-- -----------------------------------------------------
-- Table `stumblephish`.`group`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `stumblephish`.`group` (
  `group_id` INT NOT NULL AUTO_INCREMENT,
  `group_name` VARCHAR(255) NULL,
  PRIMARY KEY (`group_id`))
ENGINE = InnoDB
COMMENT = 'Campaigns target specific groups rather .';


-- -----------------------------------------------------
-- Table `stumblephish`.`target_x_group`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `stumblephish`.`target_x_group` (
  `target_id` INT NOT NULL,
  `group_id` INT NOT NULL,
  INDEX `fk_target_x_group_1_idx` (`target_id` ASC),
  INDEX `fk_target_x_group_2_idx` (`group_id` ASC),
  CONSTRAINT `fk_target_x_group_1`
    FOREIGN KEY (`target_id`)
    REFERENCES `stumblephish`.`target` (`target_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_target_x_group_2`
    FOREIGN KEY (`group_id`)
    REFERENCES `stumblephish`.`group` (`group_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Targets can be in multiple groups.';


-- -----------------------------------------------------
-- Table `stumblephish`.`campaign_x_group`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `stumblephish`.`campaign_x_group` (
  `campaign_id` INT NOT NULL,
  `group_id` INT NOT NULL,
  INDEX `fk_campaign_x_group_1_idx` (`campaign_id` ASC),
  INDEX `fk_campaign_x_group_2_idx` (`group_id` ASC),
  CONSTRAINT `fk_campaign_x_group_1`
    FOREIGN KEY (`campaign_id`)
    REFERENCES `stumblephish`.`campaign` (`campaign_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_campaign_x_group_2`
    FOREIGN KEY (`group_id`)
    REFERENCES `stumblephish`.`group` (`group_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Campaigns can target multiple groups.';

-- -----------------------------------------------------
-- Table `stumblephish`.`logs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `stumblephish`.`logs` (
  `log_message` TEXT NOT NULL,
  `log_datetime` DATETIME NOT NULL,
  `log_type` ENUM('INFO', 'WARN', 'ERROR') NOT NULL DEFAULT 'INFO')
ENGINE = InnoDB
COMMENT = 'Used for internal application logs.';


-- -----------------------------------------------------
-- Table `stumblephish`.`mailer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `stumblephish`.`mailer` (
  `mailer_id` INT NOT NULL AUTO_INCREMENT,
  `token_id` INT NOT NULL,
  `mailer_sendtime` DATETIME NOT NULL,
  `mailer_successful` TINYINT(1) NOT NULL DEFAULT 1,
  `mailer_message` TEXT NULL,
  PRIMARY KEY (`mailer_id`),
  INDEX `fk_mailer_1_idx` (`token_id` ASC),
  CONSTRAINT `fk_mailer_1`
    FOREIGN KEY (`token_id`)
    REFERENCES `stumblephish`.`token` (`token_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Logs from the mailer application and any SMTP feedback.';

-- -----------------------------------------------------
-- Create user accounts
-- -----------------------------------------------------

CREATE USER 'sp_admin'@'localhost' IDENTIFIED BY 'change_stumblephish_password';
CREATE USER 'sp_mailer'@'localhost' IDENTIFIED BY 'change_stumblephish_password';
CREATE USER 'sp_website'@'localhost' IDENTIFIED BY 'change_stumblephish_password';
CREATE USER 'sp_reportadmin'@'localhost' IDENTIFIED BY 'change_stumblephish_password';

-- Superadmin/developer account
GRANT ALL ON stumblephish.* TO 'sp_admin'@'localhost';
-- Mailer account
GRANT SELECT ON stumblephish.campaign TO 'sp_mailer'@'localhost';
GRANT SELECT ON stumblephish.campaign_x_group TO 'sp_mailer'@'localhost';
GRANT SELECT ON stumblephish.group TO 'sp_mailer'@'localhost';
GRANT SELECT ON stumblephish.target_x_group TO 'sp_mailer'@'localhost';
GRANT SELECT ON stumblephish.target TO 'sp_mailer'@'localhost';
GRANT SELECT ON stumblephish.email_template TO 'sp_mailer'@'localhost';
GRANT SELECT ON stumblephish.target TO 'sp_mailer'@'localhost';
GRANT SELECT,INSERT ON stumblephish.token TO 'sp_mailer'@'localhost';
GRANT INSERT ON stumblephish.logs TO 'sp_mailer'@'localhost';
GRANT INSERT ON stumblephish.mailer TO 'sp_mailer'@'localhost';
-- Website front end account
GRANT SELECT ON stumblephish.web_template TO 'sp_website'@'localhost';
GRANT INSERT ON stumblephish.logs TO 'sp_website'@'localhost';
GRANT INSERT ON stumblephish.bite TO 'sp_website'@'localhost';
GRANT SELECT ON stumblephish.token TO 'sp_website'@'localhost';
-- Administrative interface account
GRANT SELECT,INSERT,UPDATE,DELETE ON stumblephish.campaign TO 'sp_reportadmin'@'localhost';
GRANT SELECT,INSERT,UPDATE,DELETE ON stumblephish.campaign_x_group TO 'sp_reportadmin'@'localhost';
GRANT SELECT,INSERT,UPDATE,DELETE ON stumblephish.group TO 'sp_reportadmin'@'localhost';
GRANT SELECT,INSERT,UPDATE,DELETE ON stumblephish.target_x_group TO 'sp_reportadmin'@'localhost';
GRANT SELECT,INSERT,UPDATE,DELETE ON stumblephish.target TO 'sp_reportadmin'@'localhost';
GRANT SELECT,INSERT,UPDATE,DELETE ON stumblephish.email_template TO 'sp_reportadmin'@'localhost';
GRANT SELECT,INSERT,UPDATE,DELETE ON stumblephish.web_template TO 'sp_reportadmin'@'localhost';
GRANT SELECT,INSERT,UPDATE,DELETE ON stumblephish.target TO 'sp_reportadmin'@'localhost';
GRANT SELECT stumblephish.token TO 'sp_reportadmin'@'localhost';
GRANT SELECT ON stumblephish.bite TO 'sp_reportadmin'@'localhost';
GRANT SELECT,INSERT ON stumblephish.logs TO 'sp_reportadmin'@'localhost';
GRANT SELECT ON stumblephish.mailer TO 'sp_reportadmin'@'localhost';


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
