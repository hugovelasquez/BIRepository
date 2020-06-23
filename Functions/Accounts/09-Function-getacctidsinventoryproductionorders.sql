-- Delivers the ids of production orders inventory accounts as string
-- Example:
-- SELECT getacctidsinventoryproductionorders(1000000,1000002)
CREATE OR REPLACE FUNCTION getacctidsinventoryproductionorders(p_ad_client_id numeric, p_c_element_id numeric)
  RETURNS character varying AS 
$BODY$
DECLARE
	v_return 	character varying;
	v_acctvalue character varying= '10606';  -- Cuentas ORDENES DE PRODUCCION	
BEGIN	
	v_return = getacctidsbystring(p_ad_client_id, p_c_element_id, v_acctvalue);
  RETURN v_return;
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION getacctidsinventoryproductionorders(numeric, numeric)
  OWNER TO adempiere;
