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

**🔗 [View Interactive ERD on DrawSQL](https://drawsql.app/teams/nahid-hasan-3/diagrams/vehicle-rental-system)**

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
| `phone`    | VARCHAR | NOT NULL             | Contact number (optional)                 |

### 2. Vehicles Table

Our garage! This holds everything we know about each vehicle in our fleet.

| Column                | Type    | Constraints                          | What It Does                      |
| :-------------------- | :------ | :----------------------------------- | :-------------------------------- |
| `vehicle_id`          | SERIAL  | **Primary Key**                      | Unique ID for each vehicle        |
| `type`                | ENUM    | 'car', 'bike', 'truck'               | What kind of vehicle it is        |
| `model`               | ENUM    | NOT NULL                             | What model of vehicle it is       |
| `registration_number` | VARCHAR | **UNIQUE**, NOT NULL                 | License plate (no duplicates)     |
| `rental_price`        | DECIMAL | NOT NULL                             | How much it costs to rent per day |
| `status`              | ENUM    | 'available', 'rented', 'maintenance' | Current availability              |

### 3. Bookings Table

This is where the magic happens – connecting users with vehicles for specific time periods.

| Column       | Type    | Constraints                                      | What It Does                             |
| :----------- | :------ | :----------------------------------------------- | :--------------------------------------- |
| `booking_id` | SERIAL  | **Primary Key**                                  | Unique ID for each booking               |
| `user_id`    | INT     | **Foreign Key**                                  | Links to the Users table                 |
| `vehicle_id` | INT     | **Foreign Key**                                  | Links to the Vehicles table              |
| `start_date` | DATE    | NOT NULL                                         | When the rental begins                   |
| `end_date`   | DATE    | **CHECK (> start_date)**                         | When it ends (must be after start!)      |
| `status`     | ENUM    | 'pending', 'confirmed', 'completed', 'cancelled' | Where the booking is in its lifecycle    |
| `total_cost` | DECIMAL | NOT NULL                                         | How much the total costs to this booking |

---

## ⚙️ Smart Features I Built In

I didn't just throw tables together – there's actual business logic baked in:

1.  **Enum Types:** Instead of letting people type whatever they want for roles or vehicle types, I've locked it down to specific values. This prevents typos and keeps data consistent.

2.  **Date Validation:** There's a CHECK constraint that makes sure your rental end date comes after your start date. Because yeah, time travel isn't a thing yet.

3.  **Data Integrity:** Foreign keys mean you can't create a booking for a user or vehicle that doesn't exist. And unique constraints on emails and registration numbers prevent duplicates.

---

## 📝 SQL Queries Explained

I wrote four essential queries to demonstrate different SQL concepts and solve real business problems. Here's a detailed breakdown:

### Query 1: JOIN

**Retrieve booking information along with customer name and vehicle name.**

This query combines data from three tables to give us a complete picture of each booking. It shows who booked what vehicle and when.

**Concepts used:** INNER JOIN, SELECT

**What it does:** Pulls together booking details with the actual customer and vehicle names instead of just showing IDs. Super useful for generating reports or displaying booking history to users.

```sql
-- Query 1: Get complete booking details with customer and vehicle names
SELECT
  b.booking_id,
  u.name AS customer_name,
  v.name AS vehicle_name,
  b.start_date,
  b.end_date,
  b.status
FROM
  bookings b
  INNER JOIN users u ON b.user_id = u.user_id
  INNER JOIN vehicles v ON v.vehicle_id = b.vehicle_id;
```

**Why it matters:** Without joins, we'd only see user_id and vehicle_id numbers, which aren't helpful for humans reading the data.

---

### Query 2: NOT EXISTS

**Find all vehicles that have never been booked.**

This identifies vehicles sitting in our inventory that customers haven't rented yet. Could indicate unpopular vehicles or new additions to the fleet.

**Concepts used:** NOT EXISTS, Subquery

**What it does:** Checks each vehicle to see if there's any booking record for it. If no booking exists, it shows up in the results.

```sql
-- Query 2: Find vehicles with zero bookings
SELECT
  *
FROM
  vehicles v
WHERE
  NOT EXISTS (
    SELECT
      1
    FROM
      bookings b
    WHERE
      b.vehicle_id = v.vehicle_id
  );
```

**Why it matters:** Helps management identify underperforming inventory or spot data entry issues (like forgetting to add a vehicle to the booking system).

---

### Query 3: WHERE

**Retrieve all available vehicles of a specific type (e.g., cars).**

This is your basic search filter – the kind of query that runs when a customer visits the website and says "show me available cars."

**Concepts used:** SELECT, WHERE, AND operator

**What it does:** Filters the entire vehicle inventory to show only cars that are currently available for rent (not already rented out or in maintenance).

```sql
-- Query 3: Show only available cars
SELECT
  *
FROM
  vehicles
WHERE
  type = 'car'
  AND status = 'available';
```

**Why it matters:** This is the foundation of any rental platform's search functionality. Customers shouldn't see vehicles that aren't actually rentable!

---

### Query 4: GROUP BY and HAVING

**Find the total number of bookings for each vehicle and display only those vehicles that have more than 2 bookings.**

This analytics query identifies our most popular vehicles – the ones customers keep coming back for.

**Concepts used:** GROUP BY, HAVING, COUNT, Aggregate Functions

**What it does:** Groups all bookings by vehicle, counts how many times each vehicle has been booked, then filters to show only vehicles with more than 2 bookings.

```sql
-- Query 4: Find frequently booked vehicles (popular inventory)
SELECT
  v.name AS vehicle_name,
  COUNT(*) AS total_bookings
FROM
  bookings b
  JOIN vehicles v ON v.vehicle_id = b.vehicle_id
GROUP BY
  v.vehicle_id
HAVING
  COUNT(*) > 2;
```

**Why it matters:** Business intelligence! Knowing which vehicles are popular helps with inventory decisions – maybe we should buy more vehicles like these, or price them higher during peak seasons.

---

## 👨🏻‍💻 Viva Video Link

**https://drive.google.com/drive/folders/18MqbLvEiESO8vQOzPVVI1dIGVw7aO3gh?usp=sharing**

## 🚀 Want to Run This Yourself?

Here's how to get it up and running:

1. **Create a Database** – Fire up PostgreSQL and create a new database
2. **Run the Schema** – Execute the CREATE TABLE script to build all the tables and enums
3. **Add Some Data** – Run the INSERT script to populate it with sample users, vehicles, and bookings
4. **Test the Queries** – Try out the solution queries and see the results

---

**Built with ☕ and a lot of SQL debugging**
