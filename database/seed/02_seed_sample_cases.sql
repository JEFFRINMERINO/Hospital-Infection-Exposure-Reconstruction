-- =====================================================
-- Hospital Infection Exposure Reconstruction Database
-- Sample Investigation Scenario
-- =====================================================

-- Staff
INSERT INTO staff (role_id, first_name, last_name, department) VALUES
(1, 'Rajesh', 'Kumar', 'General Medicine'),
(2, 'Anita', 'Joseph', 'General Medicine'),
(4, 'Priya', 'Menon', 'Infection Control');

-- Medical Devices
INSERT INTO medical_device (device_name, device_type, serial_number) VALUES
('Pulse Oximeter', 'Monitoring', 'POX-1001'),
('Infusion Pump', 'Therapy', 'INF-2001');

-- Organism
INSERT INTO organism (organism_name, organism_type) VALUES
('MRSA', 'Bacteria');

-- Patients
INSERT INTO patient (first_name, last_name, date_of_birth, gender, phone, address) VALUES
('Arun', 'Kumar', '1990-05-12', 'Male', '9876543210', 'Chennai'),
('Bala', 'Raj', '1988-09-20', 'Male', '9876543211', 'Chennai'),
('Charan', 'Das', '1995-01-18', 'Male', '9876543212', 'Chennai'),
('Divya', 'Ravi', '1992-11-05', 'Female', '9876543213', 'Chennai');

-- Admissions
INSERT INTO admission (patient_id, admission_date, discharge_date, admission_reason) VALUES
(1, '2026-08-10 09:00', NULL, 'Fever'),
(2, '2026-08-10 12:30', NULL, 'Respiratory Infection'),
(3, '2026-08-10 14:00', NULL, 'Observation'),
(4, '2026-08-10 11:00', NULL, 'Chest Pain');

-- Bed Occupancy
INSERT INTO bed_occupancy (admission_id, bed_id, occupancy_start, occupancy_end) VALUES
(1, 1, '2026-08-10 09:00', '2026-08-10 15:00'),
(2, 2, '2026-08-10 12:30', NULL),
(3, 3, '2026-08-10 14:00', NULL),
(4, 1, '2026-08-10 16:00', NULL);

-- Patient Transfers
INSERT INTO patient_transfer (admission_id, from_bed_id, to_bed_id, transfer_time, transfer_reason) VALUES
(1, 1, 3, '2026-08-10 15:00', 'Condition monitoring');

-- Patient–Staff Interactions
INSERT INTO patient_staff_interaction (admission_id, staff_id, interaction_type, interaction_time) VALUES
(1, 2, 'Nursing Care', '2026-08-10 10:30'),
(2, 2, 'Nursing Care', '2026-08-10 11:00'),
(1, 1, 'Medical Examination', '2026-08-10 13:00');

-- Device Usage
INSERT INTO device_usage (device_id, admission_id, start_time, end_time) VALUES
(1, 1, '2026-08-10 12:15', '2026-08-10 13:00'),
(1, 3, '2026-08-10 14:30', '2026-08-10 15:00');

-- Cleaning Events
INSERT INTO cleaning_event (device_id, staff_id, cleaning_time, cleaning_method) VALUES
(1, 2, '2026-08-10 13:30', 'Alcohol Disinfection');

-- Laboratory Samples
INSERT INTO laboratory_sample (admission_id, sample_type, collection_time) VALUES
(1, 'Blood', '2026-08-11 13:00');

-- Laboratory Results
INSERT INTO laboratory_result (sample_id, organism_id, result_status, report_time) VALUES
(1, 1, 'Positive', '2026-08-12 09:20');

-- Infection Case
INSERT INTO infection_case (
    admission_id,
    organism_id,
    confirmation_date,
    infection_type,
    severity
) VALUES
(1, 1, '2026-08-12 09:20', 'Hospital Acquired', 'Moderate');

-- Investigation
INSERT INTO investigation (
    infection_case_id,
    investigation_status,
    investigation_start
) VALUES
(1, 'Active', '2026-08-12 10:00');

-- Investigation Officer
INSERT INTO investigation_officer (
    investigation_id,
    staff_id
) VALUES
(1, 3);

-- Exposure Candidates
INSERT INTO exposure_candidate (
    investigation_id,
    admission_id,
    pathway_id,
    exposure_start,
    exposure_end,
    candidate_status
) VALUES
(1, 2, 1, '2026-08-10 12:30', '2026-08-10 15:00', 'Under Review'),
(1, 3, 3, '2026-08-10 14:30', '2026-08-10 15:00', 'Pending');

-- Exposure Evidence
INSERT INTO exposure_evidence (
    candidate_id,
    evidence_type,
    source_reference,
    evidence_time,
    confidence_level
) VALUES
(1, 'Room Overlap', 'Room R101 overlap analysis', '2026-08-12 10:15', 0.85),
(2, 'Shared Medical Device', 'Pulse Oximeter POX-1001', '2026-08-12 10:20', 0.75);