SELECT ord.dateordered, count(ord.C_Order_ID) 
FROM C_Order ord
WHERE  ord.dateordered >= (Current_Date- {{Dias_previos}} )
AND C_Order_ID IN (
    SELECT DISTINCT c_Order_ID 
    FROM rv_orderdetail rvo
    WHERE rvo.dateordered >= TO_DATE('2020/01/01','yyyy/MM/dd')  
    AND rvo.qtyordered > rvo.qtyinvoiced 
    AND rvo.docstatus IN ('CO') 
    AND rvo.issotrx='N'
                  )
AND ord.AD_Client_ID = 1000000
GROUP BY ord.dateordered 
ORDER BY ord.dateordered