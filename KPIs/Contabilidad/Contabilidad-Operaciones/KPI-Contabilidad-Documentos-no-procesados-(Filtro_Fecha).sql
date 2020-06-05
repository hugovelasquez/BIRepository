-- Nombre: KPI - Contabilidad Documentos no procesados

-- Descripción:
-- Documentos no procesados
SELECT  
CASE 
      WHEN t.AD_Table_ID=224 THEN 'Asiento Contable'
      WHEN t.AD_Table_ID=259 AND u.isSOTrx='Y'  THEN 'Orden de Ventas'
      WHEN t.AD_Table_ID=259 AND u.isSOTrx='N'  THEN 'Orden de Compras'
      WHEN t.AD_Table_ID=318 AND u.isSOTrx='Y'  THEN 'Factura de Ventas'
      WHEN t.AD_Table_ID=318 AND u.isSOTrx='N'  THEN 'Factura de Compras'
      WHEN t.AD_Table_ID=319 AND u.isSOTrx='Y'  THEN 'Entrega de Material'
      WHEN t.AD_Table_ID=319 AND u.isSOTrx='N'  THEN 'Recibo de Material'
      WHEN t.AD_Table_ID=321 THEN 'Inventario Fisico'
      WHEN t.AD_Table_ID=323 THEN 'Traslado de Inventario'
      WHEN t.AD_Table_ID=325 THEN 'Produccion'
      WHEN t.AD_Table_ID=335 THEN 'Pago/Cobro'
      WHEN t.AD_Table_ID=392 THEN 'Conciliacion Bancaria'
      WHEN t.AD_Table_ID=472 THEN 'Asignacion Recibo-Factura'
      WHEN t.AD_Table_ID=473 THEN 'Asignacion Recibo.OdC'
      WHEN t.AD_Table_ID=623 THEN 'Salida Inventario (Proyecto)'
      WHEN t.AD_Table_ID=702 THEN 'Requisicion de Material'
      WHEN t.AD_Table_ID=735 THEN 'Asignaci�n Pago/Cobro'
      WHEN t.AD_Table_ID=53092 THEN 'N�mina/Planilla'
      ELSE ttrl.name
END as "Documento", count(*) AS "Cantidad no procesados"
FROM rv_unposted u
INNER JOIN AD_Table t ON (u.AD_Table_ID = t.AD_Table_ID)
INNER JOIN  AD_Table_Trl ttrl ON (t.AD_Table_ID = ttrl.AD_Table_ID AND AD_LAnguage = 'es_SV')
WHERE u.dateacct BETWEEN {{Fecha_inicio}} AND {{Fecha_final}}
AND u.processed = 'N'
AND u.AD_Client_ID = 1000000
GROUP BY ttrl.name, issotrx, t.AD_Table_ID
ORDER BY ttrl.name