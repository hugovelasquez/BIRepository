-- Delivers for one specified year the balance sum (dr-cr)for the specified Accoint IDs and posting type 
-- Posting Types= A for Actual, B for Budget, S for Statistical
-- Multiplier <1 negates the result. 
-- prefix "p_" denotes a parameter, "v_" denotes a variable
-- Example:
-- SELECT getamtacctbalance_year(
-- date_part('YEAR'::text, now()::timestamp) - 0, -- Year
-- getacctidsbystring(1000000, 1000002, '501'),   -- Cuentas REBAJAS Y DEVOLUCIONES SOBRE COMPRAS
-- 'A',                                           -- Posting Type
-- -1  ) ;                                        -- Multiplier= x -1
CREATE OR REPLACE FUNCTION getamtacctbalance_year(p_year double precision, p_acctids character varying, p_postingtype char, multiplier numeric)
  RETURNS numeric AS
$BODY$
DECLARE
	v_amtacctbalance numeric;
BEGIN
  v_amtacctbalance = getamtacctdr_year(p_year, p_acctids, p_postingtype) - getamtacctcr_year(p_year, p_acctids, p_postingtype);

  IF (multiplier<1)
  THEN v_amtacctbalance =  v_amtacctbalance * (-1);
  END IF;

  RETURN COALESCE(v_amtacctbalance, 0);
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION getamtacctbalance_year(double precision, character varying, char, numeric)
  OWNER TO adempiere;
