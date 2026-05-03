# SkyTrack Airline System
### SQL Server Database Project
 
---
 
## 1. System Description
 
SkyTrack is a relational database system built to manage core airline operations. It tracks airports, aircraft, flights, crew assignments, passengers, and bookings in a structured and consistent way. The system enforces business rules through constraints, foreign keys, and cascading behaviors — ensuring data integrity across all operations.
 
---
 
## 2. ERD Summary
 
### Entities
 
| Entity      | Description                                      |
|-------------|--------------------------------------------------|
| Airport     | Stores airport details identified by IATA code   |
| Aircraft    | Stores aircraft models and seat capacity         |
| Flight      | Represents a scheduled flight between two airports |
| Crew        | Stores crew members and their roles              |
| FlightCrew  | Junction table linking crew members to flights   |
| Passenger   | Stores passenger personal details                |
| Booking     | Represents a passenger's seat reservation on a flight |
 
### Key Relationships
 
- An **Aircraft** operates many **Flights**
- An **Airport** serves as origin or destination for many **Flights**
- A **Flight** can have many **Crew** members via **FlightCrew**
- A **Passenger** can make many **Bookings**
- A **Flight** can have many **Bookings**
### Design Decisions
 
- `Flight` references `Airport` twice — once for departure (`Dep_airport`) and once for arrival (`Arr_airport`). This required two separate foreign keys to the same parent table.
- A `CHECK` constraint was added to ensure `Arr_datetime > Dep_datetime`, preventing logically invalid flights.
- A `CHECK` constraint was added to ensure `Dep_airport <> Arr_airport`, preventing a flight from departing and arriving at the same airport.
- `FlightCrew` uses a composite primary key `(Flight_no, Crew_no)` to prevent the same crew member being assigned to the same flight twice.
- `Booking` uses a composite primary key `(BID, PID)` to associate each booking firmly with a passenger.
---
 
## 3. Mapping Decisions — Foreign Key Placement
 
| Foreign Key         | Table      | References            | Reason |
|---------------------|------------|-----------------------|--------|
| Aircraft            | Flight     | Aircraft(Reg_num)     | Each flight must use a registered aircraft |
| Dep_airport         | Flight     | Airport(IATA)         | Departure location must be a valid airport |
| Arr_airport         | Flight     | Airport(IATA)         | Arrival location must be a valid airport |
| Flight_no           | FlightCrew | Flight(Flight_no)     | Crew assignment is tied to a specific flight |
| Crew_no             | FlightCrew | Crew(License_no)      | Only registered crew can be assigned |
| PID                 | Booking    | Passenger(PID)        | Booking must belong to a real passenger |
| Flight_no           | Booking    | Flight(Flight_no)     | Booking must reference a real flight |
 
### Cascade Behavior
 
Most foreign keys were set to `ON DELETE CASCADE ON UPDATE CASCADE` so that removing a parent record automatically cleans up related child records.
 
**Exception:** `Dep_airport` and `Arr_airport` in the `Flight` table were set to `ON DELETE NO ACTION ON UPDATE NO ACTION`. This is because SQL Server does not allow two foreign keys from the same table referencing the same parent table to both have cascade actions — it detects multiple cascade paths and throws error Msg 1785.
 
---
 
## 4. Errors Encountered
 
### Error 1 — Column-level CHECK Referencing Another Column
 
**Error:**
```
Msg 8141: Column CHECK constraint for column 'Arr_datetime' references another column, table 'Flight'.
```
 
**Cause:** A column-level `CHECK` constraint cannot reference another column. It can only see its own value.
 
**Fix:** Moved the constraint to table level:
```sql
CONSTRAINT CHK_Arr_after_Dep CHECK (Arr_datetime > Dep_datetime)
```
 
---
 
### Error 2 — Dropping a Constraint with the Wrong Name
 
**Error:**
```
Msg 3728: 'UQ__Passenger__Nationality' is not a constraint.
```
 
**Cause:** SQL Server auto-generates truncated constraint names. The assumed name did not match the actual internal name.
 
**Fix:** Retrieved the exact name first:
```sql
SELECT name FROM sys.key_constraints
WHERE parent_object_id = OBJECT_ID('Passenger') AND type = 'UQ';
```
Then dropped using the exact name returned.
 
---
 
### Error 3 — Multiple Cascade Paths on Airport Foreign Keys
 
**Error:**
```
Msg 1785: Introducing FOREIGN KEY constraint 'FK_Flight_Arr_airport' on table 'Flight'
may cause cycles or multiple cascade paths.
```
 
**Cause:** Both `Dep_airport` and `Arr_airport` reference the same parent table `Airport`. SQL Server cannot resolve which path to follow when cascading.
 
**Fix:** Set both airport foreign keys to full `NO ACTION`:
```sql
ON DELETE NO ACTION ON UPDATE NO ACTION
```
 
---
 
## 5. WHERE vs HAVING — In My Own Words
 
**WHERE** filters rows before any grouping happens. Think of it as a gate at the entrance — only rows that pass the condition get in to be processed.
 
**HAVING** filters after grouping. It works on the result of aggregate functions like `COUNT`, `SUM`, or `AVG`. You use it when the condition involves a calculated value, not a raw column.
 
A simple way to remember it:
 
> Use WHERE to filter rows. Use HAVING to filter groups.
 
**Example:**
```sql
-- WHERE: filter individual rows first
SELECT Flight_no, SUM(Price) AS Total
FROM Booking
WHERE Class = 'Business'         -- filters rows before grouping
GROUP BY Flight_no
HAVING SUM(Price) > 1000;        -- filters groups after aggregation
```
 
---
 
## 6. Most Useful Query
 
The most useful query in this project is the **Final Flight Summary (Query 10)**:
 
```sql
SELECT
    f.Flight_no,
    dep.City                     AS Origin_City,
    arr.City                     AS Destination_City,
    a.Model,
    a.Manufacturer,
    COUNT(DISTINCT b.BID)        AS Total_passengers,
    COUNT(DISTINCT fc.Crew_no)   AS Total_crew,
    SUM(DISTINCT b.Price)        AS Total_revenue
FROM Flight f
JOIN  Airport    dep ON dep.IATA    = f.Dep_airport
JOIN  Airport    arr ON arr.IATA    = f.Arr_airport
JOIN  Aircraft   a   ON a.Reg_num   = f.Aircraft
LEFT JOIN Booking    b  ON b.Flight_no  = f.Flight_no
LEFT JOIN FlightCrew fc ON fc.Flight_no = f.Flight_no
GROUP BY f.Flight_no, dep.City, arr.City, a.Model, a.Manufacturer
ORDER BY Total_revenue DESC;
```
 
**Why it is the most useful:**
 
It is the only query that joins all major entities in the system in a single result — flights, airports, aircraft, passengers, crew, and revenue. It gives a complete operational snapshot of every flight, making it the closest thing to a real-world airline dashboard report. It also demonstrates the most advanced techniques used in this project: multiple joins, LEFT JOIN to include empty flights, DISTINCT inside aggregates to prevent double-counting from cross joins, and subquery-style thinking applied through careful join ordering.
 
---
 
*SkyTrack Airline System — SQL Server Implementation*