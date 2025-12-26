-- create enum for users role
create type role_enum as enum('Admin', 'Customer');

-- create enum for vehicle type
create type vehicle_type_enum as enum('car', 'bike', 'truck');

-- create enum for vehicle availability
create type vehicle_availability_status_enum as enum('available', 'rent', 'maintenance');

-- create enum for booking status
create type booking_status_enum as enum('pending', 'confirmed', 'completed', 'cancelled');

-- create Users table
create table Users (
  user_id serial primary key,
  name varchar(50) not null,
  email varchar(100) unique not null,
  password text not null,
  phone varchar(20) not null,
  role role_enum not null
);

-- create Vehicles table
create table Vehicles (
  vehicle_id serial primary key,
  name varchar(50) not null,
  type vehicle_type_enum not null,
  model varchar(20) not null,
  registration_number varchar(50) unique not null,
  rental_price decimal(10, 2) not null,
  status vehicle_availability_status_enum not null
);


-- create Bookings table
create table Bookings (
  booking_id serial primary key,
  user_id int references users (user_id),
  vehicle_id int references vehicles (vehicle_id),
  start_date date not null,
  end_date date not null,
  status booking_status_enum not null,
  total_cost decimal(10, 2) not null,
  constraint check_dates_order check (start_date < end_date)
);