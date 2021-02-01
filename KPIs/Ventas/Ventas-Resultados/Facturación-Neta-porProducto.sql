SELECT ild.productname as "Producto", sum(ild.linenetamtreal) as "Facturado", abs(sum(linenetamtvoided)) as "Anulaciones", sum(ild.linenetamtreturned) as "Devoluciones", sum(ild.netsales) as "Venta Neta" 
FROM rv_invoiceline_detail ild
WHERE ild.dateinvoiced BETWEEN {{Fecha_inicio}} AND {{Fecha_final}}
AND AD_Client_ID = 1000000 
AND issotrx = 'Y'
AND docstatus in ('CO','VO') 
AND docbasetype = 'ARI' 
AND producttype = 'I'
GROUP BY ild.productname
ORDER BY sum(ild.linenetamtreal) desc
LIMIT  {{CantidadDeProductos}}
