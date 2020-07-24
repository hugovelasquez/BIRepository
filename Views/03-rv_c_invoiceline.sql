-- View: rv_c_invoiceline

-- DROP VIEW rv_c_invoiceline;

CREATE OR REPLACE VIEW rv_c_invoiceline AS 
 SELECT il.ad_client_id,
    il.ad_org_id,
    il.isactive,
    il.created,
    il.createdby,
    il.updated,
    il.updatedby,
    il.c_invoiceline_id,
    i.c_invoice_id,
    i.salesrep_id,
    i.c_bpartner_id,
    i.c_bp_group_id,
    il.m_product_id,
    p.m_product_category_id,
    i.dateinvoiced,
    i.dateacct,
    i.issotrx,
    i.c_doctype_id,
    i.docstatus,
    i.ispaid,
    il.c_campaign_id,
    il.c_project_id,
    il.c_activity_id,
    il.c_projectphase_id,
    il.c_projecttask_id,
    il.qtyinvoiced * i.multiplier::numeric AS qtyinvoiced,
    il.qtyentered * i.multiplier::numeric AS qtyentered,
    il.m_attributesetinstance_id,
    productattribute(il.m_attributesetinstance_id) AS productattribute,
    pasi.m_attributeset_id,
    pasi.m_lot_id,
    pasi.guaranteedate,
    pasi.lot,
    pasi.serno,
    il.pricelist,
    il.priceactual,
    il.pricelimit,
    il.priceentered,
        CASE
            WHEN il.pricelist = 0::numeric THEN 0::numeric
            ELSE round((il.pricelist - il.priceactual) / il.pricelist * 100::numeric, 2)
        END AS discount,
        CASE
            WHEN il.pricelimit = 0::numeric THEN 0::numeric
            ELSE round((il.priceactual - il.pricelimit) / il.pricelimit * 100::numeric, 2)
        END AS margin,
        CASE
            WHEN il.pricelimit = 0::numeric THEN 0::numeric
            ELSE (il.priceactual - il.pricelimit) * il.qtyinvoiced
        END AS marginamt,
    round(i.multiplier::numeric * il.linenetamt, 2) AS linenetamt,
    round(i.multiplier::numeric * il.pricelist * il.qtyinvoiced, 2) AS linelistamt,
        CASE
            WHEN COALESCE(il.pricelimit, 0::numeric) = 0::numeric THEN round(i.multiplier::numeric * il.linenetamt, 2)
            ELSE round(i.multiplier::numeric * il.pricelimit * il.qtyinvoiced, 2)
        END AS linelimitamt,
    round(i.multiplier::numeric * il.pricelist * il.qtyinvoiced - il.linenetamt, 2) AS linediscountamt,
        CASE
            WHEN COALESCE(il.pricelimit, 0::numeric) = 0::numeric THEN 0::numeric
            ELSE round(i.multiplier::numeric * il.linenetamt - il.pricelimit * il.qtyinvoiced, 2)
        END AS lineoverlimitamt,
    p.m_product_class_id,
    p.m_product_group_id,
    p.m_product_classification_id,
    i.description,
    il.description AS linedescription,
    i.c_doctypetarget_id,
    il.c_tax_id,
    round(
        CASE
            WHEN il.currentcostprice = 0::numeric THEN 0::numeric
            ELSE round((il.priceactual - il.currentcostprice) / il.currentcostprice * 100::numeric, 2)
        END, 2) AS margincost,
        CASE
            WHEN il.currentcostprice = 0::numeric THEN 0::numeric
            ELSE (il.priceactual - il.currentcostprice) * il.qtyinvoiced
        END AS marginamtcost,
    i.multiplier,
    il.c_uom_id,
    i.documentno,
    il.reversalline_id,
    dt.docbasetype,
    il.relatedproduct_id,
    il.ref_invoiceline_id,
    il.user4_id,
    il.c_charge_id,
    i.c_bp_accounttype_id,
    i.c_bp_salesgroup_id,
    i.c_bp_segment_id,
    i.c_bp_industrytype_id,
    -- hasta aquí llega estándar Adempiere
    il.priceentered - il.pricelimit AS difflimitprice,
    linenetamtrealinvoiceline(il.c_invoiceline_id) * i.multiplier::numeric AS linenetamtreal,
    il.linetotalamt,
    i.c_bpartner_location_id,
    i.processed,
    il.importtype,
    p.name AS productname,
    p.value AS productvalue,
    p.producttype,
    i.isdiscountallowedontotal,
    i.doctypename,
    0.00 AS marge_abs,
    i.i_isimported
   FROM rv_c_invoice i
     JOIN c_invoiceline il ON i.c_invoice_id = il.c_invoice_id
     JOIN c_doctype dt ON i.c_doctype_id = dt.c_doctype_id
     LEFT JOIN m_product p ON il.m_product_id = p.m_product_id
     LEFT JOIN m_attributesetinstance pasi ON il.m_attributesetinstance_id = pasi.m_attributesetinstance_id;

ALTER TABLE rv_c_invoiceline
  OWNER TO adempiere;
