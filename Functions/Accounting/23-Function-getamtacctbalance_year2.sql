-- Delivers for one specified year the balance sum (dr-cr)for the specified  Account category and posting type 
-- Posting Types= A for Actual, B for Budget, S for Statistical
-- Multiplier <1 negates the result. 
-- Example:
-- SELECT getamtacctbalance_year2(
-- date_part('YEAR'::text, now()::timestamp) - 0, -- Year
--'iscogs',  	                                 -- Cost of goods sold
-- 'A',                                           -- Posting Type
-- 1  ) ;                                        -- Multiplier= x -1
CREATE OR REPLACE FUNCTION getamtacctbalance_year2(p_year double precision, p_acct_category character varying, p_postingtype char, multiplier numeric)
  RETURNS numeric AS
$BODY$
DECLARE
	v_amtacctbalance numeric;
BEGIN
  v_amtacctbalance = getamtacctdr_year2(p_year, p_acct_category, p_postingtype) - getamtacctcr_year2(p_year, p_acct_category, p_postingtype);

  IF (multiplier<1)
  THEN v_amtacctbalance =  v_amtacctbalance * (-1);
  END IF;

  RETURN COALESCE(v_amtacctbalance, 0);
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION getamtacctbalance_year2(double precision, character varying, char, numeric)
  OWNER TO adempiere;
