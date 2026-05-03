-- ============================================================
-- Part 3: Data Queries
-- ============================================================

-- ============================================================
-- Advanced Level
-- ============================================================

-- 1. Show each flight with its flight number, origin airport, destination airport, aircraft model, and the total
-- number of passengers booked on it. Include flights that have no bookings.
SELECT f.Flight_no, dep.Name AS Origin_Airport, arr.Name AS Destination_Airport, a.Model, COUNT(b.BID) AS Total_passengers
FROM Flight f
JOIN Airport dep ON dep.IATA=f.Dep_airport
JOIN Airport arr ON arr.IATA=f.Arr_airport
JOIN Aircraft a ON a.Reg_num=f.Aircraft
LEFT JOIN Booking b ON b.Flight_no=f.Flight_no
GROUP BY f.Flight_no, dep.Name, arr.Name, a.Model;

-- 2. List all passengers who have never made a booking.
SELECT p.PID, COUNT(B.BID) AS No_bookings
FROM Passenger p
LEFT JOIN Booking b ON b.PID=p.PID
GROUP BY p.PID
HAVING COUNT(B.BID) < 1;

-- 3. For each flight, show the flight number and the total revenue generated from its bookings. Show only
-- flights where the total revenue exceeds 500. Order from highest to lowest.
SELECT f.Flight_no, SUM(b.Price) AS Total_Revenue
FROM Flight f
JOIN Booking b ON b.Flight_no=f.Flight_no
GROUP BY f.Flight_no
HAVING SUM(b.Price) > 500
ORDER BY Total_Revenue DESC;

-- 4. Show each crew member's full name and the total number of flights they have been assigned to.
-- Show only crew members assigned to more than one flight.
SELECT F_name, L_name, COUNT(fc.Flight_no) AS Total_flights
FROM Crew c
JOIN FlightCrew fc ON fc.Crew_no=c.License_no
GROUP BY F_name, L_name
HAVING COUNT(fc.Flight_no) > 1;

-- 5. Find the average booking price per flight. Show only flights where the average price is above the
-- overall average price across all bookings.
SELECT Flight_no, AVG(Price) AS Avg_price
FROM Booking
GROUP BY Flight_no
HAVING AVG(Price) > (SELECT AVG(Price) FROM Booking);

-- 6. Show the flight with the highest number of bookings. Display its flight number, origin, destination, and
-- total bookings.
SELECT TOP 1 f.Flight_no, dep.Name AS Origin_Airport, arr.Name AS Destination_Airport, COUNT(b.BID) AS Total_bookings
FROM Flight f
JOIN Airport dep ON dep.IATA=f.Dep_airport
JOIN Airport arr ON arr.IATA=f.Arr_airport
JOIN Booking b ON b.Flight_no=f.Flight_no
GROUP BY f.Flight_no, dep.Name, arr.Name
ORDER BY Total_bookings Desc;

-- 7. For each booking class, show the total revenue, the number of bookings, the average price, the
-- highest price, and the lowest price.
SELECT Class, SUM(Price) AS Total_revenue, Count(BID) AS Total_bookings, AVG(Price) AS Average_price, MAX(Price) AS Highest_price, MIN(Price) AS Lowest_price
FROM Booking
GROUP BY Class;

-- 8. List all passengers who booked a flight that is currently 'Cancelled'. Show the passenger name, flight
-- number, and booking date.
SELECT p.F_name, F.Flight_no, b.Booking_date
FROM Passenger p
JOIN Booking b ON b.PID=p.PID
JOIN Flight f ON f.Flight_no=b.Flight_no
WHERE f.Status='Cancelled';

-- 9. Show all flights that have at least one pilot and at least one flight attendant assigned. Display the
-- flight number, total crew count, and departure datetime.
SELECT f.Flight_no, COUNT(fc.Crew_no) AS Total_crew, f.Dep_datetime
FROM Flight f
JOIN FlightCrew fc ON fc.Flight_no=f.Flight_no
JOIN Crew c ON C.License_no=fc.Crew_no
GROUP BY f.Flight_no, f.Dep_datetime
HAVING 
    COUNT(CASE WHEN c.Role = 'Pilot' THEN 1 END) >= 1
    AND
    COUNT(CASE WHEN c.Role = 'Flight Attendant' THEN 1 END) >= 1;

-- 10. FINAL CHALLENGE: Show the complete flight summary — flight number, origin airport city,
-- destination airport city, aircraft model, aircraft manufacturer, total passengers booked, total crew
-- assigned, and total revenue. Order by total revenue from highest to lowest.
SELECT f.Flight_no, dep.City AS Origin_City, arr.City AS Destination_City, a.Model, a.Manufacturer, COUNT(DISTINCT b.PID) AS Total_bookings, COUNT(DISTINCT fc.Crew_no) AS Total_Crew, SUM(b.Price) AS Total_Revenue
FROM Flight f
JOIN Airport dep ON dep.IATA=f.Dep_airport
JOIN Airport arr ON arr.IATA=f.Arr_airport
JOIN Aircraft a ON a.Reg_num=f.Aircraft
LEFT JOIN Booking b ON b.Flight_no=f.Flight_no
LEFT JOIN FlightCrew fc ON fc.Flight_no=f.Flight_no
GROUP BY f.Flight_no, dep.Name, arr.Name, a.Model, a.Manufacturer
ORDER BY Total_Revenue Desc;