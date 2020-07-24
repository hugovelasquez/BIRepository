-- Funcion para calcular costo de compra del producto de una línea de factura.
-- Si existen varias transacciones, se selecciona la primera
-- No existe en estándar Adempiere
-- Function: gettransactionpurchaseprice(numeric)

-- DROP FUNCTION gettransactionpurchaseprice(numeric);

CREATE OR REPLACE FUNCTION gettransactionpurchaseprice(p_c_invoiceline_id numeric)
  RETURNS numeric AS
$BODY$

DECLARE
	v_purchase_price				NUMERIC;
BEGIN
    SELECT coalesce(cd.currentcostprice, 0) + coalesce(cd.costadjustment, 0) INTO v_purchase_price
    FROM C_Invoiceline il
    INNER JOIN C_Invoice i ON (il.C_Invoice_ID=i.C_Invoice_ID AND p_c_invoiceline_id=il.C_Invoiceline_ID)
    INNER JOIN M_Transaction t ON (il.M_Product_ID=t.M_Product_ID )
    INNER JOIN M_Costdetail cd ON (t.M_Transaction_ID=cd.M_Transaction_ID )
    WHERE t.movementtype = 'V+'
    AND t.movementdate <= i.dateinvoiced 
    AND cd.c_landedcostallocation_id IS NULL 
    AND cd.m_matchinv_id IS NULL 
    ORDER BY t.movementdate DESC
    LIMIT 1;

	RETURN round(v_purchase_price, 4);
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gettransactionpurchaseprice(numeric)
  OWNER TO adempiere;
