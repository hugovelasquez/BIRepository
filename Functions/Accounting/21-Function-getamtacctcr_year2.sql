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

  v_cogs          				CONSTANT character varying = 'iscogs';
  v_inventory     				CONSTANT character varying = 'isinventory';
  v_labour_direct 				CONSTANT character varying = 'islabourcostdirect';
  v_revenue_op    				CONSTANT character varying = 'isrevenueoperation';
  v_finance       				CONSTANT character varying = 'isfinanceexpenses';
  v_depreciation  				CONSTANT character varying = 'isdepreciation';
  v_other_operating_expenses	CONSTANT character varying = 'isotheroperatingexpenses';
  v_taxes						CONSTANT character varying = 'istaxaccount';
  v_trade_receivables			CONSTANT character varying = 'istradereceivables';
  v_trade_payables				CONSTANT character varying = 'istradepayables';
  v_current_assets  	    	CONSTANT character varying = 'iscurrentassets';		
  v_non_current_assets			CONSTANT character varying = 'isnoncurrentassets';
  v_current_liabilities		  	CONSTANT character varying = 'iscurrentliabilities';
  v_non_current_liabilities		CONSTANT character varying = 'isnoncurrentliabilities';
  v_cash						CONSTANT character varying = 'iscash'; 
  
  v_labour_admin  				CONSTANT character varying = 'islabourcostadministration';
  v_unknown_cat   				CONSTANT character varying = 'categoria_desconocida';
BEGIN
  CASE 
    WHEN LOWER(p_acct_category)=v_cogs          			THEN v_field = v_cogs;
    WHEN LOWER(p_acct_category)=v_inventory     			THEN v_field = v_inventory;
    WHEN LOWER(p_acct_category)=v_labour_direct 			THEN v_field = v_labour_direct;
    WHEN LOWER(p_acct_category)=v_revenue_op    			THEN v_field = v_revenue_op;
    WHEN LOWER(p_acct_category)=v_finance    				THEN v_field = v_finance;
    WHEN LOWER(p_acct_category)=v_depreciation    			THEN v_field = v_depreciation;
    WHEN LOWER(p_acct_category)=v_other_operating_expenses	THEN v_field = v_other_operating_expenses;
    WHEN LOWER(p_acct_category)=v_taxes						THEN v_field = v_taxes;    
    WHEN LOWER(p_acct_category)=v_trade_receivables    		THEN v_field = v_trade_receivables;
    WHEN LOWER(p_acct_category)=v_trade_payables    		THEN v_field = v_trade_payables;
    WHEN LOWER(p_acct_category)=v_current_assets    		THEN v_field = v_current_assets;
    WHEN LOWER(p_acct_category)=v_non_current_assets    	THEN v_field = v_non_current_assets;
    WHEN LOWER(p_acct_category)=v_current_liabilities    	THEN v_field = v_current_liabilities;
    WHEN LOWER(p_acct_category)=v_non_current_liabilities   THEN v_field = v_non_current_liabilities;
    WHEN LOWER(p_acct_category)=v_cash    					THEN v_field = v_cash;
    
    WHEN LOWER(p_acct_category)=v_labour_admin  THEN v_field = v_labour_admin;
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
