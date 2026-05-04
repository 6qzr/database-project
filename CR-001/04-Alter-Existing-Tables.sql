-- ============================================================
-- PART 4: Alter Existing Tables
-- ============================================================

USE SkyTrack
-- ============================================================
-- FLIGHTS
-- ============================================================

--===== Add Airline Column =====--
-- Step 1: Add column as nullable first to handle existing rows
ALTER TABLE Flight ADD Airline VARCHAR(3) NULL;

-- Step 2: Update existing rows with a default airline
UPDATE Flight SET Airline = 'EK';

-- Step 3: Apply NOT NULL constraint now that all rows have a value
ALTER TABLE Flight ALTER COLUMN Airline VARCHAR(3) NOT NULL;

-- Before Step 4 you need to update the Airline values to values in Flight to match what is in Airline table
-- Step 4: Add FK to Airline
ALTER TABLE Flight
ADD CONSTRAINT FK_Flight_Airline
    FOREIGN KEY (Airline) REFERENCES Airline(IATA)
    ON DELETE NO ACTION
    ON UPDATE CASCADE;

--===== Add Gate code and airport =====--
ALTER TABLE Flight
ADD gate_code       VARCHAR(10) NULL,
    gate_airport    VARCHAR(3)  NULL;

ALTER TABLE Flight
ADD CONSTRAINT FK_Flight_Gate
    FOREIGN KEY (gate_code, gate_airport) REFERENCES Gate(Code, Airport)
    ON DELETE SET NULL
    ON UPDATE CASCADE;