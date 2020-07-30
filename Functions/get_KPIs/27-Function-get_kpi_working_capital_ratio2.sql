-- FUNCTION: adempiere.get_kpi_working_capital_ratio2(numeric, numeric, double precision, character)

-- DROP FUNCTION adempiere.get_kpi_working_capital_ratio2(numeric, numeric, double precision, character);

-- Example:
-- SELECT  
-- get_kpi_working_capital_ratio2(1000000, 1000002, date_part('YEAR'::text, now()::timestamp) - 1, 'A') as "Working Capital Ratio2"

CREATE OR REPLACE FUNCTION adempiere.get_kpi_working_capital_ratio2(
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
  v_revenue_op_field    		CONSTANT character varying = 'isrevenueoperation';  
  v_trade_receivables_field		CONSTANT character varying = 'istradereceivables';
  v_trade_payables_field		CONSTANT character varying = 'istradepayables';
  v_inventory_field	    		CONSTANT character varying = 'isinventory';

  v_sales_revenue         		numeric; -- Ingreso Ventas
  v_inventory_value			 	numeric; -- Inventario 
  v_trade_receivables			numeric; -- Cobros abiertos de operaciones (suma del balance financiero)
  v_trade_payables				numeric; -- Creditos abiertos de operaciones (suma del balance financiero)

  v_working_capital_ratio 		numeric; -- Ratio de Capital circulante = (trade receivables + inventory - trade payabales) / sales revenue * 100
BEGIN
  v_working_capital_ratio = 0;
  
  v_sales_revenue = getamtacctbalance_year2(
    p_year,                                         	-- Year
    v_revenue_op_field, 	                        	-- Revenue Operation (Cuentas Ingresos VENTAS - Cuentas REBAJAS Y DEVOLUCIONES = '501' - '502')
    p_postingtype,                                  	-- Posting Type
    -1                                              	-- Multiplier= x1
  ); 

  v_inventory_value = getamtacctbalance_year2(
    p_year,                                         	-- Year
    v_inventory_field,                          		-- Value of Inventory (Cuentas Inventario AGRICOLA + INDUSTRIAL + OTRAS MERCADERIAS + CONSIGNACION + ORDENES PRODUCCION + ADMINISTRATIVA = '10601' + '10602' + '10603' + '10605' + '10606' + '10607')
    p_postingtype,                                  	-- Posting Type
    1                                               	-- Multiplier= x1
    );  

  v_trade_receivables = getamtacctbalance_year2(
    p_year,                                         	-- Year 
    v_trade_receivables_field,                          -- Trade receivables
    p_postingtype,                                  	-- Posting Type
    -1                                               	-- Multiplier= x-1
    );   

  v_trade_payables = getamtacctbalance_year2(
    p_year,                                         	-- Year 
    v_trade_payables_field,                          	-- Trade payables
    p_postingtype,                                  	-- Posting Type
    -1                                               	-- Multiplier= x-1
    ); 	
																						
    IF (v_sales_revenue IS NULL OR v_sales_revenue=0)
    THEN v_working_capital_ratio = 0;
    ELSE v_working_capital_ratio = (v_trade_receivables + v_inventory_value - v_trade_payables) / v_sales_revenue * 100;
    END IF;

  RETURN ROUND(COALESCE(v_working_capital_ratio, 0), 2);
END;

$BODY$;

ALTER FUNCTION adempiere.get_kpi_working_capital_ratio2(numeric, numeric, double precision, character)
    OWNER TO adempiere;
