SELECT ild.salesrepname as "Vendedor", ild.pcatname as "Linea", sum(ild.netsales) as "Venta Neta"
FROM rv_invoiceline_detail ild
WHERE ild.dateinvoiced BETWEEN {{Fecha_inicio}} AND {{Fecha_final}}
AND AD_Client_ID = 1000000 
AND issotrx = 'Y'
AND docstatus in ('CO','VO') 
AND docbasetype = 'ARI' 
AND producttype = 'I'
GROUP BY ild.salesrepname, ild.pcatname
ORDER BY ild.salesrepname ASC, ild.pcatname ASC