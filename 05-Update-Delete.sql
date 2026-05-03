-- ============================================================
-- PART 2: UPDATE and DELETE
-- ============================================================

-- ============================================================
-- UPDATE Tasks
-- ============================================================

-- 1. Update one flight status from 'Scheduled' to 'Completed'.
UPDATE Flight SET Status='Completed' WHERE Flight_no=1;

-- 2. Change one flight status from 'Delayed' to 'Cancelled'.
UPDATE Flight SET Status='Cancelled' WHERE Flight_no=4;

-- 3. Increase all Economy class booking prices by 10%.
UPDATE Booking SET Price=Price+(Price*0.1);

-- 4. Update one passenger's phone number.
UPDATE Passenger SET Phone='+96893018473' WHERE PID=6;

-- 5. Move one crew member to a different role.
UPDATE Crew SET Role='Engineer' WHERE License_no=5;


-- ============================================================
-- DELETE Tasks
-- ============================================================

-- 1. Delete one cancelled flight.
SELECT * FROM Flight;
DELETE FROM Flight WHERE Flight_no=4;

-- 2. Delete one booking linked to a cancelled flight.
SELECT * FROM Booking;
SELECT * FROM Flight;
-- ======
-- No booking linked to a cancelled flight.
-- ======

-- 3. Try to delete a passenger who has existing bookings. Observe what happens and
-- write a short comment in your SQL file explaining the result.
SELECT * FROM Booking;
DELETE FROM Passenger WHERE PID=1;
-- ======
-- The passenger got deleted due to the exist of constraint to all foreign keys ON DELETE CASCADE
-- ======