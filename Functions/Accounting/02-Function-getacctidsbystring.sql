-- Delivers the IDs of the Account values as a string
-- If none found, it delivers 0, which will match nothing
-- Example:
-- SELECT getacctidsbystring(1000000, 1000002, '501') as accidsbystring 
CREATE OR REPLACE FUNCTION getacctidsbystring(p_ad_client_id numeric, p_c_element_id numeric, p_acctids character varying)
  RETURNS character varying AS
$BODY$
DECLARE
	v_acctids  character varying;
    v_accounts RECORD;
BEGIN
  v_acctids = '(';

  FOR v_accounts IN
    SELECT c_elementvalue_id AS c_elementvalue_id
	FROM c_elementvalue
	WHERE ad_client_id=p_ad_client_id 
	AND c_element_id=p_c_element_id 
    AND issummary = 'N'	
	AND value like p_acctids || '%'
  LOOP
	v_acctids = v_acctids || ', ' || v_accounts.c_elementvalue_id;
  END LOOP;
  v_acctids = replace(v_acctids,'(, ','');
  v_acctids = replace(v_acctids,')','');

  IF (v_acctids IS NULL OR length(v_acctids)<4)
  THEN v_acctids = '0';
  END IF;
  
  RETURN v_acctids;

END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION getacctidsbystring(numeric, numeric, character varying)
  OWNER TO adempiere;
