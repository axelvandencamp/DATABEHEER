------------------------------------------
-- moet gelopen worden voor een incasso bestand bevestigd worden
-- nadien staat alle op "recurring" en kan dus niet meer op "first" gegroepeerd worden
------------------------------------------
DROP TABLE IF EXISTS _AV_myvar;
CREATE TEMP TABLE _AV_myvar 
	(incasso_bestanden character varying[]
	 );

INSERT INTO _AV_myvar VALUES(	
				ARRAY['2022/05052','2022/05053']
				);
SELECT * FROM _AV_myvar;
--------------------------------------------------------------------------------
SELECT po.reference, sm.recurrent_sequence_type "<seqTP>", SUM(amount_currency) bedrag, COUNT(pl.id) aantal
FROM _AV_myvar v, payment_line pl
	JOIN payment_order po ON pl.order_id = po.id 
	JOIN sdd_mandate sm ON pl.sdd_mandate_id = sm.id
WHERE po.reference = ANY (v.incasso_bestanden)
GROUP BY po.reference, sm.recurrent_sequence_type