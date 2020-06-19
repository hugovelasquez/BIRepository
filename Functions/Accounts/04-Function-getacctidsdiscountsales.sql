-- Delivers the ids of sales discount accounts as string
-- Example:
-- SELECT getacctidsdiscountsales()
CREATE OR REPLACE FUNCTION getacctidsdiscountsales(p_ad_client_id numeric, p_c_element_id numeric)
  RETURNS character varying AS 
$BODY$
DECLARE
	v_return 	 character varying;
	v_acctvalue  character varying = '502';	-- Cuentas REBAJAS Y DEVOLUCIONES VENTAS ("sobre Compras");	
BEGIN	
	v_return = getacctidsbystring(p_ad_client_id, p_c_element_id, v_acctvalue);
  RETURN v_return;
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION getacctidsdiscountsales(numeric, numeric)
  OWNER TO adempiere;
