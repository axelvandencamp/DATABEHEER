SELECT p.id, p.create_date::date, p.name naam, mo.name herkomst,
		--p.street adres, p.zip postcode, p.city woonplaats, 
		pfc.name "type", p.free_member_comment omschrijving, /*p.free_membership_class_id,*/ p.active
FROM res_partner p
	LEFT OUTER JOIN res_partner_free_class pfc ON p.free_membership_class_id = pfc.id
	LEFT OUTER JOIN res_partner_membership_origin mo ON mo.id = p.membership_origin_id
WHERE p.free_member AND p.active 
		--AND pfc.name = 'Pers'
ORDER BY pfc.name

/*
SELECT * FROM res_partner p WHERE p.free_member AND free_member_comment LIKE '%1%'

SELECT * FROM res_partner_free_class
*/