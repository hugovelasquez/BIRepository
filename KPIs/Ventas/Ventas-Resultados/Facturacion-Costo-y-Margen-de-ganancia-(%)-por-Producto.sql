SELECT ild.productname as "Producto", sum(ild.linenetamtreal) as "Facturado", sum(ild.transactioncost) as "Costo", 
CASE 
      WHEN sum(ild.linenetamtreal) = 0 THEN 0
      ELSE round(( (sum(ild.linenetamtreal) - sum(ild.transactioncost))/sum(ild.linenetamtreal))*100,2) 
END  as "Margen (%)"
FROM rv_invoiceline_detail ild
WHERE ild.dateinvoiced BETWEEN {{Fecha_inicio}} AND {{Fecha_final}}
AND AD_Client_ID = 1000000 
AND issotrx = 'Y'
AND docstatus in ('CO') 
AND docbasetype = 'ARI' 
AND producttype = 'I' 
GROUP BY ild.productname
ORDER BY sum(ild.linenetamtreal) desc
LIMIT  {{CantidadDeProductos}}
