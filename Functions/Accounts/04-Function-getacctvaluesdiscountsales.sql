-- Delivers the value of sales discount accounts as a string
-- prefix "v_" denotes a variable
-- Example:
-- SELECT getacctvaluesdiscountsales()
CREATE OR REPLACE FUNCTION getacctvaluesdiscountsales()
  RETURNS character varying AS 
$BODY$
DECLARE
	v_return 	  character varying;
	v_acctvalue   character varying;	
BEGIN
	v_acctvalue   = '502';		-- Cuentas REBAJAS Y DEVOLUCIONES VENTAS ("sobre Compras")			

	v_return = v_acctvalue;
	
  RETURN v_return;
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION getacctvaluesdiscountsales()
  OWNER TO adempiere;
