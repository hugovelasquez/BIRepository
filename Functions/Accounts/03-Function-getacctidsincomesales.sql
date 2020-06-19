-- Delivers the ids of sales income accounts as string
-- Example:
-- SELECT getacctidsincomesales()
CREATE OR REPLACE FUNCTION getacctidsincomesales(p_ad_client_id numeric, p_c_element_id numeric)
  RETURNS character varying AS 
$BODY$
DECLARE
	v_return 	character varying;
	v_acctvalue character varying= '501';  -- Cuentas Ingresos VENTAS	
BEGIN	
	v_return = getacctidsbystring(p_ad_client_id, p_c_element_id, v_acctvalue);
  RETURN v_return;
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION getacctidsincomesales(numeric, numeric)
  OWNER TO adempiere;
