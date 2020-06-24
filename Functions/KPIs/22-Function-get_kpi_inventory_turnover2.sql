-- FUNCTION: adempiere.get_kpi_inventory_turnover2(numeric, numeric, double precision, character)

-- DROP FUNCTION adempiere.get_kpi_inventory_turnover2(numeric, numeric, double precision, character);

-- Example:
-- SELECT  
-- get_kpi_inventory_turnover2(1000000, 1000002, date_part('YEAR'::text, now()::timestamp) - 1, 'A') as "Labour Asset Turnover"

CREATE OR REPLACE FUNCTION adempiere.get_kpi_inventory_turnover2(
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
  v_revenue_op_field    CONSTANT character varying = 'isrevenueoperation';  
  v_inventory_field	    CONSTANT character varying = 'isinventory';

  v_sales_revenue         		numeric; -- Ingreso Ventas
  v_inventory_costs_prev_year 	numeric; -- Costo Inventario año previo
  v_inventory_costs_curr_year 	numeric; -- Costo Inventario año actual
  v_avg_inventory_costs   		numeric; -- Costo Inventario promedio ( (Costo Inventario año previo + Costo Inventario año actual)/2 )
  v_inventory_turnover 			numeric; -- Return = sales revenue / average inventory costs
BEGIN
  v_inventory_turnover = 0;
  
  v_sales_revenue = getamtacctbalance_year2(
    p_year,                                         -- Year
    v_revenue_op_field, 	                        -- Revenue Operation (Cuentas Ingresos VENTAS - Cuentas REBAJAS Y DEVOLUCIONES = '501' - '502')
    p_postingtype,                                  -- Posting Type
    -1                                              -- Multiplier= x1
  ); 
  

  v_inventory_costs_prev_year = getamtacctbalance_year2(
    p_year - 1,                                         -- Year - 1
    v_inventory_field,                          		-- Cost Inventory previous year (Cuentas Inventario AGRICOLA + INDUSTRIAL + OTRAS MERCADERIAS + CONSIGNACION + ORDENES PRODUCCION + ADMINISTRATIVA = '10601' + '10602' + '10603' + '10605' + '10606' + '10607')
    p_postingtype,                                  	-- Posting Type
    1                                               	-- Multiplier= x1
    );  

  v_inventory_costs_curr_year = getamtacctbalance_year2(
    p_year,                                         	-- Year 
    v_inventory_field,                          		-- Cost Inventory current year (Cuentas Inventario AGRICOLA + INDUSTRIAL + OTRAS MERCADERIAS + CONSIGNACION + ORDENES PRODUCCION + ADMINISTRATIVA = '10601' + '10602' + '10603' + '10605' + '10606' + '10607')
    p_postingtype,                                  	-- Posting Type
    1                                               	-- Multiplier= x1
    );                                                                                  
																						
    v_avg_inventory_costs  = (v_inventory_costs_prev_year + v_inventory_costs_curr_year)/2;

    IF (v_avg_inventory_costs IS NULL OR v_avg_inventory_costs=0)
    THEN v_inventory_turnover = 0;
    ELSE v_inventory_turnover = v_sales_revenue / v_avg_inventory_costs;
    END IF;

  RETURN ROUND(COALESCE(v_inventory_turnover, 0), 2);
END;

$BODY$;

ALTER FUNCTION adempiere.get_kpi_inventory_turnover2(numeric, numeric, double precision, character)
    OWNER TO adempiere;
