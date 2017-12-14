CREATE TABLE `carts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `quantity` tinyint(3) unsigned NOT NULL,
  `user_session_id` char(32) NOT NULL,
  `product_type` enum('storage', 'others') NOT NULL,
  `product_id` mediumint(8) unsigned NOT NULL,
  `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `coupon_applied` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `product_type` (`product_type`,`product_id`),
  KEY `user_session_id` (`user_session_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

CREATE TABLE `admin` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(80) NOT NULL,
  `password` char(40) NOT NULL,
  `first_name` VARCHAR(20) NOT NULL,
  `last_name` VARCHAR(40) NOT NULL,
  `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY(`id`),
  Constraint `admin_email_UQ` UNIQUE(`email`)
);

INSERT INTO `admin`(`id`, `email`, `password`,`first_name`, `last_name`) VALUES(1,'admin@its450000.com',sha1('admin'), 'Site', 'Admin');

CREATE TABLE `customers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(80) NOT NULL,
  `password` char(40) NOT NULL,
  `first_name` VARCHAR(20) NOT NULL,
  `last_name` VARCHAR(40) NOT NULL,
  `gender` char(1) NOT NULL ,
  `dob` date,
  `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `image` varchar(45),
  PRIMARY KEY(`id`),
  Constraint `email_UQ` UNIQUE(`email`)
);


