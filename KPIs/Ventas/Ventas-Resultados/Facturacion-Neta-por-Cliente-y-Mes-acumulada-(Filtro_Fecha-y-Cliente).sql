-- Nombre: Facturación Neta por Cliente y Mes acumulada

-- Descripción:
-- Venta Neta acumulada por Cliente y Mes: a cada mes se le suman los meses anteriores.
-- Monto facturado: con impuestos extrahídos, no incluidas anulaciones ni devoluciones.
-- Venta neta = Monto Facturado - Devoluciones - Anulaciones.
-- Filtro: rango de fechas, Cliente.
-- Filtro obligatorio:  rango de fechas, Cliente.
SELECT dateinvoicedmonth AS "Mes", 
sum(linenetamtreal) AS "Facturado", 
sum(sum(linenetamtreal)) OVER (ORDER BY dateinvoicedmonth ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS "Facturado acumulado",

abs(sum(linenetamtvoided)) AS "Anulaciones", 
sum(abs(sum(linenetamtvoided))) OVER (ORDER BY dateinvoicedmonth ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS "Anulaciones acumulado",

sum(linenetamtreturned) AS "Devoluciones",
sum(sum(linenetamtreturned)) OVER (ORDER BY dateinvoicedmonth ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS "Devoluciones acumulado",

sum(netsales) AS "Venta Neta",
sum(sum(netsales)) OVER (ORDER BY dateinvoicedmonth ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS "Venta Neta  acumulado"
, customername as "Cliente"

FROM rv_invoiceline_detail  
WHERE dateinvoiced BETWEEN {{Fecha_inicio}} AND {{Fecha_final}}
AND AD_Client_ID = 1000000 
AND issotrx = 'Y'
AND docstatus in ('CO','VO') 
AND docbasetype = 'ARI' 
AND producttype = 'I'
[[AND {{NombreCliente}}]]


GROUP BY dateinvoicedmonth, customername
ORDER BY dateinvoicedmonth ASC