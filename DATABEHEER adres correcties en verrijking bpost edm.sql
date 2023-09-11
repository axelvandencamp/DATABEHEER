-------------------------------------------------------------
-- CREATE TABLE marketing._m_temp_datavalidatieOUT
-- CREATE TABLE marketing._m_temp_datavalidatieOUTR2U
-- CONTROLE verhuizers: check op out_movedscore
-- losse test queries
-- 
-------------------------------------------------------------
-------------------------------------------------------------
CREATE TABLE marketing._m_temp_datavalidatie
(out_dq_id numeric, database_id numeric,
 geslacht text, voornaam text, achternaam text,
 /*building text,*/ straat text, huisnummer text,bus text, postcode text, woonplaats text, /*postbus text, land text, email text,*/ taal text,
 out_moved numeric, out_match_level text, out_addr_in numeric, out_st_nm text, out_house_num text, out_box_num text, out_post_cd text, out_city text,
 out_cntrct_id numeric, out_move_dt text /*later omzetten naar datum indien nodig*/, out_cntry_cd text, out_robinson numeric
);
SELECT * FROM marketing._m_temp_datavalidatie;
-- DELETE FROM marketing._m_temp_datavalidatie;
-------------------------------------------------------------
/*
DROP TABLE marketing._m_temp_datavalidatie;
*/
-------------------------------------------------------------
-- CONTROLE verhuizers: check op out_movedscore IN ('A1','A2','B1','B2') (zie docu voor betekenis)
-- tegen res_country_city tabellen
-- volgens max_sim_straat (1 = 100% match; -1 = met manuele check)
-- check op aantal te importeren records: 
SELECT * FROM marketing._m_temp_datavalidatie WHERE out_moved = 2 AND out_match_level = 'P' AND out_addr_in IN (1,2)
-- check op postcodes: 
SELECT DISTINCT out1.out_post_cd, cc.zip FROM marketing._m_temp_datavalidatie out1 LEFT OUTER JOIN public.res_country_city cc ON cc.zip = out1.out_post_cd WHERE COALESCE(cc.zip,'_') = '_'
-------------------------------------------------------------
-- datavalidatie checken tegen adres status "adres verkeerd" & "adres vermoedelijk verkeerd"
-- - aanpassen voor "tot nader order niet aanpassen"
-- - aanpassen voor "bpost_datavalidatie"
-- - export "import data" aanpassen
-------------------------------------------------------------
SELECT p.id, ccs.id street_id, out_house_num street_nbr, out_box_num street_bus -- import bestand
--SELECT p.id, p.street, out2.* -- details
FROM res_partner p
	JOIN marketing._m_temp_datavalidatie out2 ON out2.database_id = p.id
	 JOIN public.res_country_city_street ccs ON ccs.id = p.street_id
	 JOIN public.res_country_city cc ON cc.id = p.zip_id
WHERE out_moved = 2 AND out_match_level = 'P' AND out_addr_in IN (1,2)
	-- AND p.active AND p.address_state_id = 7 -- tot nader order niet aanpassen 
	 AND p.active AND COALESCE(p.address_state_id,0) <> 7 -- tot nader order niet aanpassen
	-- AND p.active AND p.address_state_id = 12 -- bpost adres validatie
	-- AND p.active AND p.address_state_id IN (2,3)   -- verkeerd & vermoedelijk verkeerd
-------------------------------------------------------------
-- adressen uit input file zonder match pc in CRAB
-------------------------------------------------------------
SELECT * 
FROM marketing._m_temp_datavalidatie out1
	JOIN
	(SELECT DISTINCT out1.out_post_cd, cc.zip 
	FROM marketing._m_temp_datavalidatie out1 
	 	JOIN res_partner p ON p.id = out1.database_id
		LEFT OUTER JOIN public.res_country_city cc ON cc.zip = out1.out_post_cd 
	WHERE COALESCE(cc.zip,'_') = '_'
		AND COALESCE(p.address_state_id,0) <> 7) sq1 ON sq1.out_post_cd = out1.out_post_cd
-------------------------------------------------------------
SELECT sq3.*
FROM
	(SELECT sq1.partner_id, sq1.address_state_id, sq1.cc_id, sq1.cc_name, sq1.cc_zip, sq1.ccs_id, sq1.ccs_name, sq1.out_house_num, sq1.out_box_num, max(sq1.sim_straat) max_sim_straat, sq1.voornaam, sq1.achternaam, /*sq1.building,*/ sq1.straat, sq1.huisnummer, sq1.bus, sq1.postcode, sq1.woonplaats, /*sq1.land, sq1.email,*/
		sq1.out_dq_id, sq1.out_st_nm, sq1.out_house_num, sq1.out_box_num, sq1.out_post_cd, sq1.out_city, sq1.out_cntrct_id, sq1.out_cntry_cd, sq1.out_robinson
	FROM 
	 --SELECT sq1.partner_id, max(sim_straat) sim_straat FROM
		(SELECT out1.database_id partner_id, p.address_state_id, cc.id cc_id, cc.name cc_name, cc.zip cc_zip, ccs.id ccs_id, ccs.name ccs_name, similarity(ccs.name,out1.out_st_nm) sim_straat, out1.*
		FROM marketing._m_temp_datavalidatie out1
			JOIN public.res_partner p ON p.id = out1.database_id
		 	JOIN public.res_country_city cc ON cc.zip = out1.out_post_cd
			JOIN public.res_country_city_street ccs ON ccs.city_id = cc.id
		WHERE out1.out_moved = 2 AND out1.out_match_level = 'P' AND out1.out_addr_in IN (1,2)
		 	AND COALESCE(p.address_state_id,0) <> 7
		 	--AND cc.active
			--AND out1.out_country <> 'BE' -- 0
		 ) sq1
	 --GROUP BY sq1.partner_id
	GROUP BY sq1.partner_id, sq1.address_state_id, sq1.cc_id, sq1.cc_name, sq1.cc_zip, sq1.ccs_id, sq1.ccs_name, sq1.out_house_num, sq1.out_box_num, sq1.voornaam, sq1.achternaam, /*sq1.building,*/ sq1.straat, sq1.huisnummer, sq1.bus, sq1.postcode, sq1.woonplaats, /*sq1.land, sq1.email,*/
		sq1.out_dq_id, sq1.out_st_nm, sq1.out_house_num, sq1.out_box_num, sq1.out_post_cd, sq1.out_city, sq1.out_cntrct_id, sq1.out_cntry_cd, sq1.out_robinson
	) sq3
	JOIN
	(SELECT sq1.out_dq_id, max(sq1.sim_straat) max_sim_straat
	FROM
		(SELECT out1.out_dq_id, similarity(ccs.name,out1.out_st_nm) sim_straat
		 FROM marketing._m_temp_datavalidatie out1
			JOIN public.res_country_city cc ON cc.zip = out1.out_post_cd
			JOIN public.res_country_city_street ccs ON ccs.city_id = cc.id
		WHERE out1.out_moved = 2 AND out1.out_match_level = 'P' AND out1.out_addr_in IN (1,2)
		 	AND cc.active
		 ) sq1
	GROUP BY sq1.out_dq_id
	) sq4
	ON sq4.out_dq_id = sq3.out_dq_id AND sq4.max_sim_straat = sq3.max_sim_straat
WHERE sq4.max_sim_straat < 1	

-------------------------------------------------------------
-- losse test queries
-------------------------------------------------------------
SELECT * FROM public.res_country_city LIMIT 10
SELECT id FROM res_partner WHERE address_state_id = 7
SELECT * FROM res_partner_address_state WHERE id = 12 -- IN (2,3) -- = 7 -- 






