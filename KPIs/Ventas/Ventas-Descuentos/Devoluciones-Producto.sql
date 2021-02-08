-- Devoluciones por Producto

SELECT ild.productvalue as "Producto", 
sum(ild.linenetamtreturned) as "Devoluciones"
FROM rv_invoiceline_detail ild
WHERE ild.dateinvoiced BETWEEN {{Fecha_inicio}} AND {{Fecha_final}}
AND AD_Client_ID = 1000000 
AND issotrx = 'Y'
AND docstatus in ('CO','CL') 
AND docbasetype = 'ARI' 
GROUP BY ild.productvalue
ORDER BY sum(ild.linenetamtreturned) desc
LIMIT  {{CantidadDeProductos}}
