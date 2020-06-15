-- Delivers the IDs of the Account values as a string
-- If none found, it delivers 0, which will match nothing
CREATE OR REPLACE FUNCTION getacctidsbyarray(p_ad_client_id numeric, p_c_element_id numeric, p_acctidarray character varying[])
  RETURNS character varying AS
$BODY$
DECLARE
	v_acctids   character varying;
	v_tempid    character varying;
	v_tempvalue character varying;
BEGIN
  v_acctids = '';

  FOREACH v_tempvalue IN ARRAY p_acctidarray
  LOOP
    SELECT c_elementvalue_id INTO v_tempid
	FROM c_elementvalue
	WHERE ad_client_id=p_ad_client_id 
	AND c_element_id=p_c_element_id 	
	AND value = v_tempvalue;

	IF (v_tempid IS NOT NULL)
    THEN v_acctids = v_acctids || v_tempid  || ' ,';
    END IF;
  END LOOP;
  v_acctids = v_acctids || ')';
  v_acctids = replace(v_acctids,',)','');

  IF (v_acctids IS NULL OR length(v_acctids)<4)
  THEN v_acctids = '(0)';
  END IF;
  
  RETURN v_acctids;

END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION getacctidsbyarray(numeric, numeric, character varying[])
  OWNER TO adempiere;