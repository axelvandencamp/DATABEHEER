-----------------
-- INCASSO: open facturen met geldig mandaat voor incasso en nog niet in ander incasso
-- - 'b-lid##' of 'b-gift##' invullen
-- - jaartal incasso bestand invullen
-----------------
SELECT i.id i_id, i.state i_state, i.number i_factuur,
	sm.id sm_id, sm.state sm_state, sm.unique_mandate_reference sm_mandaatreferte
FROM account_invoice i 
	JOIN sdd_mandate sm ON sm.id = i.sdd_mandate_id
WHERE sm.state = 'valid' AND i.state = 'open' AND LOWER(i.number) LIKE 'b-lid24%' AND 
	NOT(i.id IN (SELECT i.id i_id--, i.state i_state, i.number i_factuur, pl.id pl_id, po.id po_id, po.reference incasso_bestand
				FROM account_invoice i
					JOIN payment_line pl ON regexp_replace(pl.communication, '\D','','g') = regexp_replace(i.reference, '\D','','g')
					JOIN payment_order po ON po.id = pl.order_id
				WHERE i.state = 'open' AND po.reference LIKE '2024/%')
		)
-----------------
-- INCASSO: facturen in incasso - betaald
-- - naam incasso bestanden invullen
-----------------
SELECT po.id po_id, po.reference incasso_bestand, pl.id pl_id, pl.state pl_state, 
	pl.partner_id pl_partner_id, pl.communication pl_ogm, pl.name pl_name, --pl.sdd_mandate_id pl_mandate_id,
	i.id i_id, i.state i_state, i.number i_factuur, 
	sm.id sm_id, sm.state sm_state, sm.unique_mandate_reference sm_mandaatreferte
FROM payment_order po
	JOIN payment_line pl ON pl.order_id = po.id
	JOIN sdd_mandate sm ON sm.id = pl.sdd_mandate_id
	JOIN account_invoice i ON regexp_replace(i.reference, '\D','','g') = regexp_replace(pl.communication, '\D','','g')
WHERE po.reference IN ('2024/06302','2024/06263')
