-- Nombre: KPI - Ordenes de Almacen no entregadas

-- Descripción:
-- Ordenes de Almacen procesadas por día, pero no entregadas.
SELECT shipdate , count(WM_InoutBound_ID) 
FROM WM_InoutBound iob
WHERE iob.shipdate >= (Current_Date- {{Dias_previos}} )
AND iob.IsSOTrx='Y' 
AND iob.Processed='Y'
AND iob.AD_Client_ID = 1000000
AND iob.wm_InoutBound_ID IN  (
    SELECT distinct iobl.wm_Inoutbound_ID
	FROM WM_InoutBoundLine iobl
	INNER JOIN C_OrderLine ol ON (ol.C_OrderLine_ID= iobl.C_OrderLine_ID)
	LEFT JOIN m_InoutLine iol ON (iol.C_OrderLine_ID = iobl.C_OrderLine_ID)
	WHERE iob.WM_InoutBound_ID=iobl.WM_InoutBound_ID
    AND ol.QtyOrdered <> ol.QtyDelivered
	AND coalesce(iobl.PickedQty,0) < coalesce(iol.MovementQty,0)
                            )
GROUP BY iob.shipdate 
ORDER BY iob.shipdate