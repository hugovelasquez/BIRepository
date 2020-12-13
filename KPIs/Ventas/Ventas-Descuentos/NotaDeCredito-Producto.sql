-- Notas de Credito por Producto

-- Zurzeit haben "Descuentos" C_Charge_ID besetzt; 
-- deswegen wird diese SQL null für Produkte ausgeben.
-- Solange die Charge verwendet wird, werden die Produkte "null" liefern.

SELECT ild.productname as "Producto", 
-- linenetamtdiscounts beinhaltet bereits ARC (Credit Memo)
-- C_Charge_ID=5000016 ist für Descuentos

sum(ild.linenetamtdiscounts) as "Nota de Crédto"
FROM rv_invoiceline_detail ild
WHERE ild.dateinvoiced BETWEEN {{Fecha_inicio}} AND {{Fecha_final}}
AND ild.C_Charge_ID=5000016 
AND AD_Client_ID = 1000000 
AND issotrx = 'Y'
AND docstatus in ('CO','CL') 
GROUP BY ild.productname
ORDER BY sum(ild.linenetamtdiscounts) desc
LIMIT  {{CantidadDeProductos}}
