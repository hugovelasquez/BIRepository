-- product cost out of CostDetail for a given invoiceline

-- Function: gettransactioncost(numeric)

-- DROP FUNCTION gettransactioncost(numeric);

CREATE OR REPLACE FUNCTION gettransactioncost(p_c_invoiceline_id numeric)
  RETURNS numeric AS
$BODY$
DECLARE
	v_Cost		 NUMERIC;
	v_LinenetAmt NUMERIC;
	v_DocStatus	 character varying;
BEGIN
v_Cost = 0.0;

SELECT i.docstatus, sum(ivl.linenetamt) , coalesce(sum(cd.costamt),0) INTO v_DocStatus, v_LinenetAmt, v_Cost
FROM m_Costdetail cd 
INNER JOIN m_InoutLine iol ON cd.m_INoutline_ID = iol.m_Inoutline_ID
INNER JOIN c_invoiceline ivl ON iol.c_Orderline_ID=ivl.c_orderline_ID 
INNER JOIN C_Invoice i ON (ivl.c_Invoice_ID=i.c_Invoice_ID)
WHERE ivl.c_INvoiceline_ID = p_C_InvoiceLine_ID
GROUP BY i.docstatus;

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
