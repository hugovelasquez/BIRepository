-- Nombre: KPI - Seleccion de Pagos no completados

-- Descripción:
-- Seleccion de Pagos no completados (en estado "Borrador", "En Proceso" o "Inválido"
SELECT ps.paydate, count(ps.C_PaySelection_ID) 
FROM C_PaySelection ps
WHERE  ps.paydate >= (Current_Date - {{Dias_previos}} )
AND ps.docstatus in ('DR','IP','IV')
AND ps.AD_Client_ID = 1000000
GROUP BY ps.paydate 
ORDER BY ps.paydate