SELECT p.id, p.name, p.membership_nbr, p.membership_state, pp.name_template, ml.member_price
FROM res_partner p
	JOIN membership_membership_line ml ON ml.partner = p.id
	JOIN product_product pp ON pp.id = ml.membership_id
WHERE LOWER(pp.name_template) LIKE '%natuur.focus' AND ml.member_price = 21
LIMIT 10



SELECT ml.*, pp.name_template
FROM membership_membership_line ml 
	JOIN product_product pp ON pp.id = ml.membership_id
WHERE LOWER(pp.name_template) LIKE '%natuur.focus'