SELECT ord.dateordered , count(ord.C_Order_ID) 
FROM C_Order ord
WHERE  ord.dateordered >= (Current_Date- {{Dias_previos}} )
AND ord.C_Order_ID in (
    SELECT DISTINCT c_Order_ID 
    FROM rv_orderdetail
    WHERE dateordered >= TO_DATE('2020/01/01','yyyy/MM/dd')  
    AND qtyordered > rv_orderdetail.qtydelivered 
    AND docstatus IN ('CO') 
    AND issotrx='N')
AND ord.AD_Client_ID = 1000000
GROUP BY ord.dateordered 
ORDER BY ord.dateordered