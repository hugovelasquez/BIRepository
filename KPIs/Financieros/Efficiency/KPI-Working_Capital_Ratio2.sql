-- KPI- Working Capital Ratio2 
SELECT 
to_char(date_part('YEAR'::text, now()::timestamp) - 4, '9999') as "Año",
get_kpi_working_capital_ratio2(1000000, 1000002, date_part('YEAR'::text, now()::timestamp) - 4, 'A') as "Working Capital Ratio2"

UNION
SELECT 
to_char(date_part('YEAR'::text, now()::timestamp) - 3, '9999') as "Año",
get_kpi_working_capital_ratio2(1000000, 1000002, date_part('YEAR'::text, now()::timestamp) - 3, 'A') as "Working Capital Ratio2"

UNION
SELECT 
to_char(date_part('YEAR'::text, now()::timestamp) - 2, '9999') as "Año",
get_kpi_working_capital_ratio2(1000000, 1000002, date_part('YEAR'::text, now()::timestamp) - 2, 'A') as "Working Capital Ratio2"

UNION
SELECT 
to_char(date_part('YEAR'::text, now()::timestamp) - 1, '9999') as "Año",
get_kpi_working_capital_ratio2(1000000, 1000002, date_part('YEAR'::text, now()::timestamp) - 1, 'A') as "Working Capital Ratio2"

UNION
SELECT 
to_char(date_part('YEAR'::text, now()::timestamp) - 0, '9999') as "Año",
get_kpi_working_capital_ratio2(1000000, 1000002, date_part('YEAR'::text, now()::timestamp) - 0, 'A') as "Working Capital Ratio2"

ORDER BY 1