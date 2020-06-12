-- material marge amount for a given invoiceline
-- formula: linenetamt-cost

-- Function: gettransactionmarge_abs(numeric)

-- DROP FUNCTION gettransactionmarge_abs(numeric);

CREATE OR REPLACE FUNCTION gettransactionmarge_abs(p_c_invoiceline_id numeric)
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
    SELECT getTransactionCost(C_Invoiceline_ID), linenetamtrealinvoiceline(C_Invoiceline_ID) INTO v_Cost, v_linenetamt
    FROM c_Invoiceline ivl 
    WHERE ivl.c_INvoiceline_ID = p_C_InvoiceLine_ID;

    IF (v_Cost = 0) THEN  RETURN v_Marge; END IF;

    v_Marge = (v_linenetamt - v_Cost);
	RETURN round(v_Marge, 5);
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gettransactionmarge_abs(numeric)
  OWNER TO adempiere;
