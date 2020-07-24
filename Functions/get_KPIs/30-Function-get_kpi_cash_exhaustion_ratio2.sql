-- FUNCTION: adempiere.get_kpi_cash_exhaustion_ratio2(numeric, numeric, double precision, character)

-- DROP FUNCTION adempiere.get_kpi_cash_exhaustion_ratio2(numeric, numeric, double precision, character);

-- Example:
-- SELECT  
-- get_kpi_cash_exhaustion_ratio2(1000000, 1000002, date_part('YEAR'::text, now()::timestamp) - 1, 'A') as "Cash Exhaustion Ratio2 (%)"
CREATE OR REPLACE FUNCTION adempiere.get_kpi_cash_exhaustion_ratio2(
	p_ad_client_id numeric,
	p_c_element_id numeric,
	p_year double precision,
	p_postingtype character)
    RETURNS numeric
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
DECLARE
  v_cogs_field          			CONSTANT character varying = 'iscogs';  
  v_labour_direct_field 			CONSTANT character varying = 'islabourcostdirect';
  v_other_operating_expenses_field	CONSTANT character varying = 'isotheroperatingexpenses';
  v_depreciation_field 				CONSTANT character varying = 'isdepreciation';
  v_cash_field						CONSTANT character varying = 'iscash'  ;

  v_cogs         						numeric; -- Costos de Ventas 
  v_labour_costs_direct	   				numeric; -- Gasto Labor directa 
  v_other_operating_expenses			numeric; -- Otros gastos operacionales 
  v_depreciation 						numeric; -- Depreciación 
  v_cash								numeric; -- Efectivo y activos líquidos equivalentes (suma del balance financiero)

  v_total_operating_costs			    numeric; -- Gasto total de operaciones ( = Costos de Ventas + Gasto Labor directa + Otros gastos operacionales + Depreciaciones)
  v_avg_daily_expenditure				numeric; -- Gasto promedio de operaciones diario ( = Gasto total de operaciones / 365 días )
  v_cash_exhaustion_ratio				numeric; -- Ratio de agotamiento de efectivo  ( = cash / average daily expenditure )
BEGIN
  v_cash_exhaustion_ratio = 0;
   
  v_cogs = getamtacctbalance_year2(
    p_year,   		                                    -- Year 
    v_cogs_field,                          				-- COGS (Cuentas Costos VENTA - Cuentas REBAJAS Y DEVOLUCIONES = '401' - '402')
    p_postingtype,                                  	-- Posting Type
    1                                               	-- Multiplier= x1
    );                                                                                  

  v_labour_costs_direct = getamtacctbalance_year2(
    p_year,   		                                    -- Year 
    v_labour_direct_field,                          	-- Cost Labour Direct (ciertas Cuentas GASTO VENTAS + ciertas Cuentas GASTO ADMINISTRACION = '4030101' + '4030102')
    p_postingtype,                                  	-- Posting Type
    1                                               	-- Multiplier= x1
    );  
	
  v_other_operating_expenses = getamtacctbalance_year2(
    p_year,   		                                    	-- Year 
    v_other_operating_expenses_field,                       -- Other operating expenses (ciertas Cuentas GASTO VENTAS + ciertas Cuentas GASTO ADMINISTRACION = '4030101' + '4030102')
    p_postingtype,                                  		-- Posting Type
    1                                               		-- Multiplier= x1
    ); 

  v_cash = getamtacctbalance_year2(
    p_year,   		                                    	-- Year 
    v_cash_field,                          					-- Efectivo y activos líquidos equivalentes 
    p_postingtype,                                  		-- Posting Type
    1                                               		-- Multiplier= x1
    );  	

    v_total_operating_costs  = v_cogs + v_labour_costs_direct + v_other_operating_expenses;	
    v_avg_daily_expenditure  = v_total_operating_costs / 365;	
	

    IF (v_avg_daily_expenditure IS NULL OR v_avg_daily_expenditure=0)
    THEN v_cash_exhaustion_ratio = 0;
    ELSE v_cash_exhaustion_ratio = v_cash / v_avg_daily_expenditure;
    END IF;

  RETURN ROUND(COALESCE(v_cash_exhaustion_ratio, 0), 2);
END;

$BODY$;

ALTER FUNCTION adempiere.get_kpi_cash_exhaustion_ratio2(numeric, numeric, double precision, character)
    OWNER TO adempiere;
