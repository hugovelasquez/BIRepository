-- Nombre: KPI - Gastos de Retaceo no distribuidos

-- Descripción:
-- Gastos de Retaceo no distribuidos: Facturas de retaceo que no han sido distruibuidas
-- Modificar C_Charge_ID dependiendo de empresa!
SELECT inv.dateinvoiced , count(inv.C_Invoice_ID) 
FROM C_Invoice inv
WHERE inv.dateinvoiced >= (Current_Date- {{Dias_previos}} )
AND inv.IsSoTrx='N' 
AND inv.docstatus IN ('CO')
AND inv.AD_Client_ID = 1000000
AND inv.c_Invoice_ID IN (
    SELECT ivl.C_Invoice_ID FROM c_Invoiceline ivl
	LEFT JOIN c_Landedcostallocation lca ON ivl.c_Invoiceline_ID=lca.c_Invoiceline_ID
	where ivl.m_Product_ID IS NULL AND ivl.c_Charge_ID <> 5000001 
	AND lca.c_Invoiceline_ID IS NULL AND ivl.user4_ID IS NOT NULL
                        )
GROUP BY inv.dateinvoiced 
ORDER BY inv.dateinvoiced