-- Delivers the IDs of the Account values as a string
-- If none found, it delivers 0, which will match nothing
-- prefix "p_" denotes a parameter, "v_" denotes a variable
-- Example:
-- SELECT getacctidsbystring(1000000, 1000002, '501') as accidsbystring 
CREATE OR REPLACE FUNCTION getacctidsbystring(p_ad_client_id numeric, p_c_element_id numeric, p_acctvalues character varying)
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
	AND value like p_acctvalues || '%'
  LOOP
	v_acctids = v_acctids || ', ' || v_accounts.c_elementvalue_id;			-- concatenation: either using "||" or function "CONCAT()"
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
ALTER FUNCTION getacctidsbystring(numeric, numeric, character varying)		-- definition of footprint (how to show function in e.g. PgAdmin tree)
  OWNER TO adempiere;
