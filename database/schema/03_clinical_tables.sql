-- =====================================================
-- Hospital Infection Exposure Reconstruction Database
-- Clinical and Investigation Tables
-- =====================================================

-- Staff Role
CREATE TABLE staff_role (
role_id SERIAL PRIMARY KEY,
role_name VARCHAR(100) NOT NULL UNIQUE
);

-- Staff
CREATE TABLE staff (
staff_id SERIAL PRIMARY KEY,
role_id INTEGER NOT NULL,
first_name VARCHAR(100) NOT NULL,
last_name VARCHAR(100) NOT NULL,
department VARCHAR(100),
FOREIGN KEY (role_id)
REFERENCES staff_role(role_id)
ON DELETE RESTRICT
);

-- Patient–Staff Interaction
CREATE TABLE patient_staff_interaction (
interaction_id SERIAL PRIMARY KEY,
admission_id INTEGER NOT NULL,
staff_id INTEGER NOT NULL,
interaction_type VARCHAR(100) NOT NULL,
interaction_time TIMESTAMP NOT NULL,
FOREIGN KEY (admission_id)
REFERENCES admission(admission_id)
ON DELETE CASCADE,
FOREIGN KEY (staff_id)
REFERENCES staff(staff_id)
ON DELETE RESTRICT
);

-- Medical Device
CREATE TABLE medical_device (
device_id SERIAL PRIMARY KEY,
device_name VARCHAR(150) NOT NULL,
device_type VARCHAR(100) NOT NULL,
serial_number VARCHAR(100) UNIQUE NOT NULL
);

-- Device Usage
CREATE TABLE device_usage (
usage_id SERIAL PRIMARY KEY,
device_id INTEGER NOT NULL,
admission_id INTEGER NOT NULL,
start_time TIMESTAMP NOT NULL,
end_time TIMESTAMP,
FOREIGN KEY (device_id)
REFERENCES medical_device(device_id)
ON DELETE RESTRICT,
FOREIGN KEY (admission_id)
REFERENCES admission(admission_id)
ON DELETE CASCADE,
CHECK (
end_time IS NULL
OR end_time >= start_time
)
);

-- Cleaning Event
CREATE TABLE cleaning_event (
cleaning_id SERIAL PRIMARY KEY,
device_id INTEGER NOT NULL,
staff_id INTEGER NOT NULL,
cleaning_time TIMESTAMP NOT NULL,
cleaning_method VARCHAR(100) NOT NULL,
FOREIGN KEY (device_id)
REFERENCES medical_device(device_id)
ON DELETE CASCADE,
FOREIGN KEY (staff_id)
REFERENCES staff(staff_id)
ON DELETE RESTRICT
);

-- Laboratory Sample
CREATE TABLE laboratory_sample (
sample_id SERIAL PRIMARY KEY,
admission_id INTEGER NOT NULL,
sample_type VARCHAR(100) NOT NULL,
collection_time TIMESTAMP NOT NULL,
FOREIGN KEY (admission_id)
REFERENCES admission(admission_id)
ON DELETE CASCADE
);

-- Organism
CREATE TABLE organism (
organism_id SERIAL PRIMARY KEY,
organism_name VARCHAR(150) NOT NULL UNIQUE,
organism_type VARCHAR(100)
);

-- Laboratory Result
CREATE TABLE laboratory_result (
result_id SERIAL PRIMARY KEY,
sample_id INTEGER NOT NULL,
organism_id INTEGER,
result_status VARCHAR(50) NOT NULL,
report_time TIMESTAMP NOT NULL,
FOREIGN KEY (sample_id)
REFERENCES laboratory_sample(sample_id)
ON DELETE CASCADE,
FOREIGN KEY (organism_id)
REFERENCES organism(organism_id)
ON DELETE SET NULL
);

-- Infection Case
CREATE TABLE infection_case (
infection_case_id SERIAL PRIMARY KEY,
admission_id INTEGER NOT NULL,
organism_id INTEGER NOT NULL,
confirmation_date TIMESTAMP NOT NULL,
infection_type VARCHAR(100) NOT NULL,
severity VARCHAR(50),
FOREIGN KEY (admission_id)
REFERENCES admission(admission_id)
ON DELETE CASCADE,
FOREIGN KEY (organism_id)
REFERENCES organism(organism_id)
ON DELETE RESTRICT
);

-- Investigation
CREATE TABLE investigation (
investigation_id SERIAL PRIMARY KEY,
infection_case_id INTEGER NOT NULL UNIQUE,
created_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
investigation_status VARCHAR(50) NOT NULL,
investigation_start TIMESTAMP NOT NULL,
investigation_end TIMESTAMP,
FOREIGN KEY (infection_case_id)
REFERENCES infection_case(infection_case_id)
ON DELETE CASCADE,
CHECK (
investigation_end IS NULL
OR investigation_end >= investigation_start
)
);

-- Investigation Officer
CREATE TABLE investigation_officer (
assignment_id SERIAL PRIMARY KEY,
investigation_id INTEGER NOT NULL,
staff_id INTEGER NOT NULL,
assigned_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (investigation_id)
REFERENCES investigation(investigation_id)
ON DELETE CASCADE,
FOREIGN KEY (staff_id)
REFERENCES staff(staff_id)
ON DELETE RESTRICT
);

-- Exposure Pathway
CREATE TABLE exposure_pathway (
pathway_id SERIAL PRIMARY KEY,
pathway_name VARCHAR(100) NOT NULL UNIQUE
);

-- Exposure Candidate
CREATE TABLE exposure_candidate (
candidate_id SERIAL PRIMARY KEY,
investigation_id INTEGER NOT NULL,
admission_id INTEGER NOT NULL,
pathway_id INTEGER NOT NULL,
exposure_start TIMESTAMP NOT NULL,
exposure_end TIMESTAMP NOT NULL,
candidate_status VARCHAR(50) NOT NULL,
FOREIGN KEY (investigation_id)
REFERENCES investigation(investigation_id)
ON DELETE CASCADE,
FOREIGN KEY (admission_id)
REFERENCES admission(admission_id)
ON DELETE RESTRICT,
FOREIGN KEY (pathway_id)
REFERENCES exposure_pathway(pathway_id)
ON DELETE RESTRICT,
CHECK (exposure_end >= exposure_start)
);

-- Exposure Evidence
CREATE TABLE exposure_evidence (
evidence_id SERIAL PRIMARY KEY,
candidate_id INTEGER NOT NULL,
evidence_type VARCHAR(100) NOT NULL,
source_reference TEXT,
evidence_time TIMESTAMP,
confidence_level NUMERIC(3,2),
FOREIGN KEY (candidate_id)
REFERENCES exposure_candidate(candidate_id)
ON DELETE CASCADE,
CHECK (
confidence_level IS NULL
OR (confidence_level >= 0 AND confidence_level <= 1)
)
);
