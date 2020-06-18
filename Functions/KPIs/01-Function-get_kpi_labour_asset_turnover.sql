-- Calculates labour asset turnover for one year
-- labour asset turnover = sales revenue / labour costs  
-- Example:
-- SELECT  
-- get_kpi_labour_asset_turnover(1000000, 1000002, date_part('YEAR'::text, now()::timestamp) - 3, 'A') as "Labour Asset Turnover"
CREATE OR REPLACE FUNCTION get_kpi_labour_asset_turnover(p_ad_client_id numeric, p_c_element_id numeric, p_year double precision, p_postingtype char)
  RETURNS numeric AS
$BODY$
DECLARE
	v_income_balance numeric;   				-- Balance Ingreso Ventas
	v_discount_balance numeric; 				-- Balance Descuento Ventas
	v_sales_expense_balance numeric;			-- Balance Gasto Ventas
	v_administrative_expense_balance numeric;  	-- Balance Gasto Administrativo 
	v_sales_revenue numeric;  					-- Balance Ingreso Ventas - Balance Descuento Ventas
	v_labour_costs numeric;   					-- Balance Gasto Ventas + Balance Gasto Administrativo
	v_labour_asset_turnover numeric;  			-- Return variable = sales revenue / labour costs
BEGIN
  v_labour_asset_turnover = 0;
  
  v_income_balance = getamtacctbalance_year(
    p_year,                                                  -- Year
    getacctidsincomesales(p_ad_client_id, p_c_element_id), 	 -- Cuentas Ingresos VENTAS
    p_postingtype,                                           -- Posting Type
    -1                                                       -- Multiplier= x1
  ) ; 
  
  v_discount_balance = getamtacctbalance_year(
    p_year,                                                  -- Year
    getacctidsdiscountsales(p_ad_client_id, p_c_element_id), -- Cuentas REBAJAS Y DEVOLUCIONES VENTAS ("sobre Compras")
    p_postingtype,                                           -- Posting Type
    1                                                        -- Multiplier= x1
  ) ; 
  
  v_sales_expense_balance = getamtacctbalance_year(
    p_year,                                                  -- Year
    getacctidsexpensessales(p_ad_client_id, p_c_element_id), -- Cuentas GASTO VENTAS    
    p_postingtype,                                           -- Posting Type
    1                                                        -- Multiplier= x1
  ); 

  v_administrative_expense_balance = getamtacctbalance_year(
    p_year,                                                  -- Year
    getacctidsexpensesadmin(p_ad_client_id, p_c_element_id), -- Cuentas GASTO ADMINISTRACION      
    p_postingtype,                                           -- Posting Type
    1                                                        -- Multiplier= x1
    ) ;                                                                                 
																						
    v_sales_revenue = v_income_balance - v_discount_balance; 					   -- Balance Ingreso Ventas - Balance Descuento Ventas
    v_labour_costs  = v_sales_expense_balance + v_administrative_expense_balance;  -- Balance Gasto Ventas + Balance Gasto Administrativo 

    IF (v_labour_costs IS NULL OR v_labour_costs=0)
    THEN v_labour_asset_turnover = 0;
    ELSE v_labour_asset_turnover = v_sales_revenue / v_labour_costs;
    END IF;

  RETURN ROUND(COALESCE(v_labour_asset_turnover, 0), 2);
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION get_kpi_labour_asset_turnover(numeric, numeric, double precision, char)
  OWNER TO adempiere;
