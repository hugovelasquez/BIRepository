-- Nombre: Facturación Neta por Vendedores

-- Descripción:
-- Venta Neta por Vendedor.
-- Monto facturado: con impuestos extrahídos, no incluidas anulaciones ni devoluciones.
-- Venta neta = Monto Facturado - Devoluciones - Anulaciones.
-- Filtro: rango de fechas y cantidad de vendedores desplegados.
-- Filtro obligatorio: rango de fechas y  cantidad de vendedores desplegados.
SELECT ild.salesrepname as "Vendedor", sum(ild.linenetamtreal) as "Facturado", abs(sum(linenetamtvoided)) as "Anulaciones", sum(ild.linenetamtreturned) as "Devoluciones", sum(ild.netsales) as "Venta Neta" 
FROM rv_invoiceline_detail ild
WHERE ild.dateinvoiced BETWEEN {{Fecha_inicio}} AND {{Fecha_final}}
AND AD_Client_ID = 1000000 
AND issotrx = 'Y'
AND docstatus in ('CO','VO') 
AND docbasetype = 'ARI' 
AND producttype = 'I'
GROUP BY ild.salesrepname
ORDER BY sum(ild.linenetamtreal) desc
LIMIT  {{CantidadDeVendedores}}