-- ============================================================
-- PART 1: SAMPLE DATA INSERTION
-- ============================================================

-- ============================================================
-- 1. AIRPORTS (5 from different countries)
-- ============================================================
INSERT INTO Airport (IATA, Name, City, Country) VALUES
('DXB', 'Dubai Intl',         'Dubai',        'UAE'),
('LHR', 'Heathrow',           'London',        'UK'),
('JFK', 'John F. Kennedy',    'New York',      'USA'),
('SIN', 'Changi',             'Singapore',     'Singapore'),
('CDG', 'Charles de Gaulle',  'Paris',         'France');

-- ============================================================
-- 2. AIRCRAFT (5 different models)
-- ============================================================
INSERT INTO Aircraft (Model, Manufacturer, Seat_capacity, Year_of_manu) VALUES
('Boeing 777-300ER',  'Boeing',    396, 2015),
('Airbus A380-800',   'Airbus',    555, 2018),
('Boeing 737 MAX 8',  'Boeing',    178, 2020),
('Airbus A320neo',    'Airbus',    165, 2019),
('Embraer E190',      'Embraer',   100, 2017);

-- ============================================================
-- 3. CREW (6 members covering all 4 roles)
-- ============================================================
INSERT INTO Crew (F_name, L_name, Role) VALUES
('James',   'Carter',   'Pilot'),           -- 1
('Sara',    'Mitchell', 'Co-Pilot'),         -- 2
('Ahmed',   'Al-Farsi', 'Pilot'),            -- 3
('Lena',    'Hoffman',  'Flight Attendant'), -- 4
('Carlos',  'Reyes',    'Flight Attendant'), -- 5
('Wei',     'Zhang',    'Engineer');         -- 6

-- ============================================================
-- 4. FLIGHTS (8 flights, all 4 statuses)
-- ============================================================
INSERT INTO Flight (Status, Aircraft, Dep_airport, Dep_datetime, Arr_airport, Arr_datetime) VALUES
('Scheduled',  1, 'DXB', '2025-08-10 08:00', 'LHR', '2025-08-10 13:00'), -- 1
('Scheduled',  2, 'LHR', '2025-08-11 10:00', 'JFK', '2025-08-11 18:30'), -- 2
('Delayed',    3, 'JFK', '2025-08-12 06:00', 'CDG', '2025-08-12 18:00'), -- 3
('Delayed',    4, 'CDG', '2025-08-13 09:00', 'SIN', '2025-08-14 05:00'), -- 4
('Cancelled',  5, 'SIN', '2025-08-14 14:00', 'DXB', '2025-08-14 18:00'), -- 5
('Cancelled',  1, 'DXB', '2025-08-15 07:00', 'CDG', '2025-08-15 11:00'), -- 6
('Completed',  2, 'LHR', '2025-07-01 09:00', 'SIN', '2025-07-01 23:00'), -- 7
('Completed',  3, 'JFK', '2025-07-05 15:00', 'DXB', '2025-07-06 11:00'); -- 8

-- ============================================================
-- 5. FLIGHT CREW ASSIGNMENTS
--    Each flight gets at least 1 Pilot + 1 Flight Attendant
-- ============================================================
INSERT INTO FlightCrew (Flight_no, Crew_no) VALUES
(1, 1), (1, 2), (1, 4),  -- Flight 1: Pilot, Co-Pilot, FA
(2, 3), (2, 2), (2, 5),  -- Flight 2: Pilot, Co-Pilot, FA
(3, 1), (3, 4),           -- Flight 3: Pilot, FA
(4, 3), (4, 5),           -- Flight 4: Pilot, FA
(5, 1), (5, 4),           -- Flight 5: Pilot, FA
(6, 3), (6, 2), (6, 5),  -- Flight 6: Pilot, Co-Pilot, FA
(7, 1), (7, 2), (7, 4), (7, 6),  -- Flight 7: full crew + Engineer
(8, 3), (8, 2), (8, 5), (8, 6);  -- Flight 8: full crew + Engineer

-- ============================================================
-- 6. PASSENGERS (8 from different nationalities)
-- ============================================================
INSERT INTO Passenger (F_name, L_name, Nationality, DOB, Email, Phone) VALUES
('Oliver',  'Smith',    'British',      '1990-03-15', 'oliver.smith@email.com',   '+447700123456'),
('Fatima',  'Al-Said',  'Emirati',      '1985-07-22', 'fatima.alsaid@email.com',  '+97150123456'),
('Lucas',   'Dupont',   'French',       '1992-11-08', 'lucas.dupont@email.com',   '+33612345678'),
('Mei',     'Lin',      'Singaporean',  '1988-05-30', 'mei.lin@email.com',        '+6591234567'),
('Carlos',  'Garcia',   'American',     '1995-01-19', 'carlos.garcia@email.com',  '+12125550100'),
('Aisha',   'Khan',     'Pakistani',    '1993-09-11', 'aisha.khan@email.com',     '+923001234567'),
('Yuki',    'Tanaka',   'Japanese',     '1987-12-03', 'yuki.tanaka@email.com',    '+819012345678'),
('Hans',    'Muller',   'German',       '1980-06-25', 'hans.muller@email.com',    '+4917612345678');

-- ============================================================
-- 7. BOOKINGS (10 bookings, all 3 classes)
-- ============================================================
INSERT INTO Booking (PID, Seat_no, Class, Booking_date, Price, Flight_no) VALUES
(1, 12,  'Economy',  '2025-07-01', 450.00,  1),
(2, 5,   'First',    '2025-07-02', 3200.00, 1),
(3, 20,  'Business', '2025-07-03', 1100.00, 2),
(4, 33,  'Economy',  '2025-07-04', 520.00,  2),
(5, 8,   'Business', '2025-07-05', 980.00,  3),
(6, 1,   'First',    '2025-07-06', 4500.00, 4),
(7, 15,  'Economy',  '2025-06-01', 390.00,  7),
(8, 22,  'Economy',  '2025-06-02', 410.00,  7),
(1, 10,  'Business', '2025-06-10', 1250.00, 8),
(3, 18,  'First',    '2025-06-15', 3800.00, 8);