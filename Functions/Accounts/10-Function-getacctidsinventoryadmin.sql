-- Delivers the ids of administration inventory accounts as string
-- Example:
-- SELECT getacctidsinventoryadmin(1000000,1000002)
CREATE OR REPLACE FUNCTION getacctidsinventoryadmin(p_ad_client_id numeric, p_c_element_id numeric)
  RETURNS character varying AS 
$BODY$
DECLARE
	v_return 	character varying;
	v_acctvalue character varying= '10607';  -- Cuentas ADMINISTRATIVA	
BEGIN	
	v_return = getacctidsbystring(p_ad_client_id, p_c_element_id, v_acctvalue);
  RETURN v_return;
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION getacctidsinventoryadmin(numeric, numeric)
  OWNER TO adempiere;
