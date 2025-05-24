-- Query 1: Find properties with average rating > 4.0
-- Non-correlated subquery

SELECT * FROM PROPERTY
WHERE property_id IN(
    SELECT property_id FROM REVIEW
    GROUP BY property_id
    HAVING AVG(rating) > 4.0
)



-- Query 2: Find users who have made more than 3 bookings
-- Correlated subquery

SELECT * FROM USER
WHERE (
    SELECT COUNT(BOOKING.user_id)
    FROM BOOKING
    WHERE BOOKING.user_id = USER.user_id
) > 3;



