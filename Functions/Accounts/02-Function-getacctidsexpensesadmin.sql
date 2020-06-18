-- Delivers the values of admin expenses accounts as an array
-- Manual creation of variables necessary if more than 15 values are needed 
-- Example:
-- SELECT getacctidsexpensesadmin()
CREATE OR REPLACE FUNCTION getacctidsexpensesadmin(p_ad_client_id numeric, p_c_element_id numeric)
  RETURNS character varying AS 
$BODY$
DECLARE
	v_return  character varying;
	v_acctids character varying[];
	
	v_acctvalue1  character varying = '4030102001';		-- SUELDOS
	v_acctvalue2  character varying = '4030102002';		-- COMISIONES
	v_acctvalue3  character varying = '4030102003';		-- AGUINALDOS
	v_acctvalue4  character varying = '4030102004';		-- VACACIONES
	v_acctvalue5  character varying = '4030102005';		-- INDEMNIZACIONES
	v_acctvalue6  character varying = '4030102006';		-- BONIFICACIONES Y GRATIFICACIONES
	v_acctvalue7  character varying = '4030102009';		-- HORAS EXTRAS
	v_acctvalue8  character varying = '4030102022';		-- CUOTA PATRONAL DEL ISSS
	v_acctvalue9  character varying = '4030102023';		-- CUOTA PATRONAL DE AFP
	v_acctvalue10 character varying = '4030102024'; 	-- CUOTA PATRONAL DE INSAFORP
	v_acctvalue11 character varying = '4030102026'; 	-- VIATICOS Y GASTOS DE VIAJE
	v_acctvalue12 character varying = '4030102065'; 	-- PRESTACIONES LABORALES
	v_acctvalue13 character varying = '4030102066'; 	-- BACK OFFICE 2%
	v_acctvalue14 character varying = '4030102067';  	-- LOGISTICA 7%
BEGIN
					
	v_acctids =	ARRAY[v_acctvalue1,v_acctvalue2,v_acctvalue3,v_acctvalue4,v_acctvalue5,v_acctvalue6,v_acctvalue7,v_acctvalue8,v_acctvalue9,v_acctvalue10,v_acctvalue11,v_acctvalue12,v_acctvalue13,v_acctvalue14];

	v_return = getacctidsbyarray(p_ad_client_id, p_c_element_id, v_acctids);
	
  RETURN v_return;
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION getacctidsexpensesadmin(numeric, numeric)
  OWNER TO adempiere;
