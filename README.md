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
