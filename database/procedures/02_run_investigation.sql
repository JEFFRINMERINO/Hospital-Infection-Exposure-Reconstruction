-- =====================================================
-- Integrated Infection Investigation Engine
-- =====================================================

CREATE OR REPLACE PROCEDURE run_investigation(
    IN p_investigation_id INTEGER,
    IN p_infection_case_id INTEGER
)
LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_candidate_id INTEGER;
BEGIN

    -- =================================================
    -- 1. ROOM EXPOSURE
    -- =================================================

    CALL generate_room_exposure_candidates(
        p_investigation_id,
        p_infection_case_id
    );


    -- =================================================
    -- 2. SHARED BED EXPOSURE
    -- =================================================

    INSERT INTO exposure_candidate (
        investigation_id,
        admission_id,
        pathway_id,
        exposure_start,
        exposure_end,
        candidate_status
    )

    SELECT DISTINCT
        p_investigation_id,
        other_bo.admission_id,
        2,
        GREATEST(
            infected_bo.occupancy_start,
            other_bo.occupancy_start
        ),
        LEAST(
            COALESCE(infected_bo.occupancy_end, CURRENT_TIMESTAMP),
            COALESCE(other_bo.occupancy_end, CURRENT_TIMESTAMP)
        ),
        'Pending'

    FROM bed_occupancy infected_bo

    JOIN infection_case ic
      ON ic.admission_id = infected_bo.admission_id

    JOIN bed_occupancy other_bo
      ON other_bo.bed_id = infected_bo.bed_id
     AND other_bo.admission_id <> infected_bo.admission_id

    WHERE ic.infection_case_id = p_infection_case_id

      AND other_bo.occupancy_start <
          COALESCE(infected_bo.occupancy_end, CURRENT_TIMESTAMP)

      AND COALESCE(other_bo.occupancy_end, CURRENT_TIMESTAMP) >
          infected_bo.occupancy_start

      AND NOT EXISTS (
          SELECT 1
          FROM exposure_candidate ec
          WHERE ec.investigation_id = p_investigation_id
            AND ec.admission_id = other_bo.admission_id
            AND ec.pathway_id = 2
      );


    -- =================================================
    -- 3. MEDICAL DEVICE EXPOSURE
    --    Detect simultaneous use OR sequential reuse
    --    without documented cleaning.
    -- =================================================

    INSERT INTO exposure_candidate (
        investigation_id,
        admission_id,
        pathway_id,
        exposure_start,
        exposure_end,
        candidate_status
    )

    SELECT DISTINCT
        p_investigation_id,
        other_du.admission_id,
        3,

        CASE
            WHEN other_du.start_time < infected_du.end_time
             AND other_du.end_time > infected_du.start_time
            THEN GREATEST(
                infected_du.start_time,
                other_du.start_time
            )
            ELSE LEAST(
                infected_du.end_time,
                other_du.start_time
            )
        END,

        CASE
            WHEN other_du.start_time < infected_du.end_time
             AND other_du.end_time > infected_du.start_time
            THEN LEAST(
                infected_du.end_time,
                other_du.end_time
            )
            ELSE other_du.start_time
        END,

        'Pending'

    FROM device_usage infected_du

    JOIN infection_case ic
      ON ic.admission_id = infected_du.admission_id

    JOIN device_usage other_du
      ON other_du.device_id = infected_du.device_id
     AND other_du.admission_id <> infected_du.admission_id

    WHERE ic.infection_case_id = p_infection_case_id

      AND (
            -- Simultaneous usage
            (
                other_du.start_time < COALESCE(
                    infected_du.end_time,
                    CURRENT_TIMESTAMP
                )
                AND
                COALESCE(
                    other_du.end_time,
                    CURRENT_TIMESTAMP
                ) > infected_du.start_time
            )

            OR

            -- Sequential reuse after infected patient
            (
                other_du.start_time >=
                    COALESCE(
                        infected_du.end_time,
                        CURRENT_TIMESTAMP
                    )

                AND other_du.start_time <=
                    COALESCE(
                        infected_du.end_time,
                        CURRENT_TIMESTAMP
                    ) + INTERVAL '24 hours'

                AND NOT EXISTS (
                    SELECT 1
                    FROM cleaning_event ce
                    WHERE ce.device_id = infected_du.device_id
                      AND ce.cleaning_time >
                          COALESCE(
                              infected_du.end_time,
                              CURRENT_TIMESTAMP
                          )
                      AND ce.cleaning_time <=
                          other_du.start_time
                )
            )
          )

      AND NOT EXISTS (
          SELECT 1
          FROM exposure_candidate ec
          WHERE ec.investigation_id = p_investigation_id
            AND ec.admission_id = other_du.admission_id
            AND ec.pathway_id = 3
      );


    -- =================================================
    -- 4. HEALTHCARE WORKER EXPOSURE
    --    Same healthcare worker interacts with index
    --    patient and another patient within 24 hours.
    -- =================================================

    INSERT INTO exposure_candidate (
        investigation_id,
        admission_id,
        pathway_id,
        exposure_start,
        exposure_end,
        candidate_status
    )

    SELECT DISTINCT
        p_investigation_id,
        candidate_interaction.admission_id,
        4,

        LEAST(
            infected_interaction.interaction_time,
            candidate_interaction.interaction_time
        ),

        GREATEST(
            infected_interaction.interaction_time,
            candidate_interaction.interaction_time
        ),

        'Pending'

    FROM patient_staff_interaction infected_interaction

    JOIN infection_case ic
      ON ic.admission_id = infected_interaction.admission_id

    JOIN patient_staff_interaction candidate_interaction
      ON candidate_interaction.staff_id =
         infected_interaction.staff_id

     AND candidate_interaction.admission_id <>
         infected_interaction.admission_id

    WHERE ic.infection_case_id = p_infection_case_id

      AND candidate_interaction.interaction_time BETWEEN
          infected_interaction.interaction_time - INTERVAL '24 hours'
          AND
          infected_interaction.interaction_time + INTERVAL '24 hours'

      AND NOT EXISTS (
          SELECT 1
          FROM exposure_candidate ec
          WHERE ec.investigation_id = p_investigation_id
            AND ec.admission_id =
                candidate_interaction.admission_id
            AND ec.pathway_id = 4
      );


    -- =================================================
    -- 5. CALCULATE RISK SCORES
    -- =================================================

    FOR v_candidate_id IN
        SELECT candidate_id
        FROM exposure_candidate
        WHERE investigation_id = p_investigation_id
    LOOP

        PERFORM calculate_exposure_risk(v_candidate_id);

    END LOOP;


    -- =================================================
    -- 6. GENERATE EVIDENCE
    -- =================================================

    INSERT INTO exposure_evidence (
        candidate_id,
        evidence_type,
        source_reference,
        evidence_time,
        confidence_level
    )

    SELECT
        ec.candidate_id,
        ep.pathway_name,
        'Automated temporal exposure reconstruction',
        ec.exposure_start,

        CASE
            WHEN ec.risk_score >= 40 THEN 0.95
            WHEN ec.risk_score >= 25 THEN 0.85
            WHEN ec.risk_score >= 20 THEN 0.80
            WHEN ec.risk_score >= 10 THEN 0.70
            ELSE 0.50
        END

    FROM exposure_candidate ec

    JOIN exposure_pathway ep
      ON ep.pathway_id = ec.pathway_id

    WHERE ec.investigation_id = p_investigation_id

      AND NOT EXISTS (
          SELECT 1
          FROM exposure_evidence ee
          WHERE ee.candidate_id = ec.candidate_id
      );


    -- =================================================
    -- 7. UPDATE INVESTIGATION STATUS
    -- =================================================

    UPDATE investigation
    SET investigation_status = 'Analysis Complete'
    WHERE investigation_id = p_investigation_id;


END;
$procedure$;