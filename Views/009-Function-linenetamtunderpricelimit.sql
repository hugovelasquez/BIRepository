-- FUNCTION: adempiere.linenetamtunderpricelimit(numeric)

-- DROP FUNCTION adempiere.linenetamtunderpricelimit(numeric);

CREATE OR REPLACE FUNCTION adempiere.linenetamtunderpricelimit(
	p_invoiceline_id numeric)
    RETURNS numeric
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
DECLARE
	v_underpricelimitlinenetamtreal numeric;
BEGIN
	v_underpricelimitlinenetamtreal= 0;

	-- StandardAdempiere
	SELECT		sum( (ivl.pricelimit-ivl.priceactual)  * ivl.qtyinvoiced)
        INTO	v_underpricelimitlinenetamtreal
   	FROM	   C_Invoiceline ivl
	WHERE  ivl.C_InvoiceLine_ID=p_invoiceline_id AND ivl.pricelimit>ivl.priceactual;
	RETURN coalesce(v_underpricelimitlinenetamtreal, 0);
END;
$BODY$;

ALTER FUNCTION adempiere.linenetamtunderpricelimit(numeric)
    OWNER TO adempiere;
