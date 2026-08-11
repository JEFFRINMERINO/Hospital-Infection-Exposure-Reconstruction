# Infection Investigation Workflow

## Overview

The Hospital Infection Exposure Reconstruction Database is centered around the infection investigation process. Every major database entity exists to support the reconstruction of potential exposure pathways for a confirmed infection case.

The investigation workflow defines how hospital events are recorded and how they are later analyzed during an infection-control investigation.

---

# Primary Workflow

```text
Patient Admission
        ↓
Patient Location Assignment
        ↓
Patient Movement
        ↓
Staff Interactions
        ↓
Medical Device Usage
        ↓
Cleaning / Disinfection Events
        ↓
Laboratory Sample Collection
        ↓
Laboratory Result
        ↓
Infection Confirmation
        ↓
Investigation Creation
        ↓
Exposure Reconstruction
        ↓
Evidence Collection
        ↓
Candidate Evaluation
        ↓
Investigation Outcome
```

---

# Step 1: Patient Admission

A patient is admitted to the hospital.

Recorded information includes:

* Patient
* Admission time
* Ward
* Room
* Bed
* Admission reason

---

# Step 2: Patient Movement

During hospitalization the patient may be transferred between locations.

Each movement event records:

* Previous location
* New location
* Transfer time
* Responsible staff

Movement history becomes one of the primary investigation sources.

---

# Step 3: Staff Interactions

Healthcare workers interact with patients throughout their stay.

Examples:

* Doctor examination
* Nurse care
* Procedure
* Sample collection
* Equipment operation

Each interaction includes:

* Patient
* Staff member
* Interaction type
* Timestamp

---

# Step 4: Medical Device Usage

Medical devices used during patient care are recorded.

Examples:

* Ventilator
* Pulse oximeter
* Infusion pump
* ECG monitor

Each usage event records:

* Device
* Patient
* Start time
* End time
* Operating staff

---

# Step 5: Cleaning and Disinfection

Cleaning events are recorded for reusable devices and relevant hospital locations.

Recorded information includes:

* Device or location
* Cleaning method
* Timestamp
* Responsible staff

These records are essential for device-related exposure investigations.

---

# Step 6: Laboratory Testing

Samples are collected from patients.

Laboratory records include:

* Sample
* Test
* Organism
* Result
* Report time

---

# Step 7: Infection Confirmation

When a laboratory result confirms a relevant infection, an infection case is created.

The infection case includes:

* Patient
* Organism
* Confirmation date
* Infection type
* Severity

---

# Step 8: Investigation Creation

An Infection Control Officer creates an investigation.

The investigation contains:

* Investigation ID
* Index patient
* Investigation period
* Status
* Assigned officer
* Notes

The investigation becomes the central entity of the system.

---

# Step 9: Exposure Reconstruction

The database analyzes recorded hospital events and identifies potential exposure candidates.

Exposure pathways include:

## Location Exposure

Patients who shared:

* Room
* Bed
* Ward

during overlapping time periods.

## Staff Exposure

Patients connected through shared healthcare worker interactions.

## Device Exposure

Patients connected through shared medical device usage.

## Temporal Exposure

Patients connected through configurable time-window rules.

---

# Step 10: Evidence Collection

For every candidate exposure the system stores evidence.

Evidence may include:

* Room overlap
* Bed overlap
* Device history
* Cleaning history
* Staff interaction records
* Laboratory timing
* Investigation notes

---

# Step 11: Candidate Evaluation

Investigation personnel review each candidate.

Possible statuses:

* Pending
* Under Review
* Investigate
* Dismissed
* Confirmed
* Closed

---

# Step 12: Investigation Outcome

The investigation concludes with:

* Final findings
* Confirmed exposure relationships
* Investigation summary
* Follow-up actions

Historical investigation records remain permanently stored.

---

# Database Design Implication

The workflow indicates that the database must support temporal relationships between:

* Patients
* Locations
* Staff
* Devices
* Laboratory records
* Infection cases
* Investigations
* Evidence

The Investigation entity serves as the central business process connecting all exposure reconstruction activities.

This workflow will directly drive the ER diagram and relational schema design.
