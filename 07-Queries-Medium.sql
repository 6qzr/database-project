-- ============================================================
-- Part 3: Data Queries
-- ============================================================

-- ============================================================
-- Medium Level
-- ============================================================

-- 1. For each flight, show the flight number, the name of the origin airport, and the name of the destination airport.
SELECT f.Flight_no, dep.Name AS Origin_Airport, arr.Name AS Destination_Airport
FROM Flight f
JOIN Airport dep ON f.Dep_airport=dep.IATA
JOIN Airport arr ON f.arr_airport=arr.IATA;

-- 2. Show each booking along with the full name of the passenger who made it and the flight number it belongs to.
SELECT b.BID, p.F_name, p.L_name, b.Flight_no
FROM Booking b
JOIN Passenger p ON b.PID=p.PID;

-- 3. List all crew members assigned to flight 'SK101', showing their full name and role.
SELECT F_name, L_name, Role
FROM Crew c
JOIN FlightCrew fc ON fc.Crew_no=c.License_no
WHERE fc.Flight_no=101;
-- NOTE that my Flight is an INT

-- 4. Show all completed flights along with the aircraft model used on each flight.
SELECT f.Status, a.Model
FROM Flight f
JOIN Aircraft a ON a.Reg_num=f.Aircraft
WHERE f.Status='Completed';

-- 5. For each passenger, show their full name and the total number of bookings they have made. Order by booking count from highest to lowest.
SELECT p.F_name, p.L_name, COUNT(b.BID) AS Total_bookings
FROM Passenger p
JOIN Booking b ON b.PID = p.PID
GROUP BY p.F_name, p.L_name
ORDER BY Total_bookings DESC;

-- 6. Show the total revenue collected from each booking class.
SELECT Class, SUM(Price) AS Total_revenue
FROM Booking
GROUP BY Class;

-- 7. Count how many flights each aircraft has been assigned to
SELECT a.Reg_num AS Aircraft, COUNT(F.Aircraft) AS No_flights
FROM Aircraft a
JOIN Flight f ON f.Aircraft=a.Reg_num
GROUP BY a.Reg_num;

-- 8. List all flights that have more than one booking.
SELECT Flight_no, COUNT(BID) AS No_Booking 
FROM Booking 
GROUP BY Flight_no 
HAVING COUNT(BID) > 1;

-- 9. Show the full details of all bookings — passenger name, flight number, origin airport, destination airport, class, and price paid.
SELECT p.F_name AS Passeneger_name, b.Flight_no, dep.Name AS Origin_Airport, arr.Name AS Destination_Airport, b.Class, b.Price
FROM Booking b
JOIN Passenger p ON p.PID=b.PID
JOIN Flight f ON f.Flight_no=b.Flight_no
JOIN Airport dep ON dep.IATA=f.Dep_airport
JOIN Airport arr ON arr.IATA=f.Arr_airport;