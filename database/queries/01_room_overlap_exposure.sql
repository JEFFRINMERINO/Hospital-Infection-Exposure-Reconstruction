-- =====================================================
-- Room overlap exposure reconstruction
-- =====================================================

WITH infected_patient AS (
    SELECT
        ic.infection_case_id,
        ic.admission_id
    FROM infection_case ic
    WHERE ic.infection_case_id = 1
),

infected_occupancy AS (
    SELECT
        bo.bed_id,
        bo.occupancy_start,
        COALESCE(bo.occupancy_end, CURRENT_TIMESTAMP) AS occupancy_end
    FROM bed_occupancy bo
    JOIN infected_patient ip
      ON bo.admission_id = ip.admission_id
),

infected_room AS (
    SELECT
        b.room_id,
        io.occupancy_start,
        io.occupancy_end
    FROM infected_occupancy io
    JOIN bed b
      ON io.bed_id = b.bed_id
)

SELECT
    p.patient_id,
    p.first_name,
    p.last_name,
    r.room_number,
    bo.occupancy_start,
    bo.occupancy_end,

    GREATEST(ir.occupancy_start, bo.occupancy_start) AS overlap_start,

    LEAST(
        ir.occupancy_end,
        COALESCE(bo.occupancy_end, CURRENT_TIMESTAMP)
    ) AS overlap_end,

    EXTRACT(EPOCH FROM (
        LEAST(
            ir.occupancy_end,
            COALESCE(bo.occupancy_end, CURRENT_TIMESTAMP)
        ) -
        GREATEST(ir.occupancy_start, bo.occupancy_start)
    )) / 60 AS overlap_minutes

FROM infected_room ir

JOIN room r
  ON ir.room_id = r.room_id

JOIN bed b
  ON r.room_id = b.room_id

JOIN bed_occupancy bo
  ON bo.bed_id = b.bed_id

JOIN admission a
  ON bo.admission_id = a.admission_id

JOIN patient p
  ON a.patient_id = p.patient_id

WHERE bo.admission_id != (
    SELECT admission_id
    FROM infected_patient
)

AND bo.occupancy_start < ir.occupancy_end

AND COALESCE(bo.occupancy_end, CURRENT_TIMESTAMP)
    > ir.occupancy_start

ORDER BY overlap_minutes DESC;