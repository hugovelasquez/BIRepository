SELECT ord.dateordered, count(ord.C_Order_ID) 
FROM C_Order ord
WHERE  ord.dateordered >= (Current_Date- {{Dias_previos}} )
AND ord.issotrx = 'N' 
AND ord.docstatus IN ('CO') 
AND ord.AD_Client_ID = 1000000
GROUP BY ord.dateordered 
ORDER BY ord.dateordered