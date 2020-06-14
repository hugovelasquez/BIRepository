-- Delivers for one specified year the balance sum (dr-cr)for the specified Accoint IDs and posting type 
-- Posting Types= A for Actual, B for Budget, S for Statistical
-- Multiplier <1 negates the result. 
CREATE OR REPLACE FUNCTION getamtacctbalance(p_year double precision, p_acctids character varying, p_postingtype char, multiplier numeric)
  RETURNS numeric AS
$BODY$
DECLARE
	v_amtacctbalance numeric;
BEGIN
  v_amtacctbalance = getamtacctdr(p_year, p_acctids, p_postingtype) - getamtacctcr(p_year, p_acctids, p_postingtype);

  IF (multiplier<1)
  THEN v_amtacctbalance =  v_amtacctbalance * (-1);
  END IF;

  RETURN COALESCE(v_amtacctbalance, 0);
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION getamtacctbalance(double precision, character varying, char, numeric)
  OWNER TO adempiere;
