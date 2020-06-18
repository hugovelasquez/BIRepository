-- Delivers for one specified year the amtaactdr sum for the specified Accoint IDs and posting type 
-- Posting Types= A for Actual, B for Budget, S for Statistical 
-- prefix "p_" denotes a parameter, "v_" denotes a variable
-- Example:
-- SELECT getamtacctdr_year(
--date_part('YEAR'::text, now()::timestamp) - 0,  -- This Year - 0
--getacctidsbystring(1000000, 1000002, '501')  	-- Cuentas INGRESOS VENTAS
--, 'A')                                        -- Posting type Actual
CREATE OR REPLACE FUNCTION getamtacctdr_year(p_year double precision, p_acctids character varying, p_postingtype char)
  RETURNS numeric AS
$BODY$
DECLARE
	v_amtacctdr numeric;
	v_sql character varying;
BEGIN
  v_sql = 'SELECT SUM(amtacctdr) FILTER (WHERE date_part(''YEAR''::text, dateacct)=$1)
  FROM fact_acct
  WHERE account_id IN ('|| p_acctids || ')';
  v_sql = v_sql || ' AND postingtype=''' || p_postingtype || '''';		-- concatenation: either using "||" or function "CONCAT()"
																		-- escape: '''xxx''' , equivalent to 'xxx' in SQL
  EXECUTE v_sql
   INTO v_amtacctdr
   USING p_year;

  RETURN COALESCE(v_amtacctdr, 0);
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION getamtacctdr_year(double precision, character varying, char)	-- definition of footprint (how to show function in e.g. PgAdmin tree)
  OWNER TO adempiere;