CREATE TABLE `address`(
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `customer_id` int(10) NOT NULL,
  `first_name` varchar(20) NOT NULL,
  `last_name` varchar(40) NOT NULL,
  `address1` varchar(80) NOT NULL,
  `address2` varchar(80) DEFAULT NULL,
  `city` varchar(60) NOT NULL,
  `state` char(2) NOT NULL,
  `zip` mediumint(5) unsigned zerofill NOT NULL,
  `phone` bigint(11) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

CREATE TABLE `storage_devices` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `category` varchar(40) NOT NULL,
  `description` tinytext,
  `image` varchar(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `type` (`category`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

INSERT INTO `storage_devices` VALUES(1, 'Pen Drives', 'Easily portable small sized and can be carried in the pocket', 'pen-drive.jpg');
INSERT INTO `storage_devices` VALUES(2, 'External Hard Disk', 'large capacity portable device', 'external-hdd.jpg');
INSERT INTO `storage_devices` VALUES(3, 'Internal Hard Disk', 'large capacity non-portable device', 'internal-hdd.jpg');

CREATE TABLE `other_categories` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `category` varchar(40) NOT NULL,
  `description` tinytext NOT NULL,
  `image` varchar(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `category` (`category`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

CREATE TABLE `other_products` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `other_category_id` tinyint(3) unsigned NOT NULL,
  `name` varchar(60) NOT NULL,
  `description` tinytext,
  `image` varchar(45) NOT NULL,
  `price` decimal(5,2) unsigned NOT NULL,
  `stock` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `other_category_id` (`other_category_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;


CREATE TABLE `orders` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `customer_id` int(10) unsigned NOT NULL,
  `delivery_address` int(10) unsigned NOT NULL,
  `total` decimal(7,2) unsigned DEFAULT NULL,
  `shipping` decimal(5,2) unsigned NOT NULL,
  `credit_card_number` mediumint(4) unsigned NOT NULL,
  `order_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `coupon_applied` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `customer_id` (`customer_id`),
  KEY `order_date` (`order_date`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

CREATE TABLE `order_contents` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `order_id` int(10) unsigned NOT NULL,
  `product_type` enum('storage','other','sale') DEFAULT NULL,
  `product_id` mediumint(8) unsigned NOT NULL,
  `quantity` tinyint(3) unsigned NOT NULL,
  `price_per` decimal(5,2) unsigned NOT NULL,
  `ship_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ship_date` (`ship_date`),
  KEY `product_type` (`product_type`,`product_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

CREATE TABLE `sales` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `product_type` enum('storage','other') DEFAULT NULL,
  `product_id` mediumint(8) unsigned NOT NULL,
  `price` decimal(5,2) unsigned NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `start_date` (`start_date`),
  KEY `product_type` (`product_type`,`product_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

CREATE TABLE `sizes` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `size` varchar(40) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `size` (`size`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

INSERT INTO `sizes` VALUES(1, '8GB');
INSERT INTO `sizes` VALUES(2, '16GB');
INSERT INTO `sizes` VALUES(3, '32GB');
INSERT INTO `sizes` VALUES(4, '64GB');
INSERT INTO `sizes` VALUES(5, '128GB');
INSERT INTO `sizes` VALUES(6, '256GB');
INSERT INTO `sizes` VALUES(7, '512GB');
INSERT INTO `sizes` VALUES(8, '1TB');
INSERT INTO `sizes` VALUES(9, '2TB');


CREATE TABLE if not exists `coupons`(
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `coupon_code` VARCHAR(10) NOT NULL,
  `product_type` enum('storage','other', 'both') DEFAULT NULL,
  `method` enum('flat', 'percent') NOT NULL,
  `discount_amount` decimal(5,2) NOT NULL,
  `start_date` date NOT NULL, 
  `end_date` date DEFAULT NULL,
  PRIMARY KEY(`id`),
  KEY `coupon_code` (`coupon_code`)
);

CREATE TABLE `storage_device_products` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `storage_device_id` tinyint(3) unsigned NOT NULL,
  `size_id` tinyint(3) unsigned NOT NULL,
  `company_name` varchar(50) DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL,  
  `usb2_3` enum('usb2', 'usb3') DEFAULT NULL,
  `scsi_ide` enum('scsi','ide') DEFAULT NULL,
  `price` decimal(5,2) unsigned NOT NULL,
  `stock` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `image` varchar(45) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `storage_device_id` (`storage_device_id`),
  KEY `size` (`size_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

INSERT INTO `storage_device_products` VALUES(1, 1, 3, 'Trascend','','usb2',NULL, 12.00, 15, '2010-08-15 19:15:54','32gb1.jpg');
INSERT INTO `storage_device_products` VALUES(2, 1, 3, 'HP','','usb2',NULL, 11.00, 5, '2010-08-15 19:15:54','32gb2.jpg');
INSERT INTO `storage_device_products` VALUES(3, 1, 3, 'Slate','','usb2',NULL, 10.50, 25, '2010-08-15 19:15:54','32gb3.jpg');
INSERT INTO `storage_device_products` VALUES(4, 1, 4, 'Sony','','usb2',NULL, 22.00, 15, '2010-08-15 19:15:54','64gb1.jpg');
INSERT INTO `storage_device_products` VALUES(5, 1, 4, 'DTSE9','','usb2',NULL, 22.50, 12, '2010-08-15 19:15:54','64gb2.jpg');
INSERT INTO `storage_device_products` VALUES(6, 1, 4, 'Lexar','','usb3',NULL, 21.00, 11, '2010-08-15 19:15:54','64gb3.jpg');
INSERT INTO `storage_device_products` VALUES(7, 1, 5, 'PNY','','usb3',NULL, 40.00, 15, '2010-08-15 19:15:54','128gb1.jpg');
INSERT INTO `storage_device_products` VALUES(8, 1, 5, 'Sandisk','','usb3',NULL, 42.00, 18, '2010-08-15 19:15:54','128gb2.jpg');
INSERT INTO `storage_device_products` VALUES(9, 1, 5, 'Crossair','','usb3',NULL, 41.00, 20, '2010-08-15 19:15:54','128gb3.jpg');
INSERT INTO `storage_device_products` VALUES(10, 1, 6, 'Lexar','','usb3',NULL, 90.00, 12, '2010-08-15 19:15:54','256gb1.jpg');
INSERT INTO `storage_device_products` VALUES(11, 2, 8, 'FD','','usb3',NULL, 55.00, 15, '2010-08-15 19:15:54','hd1.jpg');
INSERT INTO `storage_device_products` VALUES(12, 2, 8, 'Verbatim','','usb3',NULL, 52.00, 22, '2010-08-15 19:15:54','hd2.jpg');
INSERT INTO `storage_device_products` VALUES(13, 2, 8, 'Seagate','','usb3',NULL, 52.00, 10, '2010-08-15 19:15:54','hd3.jpg');
INSERT INTO `storage_device_products` VALUES(14, 2, 8, 'Toshiba','','usb3',NULL, 52.50, 8, '2010-08-15 19:15:54','hd4.jpg');
INSERT INTO `storage_device_products` VALUES(15, 2, 9, 'SP','','usb3',NULL, 110, 18, '2010-08-15 19:15:54','hd5.jpg');
INSERT INTO `storage_device_products` VALUES(16, 2, 9, 'Seagate','','usb3',NULL, 115, 12, '2010-08-15 19:15:54','hd6.jpg');


CREATE TABLE `transactions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `order_id` int(10) unsigned NOT NULL,
  `type` varchar(18) NOT NULL,
  `amount` decimal(7,2) NOT NULL,
  `response_code` tinyint(1) unsigned NOT NULL,
  `response_reason` tinytext,
  `transaction_id` bigint(20) unsigned NOT NULL,
  `response` text NOT NULL,
  `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

CREATE TABLE `wish_lists` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `quantity` tinyint(3) unsigned NOT NULL,
  `user_session_id` char(32) NOT NULL,
  `product_type` enum('storage','other','sale') DEFAULT NULL,
  `product_id` mediumint(8) unsigned NOT NULL,
  `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_modified` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  KEY `product_type` (`product_type`,`product_id`),
  KEY `user_session_id` (`user_session_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;


-- -----------------------------
-- Stored Procedures --
-- -----------------------------

DELIMITER $$
CREATE PROCEDURE select_categories (type VARCHAR(7))
BEGIN
IF type = 'storage' THEN
SELECT * FROM storage_devices ORDER by category;
ELSEIF type = 'other' THEN
SELECT * FROM other_categories ORDER by category;
END IF;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE select_sale_items (get_all BOOLEAN)
BEGIN
IF get_all = 1 THEN 
SELECT CONCAT("O", op.id) AS sku, sa.price AS sale_price, oc.category, op.image, op.name, op.price, op.stock, op.description FROM sales AS sa INNER JOIN other_products AS op ON sa.product_id=op.id INNER JOIN other_categories AS oc ON oc.id=op.other_category_id WHERE sa.product_type="other" AND ((NOW() BETWEEN sa.start_date AND sa.end_date) OR (NOW() > sa.start_date AND sa.end_date IS NULL) )
UNION SELECT CONCAT("S", sdp.id), sa.price, sd.category, sdp.image, CONCAT_WS(" - ", sdp.company_name, s.size, sdp.usb2_3, sdp.scsi_ide), sdp.price, sdp.stock, sd.description FROM sales AS sa INNER JOIN storage_device_products AS sdp ON sa.product_id=sdp.id INNER JOIN sizes AS s ON s.id=sdp.size_id INNER JOIN storage_devices AS sd ON sd.id=sdp.storage_device_id WHERE sa.product_type="storage" AND ((NOW() BETWEEN sa.start_date AND sa.end_date) OR (NOW() > sa.start_date AND sa.end_date IS NULL) );
ELSE 
(SELECT CONCAT("O", op.id) AS sku, sa.price AS sale_price, oc.category, op.image, op.name FROM sales AS sa INNER JOIN other_products AS op ON sa.product_id=op.id INNER JOIN other_categories AS oc ON oc.id=op.other_category_id WHERE sa.product_type="other" AND ((NOW() BETWEEN sa.start_date AND sa.end_date) OR (NOW() > sa.start_date AND sa.end_date IS NULL) ) ORDER BY RAND() LIMIT 2) 
UNION (SELECT CONCAT("S", sdp.id), sa.price, sd.category, sdp.image, CONCAT_WS(" - ", sdp.company_name, s.size, sdp.usb2_3, sdp.scsi_ide) FROM sales AS sa INNER JOIN storage_device_products AS sdp ON sa.product_id=sdp.id INNER JOIN sizes AS s ON s.id=sdp.size_id INNER JOIN storage_devices AS sd ON sd.id=sdp.storage_device_id WHERE sa.product_type="storage" AND ((NOW() BETWEEN sa.start_date AND sa.end_date) OR (NOW() > sa.start_date AND sa.end_date IS NULL) ) ORDER BY RAND() LIMIT 2);
END IF;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE select_products(type VARCHAR(7), cat TINYINT)
BEGIN
IF type = 'storage' THEN
SELECT sd.description, sdp.image, CONCAT("S", sdp.id) AS sku, 
CONCAT_WS(" - ", sdp.company_name, s.size, sdp.usb2_3, sdp.scsi_ide) AS name, 
sdp.stock, sdp.price, sales.price AS sale_price 
FROM storage_device_products AS sdp INNER JOIN sizes AS s ON s.id=sdp.size_id 
INNER JOIN storage_devices AS sd ON sd.id=sdp.storage_device_id 
LEFT OUTER JOIN sales ON (sales.product_id=sdp.id 
AND sales.product_type='storage' AND 
((NOW() BETWEEN sales.start_date AND sales.end_date) 
OR (NOW() > sales.start_date AND sales.end_date IS NULL)) ) 
WHERE storage_device_id=cat AND stock>0 
ORDER by name;
ELSEIF type = 'other' THEN
SELECT oc.description AS g_description, op.image AS g_image, 
CONCAT("O", op.id) AS sku, op.name, op.description, op.image, 
op.price, op.stock, sales.price AS sale_price
FROM other_products AS op INNER JOIN other_categories AS oc 
ON oc.id=op.other_category_id 
LEFT OUTER JOIN sales ON (sales.product_id=op.id 
AND sales.product_type='other' AND 
((NOW() BETWEEN sales.start_date AND sales.end_date) OR (NOW() > sales.start_date AND sales.end_date IS NULL)) )
WHERE other_category_id=cat ORDER by date_created DESC;
END IF;
END$$
DELIMITER ;



DELIMITER $$
CREATE PROCEDURE get_products_list()
BEGIN
SELECT CONCAT("S", sdp.id) as sku, sdp.`id`,sdp.storage_device_id, sd.`category`, 'storage' as type, sz.`size`, sdp.size_id, sdp.`company_name`, sdp.`description`, sdp.`usb2_3`, sdp.`scsi_ide`, sdp.`price`, sdp.`stock`, sdp.`date_created`, sdp.`image` 
FROM `storage_device_products` sdp 
INNER JOIN `storage_devices` sd 
ON sdp.storage_device_id = sd.id
INNER JOIN `sizes` sz
ON sdp.size_id = sz.id
UNION
SELECT CONCAT("S", op.id) as sku, op.`id`, op.`other_category_id`, oc.`category`,'other' as type, null ,null, op.`name`, op.`description`, op.`image`, null,null,op.`price`, op.`stock`, op.`date_created`
FROM `other_products` op
INNER JOIN `other_categories` oc
ON op.`other_category_id` = oc.`id`;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE update_cart (uid CHAR(32), type VARCHAR(7), pid MEDIUMINT, qty TINYINT)
BEGIN
IF qty > 0 THEN
UPDATE carts SET quantity=qty, date_modified=NOW() WHERE user_session_id=uid AND product_type=type AND product_id=pid;
ELSEIF qty = 0 THEN
CALL remove_from_cart (uid, type, pid);
END IF;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE add_to_cart (uid CHAR(32), type VARCHAR(7), pid MEDIUMINT, qty TINYINT)
BEGIN
DECLARE cid INT;
SELECT id INTO cid FROM carts WHERE user_session_id=uid AND product_type=type AND product_id=pid;
IF cid > 0 THEN
UPDATE carts SET quantity=quantity+qty, date_modified=NOW() WHERE id=cid;
ELSE 
INSERT INTO carts (user_session_id, product_type, product_id, quantity) VALUES (uid, type, pid, qty);
END IF;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE remove_from_cart (uid CHAR(32), type VARCHAR(7), pid MEDIUMINT)
BEGIN
DELETE FROM carts WHERE user_session_id=uid AND product_type=type AND product_id=pid;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE apply_coupon (uid CHAR(32), cc VARCHAR(10))
BEGIN
DECLARE cid INT;
SELECT id INTO cid FROM carts WHERE user_session_id=uid AND product_type=type AND product_id=pid;
IF cid > 0 THEN
UPDATE carts SET quantity=quantity+qty, date_modified=NOW() WHERE id=cid;
ELSE 
INSERT INTO carts (user_session_id, product_type, product_id, quantity) VALUES (uid, type, pid, qty);
END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE get_shopping_cart_contents (uid CHAR(32))
BEGIN
SELECT CONCAT("O", op.id) AS sku, c.quantity, oc.category, op.name, op.price, op.stock, sales.price AS sale_price FROM carts AS c INNER JOIN other_products AS op ON c.product_id=op.id INNER JOIN other_categories AS oc ON oc.id=op.other_category_id LEFT OUTER JOIN sales ON (sales.product_id=op.id AND sales.product_type='other' AND ((NOW() BETWEEN sales.start_date AND sales.end_date) OR (NOW() > sales.start_date AND sales.end_date IS NULL)) ) WHERE c.product_type="other" AND c.user_session_id=uid 
UNION SELECT CONCAT("S", sdp.id), c.quantity, sd.category, CONCAT_WS(" - ", sdp.company_name, s.size, sdp.usb2_3, sdp.scsi_ide), sdp.price, sdp.stock, sales.price FROM carts AS c INNER JOIN storage_device_products AS sdp ON c.product_id=sdp.id INNER JOIN sizes AS s ON s.id=sdp.size_id INNER JOIN storage_devices AS sd ON sd.id=sdp.storage_device_id LEFT OUTER JOIN sales ON (sales.product_id=sdp.id AND sales.product_type='storage' AND ((NOW() BETWEEN sales.start_date AND sales.end_date) OR (NOW() > sales.start_date AND sales.end_date IS NULL)) ) WHERE c.product_type="storage" AND c.user_session_id=uid;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE update_wish_list (uid CHAR(32), type VARCHAR(7), pid MEDIUMINT, qty TINYINT)
BEGIN
IF qty > 0 THEN
UPDATE wish_lists SET quantity=qty, date_modified=NOW() WHERE user_session_id=uid AND product_type=type AND product_id=pid;
ELSEIF qty = 0 THEN
CALL remove_from_wish_list (uid, type, pid);
END IF;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE add_to_wish_list (uid CHAR(32), type VARCHAR(7), pid MEDIUMINT, qty TINYINT)
BEGIN
DECLARE cid INT;
SELECT id INTO cid FROM wish_lists WHERE user_session_id=uid AND product_type=type AND product_id=pid;
IF cid > 0 THEN
UPDATE wish_lists SET quantity=quantity+qty, date_modified=NOW() WHERE id=cid;
ELSE 
INSERT INTO wish_lists (user_session_id, product_type, product_id, quantity) VALUES (uid, type, pid, qty);
END IF;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE remove_from_wish_list (uid CHAR(32), type VARCHAR(7), pid MEDIUMINT)
BEGIN
DELETE FROM wish_lists WHERE user_session_id=uid AND product_type=type AND product_id=pid;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE get_wish_list_contents (uid CHAR(32))
BEGIN
SELECT CONCAT("O", op.id) AS sku, wl.quantity, oc.category, op.name, op.price, op.stock, sales.price AS sale_price FROM wish_lists AS wl INNER JOIN other_products AS op ON wl.product_id=op.id INNER JOIN other_categories AS oc ON oc.id=op.other_category_id LEFT OUTER JOIN sales ON (sales.product_id=op.id AND sales.product_type='other' AND ((NOW() BETWEEN sales.start_date AND sales.end_date) OR (NOW() > sales.start_date AND sales.end_date IS NULL)) ) WHERE wl.product_type="other" AND wl.user_session_id=uid UNION SELECT CONCAT("S", sdp.id), wl.quantity, sd.category, CONCAT_WS(" - ", sdp.company_name, s.size, sdp.usb2_3, sdp.scsi_ide), sdp.price, sdp.stock, sales.price FROM wish_lists AS wl INNER JOIN storage_device_products AS sdp ON wl.product_id=sdp.id INNER JOIN sizes AS s ON s.id=sdp.size_id INNER JOIN storage_devices AS sd ON sd.id=sdp.storage_device_id LEFT OUTER JOIN sales ON (sales.product_id=sdp.id AND sales.product_type='storage' AND ((NOW() BETWEEN sales.start_date AND sales.end_date) OR (NOW() > sales.start_date AND sales.end_date IS NULL)) ) WHERE wl.product_type="storage" AND wl.user_session_id=uid;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE add_customer(e VARCHAR(80), p VARCHAR(20), fn VARCHAR(20), ln VARCHAR(40), g CHAR(1), d DATETIME, OUT cid INT)
BEGIN
  INSERT INTO customers VALUES (NULL, e, sha1(p),fn, ln, g, d, NOW(), NULL);
  SELECT LAST_INSERT_ID() INTO cid;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE validate_user (e VARCHAR(80), p VARCHAR(80))
BEGIN
  SELECT id from customers WHERE `email`= e and `password` = sha1(p);
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE validate_admin (e VARCHAR(80), p VARCHAR(80))
BEGIN
  SELECT id from admin WHERE `email`= e and `password` = sha1(p);
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE add_address (cid int, f VARCHAR(20), l VARCHAR(40), a1 VARCHAR(80), a2 VARCHAR(80), c VARCHAR(60), s CHAR(2), z MEDIUMINT, p INT, OUT aid INT)
BEGIN
  INSERT INTO address(`customer_id`, `first_name`, `last_name`, `address1`, `address2`, `city`, `state`, `zip`, `phone`) VALUES (cid, f, l, a1, a2, c, s, z, p);
  SELECT LAST_INSERT_ID() INTO aid;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE get_addresses (cid INT)
BEGIN
  SELECT `id`, `customer_id`, `first_name`, `last_name`, `address1`, `address2`, `city`, `state`, `zip`, `phone` FROM `address` WHERE `customer_id`=cid;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE get_address (aid INT)
BEGIN
  SELECT `id`, `customer_id`, `first_name`, `last_name`, `address1`, `address2`, `city`, `state`, `zip`, `phone` FROM `address` WHERE `id`=aid;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE add_order (cid INT, uid CHAR(32), did INT, ship DECIMAL(5,2), cc MEDIUMINT, OUT total DECIMAL(7,2), OUT oid INT)
BEGIN
  DECLARE subtotal DECIMAL(7,2);
  INSERT INTO orders (customer_id, delivery_address, shipping, credit_card_number, order_date) VALUES (cid, did, ship, cc, NOW());
  SELECT LAST_INSERT_ID() INTO oid;
  INSERT INTO order_contents (order_id, product_type, product_id, quantity, price_per) SELECT oid, c.product_type, c.product_id, c.quantity, IFNULL(sales.price, op.price) FROM carts AS c INNER JOIN other_products AS op ON c.product_id=op.id LEFT OUTER JOIN sales ON (sales.product_id=op.id AND sales.product_type='other' AND ((NOW() BETWEEN sales.start_date AND sales.end_date) OR (NOW() > sales.start_date AND sales.end_date IS NULL)) ) WHERE c.product_type="other" AND c.user_session_id=uid UNION SELECT oid, c.product_type, c.product_id, c.quantity, IFNULL(sales.price, sdp.price) FROM carts AS c INNER JOIN storage_device_products AS sdp ON c.product_id=sdp.id LEFT OUTER JOIN sales ON (sales.product_id=sdp.id AND sales.product_type='storage' AND ((NOW() BETWEEN sales.start_date AND sales.end_date) OR (NOW() > sales.start_date AND sales.end_date IS NULL)) ) WHERE c.product_type="storage" AND c.user_session_id=uid;
  SELECT SUM(quantity*price_per) INTO subtotal FROM order_contents WHERE order_id=oid;
  UPDATE orders SET total = (subtotal + ship) WHERE id=oid;
  SELECT (subtotal + ship) INTO total;  
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE add_transaction (oid INT, trans_type VARCHAR(18), amt DECIMAL(7,2), rc TINYINT, rrc TINYTEXT, tid BIGINT, r TEXT)
BEGIN
  INSERT INTO transactions VALUES (NULL, oid, trans_type, amt, rc, rrc, tid, r, NOW());
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE clear_cart (uid CHAR(32))
BEGIN
  DELETE FROM carts WHERE user_session_id=uid;
END$$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE get_order_contents (oid INT)
BEGIN
SELECT oc.quantity, oc.price_per, (oc.quantity*oc.price_per) AS subtotal, oca.category, op.name, o.total, o.shipping FROM order_contents AS oc INNER JOIN other_products AS op ON oc.product_id=op.id INNER JOIN other_categories AS oca ON oc.id=op.other_category_id INNER JOIN orders AS o ON oc.order_id=o.id WHERE oc.product_type="other" AND oc.order_id=oid UNION SELECT oc.quantity, oc.price_per, (oc.quantity*oc.price_per), sd.category, CONCAT_WS(" - ", sdp.company_name, s.size, sdp.usb2_3, sdp.scsi_ide), o.total, o.shipping FROM order_contents AS oc INNER JOIN storage_device_products AS sdp ON oc.product_id=sdp.id INNER JOIN sizes AS s ON s.id=sdp.size_id INNER JOIN storage_devices AS sd ON sd.id=sdp.storage_device_id INNER JOIN orders AS o ON oc.order_id=o.id  WHERE oc.product_type="storage" AND oc.order_id=oid;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE update_order (oid INT, uid CHAR(32), did INT, ship DECIMAL(5,2), cc MEDIUMINT, OUT total DECIMAL(7,2))
BEGIN
  DECLARE subtotal DECIMAL(7,2);
  UPDATE orders SET delivery_address=did,shipping=ship,credit_card_number=cc,order_date=NOW() WHERE order_id=oid;
  DELETE FROM order_contents WHERE order_id=oid;
  INSERT INTO order_contents (order_id, product_type, product_id, quantity, price_per) SELECT oid, c.product_type, c.product_id, c.quantity, IFNULL(sales.price, op.price) FROM carts AS c INNER JOIN other_products AS op ON c.product_id=op.id LEFT OUTER JOIN sales ON (sales.product_id=op.id AND sales.product_type='other' AND ((NOW() BETWEEN sales.start_date AND sales.end_date) OR (NOW() > sales.start_date AND sales.end_date IS NULL)) ) WHERE c.product_type="other" AND c.user_session_id=uid UNION SELECT oid, c.product_type, c.product_id, c.quantity, IFNULL(sales.price, sdp.price) FROM carts AS c INNER JOIN storage_device_products AS sdp ON c.product_id=sdp.id LEFT OUTER JOIN sales ON (sales.product_id=sdp.id AND sales.product_type='storage' AND ((NOW() BETWEEN sales.start_date AND sales.end_date) OR (NOW() > sales.start_date AND sales.end_date IS NULL)) ) WHERE c.product_type="storage" AND c.user_session_id=uid;
  SELECT SUM(quantity*price_per) INTO subtotal FROM order_contents WHERE order_id=oid;
  UPDATE orders SET total = (subtotal + ship) WHERE id=oid;
  SELECT (subtotal + ship) INTO total;  
END$$
DELIMITER ;
