# Project Scope

## Overview

The Hospital Infection Exposure Reconstruction Database is designed to support hospital infection-control investigations by integrating operational hospital data into a centralized relational database.

The project focuses on reconstructing potential infection exposure pathways using recorded hospital events rather than diagnosing infections or predicting disease transmission.

---

# In Scope

The system will include the following capabilities:

## Patient Management

- Register patient information.
- Maintain patient admission and discharge records.
- Track patient transfers between wards, rooms, and beds.
- Preserve complete movement history.

---

## Hospital Location Management

The database will maintain:

- Hospital buildings
- Wards
- Rooms
- Beds

including historical occupancy information.

---

## Healthcare Staff Management

The system will maintain information about:

- Doctors
- Nurses
- Laboratory staff
- Technicians
- Infection Control Officers

The database will record patient–staff interactions.

---

## Medical Device Management

The system will record:

- Medical devices
- Device assignments
- Device usage history
- Cleaning and disinfection events
- Maintenance history (basic)

---

## Laboratory Management

The database will maintain:

- Sample collection
- Laboratory testing
- Laboratory reports
- Organism identification

---

## Infection Investigation

The system will support:

- Infection case registration
- Investigation creation
- Exposure candidate identification
- Investigation evidence
- Investigation status
- Investigation outcomes

---

## Exposure Reconstruction

The system will reconstruct possible exposure pathways using:

- Shared room occupancy
- Shared bed occupancy
- Shared healthcare worker interactions
- Shared medical device usage
- Temporal overlap between events

---

## Reporting

The system will support queries for:

- Patient timelines
- Room occupancy history
- Device usage history
- Investigation summaries
- Exposure reports

---

# Out of Scope

The following are intentionally excluded from this project:

- Disease diagnosis
- Machine Learning prediction
- AI-based infection detection
- Image processing
- Electronic Health Record (EHR) replacement
- Hospital billing
- Pharmacy management
- Appointment scheduling
- Insurance management
- Real-time IoT monitoring
- National health information exchange

These features may be considered in future work but are outside the scope of this project.

---

# Assumptions

The project assumes that:

- Hospital operational data is recorded accurately.
- Patient movement events are available.
- Staff interactions are recorded.
- Device usage history is maintained.
- Cleaning events are recorded.
- Laboratory reports are available.
- Investigation rules are defined by infection-control personnel.

---

# Expected Users

The primary users include:

- Infection Control Officers
- Hospital Administrators
- Infection Investigation Teams
- Doctors
- Nurses
- Laboratory Personnel
- Database Administrators

---

# Project Boundary

The proposed system begins when hospital events are recorded and ends when an infection investigation is completed.

The system stores, manages, and reconstructs evidence for potential exposure pathways but does not determine whether disease transmission actually occurred.

Clinical confirmation remains the responsibility of healthcare professionals.