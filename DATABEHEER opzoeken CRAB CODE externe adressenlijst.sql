DROP TABLE IF EXISTS marketing._AV_temp_ontdubbelingalgemeen;

CREATE TABLE marketing._AV_temp_ontdubbelingalgemeen 
(bron_id NUMERIC,
 dummy1 TEXT,
 voornaam TEXT,
 naam TEXT,
 straat TEXT,
 nummer TEXT,
 dummy2 TEXT,
 postcode TEXT,
 gemeente TEXT,
 dummy3 TEXT,
 dummy4 TEXT,
 email TEXT
 --, lidnummer TEXT
);

SELECT * FROM marketing._AV_temp_ontdubbelingalgemeen
--======================================================
--======================================================
SELECT * FROM
	(
	SELECT sq2.bron_id, sq2.bron_straat, sq2.ccs_straat, sq2.code, MAX(sq2.r) r
	FROM
		(
		SELECT sq1.*, ROW_NUMBER() OVER (PARTITION BY sq1.bron_straat ORDER BY sq1.sim_straat ASC) AS r
		FROM
			(
			SELECT DISTINCT bron.bron_id, bron.straat bron_straat,
				ccs.name ccs_straat,
				ccs.code,			
				similarity(ccs.name,bron.straat) sim_straat
			FROM marketing._AV_temp_ontdubbelingalgemeen bron, res_partner p
				--JOIN res_partner p ON p.email = bb.email
				JOIN res_country c ON p.country_id = c.id
				JOIN res_country_city_street ccs ON p.street_id = ccs.id
				JOIN res_country_city cc ON p.zip_id = cc.id
			WHERE cc.zip = bron.postcode
				AND similarity(ccs.name,bron.straat) > 0.4
			ORDER BY bron.straat, similarity(ccs.name,bron.straat) ASC
			) sq1
		) sq2
	GROUP BY sq2.bron_straat, sq2.bron_id, sq2.ccs_straat, sq2.code 
	) sq5
	JOIN
	(SELECT sq4.bron_id, MAX(sq4.r) r
	FROM
		(
		SELECT sq3.*, ROW_NUMBER() OVER (PARTITION BY sq3.bron_straat ORDER BY sq3.sim_straat ASC) AS r
		FROM
			(
			SELECT DISTINCT bron.bron_id, bron.straat bron_straat,
				ccs.name ccs_straat,
				ccs.code,			
				similarity(ccs.name,bron.straat) sim_straat
			FROM marketing._AV_temp_ontdubbelingalgemeen bron, res_partner p
				--JOIN res_partner p ON p.email = bb.email
				JOIN res_country c ON p.country_id = c.id
				JOIN res_country_city_street ccs ON p.street_id = ccs.id
				JOIN res_country_city cc ON p.zip_id = cc.id
			WHERE cc.zip = bron.postcode
				AND similarity(ccs.name,bron.straat) > 0.4
			ORDER BY bron.straat, similarity(ccs.name,bron.straat) ASC
			) sq3
		) sq4
	GROUP BY sq4.bron_id 
	) sq6
	ON sq5.bron_id = sq6.bron_id AND sq5.r = sq6.r

	
