SELECT shipdate , count(*) 
FROM WM_InOutBound
WHERE shipdate >= (Current_Date- {{Dias_previos}} )
AND IsSOTrx='Y' 
AND processed = 'N'
AND AD_Client_ID = 1000000
GROUP BY shipdate 
ORDER BY shipdate