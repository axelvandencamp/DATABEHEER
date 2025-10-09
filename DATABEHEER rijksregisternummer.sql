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
		SELECT p.id partner_id, /*SUM(g.bedrag) bedrag,*/  p.name, 
			CASE WHEN COALESCE(p.corporation_type_id,0) = 0 THEN COALESCE(p.national_id_nbr,'') ELSE COALESCE(p.company_registration_number,'') END RRN_ON,
			CASE WHEN COALESCE(p.national_id_nbr,'')='' AND COALESCE(p.company_registration_number,'')='' THEN 0 ELSE 1 END RRN_ON_t,
			CASE WHEN COALESCE(p.corporation_type_id,0) = 0 THEN 0 ELSE 1 END bedrijf,
			CASE WHEN COALESCE(p.national_id_nbr,'_') = '_' THEN 0 ELSE 1 END RRN,
			CASE WHEN COALESCE(p.company_registration_number,'_') = '_' THEN 0 ELSE 1 END "ON",
			p.corporation_type_id, p.national_id_nbr, p.company_registration_number
		FROM res_partner p
			--JOIN marketing._m_sproc_rpt_giften('YTD', now()::date, now()::date, 15) g ON g.partner_id = p.id
		WHERE COALESCE(p.organisation_type_id,0) = 0 
		GROUP BY partner_id, p.name, p.corporation_type_id, p.national_id_nbr, p.company_registration_number
	) sq1
WHERE rrn_on_t > 0	
WHERE sq1.bedrag >= 40	
WHERE sq1.bedrag BETWEEN 30 AND 39.999
------------------------------------
-- Ondernemingsnummer per id
------------------------------------
SELECT p.id, COALESCE(regexp_replace(p.company_registration_number, '\D','','g'),'') "O.N."
FROM res_partner p
WHERE p.id IN (416367,408600,419506,419504,412170,419480,384253,261879,391479,115566,398888,372635,371138,397649,419002,235265,415293,416899,397726,167927,416356,416833,408093,416911,418692,415282,417683,347260,339296,343342,413257,416750,401931,418751,419098,337202,417729,415022,419103,387766,416064,417161,193503,417201,415387,416748,112983,416029,416752,416769,316348,361477,381548,409627,99444,417547,413588,390088,418035,345609,401122,65942,337842,262304,416190,411341,371022,416923,316677,171200,255067,324294,415283,234722,254677,418524,259049,127455,90913,309347,164647,346658,291761,414801,154524,325844,320975,329329,370047,281830,289965,32089,210361,332999,133994,348013,345924,112029,258577,412661,341195,412660,417253,411011,16831,15045,16569,393732,18725,259888,351052,409119,415773,418869,416768,316515,366068,416362,409465,209823,319894,416891,416916,376073,416834,14873,223458,419365,16346,382011,15323,16454,15180,378364,416658,232496,14674,255360,302602,404460,389009,15892,417252,14821,141228,276755,369506,15273,412925,15169,322193,257406,416829,323118,259819,247961,262720,19046,17678,293956,415682,76088,391997,311506,368218,82342,361249,154609,403512,416361,16654,16048,418205,411212,409423,222123,224986,274337,419482,315380,19677,393216,417088,234578,328440,366670,263330,419369,249289,225270,418494);
	

	