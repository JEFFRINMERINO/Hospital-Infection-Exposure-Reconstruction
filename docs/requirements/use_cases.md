# Use Cases

## Overview

The Hospital Infection Exposure Reconstruction Database is primarily used by hospital infection-control personnel to investigate potential exposure pathways after a confirmed infection case.

The Investigation entity is the central business process of the system.

---

# Primary Actors

## Infection Control Officer

Primary system user responsible for conducting infection investigations.

### Responsibilities

* Create investigations
* Review infection cases
* Reconstruct exposure pathways
* Evaluate exposure candidates
* Record investigation findings
* Close investigations

---

## Doctor

Responsible for patient diagnosis and clinical documentation.

### Responsibilities

* View patient history
* View laboratory results
* View investigation status
* Record clinical observations

---

## Nurse

Responsible for patient care and operational documentation.

### Responsibilities

* Record patient interactions
* Record patient transfers
* Record device usage
* Record cleaning activities

---

## Laboratory Staff

Responsible for laboratory processing.

### Responsibilities

* Register samples
* Record test results
* Record organism identification
* Update laboratory reports

---

## Hospital Administrator

Responsible for operational management.

### Responsibilities

* View investigation reports
* View occupancy reports
* View resource utilization reports

---

## Database Administrator

Responsible for system maintenance.

### Responsibilities

* Manage users
* Manage roles
* Maintain database integrity
* Perform backup and recovery

---

# Primary Use Cases

## UC-01 Register Patient

Actor: Nurse / Administrator

Description:

Register a new patient and create a hospital record.

---

## UC-02 Admit Patient

Actor: Nurse

Description:

Create an admission record and assign a location.

---

## UC-03 Transfer Patient

Actor: Nurse

Description:

Record movement between hospital locations.

---

## UC-04 Record Staff Interaction

Actor: Doctor / Nurse

Description:

Record a healthcare worker interaction with a patient.

---

## UC-05 Record Device Usage

Actor: Nurse / Technician

Description:

Record a medical device usage event.

---

## UC-06 Record Cleaning Event

Actor: Nurse / Technician

Description:

Record cleaning or disinfection of a reusable device.

---

## UC-07 Register Laboratory Sample

Actor: Laboratory Staff

Description:

Register a patient sample for testing.

---

## UC-08 Record Laboratory Result

Actor: Laboratory Staff

Description:

Record test results and identified organisms.

---

## UC-09 Create Infection Case

Actor: Infection Control Officer

Description:

Create a confirmed infection case based on laboratory evidence.

---

## UC-10 Create Investigation

Actor: Infection Control Officer

Description:

Create a new investigation for a confirmed infection case.

---

## UC-11 Reconstruct Patient Timeline

Actor: Infection Control Officer

Description:

View the complete sequence of patient movements and interactions.

---

## UC-12 Identify Exposure Candidates

Actor: Infection Control Officer

Description:

Identify patients connected through rooms, beds, staff, devices, and temporal overlap.

---

## UC-13 Review Exposure Evidence

Actor: Infection Control Officer

Description:

Review supporting evidence for each candidate exposure.

---

## UC-14 Update Investigation

Actor: Infection Control Officer

Description:

Record investigation notes, evidence, and decisions.

---

## UC-15 Close Investigation

Actor: Infection Control Officer

Description:

Complete the investigation and record final findings.

---

# Most Important Use Case

The core use case is UC-12: Identify Exposure Candidates.

This use case requires the database to analyze temporal relationships between patient movement, staff interactions, device usage, cleaning records, and infection events.

It will become the primary driver of the ER diagram and exposure reconstruction queries.
