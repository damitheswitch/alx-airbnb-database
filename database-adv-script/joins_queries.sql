-- Query 1: INNER JOIN to retrieve all bookings and their respective users
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.status,
    u.first_name,
    u.last_name,
    u.email
FROM BOOKING b
INNER JOIN USER u ON b.user_id = u.user_id;

-- Query 2: LEFT JOIN to retrieve all properties and their reviews
SELECT 
    p.property_id,
    p.name,
    p.location,
    r.review_id,
    r.rating,
    r.comment,
    r.created_at as review_date
FROM PROPERTY p
LEFT JOIN REVIEW r ON p.property_id = r.property_id
ORDER BY p.name, r.created_at;

-- Query 3: FULL OUTER JOIN to retrieve all users and all bookings
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    b.booking_id,
    b.start_date,
    b.end_date,
    b.status
FROM USER u
LEFT JOIN BOOKING b ON u.user_id = b.user_id
UNION
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    b.booking_id,
    b.start_date,
    b.end_date,
    b.status
FROM BOOKING b
LEFT JOIN USER u ON b.user_id = u.user_id
WHERE u.user_id IS NULL;

