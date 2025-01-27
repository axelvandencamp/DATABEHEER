SELECT p.id, p.name, mpt.name, aaa.code, aaa.name AS "kostenplaats/contractant"
FROM res_partner p
	JOIN account_analytic_account aaa ON aaa.partner_id = p.id
	JOIN crm_marketing_partner_type_rel mptr ON mptr.partner_type_id = p.id
	JOIN res_crm_marketing_partner_type mpt ON mptr.name = mpt.id
WHERE p.active AND aaa.active AND COALESCE(p.organisation_type_id,0) = 0
	AND LOWER(aaa.code) LIKE 'c-cp-%'
	AND mpt.id = 1
ORDER BY p.id


/*
SELECT code, name, active, company_id
FROM account_analytic_account aaa
-- WHERE code = 'C-CP-000382'
WHERE LOWER(name) LIKE 'belfiu%'

-- SELECT * FROM res_partner WHERE id IN (1,5)
*/