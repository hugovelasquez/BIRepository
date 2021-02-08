-- Ventas bajo precio límite por Mes

-- Das hat nur dann Sinn, wenn die Preislisten richtig eingestellt sind
SELECT ild.dateinvoicedmonth as "Mes", 
sum(ild.linenetamtunderpricelimit) as "Ventas bajo Precio Límite"
FROM rv_invoiceline_detail ild
WHERE ild.dateinvoiced BETWEEN {{Fecha_inicio}} AND {{Fecha_final}}
AND AD_Client_ID = 1000000 
AND issotrx = 'Y'
AND docstatus in ('CO','CL') 
AND docbasetype = 'ARI' 
GROUP BY ild.dateinvoicedmonth
ORDER BY ild.dateinvoicedmonth asc
LIMIT  {{CantidadDeMeses}}
