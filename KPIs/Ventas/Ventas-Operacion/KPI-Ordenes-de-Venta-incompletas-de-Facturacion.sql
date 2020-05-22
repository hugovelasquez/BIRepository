SELECT ord.dateordered , count(ord.C_Order_ID) 
FROM C_Order ord
WHERE  ord.dateordered >= (Current_Date- {{Dias_previos}} )
AND ord.C_Order_ID IN (
    SELECT distinct c_Order_ID from rv_orderdetail
    WHERE qtyordered > qtyinvoiced 
    AND docstatus IN ('CO') 
    AND issotrx='Y'
    AND AD_Client_ID = 1000000)
GROUP BY ord.dateordered 
ORDER BY ord.dateordered