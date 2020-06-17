-- Delivers the IDs (c_elementvalue_ids) of the Account values as a string
-- If none found, it delivers 0, which will match nothing
-- prefix "p_" denotes a parameter, "v_" denotes a variable
-- Example:
-- SELECT getacctidsbyarray(1000000, 1000002, ARRAY['1010101001', '1060502501', '2020201339','454', 'trtr', 'trrtgtrg']) as accidsbyarray
CREATE OR REPLACE FUNCTION getacctidsbyarray(p_ad_client_id numeric, p_c_element_id numeric, p_acctvaluearray character varying[])
  RETURNS character varying AS
$BODY$
DECLARE
	v_acctids   character varying;
	v_tempid    character varying;
	v_tempvalue character varying;
BEGIN
  v_acctids = '';

  FOREACH v_tempvalue IN ARRAY p_acctvaluearray
  LOOP
    SELECT c_elementvalue_id INTO v_tempid
	FROM c_elementvalue
	WHERE ad_client_id=p_ad_client_id 
	AND c_element_id=p_c_element_id 	
	AND value = v_tempvalue;

	IF (v_tempid IS NOT NULL)
    THEN v_acctids = v_acctids || v_tempid  || ' ,';						-- concatenation: either using "||" or function "CONCAT()"
    END IF;
  END LOOP;
  v_acctids = v_acctids || ')';
  v_acctids = replace(v_acctids,',)','');

  IF (v_acctids IS NULL OR length(v_acctids)<4)
  THEN v_acctids = '0';
  END IF;
  
  RETURN v_acctids;

END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION getacctidsbyarray(numeric, numeric, character varying[])		-- definition of footprint (how to show function in e.g. PgAdmin tree)
  OWNER TO adempiere;
