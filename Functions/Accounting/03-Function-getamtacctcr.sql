-- Delivers for one specified year the amtaactcr sum for the specified Accoint IDs and posting type 
-- Posting Types= A for Actual, B for Budget, S for Statistical 
-- Example:
-- SELECT getamtacctcr(
--date_part('YEAR'::text, now()::timestamp) - 0,  -- This Year - 0
--getacctidsbystring(1000000, 1000002, '501')  	-- Cuentas VENTAS
--, 'A')                                        -- Posting type Actual
CREATE OR REPLACE FUNCTION getamtacctcr(p_year double precision, p_acctids character varying, p_postingtype char)
  RETURNS numeric AS
$BODY$
DECLARE
	v_amtacctcr numeric;
	v_sql character varying;
BEGIN
  v_sql = 'SELECT SUM(amtacctcr) FILTER (WHERE date_part(''YEAR''::text, dateacct)=$1)
  FROM fact_acct
  WHERE account_id IN ('|| p_acctids || ')';
  v_sql = v_sql || ' AND postingtype=''' || p_postingtype || '''';

  EXECUTE v_sql
   INTO v_amtacctcr
   USING p_year;

  RETURN COALESCE(v_amtacctcr, 0);
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION getamtacctcr(double precision, character varying, char)
  OWNER TO adempiere;
