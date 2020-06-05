-- Nombre: KPI - OdV erróneas

-- Descripción:
-- OdV erróneas por día.
-- Posibles errores: período cerrado, mal almacén, no líneas , límite de crédito excedido, termino de pago excedido, etc.
SELECT ord.dateordered , count(ord.C_Order_ID) 
FROM C_Order ord
WHERE  ord.dateordered >= (Current_Date- {{Dias_previos}} )
AND ord.isSOTrx='Y'
AND (  ord.DocStatus in ('IN') 
        OR 
       (ord.docstatus_rejectstatus = 'CL' and processed = 'N') 
    ) 
AND EXISTS(
    SELECT 1 
    FROM C_DocType dt 
    WHERE dt.C_DocType_ID = ord.C_DocTypeTarget_ID 
    AND dt.DocBaseType = 'SOO' 
    AND (dt.DocSubTypeSO IS NULL OR dt.DocSubTypeSO <> 'RM')
            )
AND ord.AD_Client_ID = 1000000
GROUP BY ord.dateordered 
ORDER BY ord.dateordered