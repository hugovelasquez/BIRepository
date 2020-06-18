-- Delivers the values of sales expenses accounts as an array
-- Manual creation of variables necessary if more than 15 values are needed 
-- Example:
-- SELECT getacctidsexpensessales(1000000, 1000002)
CREATE OR REPLACE FUNCTION getacctidsexpensessales(p_ad_client_id numeric, p_c_element_id numeric)
  RETURNS character varying AS 
$BODY$
DECLARE
	v_return  character varying;
	v_acctids character varying[];
	
	v_acctvalue1  character varying = '4030101001';		-- SUELDOS
	v_acctvalue2  character varying = '4030101002';		-- COMISIONES POR COBROS;			
	v_acctvalue3  character varying = '4030101003';		-- AGUINALDOS
	v_acctvalue4  character varying = '4030101004';		-- VACACIONES
	v_acctvalue5  character varying = '4030101005';		-- INDEMNIZACIONES 
	v_acctvalue6  character varying = '4030101006';		-- BONIFICACIONES Y GRATIFICACIONES
	v_acctvalue7  character varying = '4030101017';		-- CUOTA PATRONAL ISSS
	v_acctvalue8  character varying = '4030101018';		-- CUOTA PATRONAL AFP
	v_acctvalue9  character varying = '4030101020';		-- VIATICOS Y GASTOS DE VIAJE
BEGIN
					
	v_acctids =	ARRAY[v_acctvalue1,v_acctvalue2,v_acctvalue3,v_acctvalue4,v_acctvalue5,v_acctvalue6,v_acctvalue7,v_acctvalue8,v_acctvalue9];

	v_return = getacctidsbyarray(p_ad_client_id, p_c_element_id, v_acctids);
	
  RETURN v_return;
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION getacctidsexpensessales(numeric, numeric)
  OWNER TO adempiere;
