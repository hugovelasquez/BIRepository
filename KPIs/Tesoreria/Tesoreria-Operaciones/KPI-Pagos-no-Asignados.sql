SELECT p.datetrx, count(p.C_Payment_ID) 
FROM C_Payment p
WHERE  p.datetrx >= (Current_Date - {{Dias_previos}} )
AND p.docstatus IN ('CO','CL') 
AND p.isallocated = 'N' 
AND p.isreceipt = 'N'
AND p.AD_Client_ID = 1000000
GROUP BY p.datetrx 
ORDER BY p.datetrx