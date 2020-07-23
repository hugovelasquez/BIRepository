-- Funcion para calcular el margen de ganancia en % con 2 decimales a una línea de factura.
-- No existe en estándar Adempiere
-- Function: gettransactionmarge(numeric)

-- DROP FUNCTION gettransactionmarge(numeric);

CREATE OR REPLACE FUNCTION gettransactionmarge(p_c_invoiceline_id numeric)
  RETURNS numeric AS
$BODY$

DECLARE
	v_Cost			NUMERIC;
	v_linenetamt	NUMERIC;
	v_Marge 		NUMERIC;
BEGIN
    v_Cost       = 0.0;
    v_linenetamt = 0.0;
    v_Marge      = 0.0;

    SELECT getTransactionCost(C_Invoiceline_ID), linenetAmt INTO v_Cost, v_linenetamt
    FROM c_Invoiceline ivl 
    WHERE ivl.c_INvoiceline_ID = p_C_InvoiceLine_ID;

    IF (v_linenetamt = 0) THEN RETURN v_Marge; END IF;
    IF (v_Cost       = 0) THEN RETURN v_Marge; END IF;

    v_Marge = (v_linenetamt - v_Cost)/v_linenetamt;
	RETURN round(coalesce(v_Marge, 0) * 100, 2);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gettransactionmarge(numeric)
  OWNER TO adempiere;
