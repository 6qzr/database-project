-- ============================================================
-- Task 4 – Insert Sample Data into New Tables
-- ============================================================

-- ============================================================
-- 1. AIRLINES (4 airlines, different countries)
-- ============================================================
INSERT INTO Airline (IATA, Name, Reg_Country, Email) VALUES
('EK', 'Emirates',        'UAE',       'info@emirates.com'),
('BA', 'British Airways', 'UK',        'info@britishairways.com'),
('AA', 'American Airlines','USA',      'info@americanairlines.com'),
('SQ', 'Singapore Airlines','Singapore','info@singaporeair.com');

-- ============================================================
-- 2. GATES (8 gates across 3 airports)
-- ============================================================
INSERT INTO Gate (Code, Airport, Terminal) VALUES
('A1', 'DXB', 'Terminal 1'),
('A2', 'DXB', 'Terminal 1'),
('B1', 'DXB', 'Terminal 2'),
('C1', 'LHR', 'Terminal 3'),
('C2', 'LHR', 'Terminal 3'),
('C3', 'LHR', 'Terminal 5'),
('D1', 'JFK', 'Terminal 4'),
('D2', 'JFK', 'Terminal 4');

-- ============================================================
-- 3. UPDATE EXISTING FLIGHTS
--    Assign airline and gate to at least 6 flights
-- ============================================================
UPDATE Flight SET Airline = 'EK', gate_code = 'A1', gate_airport = 'DXB' WHERE Flight_no = 1;
UPDATE Flight SET Airline = 'BA', gate_code = 'C1', gate_airport = 'LHR' WHERE Flight_no = 2;
UPDATE Flight SET Airline = 'AA', gate_code = 'D1', gate_airport = 'JFK' WHERE Flight_no = 3;
UPDATE Flight SET Airline = 'SQ', gate_code = 'C2', gate_airport = 'LHR' WHERE Flight_no = 4;
UPDATE Flight SET Airline = 'EK', gate_code = 'A2', gate_airport = 'DXB' WHERE Flight_no = 5;
UPDATE Flight SET Airline = 'BA', gate_code = 'C3', gate_airport = 'LHR' WHERE Flight_no = 6;
-- Flights 7 and 8 get airline only, no gate assigned yet
UPDATE Flight SET Airline = 'SQ' WHERE Flight_no = 7;
UPDATE Flight SET Airline = 'AA' WHERE Flight_no = 8;

-- ============================================================
-- 4. BAGGAGE (10 records, both types, varied weights)
--    References existing Booking (BID, PID) pairs
-- ============================================================
INSERT INTO Baggage (Tag, BID, PID, weight_kg, type) VALUES
('BAG-001', 2,  2, 7.5,  'Cabin'),
('BAG-002', 2,  2, 23.0, 'Checked'),
('BAG-003', 3,  3, 8.0,  'Cabin'),
('BAG-004', 4,  4, 22.5, 'Checked'),
('BAG-005', 5,  5, 6.0,  'Cabin'),
('BAG-006', 5,  5, 25.0, 'Checked'),
('BAG-007', 7,  7, 30.0, 'Checked'),
('BAG-008', 8,  8, 7.0,  'Cabin'),
('BAG-009', 10, 3, 20.0, 'Checked'),
('BAG-010', 10, 3, 5.5,  'Cabin');

-- ============================================================
-- 5. FLIGHT DELAY LOG (4 records)
--    Linked only to Delayed or Cancelled flights
--    From my data: flights 3 = Delayed | 5, 6 = Cancelled
-- ============================================================
INSERT INTO FlightDelayLog (LogID, Flight_no, Reason, Duration_minutes, Recorded_at) VALUES
(1, 3, 'Air traffic congestion',      45,  '2025-08-12 04:30'),
(2, 5, 'Crew availability issue',     30,  '2025-08-12 05:15'),
(3, 6, 'Adverse weather conditions',  60,  '2025-08-14 12:00');