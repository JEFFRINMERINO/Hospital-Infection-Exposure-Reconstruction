-- =====================================================
-- Medical device exposure reconstruction
-- Detects:
-- 1. Simultaneous device usage
-- 2. Sequential device reuse without documented cleaning
-- =====================================================

WITH infected_patient AS (
    SELECT
        ic.admission_id
    FROM infection_case ic
    WHERE ic.infection_case_id = 1
),

infected_device_usage AS (
    SELECT
        du.usage_id,
        du.device_id,
        du.start_time,
        COALESCE(du.end_time, CURRENT_TIMESTAMP) AS end_time
    FROM device_usage du
    JOIN infected_patient ip
      ON du.admission_id = ip.admission_id
),

other_device_usage AS (
    SELECT
        du.usage_id,
        du.device_id,
        du.admission_id,
        du.start_time,
        COALESCE(du.end_time, CURRENT_TIMESTAMP) AS end_time
    FROM device_usage du
    WHERE du.admission_id != (
        SELECT admission_id
        FROM infected_patient
    )
),

device_comparison AS (
    SELECT
        idu.device_id,
        idu.start_time AS infected_start,
        idu.end_time AS infected_end,

        odu.admission_id AS other_admission_id,
        odu.start_time AS other_start,
        odu.end_time AS other_end,

        CASE
            WHEN odu.start_time < idu.end_time
             AND odu.end_time > idu.start_time
            THEN 'SIMULTANEOUS_USAGE'

            WHEN odu.start_time >= idu.end_time
             AND odu.start_time <= idu.end_time + INTERVAL '24 hours'
            THEN 'SEQUENTIAL_REUSE'

            WHEN idu.start_time >= odu.end_time
             AND idu.start_time <= odu.end_time + INTERVAL '24 hours'
            THEN 'SEQUENTIAL_REUSE'

            ELSE NULL
        END AS exposure_type

    FROM infected_device_usage idu
    JOIN other_device_usage odu
      ON idu.device_id = odu.device_id
),

cleaning_analysis AS (
    SELECT
        dc.*,

        (
            SELECT MAX(ce.cleaning_time)
            FROM cleaning_event ce
            WHERE ce.device_id = dc.device_id
              AND ce.cleaning_time >= dc.infected_end
              AND ce.cleaning_time <= dc.other_start
        ) AS cleaning_time

    FROM device_comparison dc
    WHERE dc.exposure_type IS NOT NULL
)

SELECT
    p.patient_id,
    p.first_name,
    p.last_name,
    md.device_name,

    ca.infected_start,
    ca.infected_end,

    ca.other_start,
    ca.other_end,

    ca.exposure_type,

    ca.cleaning_time,

    CASE
        WHEN ca.exposure_type = 'SIMULTANEOUS_USAGE'
            THEN 'POTENTIAL_EXPOSURE'

        WHEN ca.exposure_type = 'SEQUENTIAL_REUSE'
             AND ca.cleaning_time IS NOT NULL
            THEN 'CLEANED_BEFORE_REUSE'

        WHEN ca.exposure_type = 'SEQUENTIAL_REUSE'
             AND ca.cleaning_time IS NULL
            THEN 'POTENTIAL_EXPOSURE_NO_CLEANING'

        ELSE 'NO_EXPOSURE'
    END AS exposure_status

FROM cleaning_analysis ca

JOIN medical_device md
  ON ca.device_id = md.device_id

JOIN admission a
  ON ca.other_admission_id = a.admission_id

JOIN patient p
  ON a.patient_id = p.patient_id

ORDER BY
    ca.device_id,
    ca.other_start;