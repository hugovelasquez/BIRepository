-- Calculates labour asset turnover for one year
-- labour asset turnover = sales revenue / labour costs  
-- Example:
-- SELECT  
-- get_kpi_labour_asset_turnover2(1000000, 1000002, date_part('YEAR'::text, now()::timestamp) - 1, 'A') as "Labour Asset Turnover"
CREATE OR REPLACE FUNCTION get_kpi_labour_asset_turnover2(p_ad_client_id numeric, p_c_element_id numeric, p_year double precision, p_postingtype char)
  RETURNS numeric AS
$BODY$
DECLARE
  v_revenue_op_field    CONSTANT character varying = 'isrevenueoperation';
  v_labour_direct_field CONSTANT character varying = 'islabourcostdirect';

  v_sales_revenue         	numeric; -- Ingreso Ventas
  v_labour_costs_direct   	numeric; -- Gasto Labor directo 
  v_labour_costs          	numeric; -- Gasto Labor directo total
  v_labour_asset_turnover 	numeric; -- Return = sales revenue / labour costs
BEGIN
  v_labour_asset_turnover = 0;
  
  v_sales_revenue = getamtacctbalance_year2(
    p_year,                                         -- Year
    v_revenue_op_field, 	                        -- Revenue Operation (Cuentas Ingresos VENTAS - Cuentas REBAJAS Y DEVOLUCIONES = '501' - '502')
    p_postingtype,                                  -- Posting Type
    -1                                              -- Multiplier= x1
  ); 
  
  v_labour_costs_direct = getamtacctbalance_year2(
    p_year,                                         -- Year
    v_labour_direct_field,                          -- Cost Labour Direct (ciertas Cuentas GASTO VENTAS + ciertas Cuentas GASTO ADMINISTRACION = '4030101' + '4030102')
    p_postingtype,                                  -- Posting Type
    1                                               -- Multiplier= x1
    );  
                              
																						
    v_labour_costs  = v_labour_costs_direct;

    IF (v_labour_costs IS NULL OR v_labour_costs=0)
    THEN v_labour_asset_turnover = 0;
    ELSE v_labour_asset_turnover = v_sales_revenue / v_labour_costs;
    END IF;

  RETURN ROUND(COALESCE(v_labour_asset_turnover, 0), 2);
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION get_kpi_labour_asset_turnover2(numeric, numeric, double precision, char)
  OWNER TO adempiere;
