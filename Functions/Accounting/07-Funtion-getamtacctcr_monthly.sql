-- Example
-- SELECT 
-- getamtacctcr_monthly(
-- date_part('YEAR'::text, now()::timestamp) - 1, 
-- getacctidsincomesales(1000000, 1000002), 
-- 'A')
CREATE OR REPLACE FUNCTION getamtacctcr_monthly(p_year double precision, p_acctids character varying, p_postingtype char)
  RETURNS numeric[] AS
$BODY$
DECLARE
    v_month double precision = 1;
	v_amtacctcrmonths numeric[];
	v_amtacctcr numeric;
	v_sql character varying;
BEGIN

    LOOP
      EXIT WHEN v_month = 13;

      v_sql = 
       'SELECT SUM(amtacctcr) 
        FILTER (WHERE date_part(''YEAR''::text,  dateacct)=$1 AND  
                      date_part(''MONTH''::text, dateacct)=$2
               )
        FROM fact_acct
        WHERE account_id IN ('|| p_acctids || 
       ')';
      v_sql = v_sql || ' AND postingtype=''' || p_postingtype || '''';

      EXECUTE v_sql
      INTO v_amtacctcr
      USING p_year, v_month;

      IF (v_amtacctcr IS NULL)
      THEN v_amtacctcr = 0;
      END IF;
      v_amtacctcrmonths = array_append(v_amtacctcrmonths, v_amtacctcr);
      v_month = v_month + 1;
    END LOOP;


  RETURN v_amtacctcrmonths;
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION getamtacctcr_monthly(double precision, character varying, char)
  OWNER TO adempiere;
