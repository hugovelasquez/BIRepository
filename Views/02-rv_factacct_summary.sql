-- Summary of fact_acct grouped by Year/Month/Posting Type/Accounting Type
-- Accounting Type = {isCogs, isInventory, isLabourCostAdministration, isLabourCostDirect, isRevenueOperation}
-- Example
--SELECT sum(amtacctdr), sum(amtacctcr), sum(amtacctdr)-sum(amtacctcr)
-- FROM rv_factacct_summary
-- WHERE dateacctyear BETWEEN to_date ('01/01/2015','dd/MM/yyyy') AND  to_date ('31/05/2020','dd/MM/yyyy')
-- AND isRevenueOperation = 'Y'
CREATE VIEW rv_factacct_summary AS 

SELECT
  f.ad_client_id,
  f.c_acctschema_id,
  f.c_period_id,
  f.postingtype,
  sum(f.amtacctdr) AS amtacctdr,
  sum(f.amtacctcr) AS amtacctcr,
  ev.isCogs, 
  ev.isInventory,
  ev.isLabourCostAdministracion,
  ev.isLabourCostDirect,
  ev.isRevenueOperation,
  to_char(date_trunc('MONTH',f.dateacct)::date::timestamp with time zone, 'dd/mm/yyyy'::text) AS dateacctformatted,
  trunc(f.dateacct::timestamp with time zone, 'YEAR'::character varying) AS dateacctyear,
  trunc(f.dateacct::timestamp with time zone, 'MONTH'::character varying) AS dateacctmonth,
  date_part('YEAR'::text, f.dateacct) AS dateacctonlyyear,
  date_part('MONTH'::text, f.dateacct) AS dateacctonlymonth,
  to_char(f.dateacct::date::timestamp with time zone, 'MM'::text) AS monthacctformatted,
  to_char(f.dateacct::date::timestamp with time zone, 'YYYY'::text) AS yearacctformatted,
  p.name as "period"

  FROM fact_acct f 
  INNER JOIN C_ElementValue ev ON f.account_id=ev.C_ElementValue_ID
  INNER JOIN C_Period p ON f.C_Period_ID=p.C_Period_ID

GROUP BY f.ad_client_id,
  f.c_acctschema_id,
  f.c_period_id,
  f.postingtype,
  ev.isCogs, 
  ev.isInventory,
  ev.isLabourCostAdministration,
  ev.isLabourCostDirect,
  ev.isRevenueOperation,
  p.name,

  to_char(date_trunc('MONTH',f.dateacct)::date::timestamp with time zone, 'dd/mm/yyyy'::text),
  trunc(f.dateacct::timestamp with time zone, 'YEAR'::character varying),
  trunc(f.dateacct::timestamp with time zone, 'MONTH'::character varying),
  date_part('YEAR'::text, f.dateacct),
  date_part('MONTH'::text, f.dateacct),
  to_char(f.dateacct::date::timestamp with time zone, 'MM'::text),
  to_char(f.dateacct::date::timestamp with time zone, 'YYYY'::text);


ALTER TABLE rv_factacct_summary
  OWNER TO adempiere;
