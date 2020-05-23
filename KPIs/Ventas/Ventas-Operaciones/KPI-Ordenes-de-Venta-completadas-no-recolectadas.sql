SELECT  ord.dateordered , count(C_Order_ID) 
FROM C_Order ord
WHERE
ord.dateordered >= (Current_Date- {{Dias_previos}} )
AND C_Order_ID IN ( 
    SELECT DISTINCT ol.c_Order_ID from c_Orderline ol
    INNER JOIN c_Order o on ol.c_Order_ID=o.c_Order_ID
    WHERE o.IsSOTrx = 'Y'
    AND EXISTS( SELECT 1 
                FROM C_DocType dt 
                WHERE dt.C_DocType_ID = o.C_DocTypeTarget_ID 
                AND dt.DocBaseType = 'SOO' 
                AND (dt.DocSubTypeSO IS NULL OR dt.DocSubTypeSO <> 'RM')
                ) 
    AND o.DocStatus = 'CO'
    AND COALESCE(ol.QtyOrdered, 0) - COALESCE(ol.QtyDelivered, 0) <> 0
    AND o.DocStatus = 'CO'
    AND COALESCE(ol.QtyOrdered, 0) - COALESCE(ol.QtyDelivered, 0) <> 0    
    AND NOT EXISTS (    SELECT 1
                        FROM WM_InOutBoundLine iobl
                        INNER JOIN WM_InOutBound iob ON (iobl.WM_InOutBound_ID = iob.WM_InOutBound_ID)
                        WHERE iob.DocStatus NOT IN ('CL', 'VO')
                        AND iobl.C_OrderLine_ID = ol.C_OrderLine_ID
                        AND COALESCE(ol.QtyOrdered, 0) - COALESCE(ol.QtyDelivered, 0) <> 0
                    )
    )
AND ord.AD_Client_ID = 1000000
    
GROUP BY ord.dateordered 
ORDER BY ord.dateordered