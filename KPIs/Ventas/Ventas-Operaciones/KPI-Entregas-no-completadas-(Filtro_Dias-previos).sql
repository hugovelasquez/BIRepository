-- Nombre: KPI - Entregas no Completadas

-- Descripción:
-- Entregas no Completadas (= estado "Borrador", "En Proceso" o "Invalido")
SELECT movementdate , count(*) 
FROM  M_InOut
WHERE movementdate  >=  Current_Date- {{Dias_previos}} 
AND issotrx = 'Y' 
AND m_Inout.docstatus IN ('DR','IP','IN') 
AND movementtype='C-'
AND AD_Client_ID=1000000
GROUP BY movementdate 
ORDER BY movementdate