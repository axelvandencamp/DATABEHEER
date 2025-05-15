SELECT p.id partner_id, p.name naam, p.membership_state status, p.email,
		p2.id partner_id_partner, p2.name naam_partner, p2.membership_state status_partner, p2.email email_partner
FROM res_partner p
	JOIN res_partner p2 ON p.relation_partner_id = p2.id
WHERE p.active AND p2.active
	AND COALESCE(p.email,'_') <> '_' AND COALESCE(p2.email,'_') <> '_'
	AND p.membership_state = 'old'
	--AND p.id IN (334038)
ORDER BY p.id DESC	