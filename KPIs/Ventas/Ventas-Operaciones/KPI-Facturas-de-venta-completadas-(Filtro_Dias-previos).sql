-- Nombre: KPI - Facturas de venta completadas

-- Descripción:
-- Facturas de venta completadas por día
SELECT inv.dateinvoiced , count(inv.C_Invoice_ID) 
FROM C_Invoice inv
WHERE inv.dateinvoiced >= (Current_Date- {{Dias_previos}} )
AND inv.IsSoTrx='Y' 
AND inv.docstatus in ('CO')
AND inv.AD_Client_ID = 1000000
GROUP BY inv.dateinvoiced 
ORDER BY inv.dateinvoiced