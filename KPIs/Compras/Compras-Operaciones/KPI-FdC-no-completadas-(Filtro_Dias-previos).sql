-- Nombre: KPI - FdC no completada

-- Descripción:
-- Facturas de Compra no completadas (por estar en borrador, en proceso o inválidas)
SELECT inv.dateinvoiced , count(inv.C_Invoice_ID) 
FROM C_Invoice inv
WHERE inv.dateinvoiced >= (Current_Date- {{Dias_previos}} )
AND inv.AD_Client_ID = 1000000
AND inv.docstatus in ('DR','IP','IV') 
AND inv.issotrx='N'
GROUP BY inv.dateinvoiced 
ORDER BY inv.dateinvoiced