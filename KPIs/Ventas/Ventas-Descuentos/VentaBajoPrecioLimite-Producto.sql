-- Ventas bajo precio límite por Producto

-- Das hat nur dann Sinn, wenn die Preislisten richtig eingestellt sind
SELECT  ild.productname as "Producto", 
sum(ild.linenetamtunderpricelimit) as "Ventas bajo Precio Límite"
FROM rv_invoiceline_detail ild
WHERE ild.dateinvoiced BETWEEN {{Fecha_inicio}} AND {{Fecha_final}}
AND AD_Client_ID = 1000000 
AND issotrx = 'Y'
AND docstatus in ('CO','CL') 
AND docbasetype = 'ARI' 
GROUP BY ild.productname
ORDER BY sum(ild.linenetamtunderpricelimit) desc
LIMIT  {{CantidadDeProductos}}
