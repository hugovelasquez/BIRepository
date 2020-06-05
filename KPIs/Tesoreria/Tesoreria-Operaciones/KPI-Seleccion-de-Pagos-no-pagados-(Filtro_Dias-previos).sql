-- Nombre: KPI - Seleccion de Pagos no pagados

-- Descripción:
--  Seleccion de Pagos completados, pero no pagados
SELECT ps.paydate, count(ps.C_PaySelection_ID) 
FROM C_PaySelection ps
WHERE  ps.paydate >= (Current_Date - {{Dias_previos}} )

AND  ps.DocStatus = 'CO' 
AND ps.C_BankAccount_ID IS NOT NULL 
AND EXISTS(
    SELECT 1 
    FROM C_PaySelectionCheck psc 
	LEFT JOIN C_Payment p ON (p.C_Payment_ID = psc.C_Payment_ID) 
	WHERE psc.C_PaySelection_ID = ps.C_PaySelection_ID 
	AND (psc.C_Payment_ID IS NULL OR p.DocStatus NOT IN('CO', 'CL'))
        )
AND ps.AD_Client_ID = 1000000
GROUP BY ps.paydate 
ORDER BY ps.paydate