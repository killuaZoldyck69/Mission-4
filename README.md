# Vehicle Rental System - Database Design & SQL

## 📌 What's This Project About?

Hey there! This is a database I built for a **Vehicle Rental System** – think of it like the backend for a car rental service. It keeps track of users (both customers and admins), the vehicles they can rent (cars, bikes, and trucks), and all the bookings people make.

## 🛠 What I Used

- **Database:** PostgreSQL (because it's reliable and has great features)
- **Design Tool:** DrawSQL (for creating the visual database diagram)

---

## 📊 How the Database is Structured (ERD)

The whole system is built around three main tables that talk to each other:

1.  **Users** – Where we store info about customers and admins
2.  **Vehicles** – Our inventory of rentable vehicles
3.  **Bookings** – The bridge connecting users to the vehicles they rent

**How they connect:**

- One user can make multiple bookings (obviously, repeat customers are the best!)
- Multiple bookings can be made for the same vehicle over time (as long as dates don't overlap)
- Everything's linked with foreign keys, so you can't have ghost bookings floating around with no actual user or vehicle attached

![ER Diagram](ERD.png)

**🔗 [View Interactive ERD on DrawSQL](your-drawsql-share-link-here)**

---

## 📂 Breaking Down Each Table

### 1. Users Table

This is where all our users live – whether they're customers looking to rent or admins managing the system.

| Column     | Type    | Constraints          | What It Does                              |
| :--------- | :------ | :------------------- | :---------------------------------------- |
| `user_id`  | SERIAL  | **Primary Key**      | Auto-generated unique ID for each user    |
| `role`     | ENUM    | 'Admin', 'Customer'  | Determines what they can do in the system |
| `name`     | VARCHAR | NOT NULL             | Their full name                           |
| `email`    | VARCHAR | **UNIQUE**, NOT NULL | Login email (no duplicates allowed!)      |
| `password` | TEXT    | NOT NULL             | Encrypted password for security           |
| `phone`    | VARCHAR | -                    | Contact number (optional)                 |

### 2. Vehicles Table

Our garage! This holds everything we know about each vehicle in our fleet.

| Column          | Type    | Constraints                          | What It Does                      |
| :-------------- | :------ | :----------------------------------- | :-------------------------------- |
| `vehicle_id`    | SERIAL  | **Primary Key**                      | Unique ID for each vehicle        |
| `type`          | ENUM    | 'car', 'bike', 'truck'               | What kind of vehicle it is        |
| `reg_number`    | VARCHAR | **UNIQUE**, NOT NULL                 | License plate (no duplicates)     |
| `status`        | ENUM    | 'available', 'rented', 'maintenance' | Current availability              |
| `price_per_day` | DECIMAL | NOT NULL                             | How much it costs to rent per day |

### 3. Bookings Table

This is where the magic happens – connecting users with vehicles for specific time periods.

| Column       | Type   | Constraints                         | What It Does                          |
| :----------- | :----- | :---------------------------------- | :------------------------------------ |
| `booking_id` | SERIAL | **Primary Key**                     | Unique ID for each booking            |
| `user_id`    | INT    | **Foreign Key**                     | Links to the Users table              |
| `vehicle_id` | INT    | **Foreign Key**                     | Links to the Vehicles table           |
| `start_date` | DATE   | NOT NULL                            | When the rental begins                |
| `end_date`   | DATE   | **CHECK (> start_date)**            | When it ends (must be after start!)   |
| `status`     | ENUM   | 'pending', 'confirmed', 'completed' | Where the booking is in its lifecycle |

---

## ⚙️ Smart Features I Built In

I didn't just throw tables together – there's actual business logic baked in:

1.  **Enum Types:** Instead of letting people type whatever they want for roles or vehicle types, I've locked it down to specific values. This prevents typos and keeps data consistent.

2.  **Date Validation:** There's a CHECK constraint that makes sure your rental end date comes after your start date. Because yeah, time travel isn't a thing yet.

3.  **Data Integrity:** Foreign keys mean you can't create a booking for a user or vehicle that doesn't exist. And unique constraints on emails and registration numbers prevent duplicates.

---

## 📝 The SQL Queries That Actually Do Stuff

I wrote several queries to answer real business questions. Here's what they do:

### Query 1: JOIN

**Retrieve booking information along with customer name and vehicle name.**

This pulls together booking info with customer names and vehicle details – super useful for reports.

**Concepts used:** INNER JOIN

```sql
SELECT b.booking_id, u.name AS customer_name, v.name AS vehicle_name
FROM Bookings b
INNER JOIN Users u ON b.user_id = u.user_id
INNER JOIN Vehicles v ON b.vehicle_id = v.vehicle_id;
```

### Query 2: EXISTS

**Find all vehicles that have never been booked.**

Identifies vehicles that have never been booked. Might be time to check if something's wrong with them!

**Concepts used:** NOT EXISTS

```sql
SELECT * FROM Vehicles v
WHERE NOT EXISTS (
    SELECT 1 FROM Bookings b WHERE b.vehicle_id = v.vehicle_id
);
```

### Query 3: WHERE

**Retrieve all available vehicles of a specific type (e.g., cars).**

Want to see what cars are ready to rent right now? This query's got you covered.

**Concepts used:** SELECT, WHERE

```sql
SELECT * FROM Vehicles
WHERE type = 'car' AND status = 'available';
```

### Query 4: GROUP BY and HAVING

**Find the total number of bookings for each vehicle and display only those vehicles that have more than 2 bookings.**

Shows which vehicles are the crowd favorites – booked more than twice.

**Concepts used:** GROUP BY, HAVING, COUNT

```sql
SELECT v.name, COUNT(b.booking_id) AS total_bookings
FROM Vehicles v
INNER JOIN Bookings b ON v.vehicle_id = b.vehicle_id
GROUP BY v.vehicle_id, v.name
HAVING COUNT(b.booking_id) > 2;
```

---

## 🚀 Want to Run This Yourself?

Here's how to get it up and running:

1. **Create a Database** – Fire up PostgreSQL and create a new database
2. **Run the Schema** – Execute the CREATE TABLE script to build all the tables and enums
3. **Add Some Data** – Run the INSERT script to populate it with sample users, vehicles, and bookings
4. **Test the Queries** – Try out the solution queries and see the results

---

## 💡 Pro Tip for Submission

If you're turning this in (whether on GitHub or as a ZIP file), organize your SQL code into two clean files:

1.  `schema.sql` – All your CREATE TABLE statements
2.  `queries.sql` – The 4 business query solutions

Trust me, instructors love when things are well-organized. It shows you care about your work!

---

**Built with ☕ and a lot of SQL debugging**
