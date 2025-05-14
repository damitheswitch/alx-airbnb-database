-- USERS
INSERT INTO USER (user_id, first_name, last_name, email, password_hash, phone_number, role)
VALUES
  (UUID(), 'Alice', 'Smith', 'alice@example.com', 'hashed_pw1', '1234567890', 'host'),
  (UUID(), 'Bob', 'Jones', 'bob@example.com', 'hashed_pw2', '2345678901', 'guest'),
  (UUID(), 'Carol', 'Taylor', 'carol@example.com', 'hashed_pw3', NULL, 'guest'),
  (UUID(), 'David', 'Lee', 'david@example.com', 'hashed_pw4', '3456789012', 'admin');

-- PROPERTIES
INSERT INTO PROPERTY (property_id, host_id, name, description, location, pricepernight)
VALUES
  (UUID(), (SELECT user_id FROM USER WHERE first_name = 'Alice'), 'Cozy Cabin', 'A quiet retreat in the woods', 'Lake Tahoe', 120.00),
  (UUID(), (SELECT user_id FROM USER WHERE first_name = 'Alice'), 'Urban Apartment', 'Downtown apartment with skyline view', 'New York City', 220.00);

-- BOOKINGS
INSERT INTO BOOKING (booking_id, property_id, user_id, start_date, end_date, status)
VALUES
  (UUID(),
   (SELECT property_id FROM PROPERTY WHERE name = 'Cozy Cabin'),
   (SELECT user_id FROM USER WHERE first_name = 'Bob'),
   '2025-06-01', '2025-06-05', 'confirmed'),

  (UUID(),
   (SELECT property_id FROM PROPERTY WHERE name = 'Urban Apartment'),
   (SELECT user_id FROM USER WHERE first_name = 'Carol'),
   '2025-07-10', '2025-07-12', 'pending');

-- PAYMENTS
INSERT INTO PAYMENT (payment_id, booking_id, payment_method)
VALUES
  (UUID(),
   (SELECT booking_id FROM BOOKING WHERE start_date = '2025-06-01'),
   'credit_card');

-- REVIEWS
INSERT INTO REVIEW (review_id, property_id, user_id, rating, comment)
VALUES
  (UUID(),
   (SELECT property_id FROM PROPERTY WHERE name = 'Cozy Cabin'),
   (SELECT user_id FROM USER WHERE first_name = 'Bob'),
   5, 'Had an amazing stay! Very peaceful and clean.');

-- MESSAGES
INSERT INTO MESSAGE (message_id, sender_id, recipient_id, message_body)
VALUES
  (UUID(),
   (SELECT user_id FROM USER WHERE first_name = 'Bob'),
   (SELECT user_id FROM USER WHERE first_name = 'Alice'),
   'Hi! Just checking if the cabin has Wi-Fi?'),

  (UUID(),
   (SELECT user_id FROM USER WHERE first_name = 'Alice'),
   (SELECT user_id FROM USER WHERE first_name = 'Bob'),
   'Yes, it does. Fast and reliable!');

