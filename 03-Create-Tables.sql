-- ============================================================
-- Database Project – SkyTrack Airline System
-- SQL Implementation (SQL Server)
-- ============================================================

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'SkyTrack')
    CREATE DATABASE SkyTrack;
GO

USE SkyTrack;
GO

CREATE TABLE Airport (
	IATA	VARCHAR(3)		PRIMARY KEY,
	Name	VARCHAR(20)		NOT NULL,
	City	VARCHAR(20)		NOT NULL,
	Country	VARCHAR(20)		NOT NULL
);

CREATE TABLE Aircraft (
	Reg_num			INT				PRIMARY KEY IDENTITY (1,1),
	Model			VARCHAR(50)		NOT NULL,
	Manufacturer	VARCHAR(50)		NOT NULL,
	Seat_capacity	INT				NOT NULL CHECK (Seat_capacity > 0),
	Year_of_manu	SMALLINT
);

CREATE TABLE Flight (
	Flight_no		INT			PRIMARY KEY IDENTITY(1,1),
	Status			VARCHAR(10)	NOT NULL CHECK (Status IN ('Scheduled', 'Delayed', 'Cancelled', 'Completed')) DEFAULT 'Scheduled',
	Aircraft		INT         NOT NULL,
	Dep_airport		VARCHAR(3)  NOT NULL,
	Dep_datetime	DATETIME	NOT NULL,
	Arr_airport		VARCHAR(3)  NOT NULL,
	Arr_datetime	DATETIME	NOT NULL,

	CONSTRAINT CHK_Arr_after_Dep CHECK (Arr_datetime > Dep_datetime),

	FOREIGN KEY (Aircraft)		REFERENCES Aircraft(Reg_num),
	FOREIGN KEY (Dep_airport)	REFERENCES Airport(IATA),
	FOREIGN KEY (Arr_airport)	REFERENCES Airport(IATA)
);

CREATE TABLE Crew (
	License_no		INT				PRIMARY KEY IDENTITY(1,1),
	F_name			VARCHAR(20)		NOT NULL,
	L_name			VARCHAR(20)		NOT NULL,
	Role			VARCHAR(20)		NOT NULL CHECK (Role IN ('Pilot', 'Co-Pilot', 'Flight Attendant', 'Engineer')),
);

CREATE TABLE FlightCrew (
	Flight_no		INT		NOT NULL,
	Crew_no			INT		NOT NULL,
	
	PRIMARY KEY (Flight_no, Crew_no),
	FOREIGN KEY (Flight_no)	REFERENCES Flight(Flight_no),
	FOREIGN KEY (Crew_no)	REFERENCES Crew(License_no),
);

CREATE TABLE Passenger (
	PID			INT				PRIMARY KEY IDENTITY(1,1),
	F_name		VARCHAR(20)		NOT NULL,
	L_name		VARCHAR(20)		NOT NULL,
	Nationality	VARCHAR(20)		UNIQUE NOT NULL,
	DOB			DATE			NOT NULL,
	Email		VARCHAR(50)		UNIQUE NOT NULL,
	Phone		VARCHAR(15)
);

CREATE TABLE Booking (
	BID				INT				NOT NULL IDENTITY(1,1),
	PID				INT				NOT NULL,
	Seat_no			TINYINT			NOT NULL,
	Class			VARCHAR(10)		NOT NULL CHECK (Class IN ('Economy', 'Business', 'First')),
	Booking_date	DATE			NOT NULL DEFAULT GETDATE(),
	Price			FLOAT			NOT NULL CHECK (Price > 0),
	Flight_no		INT				NOT NULL,

	PRIMARY KEY (BID, PID),
	FOREIGN KEY (PID)		REFERENCES Passenger(PID),
	FOREIGN KEY (Flight_no)	REFERENCES Flight(Flight_no),
);