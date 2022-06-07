SELECT ml.partner, p.name, ml.date_from, ml.date_to, ml.state, ml.member_price, pp.name_template, ml.remarks
FROM membership_membership_line ml
	JOIN (SELECT max(ml.id) id FROM membership_membership_line ml WHERE LOWER(ml.remarks) LIKE 'ruilabonnement%' GROUP BY ml.partner) SQ1 ON SQ1.id = ml.id
	INNER JOIN res_partner p ON ml.partner = p.id
	JOIN product_product pp ON pp.id = ml.membership_id
WHERE LOWER(ml.remarks) LIKE 'ruilabonnement%'
