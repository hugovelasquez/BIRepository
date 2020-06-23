-- KPI-Inventory Turnover 
SELECT 
to_char(date_part('YEAR'::text, now()::timestamp) - 4, '9999') as "Año",
get_kpi_inventory_turnover(1000000, 1000002, date_part('YEAR'::text, now()::timestamp) - 4, 'A') as "Inventory Turnover"

UNION
SELECT 
to_char(date_part('YEAR'::text, now()::timestamp) - 3, '9999') as "Año",
get_kpi_inventory_turnover(1000000, 1000002, date_part('YEAR'::text, now()::timestamp) - 3, 'A') as "Inventory Turnover"

UNION
SELECT 
to_char(date_part('YEAR'::text, now()::timestamp) - 2, '9999') as "Año",
get_kpi_inventory_turnover(1000000, 1000002, date_part('YEAR'::text, now()::timestamp) - 2, 'A') as "Inventory Turnover"

UNION
SELECT 
to_char(date_part('YEAR'::text, now()::timestamp) - 1, '9999') as "Año",
get_kpi_inventory_turnover(1000000, 1000002, date_part('YEAR'::text, now()::timestamp) - 1, 'A') as "Inventory Turnover"

UNION
SELECT 
to_char(date_part('YEAR'::text, now()::timestamp) - 0, '9999') as "Año",
get_kpi_inventory_turnover(1000000, 1000002, date_part('YEAR'::text, now()::timestamp) - 0, 'A') as "Inventory Turnover"

ORDER BY 1