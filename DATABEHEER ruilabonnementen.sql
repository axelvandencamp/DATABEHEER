SELECT ml.partner, p.name, ml.date_from, ml.date_to, ml.state, ml.member_price, pp.name_template, ml.remarks
FROM membership_membership_line ml
	INNER JOIN res_partner p ON ml.partner = p.id
	JOIN product_product pp ON pp.id = ml.membership_id
WHERE LOWER(ml.remarks) = 'ruilabonnement'
