# Hospital Infection Exposure Reconstruction Database

A research-oriented healthcare database project that reconstructs potential hospital infection exposure pathways using patient movement, healthcare staff interactions, medical device usage, laboratory findings, and infection investigation records.

---

## Project Overview

Hospital-Acquired Infections (HAIs) remain one of the major challenges faced by healthcare institutions. When an infection is confirmed in a patient, infection-control teams must determine where the exposure may have occurred, identify other potentially exposed patients, and collect evidence to support further investigation.

This project aims to design and implement a centralized relational database that integrates hospital operational data into a single system capable of reconstructing potential infection exposure pathways.

Rather than diagnosing infections, the system focuses on organizing hospital events into structured, traceable records that support evidence-based infection investigations.

---

## Objectives

The project aims to:

* Design a normalized relational database for infection investigations.
* Track patient admissions, transfers, and discharge history.
* Record healthcare worker interactions with patients.
* Record medical device usage and cleaning history.
* Maintain laboratory sample and infection records.
* Reconstruct potential exposure pathways using temporal relationships.
* Preserve investigation evidence and outcomes.
* Provide a scalable database architecture for future healthcare applications.

---

## Project Scope

### In Scope

* Patient Management
* Hospital Location Management
* Healthcare Staff Management
* Medical Device Management
* Laboratory Management
* Infection Case Management
* Investigation Management
* Exposure Reconstruction
* Reporting and Search

### Out of Scope

* Disease diagnosis
* Machine Learning prediction
* AI-based infection detection
* Hospital billing
* Appointment scheduling
* Pharmacy management
* Insurance systems
* National EHR integration
* IoT monitoring

---

## Proposed Workflow

```text
Infection Detected
        │
        ▼
Create Investigation
        │
        ▼
Reconstruct Patient Timeline
        │
        ▼
Identify Potential Exposure Candidates
        │
        ▼
Collect Supporting Evidence
        │
        ▼
Review Investigation
        │
        ▼
Follow-up
        │
        ▼
Investigation Outcome
```

---

## Planned Features

* Patient Timeline Reconstruction
* Hospital Location Tracking
* Healthcare Worker Interaction Tracking
* Medical Device Traceability
* Cleaning and Disinfection Records
* Laboratory Result Management
* Infection Investigation Management
* Exposure Candidate Identification
* Investigation Evidence Tracking
* Historical Audit Support
* Reporting and Search
* REST API
* Investigation Dashboard

---

## Planned Repository Structure

```text
Hospital-Infection-Exposure-Reconstruction/
│
├── docs/
├── database/
├── backend/
├── frontend/
├── api/
├── scripts/
├── data/
├── tests/
├── docker/
├── reports/
├── screenshots/
│
├── README.md
├── LICENSE
└── .gitignore
```

---

## Technology Stack (Planned)

### Database

* PostgreSQL

### Backend

* Python
* FastAPI
* SQLAlchemy

### Frontend

* HTML
* CSS
* JavaScript

### Visualization

* Chart.js

### Development Tools

* Git
* GitHub
* Docker
* VS Code

---

## Project Status

**Current Phase:** Requirements Engineering

### Completed

* Repository Initialization
* Project Structure
* Problem Statement
* Project Objectives
* Project Scope
* Functional Requirements
* Research Paper Summary Matrix Template

### Upcoming

* Non-Functional Requirements
* Use Case Analysis
* Literature Review
* Research Gap
* ER Diagram
* Relational Schema
* Database Implementation
* Backend Development
* Dashboard Development
* Testing
* Documentation
* Research Paper

---

## License

This project is licensed under the MIT License.

---

## Author

**Jeffrin Merino J**

B.Tech – Artificial Intelligence & Data Science

Research Project: Healthcare Database Systems
