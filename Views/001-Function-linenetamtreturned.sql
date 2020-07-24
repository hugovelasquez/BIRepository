-- Funcion para calcular el monto de devoluciones a una línea de factura.
-- No existe en estándar Adempiere
-- Function: linenetamtreturned(numeric)

-- DROP FUNCTION linenetamtreturned(numeric);

CREATE OR REPLACE FUNCTION linenetamtreturned(p_invoiceline_id numeric)
  RETURNS numeric AS
$BODY$
DECLARE
	v_returnedlinenetamtreal numeric;
	v_isImported VarChar;
	v_ref_InvoiceLine_ID numeric;
BEGIN
	v_returnedlinenetamtreal= 0;
	v_isImported = 'N';
	IF (p_invoiceline_id = 0) THEN
		RETURN v_returnedlinenetamtreal;
	END IF;

    -- No estándard Adempiere. Sólo para AS400
	SELECT i_Isimported,ref_InvoiceLine_ID INTO v_isImported, v_ref_InvoiceLine_ID 
	FROM c_Invoiceline 
	WHERE c_Invoiceline_ID=p_invoiceline_id;
	
	--Aus der AS400 importierte Datensaetze bis Ende 2019
	IF (v_isImported = 'Y') THEN
	SELECT 
	case when qtyInvoiced < 0 then coalesce(ivl.linenetamt,0) else 0 end INTO v_returnedlinenetamtreal 
	FROM c_Invoiceline ivl
	WHERE ivl.C_InvoiceLine_ID=p_invoiceline_id;
	RETURN v_returnedlinenetamtreal*-1;
	END IF;	
	
	--Aus der AS400 importierte Datensaetze bis Ende Mai 2020
	SELECT coalesce(ivl.linenetamt,0) INTO v_returnedlinenetamtreal 
	FROM c_Invoiceline ivl 
	WHERE ref_invoiceline_id = p_Invoiceline_ID;
	IF v_returnedlinenetamtreal <> 0 THEN 
	RETURN v_returnedlinenetamtreal*-1;
	END IF;
	
    -- Para estándar Adempiere: a partir de esta línea (borrar líneas anteriores)
	--Ab Juni 2020, StandardAdempiere
	SELECT	COALESCE ( linenetamtrealinvoiceline(crnl.C_Invoiceline_ID), 0)
        INTO	v_returnedlinenetamtreal
   	FROM	   C_Invoiceline ivl
	INNER JOIN M_InOutLine iol    ON (ivl.M_InOutLine_ID=iol.M_InOutLine_ID)
	INNER JOIN M_RMALine rmal     ON (iol.M_InOutLine_ID=rmal.M_InOutLine_ID)
	INNER JOIN M_InOutLine retl   ON (rmal.M_RMALine_ID=retl.M_RMALine_ID)
	INNER JOIN C_Invoiceline crnl ON (retl.M_InOutLine_ID=crnl.M_InOutLine_ID)
	INNER JOIN C_Invoice crn      ON (crnl.C_Invoice_ID=crn.C_Invoice_ID AND crn.docstatus='CO')
	WHERE ivl.C_InvoiceLine_ID=p_invoiceline_id;
	RETURN coalesce(v_returnedlinenetamtreal, 0);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION linenetamtreturned(numeric)
  OWNER TO adempiere;
