# Relational Schema

## Patient

```text
PATIENT(
    patient_id PK,
    first_name,
    last_name,
    date_of_birth,
    gender,
    phone,
    address
)
```

## Admission

```text
ADMISSION(
    admission_id PK,
    patient_id FK,
    admission_date,
    discharge_date,
    admission_reason
)
```

## Building

```text
BUILDING(
    building_id PK,
    building_name
)
```

## Ward

```text
WARD(
    ward_id PK,
    building_id FK,
    ward_name
)
```

## Room

```text
ROOM(
    room_id PK,
    ward_id FK,
    room_number
)
```

## Bed

```text
BED(
    bed_id PK,
    room_id FK,
    bed_number
)
```

## Bed occupancy

```text
BED_OCCUPANCY(
    occupancy_id PK,
    admission_id FK,
    bed_id FK,
    occupancy_start,
    occupancy_end
)
```

## Patient transfer

```text
PATIENT_TRANSFER(
    transfer_id PK,
    admission_id FK,
    from_bed_id FK,
    to_bed_id FK,
    transfer_time,
    transfer_reason
)
```

## Staff role

```text
STAFF_ROLE(
    role_id PK,
    role_name
)
```

## Staff

```text
STAFF(
    staff_id PK,
    role_id FK,
    first_name,
    last_name,
    department
)
```

## Patient–staff interaction

```text
PATIENT_STAFF_INTERACTION(
    interaction_id PK,
    admission_id FK,
    staff_id FK,
    interaction_type,
    interaction_time
)
```

## Medical device

```text
MEDICAL_DEVICE(
    device_id PK,
    device_name,
    device_type,
    serial_number
)
```

## Device usage

```text
DEVICE_USAGE(
    usage_id PK,
    device_id FK,
    admission_id FK,
    start_time,
    end_time
)
```

## Cleaning event

```text
CLEANING_EVENT(
    cleaning_id PK,
    device_id FK,
    staff_id FK,
    cleaning_time,
    cleaning_method
)
```

## Laboratory sample

```text
LABORATORY_SAMPLE(
    sample_id PK,
    admission_id FK,
    sample_type,
    collection_time
)
```

## Organism

```text
ORGANISM(
    organism_id PK,
    organism_name,
    organism_type
)
```

## Laboratory result

```text
LABORATORY_RESULT(
    result_id PK,
    sample_id FK,
    organism_id FK,
    result_status,
    report_time
)
```

## Infection case

```text
INFECTION_CASE(
    infection_case_id PK,
    admission_id FK,
    organism_id FK,
    confirmation_date,
    infection_type,
    severity
)
```

## Investigation

```text
INVESTIGATION(
    investigation_id PK,
    infection_case_id FK,
    created_date,
    investigation_status,
    investigation_start,
    investigation_end
)
```

## Investigation officer

```text
INVESTIGATION_OFFICER(
    assignment_id PK,
    investigation_id FK,
    staff_id FK,
    assigned_date
)
```

## Exposure pathway

```text
EXPOSURE_PATHWAY(
    pathway_id PK,
    pathway_name
)
```

## Exposure candidate

```text
EXPOSURE_CANDIDATE(
    candidate_id PK,
    investigation_id FK,
    admission_id FK,
    pathway_id FK,
    exposure_start,
    exposure_end,
    candidate_status
)
```

## Exposure evidence

```text
EXPOSURE_EVIDENCE(
    evidence_id PK,
    candidate_id FK,
    evidence_type,
    source_reference,
    evidence_time,
    confidence_level
)
```

## Relationship summary

* PATIENT → ADMISSION (1:M)
* BUILDING → WARD (1:M)
* WARD → ROOM (1:M)
* ROOM → BED (1:M)
* ADMISSION → BED_OCCUPANCY (1:M)
* BED → BED_OCCUPANCY (1:M)
* ADMISSION → PATIENT_TRANSFER (1:M)
* STAFF_ROLE → STAFF (1:M)
* ADMISSION → PATIENT_STAFF_INTERACTION (1:M)
* STAFF → PATIENT_STAFF_INTERACTION (1:M)
* MEDICAL_DEVICE → DEVICE_USAGE (1:M)
* ADMISSION → DEVICE_USAGE (1:M)
* MEDICAL_DEVICE → CLEANING_EVENT (1:M)
* STAFF → CLEANING_EVENT (1:M)
* ADMISSION → LABORATORY_SAMPLE (1:M)
* LABORATORY_SAMPLE → LABORATORY_RESULT (1:M)
* ORGANISM → LABORATORY_RESULT (1:M)
* ADMISSION → INFECTION_CASE (1:M)
* ORGANISM → INFECTION_CASE (1:M)
* INFECTION_CASE → INVESTIGATION (1:1)
* INVESTIGATION → INVESTIGATION_OFFICER (1:M)
* STAFF → INVESTIGATION_OFFICER (1:M)
* INVESTIGATION → EXPOSURE_CANDIDATE (1:M)
* EXPOSURE_PATHWAY → EXPOSURE_CANDIDATE (1:M)
* EXPOSURE_CANDIDATE → EXPOSURE_EVIDENCE (1:M)
