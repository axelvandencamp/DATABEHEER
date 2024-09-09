SELECT COUNT(p.id) aantal
--SELECT p.id, p.write_date, u.login, p.national_id_nbr
FROM res_partner p
	JOIN res_users u ON u.id = p.write_uid
WHERE COALESCE(p.national_id_nbr,'_') <> '_'
	AND p.active
--GROUP BY u.login	
-------------------
SELECT p.id --, p.national_id_nbr
FROM res_partner p
WHERE COALESCE(p.national_id_nbr,'_') <> '_'
	AND p.active = false
-----------------------
-- aanpassingen in 2024
-----------------------
SELECT p.id, COALESCE(p.national_id_nbr,'_') national_id_nbr, u.login, p.write_date::date write_date 
FROM res_partner p 
	JOIN res_users u ON u.id = p.write_uid
WHERE 	u.login IN ('griet.vanddriessche','kristien.vercauteren','diederik.willems','lynn.sneyers','vera.baetens','linsay.bollen','axel.vandencamp') 
	AND (COALESCE(p.national_id_nbr,'_') <> '_')
	AND p.write_date::date >= '2024-01-01'
-----------------------------------------
-- rrn + on met potentieel fiscaal attest
-----------------------------------------
SELECT *
FROM
	(
		SELECT g.partner_id, SUM(g.bedrag) bedrag,  p.name, 
			CASE WHEN COALESCE(p.corporation_type_id,0) = 0 THEN COALESCE(p.national_id_nbr,'') ELSE COALESCE(p.company_registration_number,'') END RRN_ON,
			CASE WHEN COALESCE(p.national_id_nbr,'')='' AND COALESCE(p.company_registration_number,'')='' THEN 0 ELSE 1 END RRN_ON_t,
			CASE WHEN COALESCE(p.corporation_type_id,0) = 0 THEN 0 ELSE 1 END bedrijf,
			CASE WHEN COALESCE(p.national_id_nbr,'_') = '_' THEN 0 ELSE 1 END RRN,
			CASE WHEN COALESCE(p.company_registration_number,'_') = '_' THEN 0 ELSE 1 END "ON",
			p.corporation_type_id, p.national_id_nbr, p.company_registration_number
		FROM marketing._m_sproc_rpt_giften('YTD', now()::date, now()::date, 15) g
			JOIN res_partner p ON p.id = g.partner_id
		WHERE COALESCE(p.organisation_type_id,0) = 0 
		GROUP BY partner_id, p.name, p.corporation_type_id, p.national_id_nbr, p.company_registration_number
	) sq1
WHERE sq1.bedrag >= 40	
WHERE sq1.bedrag BETWEEN 30 AND 39.999
	

	