-- Postingtype: SUSANNE MUSS SIE AUF 'A' UMSTELLEN BIS 2019; ZURZEIT SIND SIE ='S'
SELECT 
to_char(date_part('YEAR'::text, now()::timestamp) - 4, '9999') as "Año",
get_kpi_labour_asset_turnover(1000000, 1000002, date_part('YEAR'::text, now()::timestamp) - 4, 'S') as "Labour Asset Turnover"

UNION
SELECT 
to_char(date_part('YEAR'::text, now()::timestamp) - 3, '9999') as "Año",
get_kpi_labour_asset_turnover(1000000, 1000002, date_part('YEAR'::text, now()::timestamp) - 3, 'S') as "Labour Asset Turnover"

UNION
SELECT 
to_char(date_part('YEAR'::text, now()::timestamp) - 2, '9999') as "Año",
get_kpi_labour_asset_turnover(1000000, 1000002, date_part('YEAR'::text, now()::timestamp) - 2, 'S') as "Labour Asset Turnover"

UNION
SELECT 
to_char(date_part('YEAR'::text, now()::timestamp) - 1, '9999') as "Año",
get_kpi_labour_asset_turnover(1000000, 1000002, date_part('YEAR'::text, now()::timestamp) - 1, 'S') as "Labour Asset Turnover"

UNION
SELECT 
to_char(date_part('YEAR'::text, now()::timestamp) - 0, '9999') as "Año",
get_kpi_labour_asset_turnover(1000000, 1000002, date_part('YEAR'::text, now()::timestamp) - 0, 'A') as "Labour Asset Turnover"

ORDER BY 1