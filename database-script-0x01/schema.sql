-- USER TABLE
CREATE TABLE USER (
    user_id UUID PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    role ENUM('guest', 'host', 'admin') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX (email)
);

-- PROPERTY TABLE
CREATE TABLE PROPERTY (
    property_id UUID PRIMARY KEY,
    host_id UUID NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR(255) NOT NULL,
    pricepernight DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (host_id) REFERENCES USER(user_id),
    INDEX (host_id)
);

-- BOOKING TABLE
CREATE TABLE BOOKING (
    booking_id UUID PRIMARY KEY,
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    price_at_booking DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    status ENUM('pending', 'confirmed', 'canceled') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (property_id) REFERENCES PROPERTY(property_id),
    FOREIGN KEY (user_id) REFERENCES USER(user_id),
    INDEX (property_id),
    INDEX (user_id)
);

-- PAYMENT TABLE
CREATE TABLE PAYMENT (
    payment_id UUID PRIMARY KEY,
    booking_id UUID NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method ENUM('credit_card', 'paypal', 'stripe') NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES BOOKING(booking_id),
    INDEX (booking_id)
);

-- REVIEW TABLE
CREATE TABLE REVIEW (
    review_id UUID PRIMARY KEY,
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (property_id) REFERENCES PROPERTY(property_id),
    FOREIGN KEY (user_id) REFERENCES USER(user_id),
    INDEX (property_id),
    INDEX (user_id)
);

-- MESSAGE TABLE
CREATE TABLE MESSAGE (
    message_id UUID PRIMARY KEY,
    sender_id UUID NOT NULL,
    recipient_id UUID NOT NULL,
    message_body TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_id) REFERENCES USER(user_id),
    FOREIGN KEY (recipient_id) REFERENCES USER(user_id),
    INDEX (sender_id),
    INDEX (recipient_id)
);

-- On every new booking, snapshot the nightly rate and compute total_price
DELIMITER //
CREATE TRIGGER trg_before_booking_insert
BEFORE INSERT ON BOOKING
FOR EACH ROW
BEGIN
  DECLARE nightly_rate DECIMAL(10,2);
  SELECT pricepernight 
    INTO nightly_rate 
    FROM PROPERTY 
    WHERE property_id = NEW.property_id;
  
  SET NEW.price_at_booking = nightly_rate;
  SET NEW.total_price      = nightly_rate * DATEDIFF(NEW.end_date, NEW.start_date);
END;
//
DELIMITER ;

-- On every new payment, snapshot the booking's total_price
DELIMITER //
CREATE TRIGGER trg_before_payment_insert
BEFORE INSERT ON PAYMENT
FOR EACH ROW
BEGIN
  DECLARE booking_total DECIMAL(10,2);
  SELECT total_price
    INTO booking_total
    FROM BOOKING
    WHERE booking_id = NEW.booking_id;
  
  SET NEW.amount = booking_total;
END;
//
DELIMITER ;

