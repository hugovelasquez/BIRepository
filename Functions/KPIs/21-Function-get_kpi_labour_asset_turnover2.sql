-- Calculates labour asset turnover for one year
-- labour asset turnover = sales revenue / costs  
-- Example:
-- SELECT  
-- get_kpi_labour_asset_turnover2(1000000, 1000002, date_part('YEAR'::text, now()::timestamp) - 1, 'A') as "Labour Asset Turnover"
CREATE OR REPLACE FUNCTION get_kpi_labour_asset_turnover2(p_ad_client_id numeric, p_c_element_id numeric, p_year double precision, p_postingtype char)
  RETURNS numeric AS
$BODY$
DECLARE
  v_revenue_op_field    CONSTANT character varying = 'isrevenueoperation';
  v_cogs_field          CONSTANT character varying = 'iscogs';
  v_labour_direct_field CONSTANT character varying = 'islabourcostdirect';
  v_labour_admin_field  CONSTANT character varying = 'islabourcostadministration';

  v_sales_revenue         numeric; -- Ingreso Ventas
  v_cogs                  numeric; -- Costo Ventas
  v_labour_costs_direct   numeric; -- Gasto Labor directo 
  v_labour_costs_admin    numeric; -- Gasto Labor Administrativo 
  v_costs                 numeric; -- Costo Ventas + Gasto Labor
  v_labour_asset_turnover numeric; -- Return = sales revenue / costs
BEGIN
  v_labour_asset_turnover = 0;
  
  v_sales_revenue = getamtacctbalance_year2(
    p_year,                                         -- Year
    v_revenue_op_field, 	                        -- Revenue Operation
    p_postingtype,                                  -- Posting Type
    -1                                              -- Multiplier= x1
  ); 
  
  v_cogs = getamtacctbalance_year2(
    p_year,                                         -- Year
    v_cogs_field,                                   -- Cost of Goods Sold   
    p_postingtype,                                  -- Posting Type
    1                                               -- Multiplier= x1
  ); 

  v_labour_costs_direct = getamtacctbalance_year2(
    p_year,                                         -- Year
    v_labour_direct_field,                          -- Cost Labour Direct
    p_postingtype,                                  -- Posting Type
    1                                               -- Multiplier= x1
    );  

  v_labour_costs_admin = getamtacctbalance_year2(
    p_year,                                         -- Year
    v_labour_admin_field,                           -- Cost Labour Admin   
    p_postingtype,                                  -- Posting Type
    1                                               -- Multiplier= x1
    );                                                                                 
																						
    v_costs  = v_cogs + v_labour_costs_direct + v_labour_costs_admin;

    IF (v_costs IS NULL OR v_costs=0)
    THEN v_labour_asset_turnover = 0;
    ELSE v_labour_asset_turnover = v_sales_revenue / v_costs;
    END IF;

  RETURN ROUND(COALESCE(v_labour_asset_turnover, 0), 2);
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION get_kpi_labour_asset_turnover2(numeric, numeric, double precision, char)
  OWNER TO adempiere;
