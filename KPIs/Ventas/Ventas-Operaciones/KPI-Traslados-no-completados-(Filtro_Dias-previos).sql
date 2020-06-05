-- Nombre: KPI - Traslados no completados

-- Descripción:
-- Número de traslados no completados por día.
SELECT movementdate, count(*)
FROM m_movement
WHERE movementdate  >= (Current_Date- {{Dias_previos}} )
AND docstatus IN ('DR','IP','IV')
AND AD_Client_ID = 1000000
GROUP BY movementdate
ORDER BY movementdate