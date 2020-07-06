-- FUNCTION: adempiere.get_kpi_net_profit_margin2(numeric, numeric, double precision, character)

-- DROP FUNCTION adempiere.get_kpi_net_profit_margin2(numeric, numeric, double precision, character);

-- Example:
-- SELECT  
-- get_kpi_net_profit_margin2(1000000, 1000002, date_part('YEAR'::text, now()::timestamp) - 1, 'A') as "Net Profit Margin2 (%)"
CREATE OR REPLACE FUNCTION adempiere.get_kpi_net_profit_margin2(
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
  v_finance_expenses_field				CONSTANT character varying = 'isfinanceexpenses';
  v_taxes_field							CONSTANT character varying = 'istaxaccount';

  v_sales_revenue         			numeric; -- Ingreso Ventas 
  v_cogs         					numeric; -- Costos de Ventas 
  v_labour_costs_direct	   			numeric; -- Gasto Labor directa 
  v_other_operating_expenses		numeric; -- Otros gastos operacionales 
  v_depreciation 					numeric; -- Depreciación
  v_finance_expenses				numeric; -- Gastos financieros 
  v_taxes		 					numeric; -- Impuestos
  
  v_net_profit 	         			numeric; -- Ganancia Neta( = sales revenue - cogs - labour cost direct - other operating expeses - depreciation - finance expenses - taxes)
  v_net_profit_margin	         	numeric; -- Margen de Ganancia Neta ( = net_profit / sales revenue)
BEGIN
  v_net_profit_margin = 0;
   
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

  v_finance_expenses = getamtacctbalance_year2(
    p_year,   		                                    	-- Year 
    v_finance_expenses_field,                          		-- Gastos financieros (Cuentas GASTOS FINANCIEROS = '40302')
    p_postingtype,                                  		-- Posting Type
    1                                               		-- Multiplier= x1
    );  	
	
  v_taxes = getamtacctbalance_year2(
    p_year,   		                                    	-- Year 
    v_taxes_field,                          				-- Impuestos (ciertas Cuentas GASTO VENTAS + ciertas Cuentas GASTO ADMINISTRACION = '4030101' + '4030102')
    p_postingtype,                                  		-- Posting Type
    1                                               		-- Multiplier= x1
    );  	
	
    v_net_profit  = v_sales_revenue - v_cogs - v_labour_costs_direct - v_other_operating_expenses - v_depreciation - v_finance_expenses - v_taxes;
	

    IF (v_sales_revenue IS NULL OR v_sales_revenue=0)
    THEN v_net_profit_margin = 0;
    ELSE v_net_profit_margin = v_net_profit / v_sales_revenue * 100;
    END IF;

  RETURN ROUND(COALESCE(v_net_profit_margin, 0), 2);
END;

$BODY$;

ALTER FUNCTION adempiere.get_kpi_net_profit_margin2(numeric, numeric, double precision, character)
    OWNER TO adempiere;
