# SkyTrack Airline System — CR-001
### Change Request: Extended System Information

---

## 1. Summary of Changes

CR-001 was raised by the airline's operations team to capture four categories of information that were missing from the original SkyTrack system. The original schema tracked flights, passengers, crew, and bookings — but had no record of which airline operated a flight, which gate it departed from, what baggage passengers carried, or why and how long a flight was delayed.

### What Was Added and Why

**Airline** — The system had no concept of an airline operator. Every flight needs to be linked to the company that operates it for reporting, revenue tracking, and operational accountability.

**Gate** — Flights depart from specific gates at airports. Without this, the system could not support gate assignment, gate conflict detection, or terminal-level reporting.

**Baggage** — Each booking may include baggage items. Tracking baggage individually by weight and type is essential for load management, fees, and cabin capacity planning.

**FlightDelayLog** — Delays need to be logged with reasons and durations. A single flight can be delayed more than once, so a one-to-many log structure was required rather than a single delay column on Flight.

---

## 2. Existing Tables Modified

### Flight
Two new columns were added:

| Column | Type | Purpose |
|---|---|---|
| Airline | VARCHAR(3) | FK referencing Airline(IATA) — links each flight to its operator |
| gate_code | VARCHAR(10) | Part of composite FK referencing Gate(Code, Airport) |
| gate_airport | VARCHAR(3) | Part of composite FK referencing Gate(Code, Airport) |

No other existing tables were structurally modified. All other connections were established through the new tables referencing existing ones.

---

## 3. Challenges When Altering Existing Tables

### Challenge 1 — Adding a NOT NULL Column to a Table With Data

The `Airline` column on `Flight` was required to be `NOT NULL`, but the `Flight` table already contained 8 rows. SQL Server does not allow adding a `NOT NULL` column directly to a table with existing rows because those rows would have no value for the new column.

**How it was resolved — three step approach:**

```sql
-- Step 1: Add as nullable to avoid conflict with existing rows
ALTER TABLE Flight ADD Airline VARCHAR(3) NULL;

-- Step 2: Populate all existing rows with a valid airline
UPDATE Flight SET Airline = 'EK';

-- Step 3: Tighten to NOT NULL now that all rows have a value
ALTER TABLE Flight ALTER COLUMN Airline VARCHAR(3) NOT NULL;
```

### Challenge 2 — FK Constraint Conflict on Step 4

When adding the foreign key after Step 3, SQL Server threw a conflict error because the value `'EK'` used in the UPDATE did not yet exist in the `Airline` table. The FK references the parent, so the parent row must exist first.

**How it was resolved:**

Insert the Airline data before adding the FK constraint, not after.

### Challenge 3 — Composite FK for Gate

Since `Gate` uses a composite PK `(Code, Airport)`, the FK on `Flight` had to reference both columns together. This required adding two columns — `gate_code` and `gate_airport` — and defining a single composite FK across both.

---

## 4. Referential Action Justifications

### Flight → Airline
```sql
ON DELETE NO ACTION
ON UPDATE CASCADE
```
**DELETE NO ACTION:** A flight must always belong to an airline. If you try to delete an airline that still operates flights, the operation should be blocked — an orphaned flight with no operator is invalid data. The user must reassign or delete the flights first.

**UPDATE CASCADE:** If an airline's IATA code changes, all linked flights should automatically reflect the new code. Manual updates across hundreds of flight records would be error-prone.

---

### Flight → Gate
```sql
ON DELETE SET NULL
ON UPDATE CASCADE
```
**DELETE SET NULL:** If a gate is removed from the system, the flight itself should not be deleted — it is still a valid flight, just without an assigned gate. Setting the gate columns to NULL cleanly unassigns the gate while preserving the flight record. This is why `gate_code` and `gate_airport` are nullable.

**UPDATE CASCADE:** If a gate code is updated, the change should propagate automatically to all flights that reference it.

---

### Baggage → Booking
```sql
ON DELETE CASCADE
ON UPDATE CASCADE
```
Baggage is a weak entity — it has no meaning without its booking. If a booking is deleted, all its baggage records should be deleted automatically. There is no scenario where a baggage item should outlive its booking.

---

### FlightDelayLog → Flight
```sql
ON DELETE CASCADE
ON UPDATE CASCADE
```
FlightDelayLog is a weak entity — delay records only exist in the context of a flight. If a flight is deleted, its delay history is irrelevant and should be cleaned up automatically.

---

## 5. Most Complex Query — Final Challenge
 
```sql
SELECT 
    f.Flight_no,
    a.Name,
    f.gate_code                             AS Gate_code,
    apDep.City                              AS Origin_City,
    apArr.City                              AS Destination_City,
    COUNT(DISTINCT b.PID)                   AS Total_passengers,
    COUNT(bg.Tag)                           AS Total_baggage,
    COALESCE(SUM(fdl.Duration_minutes), 0)  AS Total_delay,
    SUM(b.Price)                            AS Total_revenue
FROM Flight f
JOIN Airline  a    ON a.IATA     = f.Airline
JOIN Airport apDep ON apDep.IATA = f.Dep_airport
JOIN Airport apArr ON apArr.IATA = f.Arr_airport
LEFT JOIN Booking        b   ON b.Flight_no  = f.Flight_no
LEFT JOIN Baggage        bg  ON bg.BID       = b.BID
LEFT JOIN FlightDelayLog fdl ON fdl.Flight_no = f.Flight_no
GROUP BY f.Flight_no, a.Name, f.gate_code, apDep.City, apArr.City
ORDER BY Total_revenue DESC;
```
 
### How It Works
 
This query produces a complete operational report for every flight by combining data from six different tables in a single statement.
 
**Joins** — Flight is the anchor. Airline and both Airport aliases are inner joined since every flight must have an airline and two airports. Booking, Baggage, and FlightDelayLog are left joined so flights with no bookings, no baggage, or no delays still appear in the result.
 
**COUNT(DISTINCT b.PID)** — counts unique passengers per flight. Using DISTINCT prevents the same passenger being counted multiple times if they appear in multiple joined rows due to baggage or delay records multiplying the result set.
 
**COUNT(bg.Tag)** — counts baggage items. Since Tag is part of the composite PK it is the most precise column to count individual baggage records.
 
**COALESCE(SUM(fdl.Duration_minutes), 0)** — sums total delay duration per flight. COALESCE converts NULL to 0 for flights that have no delay records, keeping the output clean and numeric.
 
**GROUP BY** — every non-aggregated column in SELECT is listed in GROUP BY, collapsing all joined rows back into one row per flight.
 
The result is ordered by total revenue descending, giving the operations team an immediate view of which flights generate the most value.
 
---
 
*SkyTrack Airline System — CR-001 | Extended System Information*
 