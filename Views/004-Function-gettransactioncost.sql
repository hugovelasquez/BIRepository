-- Funcion para calcular el costo a una línea de factura.
-- No existe en estándar Adempiere
-- Function: gettransactioncost(numeric)

-- DROP FUNCTION gettransactioncost(numeric);

CREATE OR REPLACE FUNCTION gettransactioncost(p_c_invoiceline_id numeric)
  RETURNS numeric AS
$BODY$DECLARE
	v_Cost		 NUMERIC;
	v_LinenetAmt NUMERIC;
	v_DocStatus	 character varying;
	v_qtyInvoiced NUMERIC;
BEGIN
v_Cost = 0.0;

-- Para AS400, no estándar
SELECT coalesce(linecost_Historic,0) INTO v_Cost 
FROM c_Invoiceline il
INNER JOIN c_Invoice i ON il.c_Invoice_ID=i.c_Invoice_ID
WHERE c_Invoiceline_ID=p_c_invoiceline_id;

-- Para estándar Adempiere, borrar líneas anteriores
IF v_Cost = 0 then 
	SELECT i.docstatus, ivl.qtyInvoiced*cd.currentcostprice INTO v_DocStatus, v_Cost
	FROM m_Costdetail cd 
	INNER JOIN m_InoutLine iol ON cd.m_INoutline_ID = iol.m_Inoutline_ID
	INNER JOIN c_invoiceline ivl ON iol.c_Orderline_ID=ivl.c_orderline_ID 
	INNER JOIN C_Invoice i ON (ivl.c_Invoice_ID=i.c_Invoice_ID)
	INNER JOIN M_INout io ON iol.M_INout_ID=io.M_Inout_ID
	WHERE ivl.c_INvoiceline_ID = p_C_InvoiceLine_ID
	AND i.docStatus = io.DocStatus;
END IF;

IF (v_DocStatus NOT IN ('CL', 'CO') AND v_LinenetAmt = 0) 
THEN  v_Cost = 0 ; 
END IF;
RETURN round(coalesce(v_Cost, 0),4);

END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gettransactioncost(numeric)
  OWNER TO adempiere;
