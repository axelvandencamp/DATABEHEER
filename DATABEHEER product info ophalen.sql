DROP TABLE IF EXISTS marketing._m_temp_prodinfotoevoegen;

CREATE TABLE marketing._m_temp_prodinfotoevoegen (
	Partner_id numeric,
	Lidnummer text,
	Lidmaatschapslijn integer,
	OGM text,
	bedrag numeric,
	type_digitaal text)
	
SELECT * FROM marketing._m_temp_prodinfotoevoegen;	
------------------------------------------------------------------	
INSERT INTO marketing._m_temp_prodinfotoevoegen (
	SELECT p.id, p.membership_nbr, sq1.id, NULL, NULL,
		CASE WHEN COALESCE(p.no_magazine,'f') = 't' THEN 'geen magazine gewenst'
			WHEN COALESCE(p.address_state_id,0) = 2 THEN 'adres verkeerd'
			ELSE '' END type_digitaal
	FROM res_partner p
		JOIN (
			SELECT MAX(ml.id) id, ml.partner 
			FROM membership_membership_line ml JOIN product_product pp ON pp.id = ml.membership_id
			WHERE  (ml.date_to BETWEEN '2022-01-01' and '2022-12-31' OR '2022-12-31' BETWEEN ml.date_from AND ml.date_to) 
				AND pp.membership_product
			GROUP BY ml.partner
			) sq1
			ON sq1.partner = p.id)
			
--mededeling toevoegen
UPDATE marketing._m_temp_prodinfotoevoegen t
SET OGM = (SELECT i.reference 
		FROM membership_membership_line ml 
			JOIN account_invoice_line il ON ml.account_invoice_line = il.id 
			JOIN account_invoice i ON i.id = il.invoice_id
			JOIN product_product pp ON pp.id = il.product_id
		WHERE t.lidmaatschapslijn = ml.id);
--bedrag toeveogen
UPDATE marketing._m_temp_prodinfotoevoegen t
SET bedrag = (SELECT i.amount_total 
		FROM membership_membership_line ml 
			JOIN account_invoice_line il ON ml.account_invoice_line = il.id 
			JOIN account_invoice i ON i.id = il.invoice_id
			JOIN product_product pp ON pp.id = il.product_id
		WHERE t.lidmaatschapslijn = ml.id);			