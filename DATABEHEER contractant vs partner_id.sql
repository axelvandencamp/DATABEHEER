-- contracten met gelinkte partner_id
SELECT p.id, p.name, mpt.name, /*mpt.id,*/ aaa.code, aaa.name AS "kostenplaats/contractant"
FROM res_partner p
	JOIN account_analytic_account aaa ON aaa.partner_id = p.id
	JOIN crm_marketing_partner_type_rel mptr ON mptr.partner_type_id = p.id
	JOIN res_crm_marketing_partner_type mpt ON mptr.name = mpt.id
WHERE p.active AND aaa.active AND COALESCE(p.organisation_type_id,0) = 0
	AND LOWER(aaa.code) LIKE 'c-cp-%'
	AND mpt.id = 7		-- 1 = "Bedrijven & verenigingen"; 7 = "Partner Bos voor Iedereen"
ORDER BY p.id


-- contracten zonder gelinkte partner_id
SELECT p.id, p.name, mpt.name, aaa.create_date::date aanmaak_datum, aaa.code, aaa.name AS "kostenplaats/contractant"
FROM account_analytic_account aaa
	LEFT OUTER JOIN res_partner p ON p.id = aaa.partner_id
	LEFT OUTER JOIN crm_marketing_partner_type_rel mptr ON mptr.partner_type_id = p.id
	LEFT OUTER JOIN res_crm_marketing_partner_type mpt ON mptr.name = mpt.id
WHERE LOWER(aaa.code) LIKE 'c-cp-%'
	AND aaa.create_date > '2024-01-01'
	AND COALESCE(p.name,'_') = '_'
ORDER BY p.id

-- SELECT * FROM account_analytic_account aaa WHERE aaa.code = 'C-CP-000530'

/*
SELECT code, name, active, company_id
FROM account_analytic_account aaa
-- WHERE code = 'C-CP-000382'
WHERE LOWER(name) LIKE 'belfiu%'

-- SELECT * FROM res_partner WHERE id IN (1,5)
*/