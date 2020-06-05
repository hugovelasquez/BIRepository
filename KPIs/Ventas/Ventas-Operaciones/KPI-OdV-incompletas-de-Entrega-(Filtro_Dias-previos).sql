SELECT ord.dateordered , count(C_Order_ID) 
FROM C_Order ord
WHERE 
ord.dateordered >= (Current_Date- {{Dias_previos}} )
AND C_Order_ID IN (
    SELECT distinct c_Order_ID 
    FROM rv_orderdetail
    WHERE rv_orderdetail.dateordered >= TO_DATE('2020/01/01','yyyy/MM/dd')  
    AND rv_orderdetail.qtyordered > rv_orderdetail.qtydelivered 
    AND rv_orderdetail.docstatus IN ('CO') 
    AND rv_orderdetail.issotrx='Y'
                  )
AND ord.AD_Client_ID = 1000000
GROUP BY ord.dateordered 
ORDER BY ord.dateordered