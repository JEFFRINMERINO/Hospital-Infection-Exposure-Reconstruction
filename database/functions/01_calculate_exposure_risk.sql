-- =====================================================
-- Calculate exposure risk score
-- =====================================================

CREATE OR REPLACE FUNCTION calculate_exposure_risk(
    p_candidate_id INTEGER
)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE
    v_pathway_id INTEGER;
    v_overlap_minutes NUMERIC;
    v_score NUMERIC := 0;
BEGIN

    SELECT
        pathway_id,
        EXTRACT(
            EPOCH FROM (
                exposure_end - exposure_start
            )
        ) / 60
    INTO
        v_pathway_id,
        v_overlap_minutes
    FROM exposure_candidate
    WHERE candidate_id = p_candidate_id;

    IF v_pathway_id = 2 THEN
        v_score := v_score + 40;

    ELSIF v_pathway_id = 1 THEN
        v_score := v_score + 25;

    ELSIF v_pathway_id = 3 THEN
        v_score := v_score + 20;

    ELSIF v_pathway_id = 4 THEN
        v_score := v_score + 10;
    END IF;

    IF v_overlap_minutes >= 120 THEN
        v_score := v_score + 5;
    END IF;

    UPDATE exposure_candidate
    SET risk_score = v_score
    WHERE candidate_id = p_candidate_id;

    RETURN v_score;

END;
$$;