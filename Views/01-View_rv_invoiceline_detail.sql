-- Materialized view for sales
-- displays invoice lines
-- includes costs, redundant names

-- Materialized View: rv_invoiceline_detail

-- DROP MATERIALIZED VIEW rv_invoiceline_detail;

CREATE MATERIALIZED VIEW rv_invoiceline_detail AS
 SELECT il.ad_client_id,
    il.ad_org_id,
    il.dateinvoiced,
    to_char(il.dateinvoiced::date::timestamp with time zone, 'dd/mm/yyyy'::text) AS dateinvoicedformatted,
    trunc(il.dateinvoiced::timestamp with time zone, 'YEAR'::character varying) AS dateinvoicedyear,
    date_part('YEAR'::text, il.dateinvoiced) AS dateinvoicedonlyyear,
    to_char(il.dateinvoiced::date::timestamp with time zone, 'MM'::text) AS monthinvoicedformatted,
    trunc(il.dateinvoiced::timestamp with time zone, 'MONTH'::character varying) AS dateinvoicedmonth,
    date_part('MONTH'::text, il.dateinvoiced) AS dateinvoicedonlymonth,
    il.issotrx,
    il.documentno,
    il.docstatus,
    il.qtyinvoiced,
    il.priceactual,
    il.linetotalamt,
    il.linenetamtreal,
    linenetamtreturned(il.c_invoiceline_id) AS linenetamtreturned,
    linenetamtdiscounts(il.c_invoiceline_id) AS linenetamtdiscounts,
    linenetamtunderpricelimit(il.c_invoiceline_id) AS linenetamtunderpricelimit,
    abs(linenetamtvoided(il.reversalline_id, il.c_invoiceline_id)) AS linenetamtvoided,
    0 AS linenetamtreinvoiced,
    il.linenetamtreal + linenetamtvoided(il.reversalline_id, il.c_invoiceline_id) - linenetamtreturned(il.c_invoiceline_id) AS netsales,
    il.c_invoice_id,
    il.c_doctype_id,
    il.docbasetype,
    il.c_invoiceline_id,
    il.multiplier,
    il.c_bpartner_id AS customer_id,
    il.linenetamt,
    il.salesrep_id,
    il.m_product_category_id,
    il.c_bpartner_location_id,
    gettransactioncost(il.c_invoiceline_id) AS transactioncost,
    gettransactionmarge(il.c_invoiceline_id) AS transactionmarge,
    gettransactionpurchaseprice(il.c_invoiceline_id) AS pricepo,
    gettransactionmarge_abs(il.c_invoiceline_id) AS marge_abs,
    il.processed,
    il.importtype,
    il.isactive,
    il.created,
    il.createdby,
    il.updated,
    il.updatedby,
    il.c_bp_group_id,
    il.dateacct,
    il.ispaid,
    il.c_campaign_id,
    il.c_project_id,
    il.c_activity_id,
    il.c_projectphase_id,
    il.c_projecttask_id,
    il.qtyentered * il.multiplier::numeric AS qtyentered,
    il.m_attributesetinstance_id,
    productattribute(il.m_attributesetinstance_id) AS productattribute,
    il.m_attributeset_id,
    il.m_lot_id,
    il.guaranteedate,
    il.lot,
    il.serno,
    il.pricelist,
    il.pricelimit,
    il.priceentered,
    il.discount,
    il.margin,
    il.marginamt,
    il.linelimitamt,
    il.lineoverlimitamt,
    il.m_product_class_id,
    il.m_product_group_id,
    il.m_product_classification_id,
    il.description,
    il.description AS linedescription,
    il.c_tax_id,
    il.c_uom_id,
    il.reversalline_id,
    il.relatedproduct_id,
    il.ref_invoiceline_id,
    il.user4_id,
    il.c_charge_id,
    il.productname,
    il.productvalue,
    il.m_product_id,
    il.producttype,
    il.isdiscountallowedontotal,
    usr.name AS salesrepname,
    usr.ad_user_id,
    usr.value AS salesrepvalue,
    pc.name AS pcatname,
    pc.value AS pcatvalue,
    vnd.value AS vendorvalue,
    vnd.name AS vendorname,
    vnd.c_bpartner_id,
    ppo.pricelastpo,
    ppo.pricelastinv,
    ppo.vendorproductno,
    ppo.pricepo AS ppo_pricepo,
    ppo.order_min,
    COALESCE(dtt.name, il.doctypename) AS doctypename,
    per.c_period_id,
    bp.name AS customername,
    bp.value AS customervalue,
    COALESCE(taxtrl.name, tax.name) AS tax,
    COALESCE(uomtrl.name, uom.name) AS uomname,
    bp.c_bp_salesgroup_id,
    il.m_pricelist_id
   FROM rv_c_invoiceline il
     JOIN ad_user usr ON il.salesrep_id = usr.ad_user_id
     JOIN ad_client cl ON il.ad_client_id = cl.ad_client_id
     JOIN c_bpartner bp ON il.c_bpartner_id = bp.c_bpartner_id
     JOIN c_uom uom ON il.c_uom_id = uom.c_uom_id
     JOIN c_tax tax ON il.c_tax_id = tax.c_tax_id
     LEFT JOIN m_product_category pc ON il.m_product_category_id = pc.m_product_category_id
     LEFT JOIN m_product_po ppo ON il.m_product_id = ppo.m_product_id AND ppo.iscurrentvendor = 'Y'::bpchar
     LEFT JOIN c_bpartner vnd ON ppo.c_bpartner_id = vnd.c_bpartner_id
     LEFT JOIN c_doctype_trl dtt ON il.c_doctype_id = dtt.c_doctype_id AND cl.ad_language::text = dtt.ad_language::text
     LEFT JOIN c_period per ON il.dateinvoiced >= per.startdate AND il.dateinvoiced <= per.enddate AND per.ad_client_id = il.ad_client_id
     LEFT JOIN c_uom_trl uomtrl ON il.c_uom_id = uomtrl.c_uom_id AND cl.ad_language::text = uomtrl.ad_language::text
     LEFT JOIN c_tax_trl taxtrl ON il.c_tax_id = taxtrl.c_tax_id AND cl.ad_language::text = taxtrl.ad_language::text
     --WHERE il.ad_client_id = 1000000::numeric AND il.dateinvoiced >= to_date('01/01/2015'::text, 'dd/mm/yyyy'::text)
WITH NO DATA;

ALTER TABLE rv_invoiceline_detail
    OWNER TO adempiere;
