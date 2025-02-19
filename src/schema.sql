-- FitTrack Pro Database Schema

-- Initial SQLite setup
.open fittrackpro.db
.mode column

-- Enable foreign key support
PRAGMA foreign_keys = ON;


-- TODO: Create the following tables:
-- 1. locations
CREATE TABLE locations (
    location_id INTEGER PRIMARY KEY,
    name varchar(255) NOT NULL,
    address varchar(100) NOT NULL,
    phone_number CHAR(8) NOT NULL CHECK(phone_number LIKE '555-____'),
    email VARCHAR(255), -- All Location emails should end with @fittrackpro.com
    opening_hours varchar(12) NOT NULL
);
-- 2. members

CREATE TABLE members (
    member_id INTEGER PRIMARY KEY,
    first_name varchar(50) NOT NULL,
    last_name varchar(50) NOT NULL,
    email varchar(100) NOT NULL,
    phone_number CHAR(8) NOT NULL CHECK(phone_number LIKE '555-____'),
    date_of_birth DATE NOT NULL,
    join_date DATE NOT NULL CHECK(join_date >= date_of_birth),
    emergency_contact_name VARCHAR(50) NOT NULL,
    emergency_contact_phone CHAR(8) NOT NULL CHECK(emergency_contact_phone LIKE '555-____')

);

-- 3. staff

CREATE TABLE staff (
    staff_id INTEGER PRIMARY KEY,
    first_name varchar(50) NOT NULL,
    last_name varchar(50) NOT NULL,
    email VARCHAR(255),
    phone_number CHAR(8) NOT NULL CHECK(phone_number LIKE '555-____'),
    position varchar(12) NOT NULL CHECK (position IN ('Trainer', 'Manager', 'Receptionist', 'Maintenance')),
    hire_date DATE NOT NULL,
    location_id INTEGER,
    FOREIGN KEY (location_id) REFERENCES locations(location_id) ON UPDATE CASCADE
    ON DELETE SET NULL
);


-- 4. equipment

CREATE TABLE equipment (
    equipment_id INTEGER PRIMARY KEY,
    name varchar(50) NOT NULL,
    type varchar(8) NOT NULL CHECK (type IN ('Cardio', 'Strength')),
    purchase_date DATE NOT NULL,
    last_maintenance_date DATE NOT NULL CHECK(last_maintenance_date >= purchase_date),
    next_maintenance_date DATE NOT NULL CHECK(next_maintenance_date >= last_maintenance_date),
    location_id INTEGER,
    FOREIGN KEY (location_id) REFERENCES locations(location_id) ON DELETE CASCADE
);


-- 5. classes

CREATE TABLE classes (
    class_id INTEGER PRIMARY KEY,
    name varchar(50) NOT NULL,
    description varchar(255),
    capacity INTEGER NOT NULL,
    duration INTEGER NOT NULL,
    location_id INTEGER,
    FOREIGN KEY (location_id) REFERENCES locations(location_id) ON DELETE CASCADE
);

-- 6. class_schedule

CREATE TABLE class_schedule (
    schedule_id INTEGER PRIMARY KEY,
    class_id INTEGER,
    staff_id INTEGER,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL CHECK(end_time > start_time),
    FOREIGN KEY (class_id) REFERENCES classes(class_id) ON DELETE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE SET NULL
);
 

-- 7. memberships

CREATE TABLE memberships (
    membership_id INTEGER PRIMARY KEY,
    member_id INTEGER,
    type varchar(7) NOT NULL CHECK (type IN ('Basic', 'Premium')),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL CHECK(end_date > start_date),
    status varchar(8) NOT NULL CHECK (status IN ('Active', 'Inactive')),
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE
);

-- 8. attendance

CREATE TABLE attendance (
    attendance_id INTEGER PRIMARY KEY,
    member_id INTEGER,
    location_id INTEGER,
    check_in_time DATETIME NOT NULL,
    check_out_time DATETIME CHECK(check_out_time > check_in_time),
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
    FOREIGN KEY (location_id) REFERENCES locations(location_id) ON DELETE CASCADE
);

-- 9. class_attendance

CREATE TABLE class_attendance (
    class_attendance_id INTEGER PRIMARY KEY,
    schedule_id INTEGER,
    member_id INTEGER,
    attendance_status VARCHAR(10) NOT NULL CHECK(attendance_status IN ('Registered', 'Attended', 'Unattended')),
    FOREIGN KEY (schedule_id) REFERENCES class_schedule(schedule_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE
);
 

-- 10. payments

CREATE TABLE payments (
    payment_id INTEGER PRIMARY KEY,
    member_id INTEGER,
    amount REAL NOT NULL CHECK(amount > 0),
    payment_date DATETIME NOT NULL,
    payment_method varchar(13) NOT NULL CHECK (payment_method IN ('Credit Card', 'Bank Transfer', 'PayPal','Cash')),
    payment_type varchar(22) NOT NULL CHECK (payment_type IN ('Monthly membership fee', 'Day pass')),
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE SET NULL
);

-- 11. personal_training_sessions

CREATE TABLE personal_training_sessions (
    session_id INTEGER PRIMARY KEY,
    member_id INTEGER,
    staff_id INTEGER,
    session_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL CHECK(end_time > start_time),
    notes varchar(255),
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE SET NULL
);

-- 12. member_health_metrics

CREATE TABLE member_health_metrics (
    metric_id INTEGER PRIMARY KEY,
    member_id INTEGER,
    measurement_date DATE NOT NULL,
    weight REAL NOT NULL,
    body_fat_percentage REAL,
    muscle_mass REAL,
    bmi REAL,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE
);

-- 13. equipment_maintenance_log

CREATE TABLE equipment_maintenance_log (
    log_id INTEGER PRIMARY KEY,
    equipment_id INTEGER,
    maintenance_date DATE NOT NULL,
    description varchar(255) NOT NULL,
    staff_id INTEGER,
    FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id) ON DELETE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE SET NULL
);


