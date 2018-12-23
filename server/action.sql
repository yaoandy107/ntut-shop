-- You need to use root user to run the following script.

DROP USER IF EXISTS 'shopkeeper'@'%';

CREATE USER 'shopkeeper'@'%' IDENTIFIED BY 'ycjls5dm';

GRANT ALL ON ntutdb.* TO 'shopkeeper'@'%' IDENTIFIED BY 'ycjls5dm';

FLUSH PRIVILEGES;

DROP USER IF EXISTS 'shopkeeper'@'localhost';

CREATE USER 'shopkeeper'@'localhost' IDENTIFIED BY 'ycjls5dm';

GRANT ALL ON ntutdb.* TO 'shopkeeper'@'localhost' IDENTIFIED BY 'ycjls5dm';

FLUSH PRIVILEGES;

CREATE DATABASE IF NOT EXISTS ntutdb;

-- Create DATABASE
CREATE DATABASE IF NOT EXISTS ntutdb;

USE ntutdb;

-- MEMBER
CREATE TABLE IF NOT EXISTS MEMBER (
    id INT NOT NULL,
    user_id VARCHAR(64) NOT NULL,
    authority VARCHAR(20) NOT NULL,
    username VARCHAR(25) NOT NULL,
    nickname VARCHAR(25) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(50) NOT NULL,
    certificated TINYINT NOT NULL,
    permission TINYINT NOT NULL,
    register_time TIMESTAMP NOT NULL,
    PRIMARY KEY (id)
);

-- GOOD
CREATE TABLE IF NOT EXISTS GOOD (
    id INT NOT NULL,
    member_id INT NOT NULL,
    name VARCHAR(200) NOT NULL,
    stock INT NOT NULL,
    price INT NOT NULL,
    description VARCHAR(2000) NOT NULL,
    durability TINYINT NOT NULL,
    state TINYINT NOT NULL,
    publish_time TIMESTAMP NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (member_id) REFERENCES MEMBER(id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- RATE
CREATE TABLE IF NOT EXISTS RATE (
    source_id INT NOT NULL,
    target_id INT NOT NULL,
    stars TINYINT NOT NULL,
    comment VARCHAR(400) NOT NULL,
    time TIMESTAMP NOT NULL,
    PRIMARY KEY (source_id, target_id),
    FOREIGN KEY (source_id) REFERENCES MEMBER(id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (target_id) REFERENCES MEMBER(id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- MESSAGE_BOARD
CREATE TABLE IF NOT EXISTS MESSAGE_BOARD (
    id INT NOT NULL,
    source_id INT NOT NULL,
    good_id INT NOT NULL,
    content VARCHAR(800) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (source_id) REFERENCES MEMBER(id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (good_id) REFERENCES GOOD(id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- SHOPPING_CART
CREATE TABLE IF NOT EXISTS SHOPPING_CART (
    id INT NOT NULL,
    member_id INT NOT NULL,
    quantity INT NOT NULL,
    good_id INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (member_id) REFERENCES MEMBER(id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (good_id) REFERENCES GOOD(id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- SHIPPING
CREATE TABLE IF NOT EXISTS SHIPPING (
    id INT NOT NULL,
    service VARCHAR(40) NOT NULL,
    fee INT NOT NULL,
    good_id INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (good_id) REFERENCES GOOD(id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- PAYMENT
CREATE TABLE IF NOT EXISTS PAYMENT (
    id INT NOT NULL,
    good_id INT NOT NULL,
    service VARCHAR(40) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (good_id) REFERENCES GOOD(id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- ORDERS
CREATE TABLE IF NOT EXISTS ORDERS (
    id INT NOT NULL,
    member_id INT NOT NULL,
    shipping_id INT NOT NULL,
    payment_id INT NOT NULL,
    state TINYINT NOT NULL,
    transaction_time TIMESTAMP NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (member_id) REFERENCES MEMBER(id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (shipping_id) REFERENCES SHIPPING(id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (payment_id) REFERENCES PAYMENT(id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- ORDER_GOOD
CREATE TABLE IF NOT EXISTS ORDER_GOOD (
    good_id INT NOT NULL,
    order_id INT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (good_id, order_id),
    FOREIGN KEY (good_id) REFERENCES GOOD(id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (order_id) REFERENCES ORDERS(id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- TAG
CREATE TABLE IF NOT EXISTS TAG (
    good_id INT NOT NULL,
    name VARCHAR(40) NOT NULL,
    PRIMARY KEY (good_id, name),
    FOREIGN KEY (good_id) REFERENCES GOOD(id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- IMAGE
CREATE TABLE IF NOT EXISTS IMAGE (
    good_id INT NOT NULL,
    path VARCHAR(50) NOT NULL,
    PRIMARY KEY (good_id, path),
    FOREIGN KEY (good_id) REFERENCES GOOD(id)
        ON UPDATE CASCADE ON DELETE CASCADE
);