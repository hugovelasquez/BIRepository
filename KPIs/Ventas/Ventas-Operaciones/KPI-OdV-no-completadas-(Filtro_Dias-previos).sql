-- Nombre: KPI - OdV no completadas

-- Descripción:
-- Ordenes de Venta no completadas por día.
SELECT ord.dateordered , count(C_Order_ID) 
FROM C_Order ord
WHERE ord.dateordered >= (Current_Date- {{Dias_previos}} )
AND ord.issotrx = 'Y' 
AND ord.docstatus in ('DR','IP','IV') 
AND EXISTS(
    SELECT 1 
    FROM C_DocType dt 
    WHERE dt.C_DocType_ID = ord.C_DocTypeTarget_ID 
    AND dt.DocBaseType = 'SOO' AND (dt.DocSubTypeSO IS NULL OR dt.DocSubTypeSO <> 'RM')
            )
AND ord.AD_Client_ID = 1000000
GROUP BY ord.dateordered 
ORDER BY ord.dateordered