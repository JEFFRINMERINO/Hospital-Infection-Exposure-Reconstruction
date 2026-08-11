# ER Model V1 (Conceptual Database Design)

## Overview

The conceptual ER model identifies the core entities required for reconstructing potential hospital infection exposure pathways.

The **Investigation** entity is the central business entity of the system.

---

# Core Entities

## Patient

Represents a hospital patient.

### Attributes

* patient_id (PK)
* first_name
* last_name
* date_of_birth
* gender
* phone
* address

---

## Admission

Represents a hospital admission.

### Attributes

* admission_id (PK)
* patient_id (FK)
* admission_date
* discharge_date
* admission_reason

Relationship:

One Patient can have many Admissions.

---

## Hospital Building

Represents a hospital building.

### Attributes

* building_id (PK)
* building_name

---

## Ward

Represents a hospital ward.

### Attributes

* ward_id (PK)
* building_id (FK)
* ward_name

Relationship:

One Building can contain many Wards.

---

## Room

Represents a room within a ward.

### Attributes

* room_id (PK)
* ward_id (FK)
* room_number

Relationship:

One Ward can contain many Rooms.

---

## Bed

Represents a hospital bed.

### Attributes

* bed_id (PK)
* room_id (FK)
* bed_number

Relationship:

One Room can contain many Beds.

---

## Patient Movement

Represents movement between beds.

### Attributes

* movement_id (PK)
* admission_id (FK)
* bed_id (FK)
* start_time
* end_time

Relationship:

One Admission can have many Movement records.

---

## Staff

Represents a healthcare worker.

### Attributes

* staff_id (PK)
* role_id (FK)
* first_name
* last_name
* department

---

## Staff Role

Represents staff roles.

### Attributes

* role_id (PK)
* role_name

Relationship:

One Role can have many Staff members.

---

## Patient–Staff Interaction

Represents a recorded interaction.

### Attributes

* interaction_id (PK)
* admission_id (FK)
* staff_id (FK)
* interaction_type
* interaction_time

Relationship:

Many Staff can interact with many Admissions.

---

## Medical Device

Represents a reusable medical device.

### Attributes

* device_id (PK)
* device_name
* device_type
* serial_number

---

## Device Usage

Represents device usage.

### Attributes

* usage_id (PK)
* device_id (FK)
* admission_id (FK)
* start_time
* end_time

Relationship:

One Device can be used by many Admissions.

---

## Cleaning Event

Represents cleaning or disinfection.

### Attributes

* cleaning_id (PK)
* device_id (FK)
* staff_id (FK)
* cleaning_time
* cleaning_method

Relationship:

One Device can have many Cleaning events.

---

## Laboratory Sample

Represents a collected sample.

### Attributes

* sample_id (PK)
* admission_id (FK)
* sample_type
* collection_time

Relationship:

One Admission can have many Samples.

---

## Organism

Represents an identified organism.

### Attributes

* organism_id (PK)
* organism_name
* organism_type

---

## Laboratory Result

Represents a laboratory result.

### Attributes

* result_id (PK)
* sample_id (FK)
* organism_id (FK)
* result_status
* report_time

Relationship:

One Sample can have many Results.

---

## Infection Case

Represents a confirmed infection.

### Attributes

* infection_case_id (PK)
* admission_id (FK)
* organism_id (FK)
* confirmation_date
* infection_type
* severity

Relationship:

One Admission can have multiple Infection Cases.

---

## Investigation

Represents an infection investigation.

### Attributes

* investigation_id (PK)
* infection_case_id (FK)
* created_date
* investigation_status
* assigned_officer
* investigation_start
* investigation_end

Relationship:

One Infection Case can have one Investigation.

---

## Exposure Candidate

Represents a potential exposure.

### Attributes

* candidate_id (PK)
* investigation_id (FK)
* admission_id (FK)
* exposure_type
* exposure_start
* exposure_end
* candidate_status

Relationship:

One Investigation can have many Exposure Candidates.

---

## Exposure Evidence

Represents supporting evidence.

### Attributes

* evidence_id (PK)
* candidate_id (FK)
* evidence_type
* source_reference
* evidence_time
* confidence_level

Relationship:

One Exposure Candidate can have many Evidence records.

---

# Conceptual Relationship Summary

Patient

↓

Admission

↓

Patient Movement

↓

Bed → Room → Ward → Building

Admission

↓

Patient–Staff Interaction → Staff → Staff Role

Admission

↓

Device Usage → Medical Device → Cleaning Event

Admission

↓

Laboratory Sample → Laboratory Result → Organism

Admission

↓

Infection Case

↓

Investigation

↓

Exposure Candidate

↓

Exposure Evidence

---

This conceptual model will be refined in Version 2 before conversion into the relational schema.
