# Hospital Infection Exposure Reconstruction Database

## 1. Project Overview

The **Hospital Infection Exposure Reconstruction Database** is a DBMS-based healthcare system designed to help hospital infection-control teams reconstruct potential infection exposure pathways using recorded hospital events.

When an infection is detected in a patient, determining who else may have been exposed can require examining multiple types of information, including:

* Patient admissions
* Room and bed assignments
* Patient movements
* Healthcare staff interactions
* Medical device usage
* Device cleaning and disinfection records
* Laboratory tests
* Infection records
* Investigation outcomes

The proposed system integrates these records into a structured relational database and allows infection-control personnel to reconstruct possible exposure pathways with supporting evidence.

The system does **not diagnose infections or claim that one patient infected another**. It identifies potential exposure relationships based on recorded hospital events and defined investigation criteria.

---

# 2. Problem Being Solved

Consider a hospital patient, **P001**, who is later confirmed to have an infection such as MRSA.

After confirmation, the infection-control team may need to determine:

* Where was P001 during the relevant period?
* Which rooms and beds were occupied?
* Which other patients were present at overlapping times?
* Which healthcare workers interacted with P001?
* Which medical devices were used?
* Were those devices used by other patients afterward?
* Was appropriate cleaning or disinfection recorded?
* Which patients should be investigated further?
* What evidence connects each potential exposure to the original case?

The necessary information may exist across different hospital records.

The central problem is therefore:

> **How can hospital event data be structured and queried so that potential infection exposure pathways can be reconstructed quickly, consistently, and with traceable evidence?**

---

# 3. Example Scenario

Assume Patient **P001** is admitted to the hospital on August 10.

```text
10 Aug 09:10
Patient P001 admitted
        ↓
Ward: General Medicine
Room: R201
Bed: B01

10 Aug 10:30
Nurse N014 attends P001

10 Aug 12:15
Device D008 used on P001

10 Aug 15:00
P001 transferred
R201 → R205

11 Aug 08:30
Doctor D003 examines P001

11 Aug 11:00
P001 develops symptoms

11 Aug 13:00
Clinical sample collected

12 Aug 09:20
Laboratory confirms MRSA
```

The infection-control team creates an investigation for P001.

---

# 4. Patient Location Reconstruction

The database reconstructs the patient's location history.

```text
Patient P001

R201
10 Aug 09:10 → 15:00

R205
10 Aug 15:00 → ...
```

Suppose another patient, **P002**, occupied R201 during part of the same period.

```text
P001: 09:10 ───────────── 15:00
P002:              13:00 ─────────── 18:00
                       ↑
                 2-hour overlap
```

The system identifies:

```text
Potential Exposure Candidate

Patient: P002
Pathway: Shared Location
Location: R201
Overlap Duration: 120 minutes
```

This does not mean P002 was infected.

It means P002 meets the defined criteria for a potential location-based exposure and may require further investigation.

---

# 5. Medical Device Exposure Reconstruction

Suppose medical device **D008** was used by P001.

```text
12:15
D008 → P001

14:30
D008 → P003
```

The database checks whether a valid cleaning or disinfection event was recorded between the two usages.

If none exists:

```text
P001
  ↓
Device D008
  ↓
No recorded disinfection
  ↓
P003
```

The investigation may record:

```text
Candidate: P003
Pathway: Shared Medical Device
Device: D008
Previous User: P001
Disinfection Between Uses: None Recorded
```

The database therefore preserves both the potential relationship and the evidence supporting it.

---

# 6. Healthcare Worker Interaction Reconstruction

Suppose Nurse **N014** interacted with P001 and later interacted with other patients.

```text
10:30 → P001
11:00 → P004
11:25 → P005
```

The database records the interaction history.

Depending on the exposure criteria used by the investigation, P004 or P005 may become candidates for further review.

Example:

```text
Candidate: P004
Pathway: Shared Healthcare Worker
Healthcare Worker: N014

Index Patient Interaction: 10:30
Candidate Interaction: 11:00

Time Difference: 30 minutes
```

The database identifies the relationship but does not claim that the healthcare worker transmitted the infection.

---

# 7. Exposure Reconstruction

