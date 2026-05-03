-- ============================================================
-- Part 3: Data Queries
-- ============================================================

-- ============================================================
-- Basic Level
-- ============================================================

-- 1. List all flights and their current status, ordered by departure datetime from earliest to latest.
SELECT Flight_no, Status FROM Flight ORDER BY Dep_datetime ASC;

-- 2. Show all passengers, ordered alphabetically by full name.
SELECT * FROM Passenger ORDER BY F_name;

-- 3. List all aircraft and their seating capacity, ordered from largest to smallest.
SELECT Reg_num, Seat_capacity FROM Aircraft ORDER BY Seat_capacity DESC;

-- 4. Show all bookings and their class. Display only distinct class values that exist in the system.
SELECT DISTINCT Class FROM Booking;

-- 5. List all flights that have a status of 'Delayed' or 'Cancelled'.
SELECT * FROM Flight WHERE Status='Delayed' OR Status='Cancelled';

-- 6. Show all passengers whose nationality is 'Omani'.
SELECT * FROM Passenger WHERE Nationality='Omani';

-- 7. List all airports, ordered by country.
SELECT * FROM Airport ORDER BY Country;
