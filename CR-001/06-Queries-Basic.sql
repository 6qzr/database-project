-- ============================================================
-- Task 5 – Query the Extended System
-- ============================================================

-- ============================================================
-- Basic Level
-- ============================================================

-- 1. List all airlines and their country of registration, ordered alphabetically by airline name.
SELECT Name, Reg_Country FROM Airline ORDER BY Name;

-- 2. Show all gates and the airport they belong to.
SELECT Code, Airport FROM Gate;

-- 3. List all baggage records and their type, ordered by weight from heaviest to lightest.
SELECT Tag, type From Baggage ORDER BY weight_kg;

-- 4. Show all delay log records and the flight they belong to, ordered by recorded datetime.
SELECT LogID, Flight_no FROM FlightDelayLog ORDER BY Recorded_at;

-- 5. List all flights that currently have no gate assigned.
SELECT * FROM Flight WHERE gate_code IS NULL;
