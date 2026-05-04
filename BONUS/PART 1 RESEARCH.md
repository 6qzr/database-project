## PART 1: RESEARCH


### 1. What is a database index and what problem does it solve?
It is a data structure technique that allows faster data retrieval without the need to scan the entire table. It stores copies of selected columns and maintains pointers to the actual data rows.

---

### 2. What is the difference between a Clustered Index and a Non-Clustered Index?
- Clustered Indexing stores related records together in the same file, reducing search time and improving performance, especially for join operations. Data is stored in sorted order based on a key (often a non-primary key) to group similar records.
- A non-clustered index just tells us where the data lies, i.e. it gives us a list of virtual pointers or references to the location where the data is actually stored.

| Feature | Clustered Index | Non-Clustered Index |
|---|---|---|
| Physical Order | Changes physical data order | Does not change data order |
| Number Allowed | One per table | Hundreds per table |
| Size | Smaller (it is the table) | Larger (extra storage required) |
| Write Speed | Slower (requires reordering) | Faster (usually just appended) |
| Lookups | Faster for large data retrieval | Faster for specific, small lookups |

### 2.1. How many clustered indexes can one table have, and why? 
Clustered indexes 1 per table. Because the clustered index dictates the physical storage order of the data in the table, a table can contain only one clustered index.
Nonclustered indexes 999 per table
Ref: [http://msdn.microsoft.com/en-us/library/ms143432.aspx]		

---

### 3. What is a Unique Index? Identify at least two columns in the SkyTrack database where a unique index is naturally suitable.
A unique index enforces that no two rows can have the same value in the indexed column(s). A primary key is, by default, a unique index (e.g. Flight_no)

---

### 4. What is a Composite Index? Describe a situation in the airline system where combining two columns in one index would improve a query.
A composite index is an index built on two or more columns together. FlightCrew table has Flight-no and Crew_no.

---

### 5. What trade-off does adding an index introduce? Think carefully about INSERT, UPDATE, and DELETE operations.
Adding an index creates a classic time-for-space and read-for-write trade-off. While indexes significantly speed up SELECT queries (reads), they introduce overhead that slows down Data Manipulation Language (DML) operations: INSERT, UPDATE, and DELETE. The primary trade-off is that the database must maintain the index structure (usually a B-tree) every time the data changes.