Once an infection is confirmed, the system can reconstruct relevant connections around the infected patient.

```text
                    P001
                MRSA Positive
                     │
        ┌────────────┼────────────┐
        │            │            │
      R201          D008         N014
        │            │            │
       P002         P003         P004
                                  │
                                 P005
```

Possible pathways include:

* Shared location
* Shared room
* Shared medical device
* Shared healthcare worker
* Relevant temporal sequence
* Missing cleaning or disinfection records

Every candidate exposure should contain supporting evidence.

---

# 8. Infection Investigation

A confirmed infection can create an investigation record.

```text
Investigation ID: INV-042

Index Patient: P001
Organism: MRSA
Status: Active
```

The system generates or records potential exposure candidates.

```text
Candidate: P002
Pathway: LOCATION
Evidence: R201
Overlap: 120 minutes

Candidate: P003
Pathway: DEVICE
Evidence: D008
Disinfection Between Usage: None Recorded

Candidate: P004
Pathway: STAFF
Evidence: N014
Time Difference: 30 minutes
```

Infection-control personnel can review the evidence.

Possible investigation states may include:

```text
Pending Review
Investigate
Dismissed
Follow-up Required
Confirmed Case
Closed
```

---

# 9. Follow-Up

Suppose P003 is selected for further investigation.

```text
P003
 ↓
Sample Collected
 ↓
Laboratory Test
 ↓
MRSA Positive
```

The investigation can then record the updated outcome.

```text
Candidate: P003
Status: Confirmed Case
```

The system therefore supports the workflow:

```text
Infection Detection
        ↓
Investigation Creation
        ↓
Patient History Reconstruction
        ↓
Exposure Candidate Identification
        ↓
Evidence Collection
        ↓
Investigation Review
        ↓
Follow-Up
        ↓
Outcome
```

---

# 10. What the System Records

The database can contain information about:

### Patients

Patient identity and hospital-related information.

### Admissions

When patients enter and leave the hospital.

### Locations

Hospital wards, rooms, beds, and other relevant locations.

### Patient Movement

Movement of patients between hospital locations over time.

### Healthcare Staff

Doctors, nurses, technicians, and other healthcare workers.

### Staff Interactions

Recorded interactions between healthcare workers and patients.

### Medical Devices

Devices used during patient care.

### Device Usage

Which device was used by which patient and when.

### Cleaning and Disinfection

Cleaning or disinfection events associated with relevant devices or locations.

### Laboratory Samples

Samples collected from patients.

### Laboratory Results

Test results associated with collected samples.

### Organisms

Organisms associated with confirmed or suspected infections.

### Infection Cases

Recorded infection cases associated with patients.

### Investigations

Infection-control investigations initiated after relevant infection events.

### Exposure Candidates

Patients identified for investigation based on defined exposure criteria.

### Exposure Evidence

The events and records supporting a potential exposure relationship.

### Investigation Outcomes

The final status or follow-up result for each investigated candidate.

---

# 11. What the System Does Not Claim

The database must distinguish between **potential exposure** and **confirmed transmission**.

For example:

```text
P001
 ↓
Device D008
 ↓
P003
```

does not prove:

```text
P001 infected P003
```

Instead, the database establishes:

```text
P003 had a recorded potential exposure
associated with P001 through Device D008
during the investigation window.
```

Determining actual transmission may require additional clinical, epidemiological, microbiological, or genomic evidence.

---

# 12. Main Objective

The main objective of the project is:

> **To design and implement a temporal relational database capable of integrating hospital patient movement, staff interaction, medical-device usage, cleaning, laboratory, and infection records to support evidence-based reconstruction of potential hospital infection exposure pathways.**

---

# 13. Expected Outcome

When an infection case is detected, the completed system should help answer:

```text
WHO might have been exposed?

WHERE could the exposure have occurred?

WHEN did the relevant events occur?

HOW are the patients connected?

WHAT records support the connection?

WHAT happened during follow-up?
```

Instead of manually examining unrelated records, infection-control personnel can reconstruct the relevant timeline and investigate potential exposure pathways from an integrated database.

The system therefore supports the complete process:

> **Detection → Reconstruction → Investigation → Evidence → Follow-Up → Outcome**
