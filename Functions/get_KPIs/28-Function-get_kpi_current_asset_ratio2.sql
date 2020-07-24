-- FUNCTION: adempiere.get_kpi_current_asset_ratio2(numeric, numeric, double precision, character)

-- DROP FUNCTION adempiere.get_kpi_current_asset_ratio2(numeric, numeric, double precision, character);

-- Example:
-- SELECT  
-- get_kpi_current_asset_ratio2(1000000, 1000002, date_part('YEAR'::text, now()::timestamp) - 1, 'A') as "Current Asset Ratio2"

CREATE OR REPLACE FUNCTION adempiere.get_kpi_current_asset_ratio2(
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
  v_current_assets_field       	CONSTANT character varying = 'iscurrentassets';		
  v_current_liabilities_field  	CONSTANT character varying = 'iscurrentliabilities';

  v_current_assets				numeric; -- Activos corrientes (suma del balance financiero)
  v_current_liabilities			numeric; -- Pasivos corrientes (suma del balance financiero)

  v_current_asset_ratio 		numeric; -- Ratio de activos corrientes = current_assets / current_liabilities
BEGIN
  v_current_asset_ratio = 0;
  
  v_current_assets = getamtacctbalance_year2(
    p_year,                                         	-- Year
    v_current_assets_field, 	                        -- Activos corrientes
    p_postingtype,                                  	-- Posting Type
    1                                              		-- Multiplier= x1
  ); 

  v_current_liabilities = getamtacctbalance_year2(
    p_year,                                         	-- Year
    v_current_liabilities_field, 	                    -- Pasivos corrientes
    p_postingtype,                                  	-- Posting Type
    1                                              		-- Multiplier= x1
  ); 
																						
    IF (v_current_liabilities IS NULL OR v_current_liabilities=0)
    THEN v_current_asset_ratio = 0;
    ELSE v_current_asset_ratio = v_current_assets / v_current_liabilities;
    END IF;

  RETURN ROUND(COALESCE(v_current_asset_ratio, 0), 2);
END;

$BODY$;

ALTER FUNCTION adempiere.get_kpi_current_asset_ratio2(numeric, numeric, double precision, character)
    OWNER TO adempiere;
