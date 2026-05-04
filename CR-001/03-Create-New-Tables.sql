-- ============================================================
-- Task 3 – DDL: Create New Tables
-- ============================================================


CREATE TABLE Airline (
    IATA            VARCHAR(3)    PRIMARY KEY,
    Name            VARCHAR(50)	  NOT NULL UNIQUE,
    Reg_Country     VARCHAR(50)   NOT NULL,
    Email           VARCHAR(50)   NOT NULL UNIQUE
);

CREATE TABLE Gate (
    Code		VARCHAR(10)     NOT NULL,
    Airport		VARCHAR(3)      NOT NULL,
    Terminal	VARCHAR(20)     NOT NULL,
 
    PRIMARY KEY (Code, Airport),
    FOREIGN KEY (Airport) REFERENCES Airport(IATA)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
);

CREATE TABLE Baggage (
    Tag			VARCHAR(20)     NOT NULL,
    BID         INT             NOT NULL,
    PID         INT             NOT NULL,
    weight_kg	DECIMAL(5,2)    NOT NULL CHECK (weight_kg > 0),
    type        VARCHAR(10)     NOT NULL CHECK (type IN ('Cabin', 'Checked')),
 
    PRIMARY KEY (Tag, BID, PID),
    FOREIGN KEY (BID, PID) REFERENCES Booking(BID, PID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE FlightDelayLog (
    LogID            	INT		        NOT NULL,
    Flight_no           INT             NOT NULL,
    Reason              VARCHAR(255)    NOT NULL,
    Duration_minutes	INT             NOT NULL CHECK (duration_minutes > 0),
    Recorded_at         DATETIME        NOT NULL,
 
    PRIMARY KEY (LogID, Flight_no),
    FOREIGN KEY (Flight_no) REFERENCES Flight(Flight_no)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

ALTER TABLE Baggage
ADD CONSTRAINT UQ_Baggage_Tag UNIQUE (Tag);