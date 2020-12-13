-- Devoluciones por mes

SELECT ild.dateinvoicedmonth as "Mes", sum(ild.linenetamtreturned) as "Devoluciones"
FROM rv_invoiceline_detail ild
WHERE ild.dateinvoiced BETWEEN {{Fecha_inicio}} AND {{Fecha_final}}
AND ild.AD_Client_ID = 1000000 
AND ild.issotrx = 'Y'
AND ild.docstatus in ('CO','VO') 
AND ild.docbasetype = 'ARI' 
GROUP BY ild.dateinvoicedmonth
ORDER BY ild.dateinvoicedmonth asc
LIMIT  {{CantidadDeMeses}}
