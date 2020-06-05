-- material marge amount for a given invoiceline
-- formula: linenetamt-cost

-- Function: gettransactionmarge_abs(numeric)

-- DROP FUNCTION gettransactionmarge_abs(numeric);

CREATE OR REPLACE FUNCTION gettransactionmarge_abs(p_c_invoiceline_id numeric)
  RETURNS numeric AS
$BODY$

DECLARE

	v_Cost						NUMERIC;

	v_linenetamt				NUMERIC;

	v_Marge 					NUMERIC;

BEGIN

		v_Marge = 0.0;

		select getTransactionCost(C_Invoiceline_ID), linenetamtrealinvoiceline(C_Invoiceline_ID) INTO v_Cost, v_linenetamt

from c_Invoiceline ivl 
where ivl.c_INvoiceline_ID = p_C_InvoiceLine_ID;

v_Marge = (v_linenetamt - v_Cost);
	RETURN round(v_Marge, 5);
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gettransactionmarge_abs(numeric)
  OWNER TO adempiere;
