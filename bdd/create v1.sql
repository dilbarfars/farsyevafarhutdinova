-- create_v1.sql — структура БД магазина обуви «Башмак» (схема bashmak).
-- Выполнить целиком, затем выполнить data.sql.

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

CREATE SCHEMA IF NOT EXISTS `bashmak` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `bashmak`;

-- -----------------------------------------------------
-- Table `bashmak`.`categories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bashmak`.`categories` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `bashmak`.`manufacturers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bashmak`.`manufacturers` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `bashmak`.`pvz`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bashmak`.`pvz` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `postcode` CHAR(6) NOT NULL,
  `city` VARCHAR(30) NOT NULL,
  `street` VARCHAR(30) NOT NULL,
  `house` VARCHAR(5) NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `bashmak`.`orderstatus`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bashmak`.`orderstatus` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `bashmak`.`roles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bashmak`.`roles` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `bashmak`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bashmak`.`users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `full_name` VARCHAR(60) NOT NULL,
  `login` VARCHAR(50) NOT NULL,
  `password` VARCHAR(30) NOT NULL,
  `role_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_users_role` (`role_id` ASC) VISIBLE,
  CONSTRAINT `fk_users_role`
    FOREIGN KEY (`role_id`)
    REFERENCES `bashmak`.`roles` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `bashmak`.`orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bashmak`.`orders` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `order_date` DATETIME NOT NULL,
  `delivery_date` DATETIME NULL DEFAULT NULL,
  `pvz_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `receive_code` VARCHAR(10) NOT NULL,
  `status_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_orders_pvz` (`pvz_id` ASC) VISIBLE,
  INDEX `fk_orders_user` (`user_id` ASC) VISIBLE,
  INDEX `fk_orders_status` (`status_id` ASC) VISIBLE,
  CONSTRAINT `fk_orders_pvz`
    FOREIGN KEY (`pvz_id`)
    REFERENCES `bashmak`.`pvz` (`id`),
  CONSTRAINT `fk_orders_status`
    FOREIGN KEY (`status_id`)
    REFERENCES `bashmak`.`orderstatus` (`id`),
  CONSTRAINT `fk_orders_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `bashmak`.`users` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `bashmak`.`suppliers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bashmak`.`suppliers` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `bashmak`.`products`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bashmak`.`products` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `article` VARCHAR(10) NOT NULL,
  `name` VARCHAR(50) NOT NULL,
  `unit` VARCHAR(20) NOT NULL,
  `price` DECIMAL(10,2) NOT NULL,
  `discount` INT NOT NULL,
  `stock_qty` INT NOT NULL,
  `description` TEXT NULL DEFAULT NULL,
  `photo` TEXT NULL DEFAULT NULL,
  `category_id` INT NOT NULL,
  `manufacturer_id` INT NOT NULL,
  `supplier_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_products_category` (`category_id` ASC) VISIBLE,
  INDEX `fk_products_manufacturer` (`manufacturer_id` ASC) VISIBLE,
  INDEX `fk_products_supplier` (`supplier_id` ASC) VISIBLE,
  CONSTRAINT `fk_products_category`
    FOREIGN KEY (`category_id`)
    REFERENCES `bashmak`.`categories` (`id`),
  CONSTRAINT `fk_products_manufacturer`
    FOREIGN KEY (`manufacturer_id`)
    REFERENCES `bashmak`.`manufacturers` (`id`),
  CONSTRAINT `fk_products_supplier`
    FOREIGN KEY (`supplier_id`)
    REFERENCES `bashmak`.`suppliers` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------
-- Table `bashmak`.`prodorders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bashmak`.`prodorders` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `order_id` INT NOT NULL,
  `product_id` INT NOT NULL,
  `qty` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_prodorders_order` (`order_id` ASC) VISIBLE,
  INDEX `fk_prodorders_product` (`product_id` ASC) VISIBLE,
  CONSTRAINT `fk_prodorders_order`
    FOREIGN KEY (`order_id`)
    REFERENCES `bashmak`.`orders` (`id`)
    ON DELETE CASCADE,
  CONSTRAINT `fk_prodorders_product`
    FOREIGN KEY (`product_id`)
    REFERENCES `bashmak`.`products` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
