-- Nombre: KPI - Pagos planeados no pagados

-- Descripción:
-- Seleccion de pagos no pagadas
SELECT ps.paydate, count(ps.C_PaySelection_ID) 
FROM C_PaySelection ps
WHERE  ps.paydate >= (Current_Date - {{Dias_previos}} )
AND ps.c_Bankaccount_ID IS NULL 
and ps.docstatus IN ('CO','CL')
AND EXISTS(
    SELECT 1 FROM C_PaySelectionline psl 
	LEFT JOIN C_Payselectionline pslp ON (psl.c_Payselectionline_ID = pslp.c_payselectionline_parent_id) 
	LEFT JOIN C_Payselection psp ON (pslp.c_Payselection_ID=psp.c_Payselection_ID)
	WHERE psl.C_PaySelection_ID = ps.C_PaySelection_ID 
	AND (pslp.c_payselectionline_parent_id IS NULL OR psp.DocStatus NOT IN('CO', 'CL'))
        )
AND ps.AD_Client_ID = 1000000
GROUP BY ps.paydate 
ORDER BY ps.paydate