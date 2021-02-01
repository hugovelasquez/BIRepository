-- Notas de Credito por mes

SELECT ild.dateinvoicedmonth as "Mes", 
-- linenetamtdiscounts beinhaltet bereits ARC (Credit Memo)
-- C_Charge_ID=5000016 ist für Descuentos

sum(ild.linenetamtdiscounts) as "Nota de Crédto"
FROM rv_invoiceline_detail ild
WHERE ild.dateinvoiced BETWEEN {{Fecha_inicio}} AND {{Fecha_final}}
AND ild.C_Charge_ID=5000016 
AND AD_Client_ID = 1000000 
AND issotrx = 'Y'
AND docstatus in ('CO','CL') 
GROUP BY ild.dateinvoicedmonth
ORDER BY ild.dateinvoicedmonth asc
LIMIT  {{CantidadDeMeses}}
