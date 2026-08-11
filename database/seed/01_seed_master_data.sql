-- =====================================================
-- Hospital Infection Exposure Reconstruction Database
-- Master Seed Data
-- =====================================================

-- Staff Roles
INSERT INTO staff_role (role_name) VALUES
('Doctor'),
('Nurse'),
('Laboratory Technician'),
('Infection Control Officer'),
('Hospital Administrator');

-- Exposure Pathways
INSERT INTO exposure_pathway (pathway_name) VALUES
('Shared Room'),
('Shared Bed'),
('Shared Medical Device'),
('Shared Healthcare Worker'),
('Temporal Overlap');

-- Building
INSERT INTO building (building_name) VALUES
('Main Hospital Block');

-- Wards
INSERT INTO ward (building_id, ward_name) VALUES
(1, 'General Medicine'),
(1, 'Intensive Care Unit'),
(1, 'Emergency');

-- Rooms
INSERT INTO room (ward_id, room_number) VALUES
(1, 'R101'),
(1, 'R102'),
(2, 'ICU01'),
(3, 'ER01');

-- Beds
INSERT INTO bed (room_id, bed_number) VALUES
(1, 'B01'),
(1, 'B02'),
(2, 'B01'),
(2, 'B02'),
(3, 'B01'),
(3, 'B02'),
(4, 'B01');

-- Verify
SELECT * FROM staff_role;
SELECT * FROM exposure_pathway;
SELECT * FROM building;
SELECT * FROM ward;
SELECT * FROM room;
SELECT * FROM bed;