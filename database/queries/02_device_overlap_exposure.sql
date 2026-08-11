-- =====================================================
-- Shared medical device exposure reconstruction
-- =====================================================

WITH infected_patient AS (
    SELECT admission_id
    FROM infection_case
    WHERE infection_case_id = 1
),

infected_device_usage AS (
    SELECT
        du.device_id,
        du.start_time,
        COALESCE(du.end_time, CURRENT_TIMESTAMP) AS end_time
    FROM device_usage du
    JOIN infected_patient ip
      ON du.admission_id = ip.admission_id
)

SELECT
    p.patient_id,
    p.first_name,
    p.last_name,
    md.device_name,
    du.start_time,
    du.end_time,

    EXTRACT(EPOCH FROM (
        LEAST(
            idu.end_time,
            COALESCE(du.end_time, CURRENT_TIMESTAMP)
        ) -
        GREATEST(idu.start_time, du.start_time)
    )) / 60 AS overlap_minutes

FROM infected_device_usage idu

JOIN medical_device md
  ON idu.device_id = md.device_id

JOIN device_usage du
  ON idu.device_id = du.device_id

JOIN admission a
  ON du.admission_id = a.admission_id

JOIN patient p
  ON a.patient_id = p.patient_id

WHERE du.admission_id != (
    SELECT admission_id
    FROM infected_patient
)

AND du.start_time < idu.end_time

AND COALESCE(du.end_time, CURRENT_TIMESTAMP)
    > idu.start_time

ORDER BY overlap_minutes DESC;