# Functional Requirements

## Overview

The Hospital Infection Exposure Reconstruction Database shall provide functionality to record, manage, and reconstruct hospital events required during infection-control investigations.

---

# FR-01 Patient Management

The system shall:

- Register new patients.
- Maintain patient demographic information.
- Record patient admissions.
- Record patient discharges.
- Maintain patient movement history.
- Preserve historical records.

---

# FR-02 Hospital Location Management

The system shall:

- Maintain hospital buildings.
- Maintain wards.
- Maintain rooms.
- Maintain beds.
- Record room occupancy history.
- Record bed occupancy history.

---

# FR-03 Healthcare Staff Management

The system shall:

- Maintain healthcare worker information.
- Maintain staff roles.
- Record patient–staff interactions.
- Record interaction timestamps.

---

# FR-04 Medical Device Management

The system shall:

- Register medical devices.
- Maintain device information.
- Record device assignments.
- Record device usage.
- Record cleaning events.
- Record maintenance history.

---

# FR-05 Laboratory Management

The system shall:

- Register laboratory samples.
- Record sample collection.
- Record laboratory tests.
- Record laboratory results.
- Record organism identification.

---

# FR-06 Infection Case Management

The system shall:

- Register infection cases.
- Associate infections with patients.
- Record diagnosis dates.
- Record infection status.
- Record organism information.

---

# FR-07 Investigation Management

The system shall:

- Create investigations.
- Assign investigation identifiers.
- Maintain investigation status.
- Record investigation notes.
- Maintain investigation history.
- Record investigation outcomes.

---

# FR-08 Exposure Reconstruction

The system shall identify potential exposure candidates using:

- Shared room occupancy.
- Shared bed occupancy.
- Shared healthcare worker interactions.
- Shared medical device usage.
- Temporal overlap between hospital events.

---

# FR-09 Evidence Management

The system shall:

- Preserve investigation evidence.
- Associate evidence with exposure candidates.
- Record evidence source.
- Record timestamps.
- Maintain evidence history.

---

# FR-10 Reporting

The system shall generate:

- Patient timelines.
- Investigation reports.
- Exposure reports.
- Room history reports.
- Device usage reports.
- Staff interaction reports.

---

# FR-11 Search

The system shall allow searching by:

- Patient
- Investigation
- Room
- Device
- Staff member
- Infection case

---

# FR-12 Audit

The system shall:

- Maintain historical records.
- Preserve investigation changes.
- Record important database events where applicable.