-- Delivers for one specified year the amtaactcr sum for the specified Account category and posting type 
-- Posting Types= A for Actual, B for Budget, S for Statistical 
-- Example:
-- SELECT getamtacctcr_year2(
--date_part('YEAR'::text, now()::timestamp) - 0, -- This Year - 0
--'iscogs'  	                                 -- Cost of goods sold
--, 'A')                                         -- Posting type Actual
CREATE OR REPLACE FUNCTION getamtacctcr_year2(p_year double precision, p_acct_category character varying, p_postingtype char)
  RETURNS numeric AS
$BODY$
DECLARE
  v_amtacctcr numeric=0;
  v_sql       character varying;
  v_field     character varying;

  v_inventory     CONSTANT character varying = 'isinventory';
  v_labour_admin  CONSTANT character varying = 'islabourcostadministration';
  v_labour_direct CONSTANT character varying = 'islabourcostdirect';
  v_revenue_op    CONSTANT character varying = 'isrevenueoperation';
  v_cogs          CONSTANT character varying = 'iscogs';
  v_unknown_cat   CONSTANT character varying = 'categoria_desconocida';
BEGIN
  CASE 
    WHEN LOWER(p_acct_category)=v_inventory     THEN v_field = v_inventory;
    WHEN LOWER(p_acct_category)=v_labour_admin  THEN v_field = v_labour_admin;
    WHEN LOWER(p_acct_category)=v_labour_direct THEN v_field = v_labour_direct;
    WHEN LOWER(p_acct_category)=v_revenue_op    THEN v_field = v_revenue_op;
    WHEN LOWER(p_acct_category)=v_cogs          THEN v_field = v_cogs;
    ELSE                                             v_field = v_unknown_cat;
  END CASE;

  IF v_field=v_unknown_cat THEN
    RETURN v_amtacctcr;
  END IF;

  v_sql = 'SELECT SUM(amtacctcr) FILTER (WHERE date_part(''YEAR''::text, dateacctyear)=$1)
  FROM rv_fact_acct_summary
  WHERE '|| v_field || '=''Y''';
  v_sql = v_sql || ' AND postingtype=''' || p_postingtype || '''';
  EXECUTE v_sql
   INTO v_amtacctcr
   USING p_year;

  RETURN COALESCE(v_amtacctcr, 0);
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION getamtacctcr_year2(double precision, character varying, char)	-- definition of footprint (how to show function in e.g. PgAdmin tree)
  OWNER TO adempiere;
