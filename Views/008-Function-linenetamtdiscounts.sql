-- FUNCTION: adempiere.linenetamtdiscounts(numeric)

-- DROP FUNCTION adempiere.linenetamtdiscounts(numeric);

-- Betrag der Notas de Crédito (ARC, Accounts Receivable Memo)
CREATE OR REPLACE FUNCTION adempiere.linenetamtdiscounts(
	p_invoiceline_id numeric)
    RETURNS numeric
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
DECLARE
	v_discountslinenetamtreal numeric;
BEGIN
	v_discountslinenetamtreal= 0;

	-- StandardAdempiere
	SELECT	COALESCE ( linenetamtrealinvoiceline(ivl.C_Invoiceline_ID), 0)
        INTO	v_discountslinenetamtreal
   	FROM	   C_Invoiceline ivl
	INNER JOIN C_Invoice i ON (ivl.C_Invoice_ID=i.C_Invoice_ID)
	INNER JOIN C_DocType dt ON (i.C_DocType_ID=dt.C_DocType_ID AND dt.DocBaseType='ARC')
	WHERE  ivl.C_InvoiceLine_ID=p_invoiceline_id;
	RETURN coalesce(v_discountslinenetamtreal, 0);
END;
$BODY$;

ALTER FUNCTION adempiere.linenetamtdiscounts(numeric)
    OWNER TO adempiere;
