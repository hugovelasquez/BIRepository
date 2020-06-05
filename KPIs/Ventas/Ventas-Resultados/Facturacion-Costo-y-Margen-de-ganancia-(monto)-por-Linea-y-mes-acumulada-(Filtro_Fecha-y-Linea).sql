-- Nombre: Facturación, Costo y Margen de ganancia (monto) por Línea y mes acumulada

-- Descripción:
--Venta bruta, costos y margen de ganancia monto por Línea.
--A cada mes se le suman los meses anteriores.
--Venta bruta=Monto facturado: con impuestos extrahídos, no incluidas anulaciones ni devoluciones.
--Margen de ganancia = Monto Facturado - Costos
--El margen de ganancia no incluye devoluciones ni anulaciones.
--Si hay una cantidad considerable de devoluciones y anulaciones, éste dato no concuerda con la realidad.
--Filtro:  rango de fechas y  Línea.
--Filtro obligatorio:  rango de fechas y  Línea.
SELECT dateinvoicedmonth AS "Mes", pcatname as "Línea", 
sum(linenetamtreal) AS "Facturado", 
sum(sum(linenetamtreal)) OVER (ORDER BY dateinvoicedmonth ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS "Facturado acumulado",

sum(transactioncost) AS "Costo",
sum(sum(transactioncost)) OVER (ORDER BY dateinvoicedmonth ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS "Costo acumulado",

sum(linenetamtreal) - sum(transactioncost) as "Margen (monto)",
sum(sum(linenetamtreal) - sum(transactioncost))   OVER (ORDER BY dateinvoicedmonth ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS "Margen (monto) acumulado"

FROM rv_invoiceline_detail
WHERE dateinvoiced BETWEEN {{Fecha_inicio}} AND {{Fecha_final}}
AND AD_Client_ID = 1000000 
AND issotrx = 'Y'
AND docstatus in ('CO') 
AND docbasetype = 'ARI' 
AND producttype = 'I'
AND {{Linea}}
GROUP BY dateinvoicedmonth, pcatname
ORDER BY sum(linenetamtreal) desc