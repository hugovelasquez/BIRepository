-- KPI-Inventory Turnover 2 
SELECT 
to_char(date_part('YEAR'::text, now()::timestamp) - 4, '9999') as "Año",
get_kpi_labour_asset_turnover2(1000000, 1000002, date_part('YEAR'::text, now()::timestamp) - 4, 'A') as "Inventory Turnover2"

UNION
SELECT 
to_char(date_part('YEAR'::text, now()::timestamp) - 3, '9999') as "Año",
get_kpi_labour_asset_turnover2(1000000, 1000002, date_part('YEAR'::text, now()::timestamp) - 3, 'A') as "Inventory Turnover2"

UNION
SELECT 
to_char(date_part('YEAR'::text, now()::timestamp) - 2, '9999') as "Año",
get_kpi_labour_asset_turnover2(1000000, 1000002, date_part('YEAR'::text, now()::timestamp) - 2, 'A') as "Inventory Turnover2"

UNION
SELECT 
to_char(date_part('YEAR'::text, now()::timestamp) - 1, '9999') as "Año",
get_kpi_labour_asset_turnover2(1000000, 1000002, date_part('YEAR'::text, now()::timestamp) - 1, 'A') as "Inventory Turnover2"

UNION
SELECT 
to_char(date_part('YEAR'::text, now()::timestamp) - 0, '9999') as "Año",
get_kpi_labour_asset_turnover2(1000000, 1000002, date_part('YEAR'::text, now()::timestamp) - 0, 'A') as "Inventory Turnover2"

ORDER BY 1