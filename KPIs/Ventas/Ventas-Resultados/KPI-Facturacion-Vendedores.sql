SELECT ild.salesrepname, sum(ild.linenetamtreal) as facturado, sum(ild.linenetamtvoided) as anulaciones, sum(ild.linenetamtreturned) as devoluciones
FROM rv_invoiceline_detail ild
WHERE ild.dateinvoiced BETWEEN {{Fecha_inicio}} AND {{Fecha_final}}
GROUP BY ild.salesrepname
ORDER BY sum(ild.linenetamtreal) desc
LIMIT  {{Limite}}