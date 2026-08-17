-- =====================================================
-- Shared bed exposure reconstruction
-- =====================================================

WITH infected_patient AS (
    SELECT
        ic.admission_id
    FROM infection_case ic
    WHERE ic.infection_case_id = 1
),

infected_bed_occupancy AS (
    SELECT
        bo.bed_id,
        bo.occupancy_start,
        COALESCE(bo.occupancy_end, CURRENT_TIMESTAMP) AS occupancy_end
    FROM bed_occupancy bo
    JOIN infected_patient ip
      ON bo.admission_id = ip.admission_id
),

other_bed_occupancy AS (
    SELECT
        bo.bed_id,
        bo.admission_id,
        bo.occupancy_start,
        COALESCE(bo.occupancy_end, CURRENT_TIMESTAMP) AS occupancy_end
    FROM bed_occupancy bo
    WHERE bo.admission_id != (
        SELECT admission_id
        FROM infected_patient
    )
)

SELECT
    p.patient_id,
    p.first_name,
    p.last_name,
    r.room_number,
    ibo.bed_id,

    GREATEST(
        ibo.occupancy_start,
        obo.occupancy_start
    ) AS overlap_start,

    LEAST(
        ibo.occupancy_end,
        obo.occupancy_end
    ) AS overlap_end,

    EXTRACT(
        EPOCH FROM (
            LEAST(ibo.occupancy_end, obo.occupancy_end)
            -
            GREATEST(ibo.occupancy_start, obo.occupancy_start)
        )
    ) / 60 AS overlap_minutes,

    'Shared Bed' AS exposure_pathway,
    'POTENTIAL_EXPOSURE' AS exposure_status

FROM infected_bed_occupancy ibo

JOIN other_bed_occupancy obo
  ON ibo.bed_id = obo.bed_id

JOIN bed b
  ON ibo.bed_id = b.bed_id

JOIN room r
  ON b.room_id = r.room_id

JOIN admission a
  ON obo.admission_id = a.admission_id

JOIN patient p
  ON a.patient_id = p.patient_id

WHERE obo.occupancy_start < ibo.occupancy_end
  AND obo.occupancy_end > ibo.occupancy_start

ORDER BY overlap_minutes DESC;