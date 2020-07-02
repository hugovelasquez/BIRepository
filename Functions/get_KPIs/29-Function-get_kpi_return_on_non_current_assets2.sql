-- FUNCTION: adempiere.get_kpi_return_on_non_current_assets2(numeric, numeric, double precision, character)

-- DROP FUNCTION adempiere.get_kpi_return_on_non_current_assets2(numeric, numeric, double precision, character);

-- Example:
-- SELECT  
-- get_kpi_return_on_non_current_assets2(1000000, 1000002, date_part('YEAR'::text, now()::timestamp) - 1, 'A') as "Return on Non-Current Assets2 (%)"
CREATE OR REPLACE FUNCTION adempiere.get_kpi_return_on_non_current_assets2(
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
  v_revenue_op_field    			CONSTANT character varying = 'isrevenueoperation'; 
  v_cogs_field          			CONSTANT character varying = 'iscogs';  
  v_labour_direct_field 			CONSTANT character varying = 'islabourcostdirect';
  v_other_operating_expenses_field	CONSTANT character varying = 'isotheroperatingexpenses';
  v_depreciation_field 				CONSTANT character varying = 'isdepreciation';
  v_non_current_assets_field		CONSTANT character varying = 'isnoncurrentassets';   

  v_sales_revenue         			numeric; -- Ingreso Ventas 
  v_cogs         					numeric; -- Costos de Ventas 
  v_labour_costs_direct	   			numeric; -- Gasto Labor directa 
  v_other_operating_expenses		numeric; -- Otros gastos operacionales 
  v_depreciation 					numeric; -- Depreciación 
  v_non_current_assets				numeric; -- Activos no corrientes
  
  v_ebit 	         				numeric; -- Ganancia de Operaciones	( = sales revenue - cogs - labour cost direct - other operating expeses - depreciation)
  v_return_on_non_current_assets	numeric; -- Margen sobre activos no corrientes ( = ebit / non current assets * 100)
BEGIN
  v_return_on_non_current_assets = 0;
   
  v_sales_revenue = getamtacctbalance_year2(
    p_year,                                         	-- Year 
    v_revenue_op_field, 	                        	-- Revenue Operation (Cuentas Ingresos VENTAS - Cuentas REBAJAS Y DEVOLUCIONES = '501' - '502')
    p_postingtype,                                  	-- Posting Type
    -1                                              	-- Multiplier= x1
  ); 

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
	
  v_depreciation = getamtacctbalance_year2(
    p_year,   		                                    	-- Year 
    v_depreciation_field,                          			-- Depreciaciones (ciertas Cuentas GASTO VENTAS + ciertas Cuentas GASTO ADMINISTRACION = '4030101' + '4030102')
    p_postingtype,                                  		-- Posting Type
    1                                               		-- Multiplier= x1
    ); 

  v_non_current_assets = getamtacctbalance_year2(
    p_year,   		                                    	-- Year 
    v_non_current_assets_field,                          	-- Activos no corrientes 
    p_postingtype,                                  		-- Posting Type
    1                                               		-- Multiplier= x1
    );  	

    v_ebit  = v_sales_revenue - v_cogs - v_labour_costs_direct - v_other_operating_expenses - v_depreciation;
	

    IF (v_non_current_assets IS NULL OR v_non_current_assets=0)
    THEN v_return_on_non_current_assets = 0;
    ELSE v_return_on_non_current_assets = v_ebit / v_non_current_assets * 100;
    END IF;

  RETURN ROUND(COALESCE(v_return_on_non_current_assets, 0), 2);
END;

$BODY$;

ALTER FUNCTION adempiere.get_kpi_return_on_non_current_assets2(numeric, numeric, double precision, character)
    OWNER TO adempiere;
