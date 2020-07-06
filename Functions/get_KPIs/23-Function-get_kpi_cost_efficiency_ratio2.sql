-- FUNCTION: adempiere.get_kpi_cost_efficiency_ratio2(numeric, numeric, double precision, character)

-- DROP FUNCTION adempiere.get_kpi_cost_efficiency_ratio2(numeric, numeric, double precision, character);

-- Example:
-- SELECT  
-- get_kpi_cost_efficiency_ratio2(1000000, 1000002, date_part('YEAR'::text, now()::timestamp) - 1, 'A') as "Cost Efficiency Ratio"
CREATE OR REPLACE FUNCTION adempiere.get_kpi_cost_efficiency_ratio2(
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
  v_revenue_op_field    				CONSTANT character varying = 'isrevenueoperation'; 
  v_cogs_field          				CONSTANT character varying = 'iscogs';  
  v_labour_direct_field 				CONSTANT character varying = 'islabourcostdirect';
  v_other_operating_expenses_field		CONSTANT character varying = 'isotheroperatingexpenses';
  v_depreciation_field 					CONSTANT character varying = 'isdepreciation';


  v_sales_revenue_prev_year         			numeric; -- Ingreso Ventas año previo
  v_total_operating_costs_prev_year	         	numeric; -- Gasto total de operación año previo (Costos de Ventas + Gasto Labor directa + Otros gastos operacionales + Depreciación)
  v_cogs_prev_year         						numeric; -- Costos de Ventas año previo
  v_labour_costs_direct_prev_year	   			numeric; -- Gasto Labor directa año previo
  v_other_operating_expenses_prev_year			numeric; -- Otros gastos operacionales año previo
  v_depreciation_prev_year 						numeric; -- Depreciación año previo
  
  v_sales_revenue_curr_year         			numeric; -- Ingreso Ventas año actual
  v_total_operating_costs_curr_year	         	numeric; -- Gasto total de operación año actual (Costos de Ventas + Gasto Labor directa + Otros gastos operacionales + Depreciación)
  v_cogs_curr_year         						numeric; -- Costos de Ventas año actual
  v_labour_costs_direct_curr_year	   			numeric; -- Gasto Labor directa año actual
  v_other_operating_expenses_curr_year			numeric; -- Otros gastos operacionales año actual
  v_depreciation_curr_year 						numeric; -- Depreciación año actual
  
  v_actual_operating_costs 	         			numeric; -- Gasto total de operación actual ( = Gasto total de operación año actual )	
  v_expected_operating_costs 	         		numeric; -- Gasto total de operación esperado ( = Gasto total de operación año previo x Ingreso Ventas año actual / Ingreso Ventas año previo )
  v_cost_efficiency_ratio	         			numeric; -- Ratio de eficiencia de costos ( = Gasto total de operación actual / Gasto total de operación esperado)
BEGIN
  v_cost_efficiency_ratio = 0;
  
  v_sales_revenue_prev_year = getamtacctbalance_year2(
    p_year - 1,                                         -- Year - 1
    v_revenue_op_field, 	                        	-- Revenue Operation (Cuentas Ingresos VENTAS - Cuentas REBAJAS Y DEVOLUCIONES = '501' - '502')
    p_postingtype,                                  	-- Posting Type
    -1                                              	-- Multiplier= x1
  ); 
  
  v_sales_revenue_curr_year = getamtacctbalance_year2(
    p_year,                                         	-- Year 
    v_revenue_op_field, 	                        	-- Revenue Operation (Cuentas Ingresos VENTAS - Cuentas REBAJAS Y DEVOLUCIONES = '501' - '502')
    p_postingtype,                                  	-- Posting Type
    -1                                              	-- Multiplier= x1
  ); 

  v_cogs_prev_year = getamtacctbalance_year2(
    p_year - 1,                                         -- Year - 1
    v_cogs_field,                          				-- COGS (Cuentas Costos VENTA - Cuentas REBAJAS Y DEVOLUCIONES = '401' - '402')
    p_postingtype,                                  	-- Posting Type
    1                                               	-- Multiplier= x1
    );  

  v_cogs_curr_year = getamtacctbalance_year2(
    p_year,   		                                    -- Year 
    v_cogs_field,                          				-- COGS (Cuentas Costos VENTA - Cuentas REBAJAS Y DEVOLUCIONES = '401' - '402')
    p_postingtype,                                  	-- Posting Type
    1                                               	-- Multiplier= x1
    );                                                                                  

  v_labour_costs_direct_prev_year = getamtacctbalance_year2(
    p_year - 1,                                         		-- Year - 1
    v_labour_direct_field,                          			-- Cost Labour Direct (ciertas Cuentas GASTO VENTAS + ciertas Cuentas GASTO ADMINISTRACION = '4030101' + '4030102')
    p_postingtype,                                  			-- Posting Type
    1                                               			-- Multiplier= x1
    );  

  v_labour_costs_direct_curr_year = getamtacctbalance_year2(
    p_year,   		                                    		-- Year 
    v_labour_direct_field,                          			-- Cost Labour Direct (ciertas Cuentas GASTO VENTAS + ciertas Cuentas GASTO ADMINISTRACION = '4030101' + '4030102')
    p_postingtype,                                  			-- Posting Type
    1                                               			-- Multiplier= x1
    );  
	
  v_other_operating_expenses_prev_year = getamtacctbalance_year2(
    p_year - 1,                                         		-- Year - 1
    v_other_operating_expenses_field,                          	-- Other operating expenses (ciertas Cuentas GASTO VENTAS + ciertas Cuentas GASTO ADMINISTRACION = '4030101' + '4030102')
    p_postingtype,                                  			-- Posting Type
    1                                               			-- Multiplier= x1
    );  

  v_other_operating_expenses_curr_year = getamtacctbalance_year2(
    p_year,   		                                    		-- Year 
    v_other_operating_expenses_field,                          	-- Other operating expenses (ciertas Cuentas GASTO VENTAS + ciertas Cuentas GASTO ADMINISTRACION = '4030101' + '4030102')
    p_postingtype,                                  			-- Posting Type
    1                                               			-- Multiplier= x1
    );  
	
  v_depreciation_prev_year = getamtacctbalance_year2(
    p_year - 1,                                         		-- Year - 1
    v_depreciation_field,                          				-- Depreciaciones (ciertas Cuentas GASTO VENTAS + ciertas Cuentas GASTO ADMINISTRACION = '4030101' + '4030102')
    p_postingtype,                                  			-- Posting Type
    1                                               			-- Multiplier= x1
    );  

  v_depreciation_curr_year = getamtacctbalance_year2(
    p_year,   		                                    		-- Year 
    v_depreciation_field,                          				-- Depreciaciones (ciertas Cuentas GASTO VENTAS + ciertas Cuentas GASTO ADMINISTRACION = '4030101' + '4030102')
    p_postingtype,                                  			-- Posting Type
    1                                               			-- Multiplier= x1
    );  	

    v_total_operating_costs_curr_year  = v_cogs_curr_year + v_labour_costs_direct_curr_year + v_other_operating_expenses_curr_year + v_depreciation_curr_year;	
	v_total_operating_costs_prev_year = v_cogs_prev_year + v_labour_costs_direct_prev_year + v_other_operating_expenses_prev_year + v_depreciation_prev_year;
	
	v_actual_operating_costs = v_total_operating_costs_curr_year;
	IF (v_sales_revenue_prev_year IS NULL OR v_sales_revenue_prev_year=0)
    THEN v_expected_operating_costs = 0;
    ELSE v_expected_operating_costs = v_total_operating_costs_prev_year * v_sales_revenue_curr_year / v_sales_revenue_prev_year; 
    END IF;	

    IF (v_expected_operating_costs IS NULL OR v_expected_operating_costs=0)
    THEN v_cost_efficiency_ratio = 0;
    ELSE v_cost_efficiency_ratio = v_actual_operating_costs / v_expected_operating_costs;
    END IF;

  RETURN ROUND(COALESCE(v_cost_efficiency_ratio, 0), 2);
END;

$BODY$;

ALTER FUNCTION adempiere.get_kpi_cost_efficiency_ratio2(numeric, numeric, double precision, character)
    OWNER TO adempiere;
