-------------------------------------------------------------
-- CREATE TABLE marketing._m_temp_datavalidatieOUT
-- CREATE TABLE marketing._m_temp_datavalidatieOUTR2U
-- CONTROLE verhuizers: check op out_movedscore
-- losse test queries
-- 
-------------------------------------------------------------
CREATE TABLE marketing._m_temp_datavalidatieOUT
(database_id numeric,
 voornaam text, achternaam text,
 building text, straat text, huisnummer text,bus text, postcode text, woonplaats text, postbus text, land text, email text,
 edmid numeric, out_gender text, out_firstname text, out_lastname text, out_dateofbirth date,
 out_street text, out_housenr text, out_housenr_add text, out_postalcode text, out_city text, out_country text, 
 out_phone text, out_mobile text, out_language text, 
 out_addressin numeric, out_deceased numeric, out_comp_deceased numeric,
 out_ref text, out_moved numeric, out_movedscore text, 
 out_dup_addressgroup numeric, out_dup_addressrank numeric, out_dup_persongroup numeric, out_dup_personrank numeric, out_robinson numeric, 
 out_comp_gender numeric, out_comp_firstname numeric, out_comp_lastnameprefix numeric, out_comp_lastname numeric, out_comp_dateofbirth numeric, 
 out_comp_street numeric, out_comp_housenr numeric, out_comp_housenr_add numeric, out_comp_postalcode numeric, out_comp_city numeric, 
 out_comp_phone numeric, out_comp_mobile numeric, out_comp_language numeric
);
SELECT * FROM marketing._m_temp_datavalidatieOUT;
-------------------------------------------------------------
CREATE TABLE marketing._m_temp_datavalidatieOUTR2U
(database_id numeric,
 voornaam text, achternaam text,
 building text, straat text, huisnummer text,bus text, postcode text, woonplaats text, postbus text, land text, email text,
 edmid numeric, out_gender text, out_firstname text, out_lastname text, out_salutation text,
 out_street character varying, out_housenr text, out_housenr_add text, out_postalcode text, out_city text, out_country text,
 out_phone text, out_mobile text, out_language text, 
 out_dup_addressgroup numeric, out_dup_addressrank numeric, out_robinson numeric
);
SELECT * FROM marketing._m_temp_datavalidatieOUTR2U;
-------------------------------------------------------------
/*
DROP TABLE marketing._m_temp_datavalidatieOUT;
DROP TABLE marketing._m_temp_datavalidatieOUTR2U;
*/
-------------------------------------------------------------
-- CONTROLE verhuizers: check op out_movedscore IN ('A1','A2','B1','B2') (zie docu voor betekenis)
-- tegen res_country_city tabellen
-- volgens max_sim_straat (1 = 100% match; -1 = met manuele check)
-------------------------------------------------------------
SELECT sq3.*
FROM
	(SELECT sq1.partner_id, sq1.cc_id, sq1.cc_name, sq1.cc_zip, sq1.ccs_id, sq1.ccs_name, sq1.out_housenr, sq1.out_housenr_add, max(sq1.sim_straat) max_sim_straat, sq1.voornaam, sq1.achternaam, sq1.building, sq1.straat, sq1.huisnummer, sq1.bus, sq1.postcode, sq1.woonplaats, sq1.land, sq1.email,
		sq1.edmid, sq1.out_firstname, sq1.out_lastname, sq1.out_street, sq1.out_housenr, sq1.out_housenr_add, sq1.out_postalcode, sq1.out_city, sq1.out_country, sq1.out_dup_addressgroup, sq1.out_dup_addressrank, sq1.out_robinson
	FROM
		(SELECT out1.database_id partner_id, cc.id cc_id, cc.name cc_name, cc.zip cc_zip, ccs.id ccs_id, ccs.name ccs_name, similarity(ccs.name,out1.out_street) sim_straat, out1.*
		FROM marketing._m_temp_datavalidatieOUTR2U out1
			JOIN marketing._m_temp_datavalidatieOUT out2 ON out2.edmid = out1.edmid
			JOIN public.res_country_city cc ON cc.zip = out1.out_postalcode
			JOIN public.res_country_city_street ccs ON ccs.city_id = cc.id
		WHERE out2.out_moved = 1 AND out2.out_movedscore IN ('A1','A2','B1','B2')
		 	AND cc.active
			--AND out1.out_country <> 'BE' -- 0
		 ) sq1
	GROUP BY sq1.partner_id, sq1.cc_id, sq1.cc_name, sq1.cc_zip, sq1.ccs_id, sq1.ccs_name, sq1.voornaam, sq1.achternaam, sq1.building, sq1.straat, sq1.huisnummer, sq1.bus, sq1.postcode, sq1.woonplaats, sq1.land, sq1.email,
		sq1.edmid, sq1.out_firstname, sq1.out_lastname, sq1.out_street, sq1.out_housenr, sq1.out_housenr_add, sq1.out_postalcode, sq1.out_city, sq1.out_country, sq1.out_dup_addressgroup, sq1.out_dup_addressrank, sq1.out_robinson
	) sq3
	JOIN
	(SELECT sq1.edmid, max(sq1.sim_straat) max_sim_straat
	FROM
		(SELECT out1.edmid, similarity(ccs.name,out1.out_street) sim_straat
		FROM marketing._m_temp_datavalidatieOUTR2U out1
			JOIN marketing._m_temp_datavalidatieOUT out2 ON out2.edmid = out1.edmid
			JOIN public.res_country_city cc ON cc.zip = out1.out_postalcode
			JOIN public.res_country_city_street ccs ON ccs.city_id = cc.id
		WHERE out2.out_moved = 1 AND out2.out_movedscore IN ('A1','A2','B1','B2')
		 	AND cc.active
		 ) sq1
	GROUP BY sq1.edmid
	) sq4
	ON sq4.edmid = sq3.edmid AND sq4.max_sim_straat = sq3.max_sim_straat
WHERE sq4.max_sim_straat < 1	
-------------------------------------------------------------
-- losse test queries
-------------------------------------------------------------
SELECT * FROM public.res_country_city LIMIT 10
SELECT id FROM res_partner WHERE address_state_id = 7
SELECT * FROM res_partner_address_state WHERE 
-------------------------------------------------------------
-- datavalidatie checken tegen adres status "adres verkeerd"
-------------------------------------------------------------
SELECT p.id, p.street, out2.*
FROM res_partner p
	JOIN marketing._m_temp_datavalidatieout out2 ON out2.database_id = p.id
WHERE p.active AND p.address_state_id IN (2,3)



