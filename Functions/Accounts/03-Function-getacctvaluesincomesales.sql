-- Delivers the value of sales income accounts as a string
-- prefix "v_" denotes a variable
-- Example:
-- SELECT getacctvaluesincomesales()
CREATE OR REPLACE FUNCTION getacctvaluesincomesales()
  RETURNS character varying AS 
$BODY$
DECLARE
	v_return 	  character varying;
	v_acctvalue   character varying;	
BEGIN
	v_acctvalue   = '501';		-- Cuentas Ingresos VENTAS			

	v_return = v_acctvalue;
	
  RETURN v_return;
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION getacctvaluesincomesales()
  OWNER TO adempiere;
