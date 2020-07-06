SELECT salesrepname,
        CASE
            WHEN dateinvoicedonlymonth =  1 THEN 'Enero'
            WHEN dateinvoicedonlymonth =  2 THEN 'Febrero'
            WHEN dateinvoicedonlymonth =  3 THEN 'Marzo'
            WHEN dateinvoicedonlymonth =  4 THEN 'Abril'
            WHEN dateinvoicedonlymonth =  5 THEN 'Mayo'
            WHEN dateinvoicedonlymonth =  6 THEN 'Junio'
            WHEN dateinvoicedonlymonth =  7 THEN 'Julio'
            WHEN dateinvoicedonlymonth =  8 THEN 'Agosto'
            WHEN dateinvoicedonlymonth =  9 THEN 'Septiembre'
            WHEN dateinvoicedonlymonth = 10 THEN 'Octubre'
            WHEN dateinvoicedonlymonth = 11 THEN 'Noviembre'
            ELSE 'Diciembre'
        END AS dateinvoicedmonthname,
  
  COALESCE( SUM(linenetamtreal) FILTER (WHERE dateinvoicedonlyyear=date_part('YEAR'::text, $P{DateInvoiced}::timestamp) - 4) ,0) AS "year-4amt",
  COALESCE( SUM(linenetamtreal) FILTER (WHERE dateinvoicedonlyyear=date_part('YEAR'::text, $P{DateInvoiced}::timestamp) - 3) ,0)  AS "year-3amt",
  COALESCE( SUM(linenetamtreal) FILTER (WHERE dateinvoicedonlyyear=date_part('YEAR'::text, $P{DateInvoiced}::timestamp) - 2) ,0)  AS "year-2amt",
  COALESCE( SUM(linenetamtreal) FILTER (WHERE dateinvoicedonlyyear=date_part('YEAR'::text, $P{DateInvoiced}::timestamp) - 1) ,0)  AS "year-1amt",
  COALESCE( SUM(linenetamtreal) FILTER (WHERE dateinvoicedonlyyear=date_part('YEAR'::text, $P{DateInvoiced}::timestamp)    ) ,0)  AS "year0amt"

FROM rv_invoiceline_detail 
WHERE ad_Client_ID= $P{AD_CLIENT_ID} 
AND issotrx=$P{IsSOTrx} 
AND ( ( docbasetype = 'ARI' AND docstatus IN ('CO','VO')     ) 
	   OR 
      (docstatus IN ('CO') AND IsDiscountAllowedOnTotal = 'Y')
    )
AND $P!{SALESREP_ID_QUERY}
AND $P!{M_PRODUCT_CATEGORY_ID_QUERY}
AND $P!{C_BPARTNER_ID_CUSTOMER_QUERY}
AND $P!{C_BPARTNER_ID_VENDOR_QUERY}
AND $P!{M_PRODUCT_ID_QUERY}
AND dateinvoicedonlyyear >= date_part('YEAR'::text, $P{DateInvoiced}::timestamp) - 4 

GROUP BY salesrepname, dateinvoicedonlymonth
ORDER BY salesrepname ASC, dateinvoicedonlymonth ASC
