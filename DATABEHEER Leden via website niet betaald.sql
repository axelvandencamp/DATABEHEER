--SET VARIABLES
DROP TABLE IF EXISTS _AV_myvar;
CREATE TEMP TABLE _AV_myvar 
	(startdatum DATE, einddatum DATE
	 ,afdeling NUMERIC, postcode TEXT, herkomst_lidmaatschap NUMERIC, wervende_organisatie NUMERIC, test_id NUMERIC
	 );

INSERT INTO _AV_myvar VALUES('2021-01-01',	--startdatum
				'2021-08-19'	--einddatum
				);
SELECT * FROM _AV_myvar;
--==============================================================
SELECT p.id, sq3.login, sq3.create_date, p.membership_start,
	CASE WHEN sq1.membership_state = 'none' THEN 'nieuw' --ELSE
		WHEN sq1.membership_state = 'wait_member' THEN 'hernieuwing'
	END type_lid,
	sq1.*,
	SQ2.*
FROM _AV_myvar v, res_partner p
	JOIN
		(SELECT DISTINCT p.id, p.create_date::date create_date, u.login
		FROM _AV_myvar v, res_partner p
			JOIN res_users u ON u.id = p.create_uid
		 	JOIN membership_membership_line ml ON ml.partner = p.id
		WHERE p.active AND p.membership_state = 'none' AND u.login = 'apiuser'
			AND p.create_date::date BETWEEN v.startdatum AND v.einddatum

		UNION ALL
		--SELECT u.login, p.membership_state, p.id, ml.* 
		SELECT p.id, ml.create_date::date create_date, u.login
		FROM _av_myvar v, membership_membership_line ml 
			JOIN res_users u ON u.id = ml.create_uid 
			JOIN res_partner p ON p.id = ml.partner
		WHERE ml.create_date::date BETWEEN v.startdatum AND v.einddatum
			AND u.login = 'apiuser'
			AND p.membership_state = 'wait_member') sq3
	ON sq3.id = p.id
	JOIN (SELECT * FROM marketing._CRM_partnerinfo()) SQ1 ON SQ1.partner_id = p.id
	--Voor de ontdubbeling veroorzaakt door meedere lidmaatschapslijnen
	LEFT OUTER JOIN (SELECT MAX(ml.id) ml_id, partner FROM _av_myvar v, membership_membership_line ml JOIN product_product pp ON pp.id = ml.membership_id WHERE pp.membership_product GROUP BY partner) ml ON ml.partner = p.id
	--factuur info
	LEFT OUTER JOIN (SELECT * FROM marketing._crm_leden_factuurinfo()) SQ2 ON SQ2.id = ml.ml_id
	--user infor
	JOIN res_users u ON u.id = p.create_uid
