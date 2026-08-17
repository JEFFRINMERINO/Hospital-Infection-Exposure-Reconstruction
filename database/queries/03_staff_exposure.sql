-- =====================================================
-- Healthcare worker exposure reconstruction
-- =====================================================

WITH infected_patient AS (
    SELECT
        ic.admission_id
    FROM infection_case ic
    WHERE ic.infection_case_id = 1
),

infected_staff_interactions AS (
    SELECT
        psi.staff_id,
        psi.interaction_time AS infected_interaction_time,
        psi.interaction_type AS infected_interaction_type
    FROM patient_staff_interaction psi
    JOIN infected_patient ip
      ON psi.admission_id = ip.admission_id
),

other_staff_interactions AS (
    SELECT
        psi.staff_id,
        psi.admission_id,
        psi.interaction_time,
        psi.interaction_type
    FROM patient_staff_interaction psi
    WHERE psi.admission_id != (
        SELECT admission_id
        FROM infected_patient
    )
)

SELECT
    s.staff_id,
    s.first_name AS staff_first_name,
    s.last_name AS staff_last_name,

    ip.patient_id AS index_patient_id,
    ip.first_name AS index_patient_first_name,
    ip.last_name AS index_patient_last_name,

    cp.patient_id AS candidate_patient_id,
    cp.first_name AS candidate_patient_first_name,
    cp.last_name AS candidate_patient_last_name,

    isi.infected_interaction_time,
    osi.interaction_time AS candidate_interaction_time,

    isi.infected_interaction_type,
    osi.interaction_type AS candidate_interaction_type,

    ABS(
        EXTRACT(
            EPOCH FROM (
                osi.interaction_time
                - isi.infected_interaction_time
            )
        )
    ) / 60 AS time_difference_minutes,

    'POTENTIAL_EXPOSURE' AS exposure_status

FROM infected_staff_interactions isi

JOIN other_staff_interactions osi
  ON isi.staff_id = osi.staff_id

JOIN staff s
  ON isi.staff_id = s.staff_id

JOIN admission ia
  ON ia.admission_id = (
      SELECT admission_id
      FROM infected_patient
  )

JOIN patient ip
  ON ia.patient_id = ip.patient_id

JOIN admission ca
  ON osi.admission_id = ca.admission_id

JOIN patient cp
  ON ca.patient_id = cp.patient_id

WHERE osi.interaction_time BETWEEN
      isi.infected_interaction_time - INTERVAL '24 hours'
      AND
      isi.infected_interaction_time + INTERVAL '24 hours'

ORDER BY time_difference_minutes;