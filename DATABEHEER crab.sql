--========================================================================
-- aanmaak tabel voor import crab mdb
--------------------------------------------------------------------------
--DROP TABLE IF EXISTS marketing._m_so_crab;

CREATE TABLE marketing._m_so_crab
(gemid numeric,
 gemnm text,
 straatnmid numeric,
 straatnm text,
 pkancode text,
 postkannm text
);

SELECT * FROM marketing._m_so_crab WHERE straatnm LIKE 'Spinnerij%'
--========================================================================
-- ERP crab lijst
--------------------------------------------------------------------------
SELECT ccs.id ccs_id, ccs.code crab_code, ccs.name, cc.id cc_id, ccs.zip, cc.name
FROM res_country_city cc
	JOIN res_country_city_street ccs ON cc.id = ccs.city_id
--WHERE ccs.code IN (217596) --ccs.code voor crabcode
--WHERE ccs.id = 1679002 
--WHERE ccs.zip IN ('9910','9880') AND  LOWER(ccs.name) = 'driesstraat'
--WHERE cc.name = 'Dendermonde' AND  LOWER(ccs.name) LIKE 'leopold%'
--WHERE LOWER(ccs.name) = 'rue du tilleul'
ORDER BY ccs.id DESC
LIMIT 100
--========================================================================
-- ERP crab lijst ZONDER CRAB-code
-- - geeft een lijst van straatnamen + postcodes 
-- - waarvoor er geen CRAB-code in de database zit
--------------------------------------------------------------------------
SELECT ccs.id ccs_id, ccs.code crab_code, ccs.name ccs_name, cc.id cc_id, ccs.zip, cc.name cc_name, p.id p_id, p.name p_name
FROM res_country_city cc
	JOIN res_country_city_street ccs ON cc.id = ccs.city_id
	JOIN res_partner p ON p.street_id = ccs.id
WHERE cc.active AND ccs.country_id = 21 AND p.active
	AND COALESCE(ccs.code,0) = 0 --ccs.code voor crabcode
ORDER BY ccs.zip DESC
--========================================================================
-- ERP crab lijst ZONDER CRAB-code (prefix: "partner")
-- - geeft een lijst van straatnamen + postcodes 
-- - waarvoor er geen CRAB-code in de database zit
-- - met vgl CRAB-lijst in erp (prefix: "erp")
-- - met vgl CRAB-lijst AGIV (prefix: "agiv")
--------------------------------------------------------------------------
SELECT DISTINCT sq1.ccs_id partner_ccs_id, sq1.crab_code partner_crab_code, sq1.ccs_name partner_ccs_name, sq1.cc_id partner_cc_id, sq1.ccs_zip partner_cc_zip, sq1.cc_name partner_cc_name, sq1.p_id, sq1.p_name, 
	ccs.id erp_ccs_id, ccs.code erp_crab_code, ccs.zip erp_ccs_zip, ccs.name erp_ccs_name, similarity(ccs.zip||ccs.name,sq1.ccs_zip||sq1.ccs_name) erp_sim_adres,
	sq2.straatnmid agiv_straatnmid, sq2.pkancode agiv_pkancode, sq2.straatnm agiv_straatnm, similarity(sq1.ccs_name,sq2.straatnm) agiv_sim_adres
FROM (SELECT ccs.id ccs_id, ccs.code crab_code, ccs.name ccs_name, cc.id cc_id, ccs.zip ccs_zip, cc.name cc_name, p.id p_id, p.name p_name
	FROM res_country_city cc
		JOIN res_country_city_street ccs ON cc.id = ccs.city_id
		JOIN res_partner p ON p.street_id = ccs.id
	WHERE cc.active AND ccs.country_id = 21 AND p.active
		AND COALESCE(ccs.code,0) = 0 --ccs.code voor crabcode
	ORDER BY ccs.zip DESC) sq1,
	marketing._m_so_crab sq2,
	res_country_city cc
	JOIN res_country_city_street ccs ON cc.id = ccs.city_id
	JOIN res_partner p ON p.street_id = ccs.id
WHERE cc.active AND ccs.country_id = 21 AND p.active
	AND COALESCE(ccs.code,0) <> 0 --ccs.code voor crabcode
	AND ccs.zip = sq1.ccs_zip AND similarity(ccs.name,sq1.ccs_name) >= 0.4
	AND sq2.pkancode = sq1.ccs_zip AND similarity(sq1.ccs_name,sq2.straatnm) >= 0.4
ORDER BY ccs.zip DESC
--========================================================================
-- zelfde CRAB-code: verschil in combinatie postcode+straatnaam
--------------------------------------------------------------------------
SELECT ccs.id erp_ccs_id, ccs.code erp_crab_code, ccs.zip erp_zip, ccs.name erp_straatnaam,
	crab.straatnmid crab_code, crab.pkancode crab_zip, crab.straatnm crab_straatnaam
FROM res_country_city cc
	JOIN res_country_city_street ccs ON ccs.city_id = cc.id
	JOIN marketing._m_so_crab crab ON crab.straatnmid = ccs.code
WHERE cc.active AND NOT(ccs.zip||ccs.name = crab.pkancode||crab.straatnm)	
--========================================================================
-- CRAB-code in AGIV niet in ERP met import format (in commentaar)
--------------------------------------------------------------------------
SELECT ccs.id erp_ccs_id, ccs.code erp_crab_code, ccs.zip erp_zip, ccs.name erp_straatnaam,
	crab.straatnmid crab_code, crab.pkancode crab_zip, crab.straatnm crab_straatnaam
--SELECT 	crab.straatnmid||'|'||crab.pkancode||'|'||crab.straatnm crab_import
FROM res_country_city cc
	JOIN res_country_city_street ccs ON ccs.city_id = cc.id
	FULL OUTER JOIN marketing._m_so_crab crab ON crab.straatnmid = ccs.code
WHERE COALESCE(ccs.code,0) = 0 AND COALESCE(crab.straatnmid,0) > 0
ORDER BY crab.pkancode
--========================================================================
-- 
--------------------------------------------------------------------------
SELECT * FROM res_country_city_street ccs LIMIT 10
SELECT * FROM marketing._m_so_crab LIMIT 10;
