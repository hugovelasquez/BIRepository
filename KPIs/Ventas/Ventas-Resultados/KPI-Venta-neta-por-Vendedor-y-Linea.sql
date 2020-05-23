SELECT ild.salesrepname as "Vendedor", ild.pcatname as "Linea", sum(ild.netsales) as "Venta Neta"
FROM rv_invoiceline_detail ild
WHERE ild.dateinvoiced BETWEEN {{Fecha_inicio}} AND {{Fecha_final}}
GROUP BY ild.salesrepname, ild.pcatname
ORDER BY sum(ild.linenetamtreal) desc
LIMIT  {{Limite}}