-- =====================================================
-- Hospital Infection Exposure Reconstruction Database
-- Core Tables
-- =====================================================

-- Building
CREATE TABLE building (
building_id SERIAL PRIMARY KEY,
building_name VARCHAR(100) NOT NULL UNIQUE
);

-- Ward
CREATE TABLE ward (
ward_id SERIAL PRIMARY KEY,
building_id INTEGER NOT NULL,
ward_name VARCHAR(100) NOT NULL,
FOREIGN KEY (building_id)
REFERENCES building(building_id)
ON DELETE RESTRICT
);

-- Room
CREATE TABLE room (
room_id SERIAL PRIMARY KEY,
ward_id INTEGER NOT NULL,
room_number VARCHAR(20) NOT NULL,
FOREIGN KEY (ward_id)
REFERENCES ward(ward_id)
ON DELETE RESTRICT,
UNIQUE (ward_id, room_number)
);

-- Bed
CREATE TABLE bed (
bed_id SERIAL PRIMARY KEY,
room_id INTEGER NOT NULL,
bed_number VARCHAR(20) NOT NULL,
FOREIGN KEY (room_id)
REFERENCES room(room_id)
ON DELETE RESTRICT,
UNIQUE (room_id, bed_number)
);

-- Patient
CREATE TABLE patient (
patient_id SERIAL PRIMARY KEY,
first_name VARCHAR(100) NOT NULL,
last_name VARCHAR(100) NOT NULL,
date_of_birth DATE NOT NULL,
gender VARCHAR(20),
phone VARCHAR(20),
address TEXT
);

-- Admission
CREATE TABLE admission (
admission_id SERIAL PRIMARY KEY,
patient_id INTEGER NOT NULL,
admission_date TIMESTAMP NOT NULL,
discharge_date TIMESTAMP,
admission_reason TEXT,
FOREIGN KEY (patient_id)
REFERENCES patient(patient_id)
ON DELETE RESTRICT,
CHECK (
discharge_date IS NULL
OR discharge_date >= admission_date
)
);

-- Bed Occupancy
CREATE TABLE bed_occupancy (
occupancy_id SERIAL PRIMARY KEY,
admission_id INTEGER NOT NULL,
bed_id INTEGER NOT NULL,
occupancy_start TIMESTAMP NOT NULL,
occupancy_end TIMESTAMP,
FOREIGN KEY (admission_id)
REFERENCES admission(admission_id)
ON DELETE CASCADE,
FOREIGN KEY (bed_id)
REFERENCES bed(bed_id)
ON DELETE RESTRICT,
CHECK (
occupancy_end IS NULL
OR occupancy_end >= occupancy_start
)
);
