-- Delivers the ids of other inventory accounts as string
-- Example:
-- SELECT getacctidsinventoryothers(1000000,1000002)
CREATE OR REPLACE FUNCTION getacctidsinventoryothers(p_ad_client_id numeric, p_c_element_id numeric)
  RETURNS character varying AS 
$BODY$
DECLARE
	v_return 	character varying;
	v_acctvalue character varying= '10603';  -- Cuentas INVENTARIO DE OTRAS MERCADERIAS	
BEGIN	
	v_return = getacctidsbystring(p_ad_client_id, p_c_element_id, v_acctvalue);
  RETURN v_return;
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION getacctidsinventoryothers(numeric, numeric)
  OWNER TO adempiere;
