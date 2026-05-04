-- ============================================================
-- Task 5 – Query the Extended System
-- ============================================================

-- ============================================================
-- Advanced Level
-- ============================================================

-- 1. Show each airline with the total number of flights it operates, the total number of passengers across
-- all its flights, and the total revenue generated from bookings on its flights.
SELECT a.Name, COUNT(DISTINCT f.Flight_no) AS No_flights, COUNT(DISTINCT b.PID) AS Total_passengers, SUM(b.Price) AS Total_revenue
FROM Airline a
LEFT JOIN Flight f ON f.Airline=a.IATA
LEFT JOIN Booking b ON b.Flight_no=f.Flight_no
GROUP BY a.Name;

-- 2. Find the gate that has been used by the most flights. Show the gate code, terminal, airport name, and flight count.
SELECT f.gate_code, g.Terminal, a.Name, COUNT(f.Flight_no) AS Total_flights
FROM Flight f
JOIN Gate g ON g.Code=f.gate_code
JOIN Airport a ON a.IATA=g.Airport
WHERE f.gate_code IS NOT NULL
GROUP BY f.gate_code, g.Terminal, a.Name;

-- 3. For each flight that has delay records, show the flight number, airline name, total number of delays, and total accumulated delay duration in minutes.
SELECT fdl.Flight_no, a.Name, COUNT(fdl.LogID) AS Total_delays, SUM(fdl.Duration_minutes) AS Total_duration
FROM FlightDelayLog fdl
JOIN Flight f ON f.Flight_no=fdl.Flight_no
JOIN Airline a ON a.IATA=f.Airline
GROUP BY fdl.Flight_no, a.Name;

-- 4. Show each passenger's full name alongside the total number of baggage items they have across all
-- their bookings, broken down by type (Cabin and Checked).
SELECT p.F_name, p.L_name, b.type, COUNT(b.Tag) AS Total_baggage
FROM Passenger p
JOIN Baggage b ON b.PID=p.PID
GROUP BY p.F_name, p.L_name, b.type;

-- 5. List all flights operated by airlines registered in 'Oman', showing the flight number, origin airport,
-- destination airport, and total revenue from bookings.
SELECT f.Flight_no, f.Dep_airport AS Origin_airport, f.Arr_airport AS Destination_airport, SUM(b.Price) AS Total_revenue
FROM Flight f
JOIN Airline a ON a.IATA=f.Airline
JOIN Booking b ON b.Flight_no=f.Flight_no
WHERE a.Reg_Country='Oman'
GROUP BY f.Flight_no, f.Dep_airport, f.Arr_airport;

-- 6. FINAL CHALLENGE: Show a complete flight report — flight number, airline name, gate code, origin
-- airport city, destination airport city, total passengers booked, total baggage items, total delay duration in
-- minutes (0 if no delays), and total booking revenue. Order by total booking revenue from highest to
-- lowest.
SELECT f.Flight_no, a.Name, f.gate_code AS Gate_code, apDep.City AS Origin_City, apArr.City AS Destination_City, COUNT(DISTINCT b.PID) AS Total_passengers, COUNT(bg.Tag) AS Total_baggage, COALESCE(SUM(fdl.Duration_minutes), 0) AS Total_delay, SUM(b.Price) AS Total_revenue
FROM Flight f
JOIN Airline a ON a.IATA=f.Airline
JOIN Airport apDep ON apDep.IATA=f.Dep_airport
JOIN Airport apArr ON apArr.IATA=f.Arr_airport
LEFT JOIN Booking b ON b.Flight_no=f.Flight_no
LEFT JOIN Baggage bg ON bg.BID=b.BID
LEFT JOIN FlightDelayLog fdl ON fdl.Flight_no=f.Flight_no
GROUP BY f.Flight_no, a.Name, f.gate_code, apDep.City, apArr.City
ORDER BY Total_revenue DESC;
