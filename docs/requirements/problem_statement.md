# Problem Statement

## Background

Hospital-Acquired Infections (HAIs) remain a significant challenge for healthcare institutions worldwide. Once an infection is confirmed in a patient, infection-control teams must investigate where the exposure may have occurred and identify other patients who may also be at risk.

Most hospitals maintain separate records for patient admissions, room allocations, staff interactions, medical device usage, laboratory reports, and infection cases. Although these records are available, reconstructing potential exposure pathways often requires manual investigation across multiple systems.

---

## Existing Problem

During an infection investigation, hospitals need answers to questions such as:

- Which rooms did the infected patient occupy?
- Which patients shared those rooms?
- Which healthcare workers interacted with the patient?
- Which medical devices were used?
- Were those devices used by other patients?
- Was cleaning or disinfection performed before reuse?
- Which patients require further investigation?

Answering these questions manually is time-consuming and prone to missing important relationships.

---

## Problem Statement

Current hospital data is often fragmented across multiple operational records, making infection exposure investigations difficult, slow, and highly dependent on manual analysis.

There is a need for a centralized relational database capable of integrating hospital events and reconstructing potential infection exposure pathways using recorded evidence.

---

## Proposed Solution

This project proposes a temporal relational database that integrates:

- Patient admissions
- Room and bed movements
- Healthcare worker interactions
- Medical device usage
- Cleaning and disinfection events
- Laboratory results
- Infection records
- Investigation records

Using these interconnected records, the system can reconstruct possible exposure pathways and provide evidence to support infection-control investigations.

The system identifies **potential exposure relationships** based on recorded hospital events. It does not diagnose infections or confirm disease transmission.

---

## Expected Outcome

The proposed database should enable infection-control teams to:

- Reconstruct patient timelines
- Identify possible exposure candidates
- Trace shared locations, devices, and staff interactions
- Preserve investigation evidence
- Support faster and more consistent infection investigations