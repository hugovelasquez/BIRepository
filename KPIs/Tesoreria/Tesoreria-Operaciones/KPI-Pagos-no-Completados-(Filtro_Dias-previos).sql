-- Nombre: KPI - Pagos no Completados

-- Descripción:
-- Pagos no completados; no incluye cajas
SELECT p.datetrx, count(p.C_Payment_ID) 
FROM C_Payment p
WHERE  p.datetrx >= (Current_Date - {{Dias_previos}} )
AND p.docstatus in ('DR','IP','IV') and p.isreceipt = 'N'
AND p.C_BPartner_ID IS NOT NULL 
AND EXISTS(SELECT 1 
           FROM C_BankAccount ba 
           INNER JOIN C_Bank b ON(b.C_Bank_ID = ba.C_Bank_ID) 
           WHERE ba.C_BankAccount_ID = p.C_BankAccount_ID 
           AND b.BankType = 'B')
AND p.AD_Client_ID = 1000000
GROUP BY p.datetrx 
ORDER BY p.datetrx