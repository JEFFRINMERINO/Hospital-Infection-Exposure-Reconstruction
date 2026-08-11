# ER Model V2 (Refined Conceptual Database Design)

## Overview

This version refines the conceptual database design by separating occupancy history from patient movement, introducing investigation-specific entities, and improving normalization.

The **Investigation** entity remains the central business entity of the system.

---

# Core Entities

## Patient

Stores patient demographic information.

**Attributes**

* patient_id (PK)
* first_name
* last_name
* date_of_birth
* gender
* phone
* address

Relationship:

One Patient can have many Admissions.

---

## Admission

Represents a hospital admission episode.

**Attributes**

* admission_id (PK)
* patient_id (FK)
* admission_date
* discharge_date
* admission_reason

Relationship:

One Patient can have many Admissions.

---

## Building

Represents a hospital building.

**Attributes**

* building_id (PK)
* building_name

Relationship:

One Building contains many Wards.

---

## Ward

Represents a ward within a building.

**Attributes**

* ward_id (PK)
* building_id (FK)
* ward_name

Relationship:

One Ward contains many Rooms.

---

## Room

Represents a room within a ward.

**Attributes**

* room_id (PK)
* ward_id (FK)
* room_number

Relationship:

One Room contains many Beds.

---

## Bed

Represents a hospital bed.

**Attributes**

* bed_id (PK)
* room_id (FK)
* bed_number

Relationship:

One Bed can have many Bed Occupancy records over time.

---

## Bed Occupancy

Maintains the complete temporal occupancy history.

**Attributes**

* occupancy_id (PK)
* admission_id (FK)
* bed_id (FK)
* occupancy_start
* occupancy_end

Relationship:

One Admission can have many Bed Occupancy records.

---

## Patient Transfer

Records patient movement between beds.

**Attributes**

* transfer_id (PK)
* admission_id (FK)
* from_bed_id (FK)
* to_bed_id (FK)
* transfer_time
* transfer_reason

Relationship:

One Admission can have many Transfer records.

---

## Staff Role

Represents staff roles.

**Attributes**

* role_id (PK)
* role_name

Examples:

* Doctor
* Nurse
* Laboratory Staff
* Technician
* Infection Control Officer

Relationship:

One Role can have many Staff members.

---

## Staff

Represents a healthcare worker.

**Attributes**

* staff_id (PK)
* role_id (FK)
* first_name
* last_name
* department

Relationship:

One Staff member can participate in many Interactions.

---

## Patient–Staff Interaction

Records interactions between staff and patients.

**Attributes**

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

**Attributes**

* device_id (PK)
* device_name
* device_type
* serial_number

Relationship:

One Device can have many Usage records.

---

## Device Usage

Records medical device usage.

**Attributes**

* usage_id (PK)
* device_id (FK)
* admission_id (FK)
* start_time
* end_time

Relationship:

One Device can be used by many Admissions.

---

## Cleaning Event

Records cleaning or disinfection events.

**Attributes**

* cleaning_id (PK)
* device_id (FK)
* staff_id (FK)
* cleaning_time
* cleaning_method

Relationship:

One Device can have many Cleaning Events.

---

## Laboratory Sample

Represents a collected laboratory sample.

**Attributes**

* sample_id (PK)
* admission_id (FK)
* sample_type
* collection_time

Relationship:

One Admission can have many Samples.

---

## Organism

Represents an identified microorganism.

**Attributes**

* organism_id (PK)
* organism_name
* organism_type

Relationship:

One Organism can appear in many Laboratory Results.

---

## Laboratory Result

Represents laboratory test results.

**Attributes**

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

**Attributes**

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

Represents an infection-control investigation.

**Attributes**

* investigation_id (PK)
* infection_case_id (FK)
* created_date
* investigation_status
* investigation_start
* investigation_end

Relationship:

One Infection Case can have one Investigation.

---

## Investigation Officer

Assigns staff members to investigations.

**Attributes**

* assignment_id (PK)
* investigation_id (FK)
* staff_id (FK)
* assigned_date

Relationship:

One Investigation can have one or more assigned Staff members.

---

## Exposure Pathway

Defines the type of exposure.

**Attributes**

* pathway_id (PK)
* pathway_name

Examples:

* Shared Room
* Shared Bed
* Shared Device
* Shared Staff
* Temporal Overlap

Relationship:

One Pathway can be associated with many Exposure Candidates.

---

## Exposure Candidate

Represents a patient potentially exposed during an investigation.

**Attributes**

* candidate_id (PK)
* investigation_id (FK)
* admission_id (FK)
* pathway_id (FK)
* exposure_start
* exposure_end
* candidate_status

Relationship:

One Investigation can have many Exposure Candidates.

---

## Exposure Evidence

Stores evidence supporting a candidate exposure.

**Attributes**

* evidence_id (PK)
* candidate_id (FK)
* evidence_type
* source_reference
* evidence_time
* confidence_level

Relationship:

One Exposure Candidate can have many Evidence records.

---

# Refined Relationship Summary

Patient

↓

Admission

↓

Bed Occupancy

↓

Bed → Room → Ward → Building

Admission

↓

Patient Transfer

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

Investigation Officer → Staff

↓

Exposure Candidate → Exposure Pathway

↓

Exposure Evidence

---

# Key Improvements Over Version 1

* Separated Bed Occupancy from Patient Transfer.
* Introduced Investigation Officer as a relationship entity.
* Introduced Exposure Pathway as a reference entity.
* Improved temporal modeling.
* Reduced attribute redundancy.
* Improved normalization.
* Better support for exposure reconstruction queries.

This refined conceptual model will be used to create the final ER diagram and the relational schema.
