-- Calculates labour asset turnover for one year
-- labour asset turnover = sales revenue / labour costs  
-- Example:
-- SELECT  
-- get_kpi_labour_asset_turnover(1000000, 1000002, date_part('YEAR'::text, now()::timestamp) - 3, 'A') as "Labour Asset Turnover"
CREATE OR REPLACE FUNCTION get_kpi_labour_asset_turnover(p_ad_client_id numeric, p_c_element_id numeric, p_year double precision, p_postingtype char)
  RETURNS numeric AS
$BODY$
DECLARE
	v_income_debit_balance numeric;   -- Balance Ingreso Debito
	v_discount_debit_balance numeric; -- Balance Descuento Debito
	v_administrative_expense_credit_balance numeric; -- Balance Gasto Administrativo Credito
	v_administrative_expense_debit_balance numeric;  -- Balance Gasto Administrativo Debito
	v_sales_revenue numeric;  -- Balance Ingreso Debito - Balance Descuento Debito
	v_labour_costs numeric;   -- Balance Gasto Administrativo Credito + Balance Gasto Administrativo Debito
	v_labour_asset_turnover numeric;  -- Return variable = sales revenue / labour costs
BEGIN
  v_labour_asset_turnover = 0;
  
  v_income_debit_balance = getamtacctbalance(
    p_year,                                                    -- Year
    getacctidsbystring(p_ad_client_id, p_c_element_id, '501'), -- Cuentas VENTAS
    p_postingtype,                                             -- Posting Type
    -1                                                         -- Multiplier= x1
  ) ; 
  
  v_discount_debit_balance = getamtacctbalance(
    p_year,                                                    -- Year
    getacctidsbystring(p_ad_client_id, p_c_element_id, '502'), -- Cuentas REBAJAS Y DEVOLUCIONES SOBRE COMPRAS
    p_postingtype,                                             -- Posting Type
    1                                                          -- Multiplier= x1
  ) ; 
  
  v_administrative_expense_credit_balance = getamtacctbalance(
    p_year,                                                    -- Year
    getacctidsbyarray(p_ad_client_id, p_c_element_id, 
    ARRAY[
    '4030101001', -- SUELDOS
    '4030101002', -- COMISIONES POR COBROS
    '4030101003', -- AGUINALDOS
    '4030101004', -- VACACIONES
    '4030101005', -- INDEMNIZACIONES
    '4030101006', -- BONIFICACIONES Y GRATIFICACIONES
    '4030101017', -- CUOTA PATRONAL ISSS
    '4030101018', -- CUOTA PATRONAL AFP
    '4030101020'  -- VIATICOS Y GASTOS DE VIAJE
    ]),                                                        -- Cuentas Gasto Administrativo Credito
    p_postingtype,                                             -- Posting Type
    1                                                          -- Multiplier= x1
  ); 

  v_administrative_expense_debit_balance = getamtacctbalance(
    p_year,                                                    -- Year
    getacctidsbyarray(p_ad_client_id, p_c_element_id, 
    ARRAY[
    '4030102001',  -- SUELDOS
    '4030102002',  -- COMISIONES
    '4030102003',  -- AGUINALDOS
    '4030102004',  -- VACACIONES
    '4030102005',  -- INDEMNIZACIONES
    '4030102006',  -- BONIFICACIONES Y GRATIFICACIONES
    '4030102009',  -- HORAS EXTRAS
    '4030102022',  -- CUOTA PATRONAL DEL ISSS
    '4030102023',  -- CUOTA PATRONAL DE AFP
    '4030102024',  -- CUOTA PATRONAL DE INSAFORP
    '4030102026',  -- VIATICOS Y GASTOS DE VIAJE
    '4030102065',  -- PRESTACIONES LABORALES
    '4030102066',  -- BACK OFFICE 2%
    '4030102067'  -- LOGISTICA 7%
    ]),                                                       -- Cuentas Gasto Administrativo Debito
    p_postingtype,                                            -- Posting Type
    1                                                         -- Multiplier= x1
    ) ; 

    v_sales_revenue = v_income_debit_balance - v_discount_debit_balance; -- Balance Ingreso Debito - Balance Descuento Debito
    v_labour_costs  = v_administrative_expense_credit_balance + v_administrative_expense_debit_balance;  -- Balance Gasto Administrativo Credito + Balance Gasto Administrativo Debito

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
