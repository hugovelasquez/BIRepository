SELECT ild.salesrepname as "Vendedor", sum(ild.linenetamtreal) as "Facturado", sum(ild.transactioncost) as "Costo", sum(marge_abs) as "Margen (monto)"
FROM rv_invoiceline_detail ild
WHERE ild.dateinvoiced BETWEEN {{Fecha_inicio}} AND {{Fecha_final}}
AND AD_Client_ID = 1000000 
AND issotrx = 'Y'
AND docstatus in ('CO') 
AND docbasetype = 'ARI' 
AND producttype = 'I' 
GROUP BY ild.salesrepname
ORDER BY sum(ild.linenetamtreal) desc
LIMIT  {{CantidadDeVendedores}}