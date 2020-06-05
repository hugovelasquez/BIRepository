-- Nombre: KPI - Recibos no completados

-- Descripción:
- Recibos no completados (en estados diferentes a completado o anulado)
SELECT movementdate, count(*)
FROM M_Inout
WHERE movementdate >= TO_DATE('2020/01/01','yyyy/MM/dd') 
AND issotrx = 'N' 
AND docstatus IN ('DR','IP','IV')
AND AD_Client_ID = 1000000
GROUP BY movementdate
ORDER BY movementdate




