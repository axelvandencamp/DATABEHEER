-------------------------------------------------------------
-- - partner_id's met geldig mandaat
-- - sq1: lidmaatschapsfactuur
-- - sq2: abonnementsfactuur die geen lidmaatschapsfactuur is
-------------------------------------------------------------
SELECT p.id, sm.sm_id, sq1.sdd_mandate_id, sq2.sdd_mandate_id
FROM res_partner p
	--door bank aan mandaat te linken en enkel de mandaat info te nemen ontdubbeling veroorzaakt door meerdere bankrekening nummers
	JOIN (SELECT pb.id pb_id, pb.partner_id pb_partner_id, sm.id sm_id, sm.state sm_state FROM res_partner_bank pb JOIN sdd_mandate sm ON sm.partner_bank_id = pb.id WHERE sm.state = 'valid') sm ON pb_partner_id = p.id
	--lidmaatschapsfacturen
	JOIN (SELECT i.partner_id, i.sdd_mandate_id 
		 FROM account_invoice i 
			JOIN account_invoice_line il ON il.invoice_id = i.id 
			JOIN product_product pp ON pp.id = il.product_id
		WHERE pp.membership_product AND i.state IN ('open','paid') AND EXTRACT(YEAR FROM i.create_date) = EXTRACT(YEAR FROM now()) ) sq1
		ON sq1.partner_id = p.id AND sq1.sdd_mandate_id = sm.sm_id
	-- abonnementsfacturen die geen lidmaatschapsfactuur zijn
	LEFT OUTER JOIN (SELECT i.partner_id, i.sdd_mandate_id 
		 FROM account_invoice i 
			JOIN account_invoice_line il ON il.invoice_id = i.id 
			JOIN product_product pp ON pp.id = il.product_id
		WHERE pp.magazine_product AND pp.membership_product = 'f' AND i.state IN ('open')AND EXTRACT(YEAR FROM i.create_date) = EXTRACT(YEAR FROM now())  ) sq2	
		ON sq2.partner_id = p.id
WHERE COALESCE(sq2.partner_id,0) > 0 AND COALESCE(sq2.sdd_mandate_id,0) = 0
	

	
	