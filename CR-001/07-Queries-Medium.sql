-- ============================================================
-- Task 5 – Query the Extended System
-- ============================================================

-- ============================================================
-- Medium Level
-- ============================================================

-- 1. Show each flight with its flight number, airline name, and gate code.
SELECT Flight_no, Airline, gate_code 
FROM Flight;

-- 2. List all baggage items along with the passenger name and flight number they are linked to.
SELECT b.Tag, p.F_name, p.L_name, bo.Flight_no 
FROM Baggage b
JOIN Passenger p ON p.PID=b.PID
JOIN Booking bo  ON bo.BID=b.BID
				 AND bo.PID=b.PID;

-- 3. Count the total number of baggage items per booking. Show the booking ID, passenger name, and baggage count
SELECT b.BID, p.F_name, p.L_name, COUNT(b.Tag) AS No_Baggages
FROM Baggage b
JOIN Passenger p ON p.PID=b.PID
GROUP BY b.BID, p.F_name, p.L_name;

-- 4. Show all delay logs including the flight number, airline name, delay reason, and duration in minutes.
SELECT fdl.Flight_no, a.Name, fdl.Reason, fdl.Duration_minutes
FROM FlightDelayLog fdl
JOIN Flight f ON f.Flight_no=fdl.Flight_no
JOIN Airline a ON a.IATA=f.Airline

-- 5. Find the total weight of checked baggage per flight. Show the flight number and total checked weight.
SELECT bk.Flight_no, SUM(B.weight_kg) AS Total_weight
FROM Baggage b
JOIN Booking bk ON bk.BID=b.BID
WHERE b.type = 'Checked'
GROUP BY Bk.Flight_no;

-- 6. Count how many flights each airline operates. Order from highest to lowest.
SELECT a.Name, COUNT(f.Flight_no) AS No_flights
FROM Airline a
join Flight f ON f.Airline=a.IATA
GROUP BY a.Name;

-- 7. Show all flights that have been delayed more than once. Display the flight number and total number of delay records.
SELECT Flight_no, COUNT(LogID) AS No_delay_records
FROM FlightDelayLog
GROUP BY Flight_no
Having COUNT(LogID) > 1;