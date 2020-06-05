-- product cost out of CostDetail for a given invoiceline

-- Function: gettransactioncost(numeric)
-- DROP FUNCTION gettransactioncost(numeric);

CREATE OR REPLACE FUNCTION gettransactioncost(p_c_invoiceline_id numeric)
  RETURNS numeric AS
$BODY$

DECLARE
	v_Cost						NUMERIC;
	v_LinenetAmt				NUMERIC;
	v_DocStatus					character varying;

BEGIN

select i.docstatus, sum(ivl.linenetamt) , coalesce(sum(cd.costamt),0) INTO v_DocStatus, v_LinenetAmt, v_Cost

from m_Costdetail cd 
INNER JOIN m_InoutLine iol on cd.m_INoutline_ID = iol.m_Inoutline_ID
INNER JOIN c_invoiceline ivl on iol.c_Orderline_ID=ivl.c_orderline_ID 
INNER JOIN C_Invoice i on (ivl.c_Invoice_ID=i.c_Invoice_ID)
where
ivl.c_INvoiceline_ID = p_C_InvoiceLine_ID
group by i.docstatus;

IF (v_DocStatus not in ( 'CL', 'CO') AND v_LinenetAmt = 0) THEN  v_Cost = 0 ; END IF;
RETURN round(v_Cost,4);

END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gettransactioncost(numeric)
  OWNER TO adempiere;
