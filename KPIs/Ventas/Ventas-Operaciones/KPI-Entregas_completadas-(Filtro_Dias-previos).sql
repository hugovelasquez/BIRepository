SELECT movementdate , count(*) 
FROM  M_InOut
WHERE movementdate >= current_date - {{Dias_previos}} 
AND IsSoTrx='Y' 
AND docstatus in ('CO') 
AND movementtype='C-'
AND AD_Client_ID = 1000000
GROUP BY movementdate 
ORDER BY movementdate