-- Calculates inventory turnover for one year
-- inventory turnover = sales revenue / average inventory costs
-- Example:
-- SELECT  
-- get_kpi_inventory_turnover(1000000, 1000002, date_part('YEAR'::text, now()::timestamp) - 0, 'A') as "Inventory Turnover"
CREATE OR REPLACE FUNCTION get_kpi_inventory_turnover(p_ad_client_id numeric, p_c_element_id numeric, p_year double precision, p_postingtype char)
  RETURNS numeric AS
$BODY$
DECLARE
	v_income_balance numeric;   						-- Balance Ingreso Ventas
	v_discount_balance numeric; 						-- Balance Descuento Ventas
	v_inventory_agriculture_balance_pre_year numeric;	-- Balance Inventario Agricola año previo
	v_inventory_agriculture_balance_curr_year numeric;	-- Balance Inventario Agricola año actual
	v_inventory_industrial_balance_pre_year numeric;	-- Balance Inventario Industrial año previo
	v_inventory_industrial_balance_curr_year numeric;	-- Balance Inventario Industrial año actual
	v_inventory_others_balance_pre_year numeric;		-- Balance Inventario Otros Materiales año previo
	v_inventory_others_balance_curr_year numeric;		-- Balance Inventario Otros Materiales año actual
	
	v_sales_revenue numeric;  							-- Balance Ingreso Ventas - Balance Descuento Ventas
	v_inventory_costs_pre_year numeric;   				-- (Balance Inventario Agricola año previo + Balance Inventario Industrial año previo + Balance Inventario Otros Materiales año previo)
	v_inventory_costs_curr_year numeric;   				-- (Balance Inventario Agricola año actual + Balance Inventario Industrial año actual + Balance Inventario Otros Materiales año actual)
	v_average_inventory_costs numeric;   				-- (v_inventory_costs_pre_year + v_inventory_costs_curr_year)/2 
	v_inventory_turnover numeric;  						-- Return variable = sales revenue / average inventory costs
BEGIN
  v_inventory_turnover = 0;
  
  v_income_balance = getamtacctbalance_year(
    p_year,                                                  		-- Year
    getacctidsincomesales(p_ad_client_id, p_c_element_id), 	 		-- Cuentas Ingresos VENTAS
    p_postingtype,                                           		-- Posting Type
    -1                                                       		-- Multiplier= x1
  ) ; 		
		
  v_discount_balance = getamtacctbalance_year(		
    p_year,                                                  		-- Year
    getacctidsdiscountsales(p_ad_client_id, p_c_element_id), 		-- Cuentas REBAJAS Y DEVOLUCIONES VENTAS ("sobre Compras")
    p_postingtype,                                           		-- Posting Type
    1                                                        		-- Multiplier= x1
  ) ; 
  
  v_inventory_agriculture_balance_curr_year = getamtacctbalance_year(
    p_year,                                                  			-- Year
    getacctidsinventoryagriculture(p_ad_client_id, p_c_element_id), 	-- Cuentas INVENTARIO AGRICOLA año actual  
    p_postingtype,                                           			-- Posting Type
    1                                                        			-- Multiplier= x1
  ); 

   v_inventory_agriculture_balance_pre_year = getamtacctbalance_year(
    p_year - 1,                                                  		-- Year - 1
    getacctidsinventoryagriculture(p_ad_client_id, p_c_element_id), 	-- Cuentas INVENTARIO AGRICOLA año previo 
    p_postingtype,                                           			-- Posting Type
    1                                                        			-- Multiplier= x1
  );               

  v_inventory_industrial_balance_curr_year = getamtacctbalance_year(
    p_year,                                                  			-- Year
    getacctidsinventoryindustrial(p_ad_client_id, p_c_element_id), 		-- Cuentas INVENTARIO INDUSTRIAL año actual  
    p_postingtype,                                           			-- Posting Type
    1                                                        			-- Multiplier= x1
  ); 

   v_inventory_industrial_balance_pre_year = getamtacctbalance_year(
    p_year - 1,                                                  		-- Year - 1
    getacctidsinventoryindustrial(p_ad_client_id, p_c_element_id), 		-- Cuentas INVENTARIO INDUSTRIAL año previo 
    p_postingtype,                                           			-- Posting Type
    1                                                        			-- Multiplier= x1
  );  
  
   v_inventory_others_balance_curr_year = getamtacctbalance_year(
    p_year,                                                  			-- Year
    getacctidsinventoryothers(p_ad_client_id, p_c_element_id), 			-- Cuentas INVENTARIO DE OTRAS MERCADERIAS año actual  
    p_postingtype,                                           			-- Posting Type
    1                                                        			-- Multiplier= x1
  ); 

   v_inventory_others_balance_pre_year = getamtacctbalance_year(
    p_year - 1,                                                  		-- Year - 1
    getacctidsinventoryothers(p_ad_client_id, p_c_element_id), 			-- Cuentas INVENTARIO DE OTRAS MERCADERIAS año previo 
    p_postingtype,                                           			-- Posting Type
    1                                                        			-- Multiplier= x1
  );              
			
			
    v_sales_revenue = v_income_balance - v_discount_balance; 			-- Balance Ingreso Ventas - Balance Descuento Ventas
    v_inventory_costs_pre_year  = v_inventory_agriculture_balance_pre_year + v_inventory_industrial_balance_pre_year + v_inventory_others_balance_pre_year;
    v_inventory_costs_curr_year = v_inventory_agriculture_balance_curr_year + v_inventory_industrial_balance_curr_year + v_inventory_others_balance_curr_year;
	v_average_inventory_costs   = (v_inventory_costs_pre_year + v_inventory_costs_curr_year)/2;  	 

    IF (v_average_inventory_costs IS NULL OR v_average_inventory_costs=0)
    THEN v_inventory_turnover = 0;
    ELSE v_inventory_turnover = v_sales_revenue / v_average_inventory_costs;
    END IF;

  RETURN ROUND(COALESCE(v_inventory_turnover, 0), 5);
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION get_kpi_inventory_turnover(numeric, numeric, double precision, char)
  OWNER TO adempiere;
