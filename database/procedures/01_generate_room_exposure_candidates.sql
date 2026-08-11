-- =====================================================
-- Generate room-based exposure candidates
-- =====================================================

CREATE OR REPLACE PROCEDURE generate_room_exposure_candidates(
    p_investigation_id INTEGER,
    p_infection_case_id INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN

INSERT INTO exposure_candidate (
    investigation_id,
    admission_id,
    pathway_id,
    exposure_start,
    exposure_end,
    candidate_status
)

WITH infected_admission AS (
    SELECT admission_id
    FROM infection_case
    WHERE infection_case_id = p_infection_case_id
),

infected_room AS (
    SELECT
        b.room_id,
        bo.occupancy_start,
        COALESCE(bo.occupancy_end, CURRENT_TIMESTAMP) AS occupancy_end
    FROM bed_occupancy bo
    JOIN infected_admission ia
      ON bo.admission_id = ia.admission_id
    JOIN bed b
      ON bo.bed_id = b.bed_id
)

SELECT DISTINCT
    p_investigation_id,
    bo.admission_id,
    1,
    GREATEST(ir.occupancy_start, bo.occupancy_start),
    LEAST(
        ir.occupancy_end,
        COALESCE(bo.occupancy_end, CURRENT_TIMESTAMP)
    ),
    'Pending'

FROM infected_room ir

JOIN bed b
  ON ir.room_id = b.room_id

JOIN bed_occupancy bo
  ON bo.bed_id = b.bed_id

WHERE bo.admission_id != (
    SELECT admission_id
    FROM infected_admission
)

AND bo.occupancy_start < ir.occupancy_end

AND COALESCE(bo.occupancy_end, CURRENT_TIMESTAMP)
    > ir.occupancy_start

AND NOT EXISTS (
    SELECT 1
    FROM exposure_candidate ec
    WHERE ec.investigation_id = p_investigation_id
      AND ec.admission_id = bo.admission_id
      AND ec.pathway_id = 1
);

END;
$$;