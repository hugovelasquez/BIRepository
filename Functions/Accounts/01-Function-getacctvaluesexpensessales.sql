-- Delivers the values of sales expenses accounts as an array
-- Manual creation of variables necessary if more than 15 values are needed 
-- prefix "v_" denotes a variable
-- Example:
-- SELECT getacctvaluesexpensessales()
CREATE OR REPLACE FUNCTION getacctvaluesexpensessales()
  RETURNS text[] AS 
$BODY$
DECLARE
	v_return 	  character varying;
	v_acctvalues  character varying;
	
	v_acctvalue1  character varying;			
	v_acctvalue2  character varying;			
	v_acctvalue3  character varying;			
	v_acctvalue4  character varying;			
	v_acctvalue5  character varying;			
	v_acctvalue6  character varying;			
	v_acctvalue7  character varying;			
	v_acctvalue8  character varying;			
	v_acctvalue9  character varying;			
	v_acctvalue10 character varying;			
	v_acctvalue11 character varying;			
	v_acctvalue12 character varying;			
	v_acctvalue13 character varying;			
	v_acctvalue14 character varying;			
	v_acctvalue15 character varying;			
BEGIN
	v_acctvalue1  = '4030101001';		-- SUELDOS
	v_acctvalue2  = '4030101002';		-- COMISIONES POR COBROS
	v_acctvalue3  = '4030101003';		-- AGUINALDOS
	v_acctvalue4  = '4030101004';		-- VACACIONES
	v_acctvalue5  = '4030101005';		-- INDEMNIZACIONES 
	v_acctvalue6  = '4030101006';		-- BONIFICACIONES Y GRATIFICACIONES
	v_acctvalue7  = '4030101017';		-- CUOTA PATRONAL ISSS
	v_acctvalue8  = '4030101018';		-- CUOTA PATRONAL AFP
	v_acctvalue9  = '4030101020';		-- VIATICOS Y GASTOS DE VIAJE
	v_acctvalue10 = '';					-- 
	v_acctvalue11 = '';					-- 
	v_acctvalue12 = '';					-- 
	v_acctvalue13 = '';					-- 
	v_acctvalue14 = '';					-- 
	v_acctvalue15 = '';					-- 
					
	v_acctvalues =	ARRAY[v_acctvalue1,v_acctvalue2,v_acctvalue3,v_acctvalue4,v_acctvalue5,v_acctvalue6,v_acctvalue7,v_acctvalue8
						 ,v_acctvalue9,v_acctvalue10,v_acctvalue11,v_acctvalue12,v_acctvalue13,v_acctvalue14,v_acctvalue15];

	v_return = v_acctvalues;
	
  RETURN v_return;
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION getacctvaluesexpensessales()
  OWNER TO adempiere;
