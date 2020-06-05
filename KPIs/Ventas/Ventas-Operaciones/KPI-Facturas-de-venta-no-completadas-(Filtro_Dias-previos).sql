-- Nombre: KPI - Facturas de venta no completadas

-- Descripción:
-- Facturas creadas pero sin completar la facturacion, por día
SELECT dateinvoiced, count(*)
FROM C_Invoice
WHERE dateinvoiced >= Current_Date- {{Dias_previos}}
AND issotrx = 'Y' 
AND docstatus IN ('DR','IP','IV')
AND AD_Client_ID = 1000000
GROUP BY dateinvoiced
ORDER BY dateinvoiced ASC