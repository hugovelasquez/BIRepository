-- KPI- Interest Gearing2 
SELECT 
to_char(date_part('YEAR'::text, now()::timestamp) - 4, '9999') as "Año",
get_kpi_interest_gearing2(1000000, 1000002, date_part('YEAR'::text, now()::timestamp) - 4, 'A') as "Interest Gearing2 (%)"

UNION
SELECT 
to_char(date_part('YEAR'::text, now()::timestamp) - 3, '9999') as "Año",
get_kpi_interest_gearing2(1000000, 1000002, date_part('YEAR'::text, now()::timestamp) - 3, 'A') as "Interest Gearing2 (%)"

UNION
SELECT 
to_char(date_part('YEAR'::text, now()::timestamp) - 2, '9999') as "Año",
get_kpi_interest_gearing2(1000000, 1000002, date_part('YEAR'::text, now()::timestamp) - 2, 'A') as "Interest Gearing2 (%)"

UNION
SELECT 
to_char(date_part('YEAR'::text, now()::timestamp) - 1, '9999') as "Año",
get_kpi_interest_gearing2(1000000, 1000002, date_part('YEAR'::text, now()::timestamp) - 1, 'A') as "Interest Gearing2 (%)"

UNION
SELECT 
to_char(date_part('YEAR'::text, now()::timestamp) - 0, '9999') as "Año",
get_kpi_interest_gearing2(1000000, 1000002, date_part('YEAR'::text, now()::timestamp) - 0, 'A') as "Interest Gearing2 (%)"

ORDER BY 1