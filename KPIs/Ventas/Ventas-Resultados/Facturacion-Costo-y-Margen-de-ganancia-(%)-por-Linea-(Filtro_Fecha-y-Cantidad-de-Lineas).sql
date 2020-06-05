-- Nombre: Facturación, Costo y Margen de ganancia (%) por Línea

-- Descripción:
-- Venta bruta=Monto facturado: con impuestos extrahídos, no incluidas anulaciones ni devoluciones.
-- Margen de ganancia en %  = (Monto Facturado - Costos) / Monto Facturado.
-- El margen de ganancia no incluye devoluciones ni anulaciones.
-- Si hay una cantidad considerable de devoluciones y anulaciones, éste dato no concuerda con la realidad.
-- Filtro:  rango de fechas y Límite de cantidad de Líneas desplegadas.
-- Filtro obligatorio:  rango de fechas y Límite de cantidad de Líneas desplegadas.
SELECT ild.pcatname as "L�nea", sum(ild.linenetamtreal) as "Facturado", sum(ild.transactioncost) as "Costo", 
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
GROUP BY ild.pcatname
ORDER BY sum(ild.linenetamtreal) desc
LIMIT  {{CantidadDeLineas}}