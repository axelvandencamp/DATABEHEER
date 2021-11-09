------------------------------------------------------------------
-- aanmaken _av_temp_mindwize
------------------------------------------------------------------
/*
DROP TABLE IF EXISTS marketing._av_temp_mindwize;

CREATE TABLE marketing._av_temp_mindwize (
	bron_id integer,
	Voornaam text,
	Achternaam text,
	email text,
	Telefoonnummer text,
	adset_name text,
	email_opt_in text
);

SELECT  * FROM marketing._av_temp_mindwize bron WHERE bron_id = 2;
*/
-------------------------------------------------
--aanmaken controle tabel voor 'automatische' controle
-------------------------------------------------
DROP TABLE IF EXISTS marketing._AV_temp_controletabel;

CREATE TABLE marketing._AV_temp_controletabel
(bron_id NUMERIC,
 id NUMERIC,
 first_name TEXT,
 last_name TEXT,
 bron_naam TEXT,
 email TEXT,
 email_work TEXT,
 bron_email TEXT,
 telefoon TEXT,
 telefoon_werk TEXT,
 gsm TEXT,
 bron_telefoon TEXT,
 inactieve_dubbel TEXT,
 actieve_partner_id NUMERIC,
 status_dubbel TEXT,
 active TEXT,
 deceased TEXT,
 status TEXT,
 create_uid NUMERIC,
 partner TEXT,
 status_partner TEXT,
 sim_naam NUMERIC,
 sim_partner NUMERIC,
 sim_email NUMERIC,
 sim_emailwerk NUMERIC,
 check_naam NUMERIC,
 check_email NUMERIC,
 check_email_work NUMERIC,
 check_telefoon NUMERIC,
 check_telelfoon_werk NUMERIC,
 check_gsm NUMERIC,
 controle NUMERIC,
 r NUMERIC,
 type_controle TEXT,
 lid NUMERIC
);
------------------------------------------------------------------
-- controle naam
------------------------------------------------------------------
INSERT INTO marketing._AV_temp_controletabel (
	SELECT *, 'naam' AS type_controle, CASE WHEN sim_naam = 1 THEN 1 WHEN sim_naam BETWEEN 1 AND 0.4 THEN 2 ELSE 0 END AS lid
	FROM	(
		SELECT y.*, 
		ROW_NUMBER() OVER (PARTITION BY bron_id ORDER BY controle DESC, sim_naam DESC) AS r
		FROM	--myvar v, 
			(
			SELECT x.*, (x.check_naam + x.check_email + x.check_email_work + x.check_telefoon + x.check_telefoon_werk + + x.check_gsm) controle
			FROM (SELECT bron.bron_id bron_id, p.id, 
					p.first_name, p.last_name, RTRIM(LTRIM(bron.Voornaam)) || ' ' || RTRIM(LTRIM(bron.achternaam)) bron_naam, 
					p.email, p.email_work, bron.email bron_email, 
					CASE
						WHEN substr(p.phone,1,2) = '00' THEN '+'||regexp_replace(substr(p.phone,3,length(p.phone)), '[^0-9]+', '', 'g')
						WHEN substr(p.phone,1,3) = '+32' THEN '+'||regexp_replace(p.phone, '[^0-9]+', '', 'g')
						WHEN substr(p.phone,1,1) = '0' THEN '+32'||regexp_replace(substr(p.phone,2,length(p.phone)), '[^0-9]+', '', 'g')
						WHEN LENGTH(regexp_replace(p.phone, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(p.phone, '[^0-9]+', '', 'g')
						WHEN LENGTH(p.phone) > 0 THEN '+32'||regexp_replace(p.phone, '[^0-9]+', '', 'g')
						ELSE p.phone
					END telefoon, 
				  	CASE
						WHEN substr(p.phone_work,1,2) = '00' THEN '+'||regexp_replace(substr(p.phone_work,3,length(p.phone_work)), '[^0-9]+', '', 'g')
						WHEN substr(p.phone_work,1,3) = '+32' THEN '+'||regexp_replace(p.phone_work, '[^0-9]+', '', 'g')
						WHEN substr(p.phone_work,1,1) = '0' THEN '+32'||regexp_replace(substr(p.phone_work,2,length(p.phone_work)), '[^0-9]+', '', 'g')
						WHEN LENGTH(regexp_replace(p.phone_work, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(p.phone_work, '[^0-9]+', '', 'g')
						WHEN LENGTH(p.phone_work) > 0 THEN '+32'||regexp_replace(p.phone_work, '[^0-9]+', '', 'g')
						ELSE p.phone_work
					END  telefoon_werk, 
				  	CASE
						WHEN substr(p.mobile,1,2) = '00' THEN '+'||regexp_replace(substr(p.mobile,3,length(p.mobile)), '[^0-9]+', '', 'g')
						WHEN substr(p.mobile,1,3) = '+32' THEN '+'||regexp_replace(p.mobile, '[^0-9]+', '', 'g')
						WHEN substr(p.mobile,1,1) = '0' THEN '+32'||regexp_replace(substr(p.mobile,2,length(p.mobile)), '[^0-9]+', '', 'g')
						WHEN LENGTH(regexp_replace(p.mobile, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(p.mobile, '[^0-9]+', '', 'g')
						WHEN LENGTH(p.mobile) > 0 THEN '+32'||regexp_replace(p.mobile, '[^0-9]+', '', 'g')
						ELSE p.mobile
					END  gsm, 
				  	CASE
						WHEN substr(bron.telefoonnummer,1,2) = '00' THEN '+'||regexp_replace(substr(bron.telefoonnummer,3,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
						WHEN substr(bron.telefoonnummer,1,3) = '+32' THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
						WHEN substr(bron.telefoonnummer,1,1) = '0' THEN '+32'||regexp_replace(substr(bron.telefoonnummer,2,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
						WHEN LENGTH(regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
						WHEN LENGTH(bron.telefoonnummer) > 0 THEN '+32'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
						ELSE p.mobile
					END  bron_telefoon,
					p.membership_nbr,
					CASE
						WHEN p.inactive_id IN (1,8) THEN p.active_partner_id ELSE 0
					END actieve_partner_id,
					p3.membership_state,
					p.active, p.deceased, p.membership_state status, 
					p.create_uid,
					p2.id, p2.membership_state,
					similarity(p.name,bron.voornaam || ' ' || bron.achternaam) sim_naam,
					similarity(p2.name,bron.Voornaam || ' ' || bron.achternaam) sim_partner,
					similarity(COALESCE(p.email,'_'),bron.email) sim_email,
					similarity(COALESCE(p.email_work,'_'),bron.email) sim_emailwerk,
					--
					CASE WHEN RTRIM(LTRIM(LOWER(p.name))) = RTRIM(LTRIM(LOWER(bron.Voornaam || ' ' || bron.achternaam))) THEN 1 ELSE 0 END check_naam,
					CASE WHEN RTRIM(LTRIM(LOWER(p.email))) = RTRIM(LTRIM(LOWER(bron.email))) THEN 1 ELSE 0 END check_email,
					CASE WHEN RTRIM(LTRIM(LOWER(p.email_work))) = RTRIM(LTRIM(LOWER(bron.email))) THEN 1 ELSE 0 END check_email_work,
				  	--phone
					CASE WHEN 
				  			CASE
								WHEN substr(p.phone,1,2) = '00' THEN '+'||regexp_replace(substr(p.phone,3,length(p.phone)), '[^0-9]+', '', 'g')
								WHEN substr(p.phone,1,3) = '+32' THEN '+'||regexp_replace(p.phone, '[^0-9]+', '', 'g')
								WHEN substr(p.phone,1,1) = '0' THEN '+32'||regexp_replace(substr(p.phone,2,length(p.phone)), '[^0-9]+', '', 'g')
								WHEN LENGTH(regexp_replace(p.phone, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(p.phone, '[^0-9]+', '', 'g')
								WHEN LENGTH(p.phone) > 0 THEN '+32'||regexp_replace(p.phone, '[^0-9]+', '', 'g')
				  				ELSE p.phone
							END
				  		=
				  			CASE
								WHEN substr(bron.telefoonnummer,1,2) = '00' THEN '+'||regexp_replace(substr(bron.telefoonnummer,3,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
								WHEN substr(bron.telefoonnummer,1,3) = '+32' THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
								WHEN substr(bron.telefoonnummer,1,1) = '0' THEN '+32'||regexp_replace(substr(bron.telefoonnummer,2,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
								WHEN LENGTH(regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
								WHEN LENGTH(bron.telefoonnummer) > 0 THEN '+32'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
				  				ELSE bron.telefoonnummer
							END
				  		THEN 1 ELSE 0 END check_telefoon,
				  	--phone_work
				  	CASE WHEN 
				  			CASE
								WHEN substr(p.phone_work,1,2) = '00' THEN '+'||regexp_replace(substr(p.phone_work,3,length(p.phone_work)), '[^0-9]+', '', 'g')
								WHEN substr(p.phone_work,1,3) = '+32' THEN '+'||regexp_replace(p.phone_work, '[^0-9]+', '', 'g')
								WHEN substr(p.phone_work,1,1) = '0' THEN '+32'||regexp_replace(substr(p.phone_work,2,length(p.phone_work)), '[^0-9]+', '', 'g')
								WHEN LENGTH(regexp_replace(p.phone_work, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(p.phone_work, '[^0-9]+', '', 'g')
								WHEN LENGTH(p.phone_work) > 0 THEN '+32'||regexp_replace(p.phone_work, '[^0-9]+', '', 'g')
								ELSE p.phone_work
							END
				  		=
				  			CASE
								WHEN substr(bron.telefoonnummer,1,2) = '00' THEN '+'||regexp_replace(substr(bron.telefoonnummer,3,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
								WHEN substr(bron.telefoonnummer,1,3) = '+32' THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
								WHEN substr(bron.telefoonnummer,1,1) = '0' THEN '+32'||regexp_replace(substr(bron.telefoonnummer,2,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
								WHEN LENGTH(regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
								WHEN LENGTH(bron.telefoonnummer) > 0 THEN '+32'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
				  				ELSE bron.telefoonnummer
							END THEN 1 ELSE 0 END check_telefoon_werk,
				  	--mobile
				  	CASE WHEN 
				  			CASE
								WHEN substr(p.mobile,1,2) = '00' THEN '+'||regexp_replace(substr(p.mobile,3,length(p.mobile)), '[^0-9]+', '', 'g')
								WHEN substr(p.mobile,1,3) = '+32' THEN '+'||regexp_replace(p.mobile, '[^0-9]+', '', 'g')
								WHEN substr(p.mobile,1,1) = '0' THEN '+32'||regexp_replace(substr(p.mobile,2,length(p.mobile)), '[^0-9]+', '', 'g')
								WHEN LENGTH(regexp_replace(p.mobile, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(p.mobile, '[^0-9]+', '', 'g')
								WHEN LENGTH(p.mobile) > 0 THEN '+32'||regexp_replace(p.mobile, '[^0-9]+', '', 'g')
								ELSE p.mobile
							END
				  		=
				  			CASE
								WHEN substr(bron.telefoonnummer,1,2) = '00' THEN '+'||regexp_replace(substr(bron.telefoonnummer,3,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
								WHEN substr(bron.telefoonnummer,1,3) = '+32' THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
								WHEN substr(bron.telefoonnummer,1,1) = '0' THEN '+32'||regexp_replace(substr(bron.telefoonnummer,2,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
								WHEN LENGTH(regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
								WHEN LENGTH(bron.telefoonnummer) > 0 THEN '+32'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
				  				ELSE bron.telefoonnummer
							END THEN 1 ELSE 0 END check_gsm
				FROM marketing._av_temp_mindwize bron, res_partner p
					--gegevens van eventuele partner
					LEFT OUTER JOIN res_partner p2 ON p.relation_partner_id = p2.id
					LEFT OUTER JOIN partner_inactive pi ON p.inactive_id = pi.id
					LEFT OUTER JOIN res_partner p3 ON p.active_partner_id = p3.id	
				WHERE similarity(p.name,bron.voornaam || ' ' || bron.achternaam) >= 0.4
				--*/
				) x
			) y
		ORDER BY bron_id--, controle, sim_naam DESC	
		) z
	WHERE r = 1);
------------------------------------------------------------------
-- controle email
------------------------------------------------------------------
INSERT INTO marketing._AV_temp_controletabel (
	SELECT *, 'email' AS type_controle, 1 AS lid
	FROM	(
		SELECT y.*, 
		ROW_NUMBER() OVER (PARTITION BY bron_id ORDER BY controle DESC, sim_email DESC) AS r
		FROM	--myvar v, 
			(
			SELECT x.*, (x.check_naam + x.check_email + x.check_email_work + x.check_telefoon + x.check_telefoon_werk + + x.check_gsm) controle
			FROM (SELECT bron.bron_id bron_id, p.id, 
					p.first_name, p.last_name, RTRIM(LTRIM(bron.Voornaam)) || ' ' || RTRIM(LTRIM(bron.achternaam)) bron_naam, 
					p.email, p.email_work, bron.email bron_email, 
					CASE
						WHEN substr(p.phone,1,2) = '00' THEN '+'||regexp_replace(substr(p.phone,3,length(p.phone)), '[^0-9]+', '', 'g')
						WHEN substr(p.phone,1,3) = '+32' THEN '+'||regexp_replace(p.phone, '[^0-9]+', '', 'g')
						WHEN substr(p.phone,1,1) = '0' THEN '+32'||regexp_replace(substr(p.phone,2,length(p.phone)), '[^0-9]+', '', 'g')
						WHEN LENGTH(regexp_replace(p.phone, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(p.phone, '[^0-9]+', '', 'g')
						WHEN LENGTH(p.phone) > 0 THEN '+32'||regexp_replace(p.phone, '[^0-9]+', '', 'g')
						ELSE p.phone
					END telefoon, 
				  	CASE
						WHEN substr(p.phone_work,1,2) = '00' THEN '+'||regexp_replace(substr(p.phone_work,3,length(p.phone_work)), '[^0-9]+', '', 'g')
						WHEN substr(p.phone_work,1,3) = '+32' THEN '+'||regexp_replace(p.phone_work, '[^0-9]+', '', 'g')
						WHEN substr(p.phone_work,1,1) = '0' THEN '+32'||regexp_replace(substr(p.phone_work,2,length(p.phone_work)), '[^0-9]+', '', 'g')
						WHEN LENGTH(regexp_replace(p.phone_work, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(p.phone_work, '[^0-9]+', '', 'g')
						WHEN LENGTH(p.phone_work) > 0 THEN '+32'||regexp_replace(p.phone_work, '[^0-9]+', '', 'g')
						ELSE p.phone_work
					END  telefoon_werk, 
				  	CASE
						WHEN substr(p.mobile,1,2) = '00' THEN '+'||regexp_replace(substr(p.mobile,3,length(p.mobile)), '[^0-9]+', '', 'g')
						WHEN substr(p.mobile,1,3) = '+32' THEN '+'||regexp_replace(p.mobile, '[^0-9]+', '', 'g')
						WHEN substr(p.mobile,1,1) = '0' THEN '+32'||regexp_replace(substr(p.mobile,2,length(p.mobile)), '[^0-9]+', '', 'g')
						WHEN LENGTH(regexp_replace(p.mobile, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(p.mobile, '[^0-9]+', '', 'g')
						WHEN LENGTH(p.mobile) > 0 THEN '+32'||regexp_replace(p.mobile, '[^0-9]+', '', 'g')
						ELSE p.mobile
					END  gsm, 
				  	CASE
						WHEN substr(bron.telefoonnummer,1,2) = '00' THEN '+'||regexp_replace(substr(bron.telefoonnummer,3,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
						WHEN substr(bron.telefoonnummer,1,3) = '+32' THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
						WHEN substr(bron.telefoonnummer,1,1) = '0' THEN '+32'||regexp_replace(substr(bron.telefoonnummer,2,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
						WHEN LENGTH(regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
						WHEN LENGTH(bron.telefoonnummer) > 0 THEN '+32'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
						ELSE p.mobile
					END  bron_telefoon,
					p.membership_nbr,
					CASE
						WHEN p.inactive_id IN (1,8) THEN p.active_partner_id ELSE 0
					END actieve_partner_id,
					p3.membership_state,
					p.active, p.deceased, p.membership_state status, 
					p.create_uid,
					p2.id, p2.membership_state,
					similarity(p.name,bron.voornaam || ' ' || bron.achternaam) sim_naam,
					similarity(p2.name,bron.Voornaam || ' ' || bron.achternaam) sim_partner,
					similarity(COALESCE(p.email,'_'),bron.email) sim_email,
					similarity(COALESCE(p.email_work,'_'),bron.email) sim_emailwerk,
					--
					CASE WHEN RTRIM(LTRIM(LOWER(p.name))) = RTRIM(LTRIM(LOWER(bron.Voornaam || ' ' || bron.achternaam))) THEN 1 ELSE 0 END check_naam,
					CASE WHEN RTRIM(LTRIM(LOWER(p.email))) = RTRIM(LTRIM(LOWER(bron.email))) THEN 1 ELSE 0 END check_email,
					CASE WHEN RTRIM(LTRIM(LOWER(p.email_work))) = RTRIM(LTRIM(LOWER(bron.email))) THEN 1 ELSE 0 END check_email_work,
				  	--phone
					CASE WHEN 
				  			CASE
								WHEN substr(p.phone,1,2) = '00' THEN '+'||regexp_replace(substr(p.phone,3,length(p.phone)), '[^0-9]+', '', 'g')
								WHEN substr(p.phone,1,3) = '+32' THEN '+'||regexp_replace(p.phone, '[^0-9]+', '', 'g')
								WHEN substr(p.phone,1,1) = '0' THEN '+32'||regexp_replace(substr(p.phone,2,length(p.phone)), '[^0-9]+', '', 'g')
								WHEN LENGTH(regexp_replace(p.phone, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(p.phone, '[^0-9]+', '', 'g')
								WHEN LENGTH(p.phone) > 0 THEN '+32'||regexp_replace(p.phone, '[^0-9]+', '', 'g')
				  				ELSE p.phone
							END
				  		=
				  			CASE
								WHEN substr(bron.telefoonnummer,1,2) = '00' THEN '+'||regexp_replace(substr(bron.telefoonnummer,3,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
								WHEN substr(bron.telefoonnummer,1,3) = '+32' THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
								WHEN substr(bron.telefoonnummer,1,1) = '0' THEN '+32'||regexp_replace(substr(bron.telefoonnummer,2,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
								WHEN LENGTH(regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
								WHEN LENGTH(bron.telefoonnummer) > 0 THEN '+32'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
				  				ELSE bron.telefoonnummer
							END
				  		THEN 1 ELSE 0 END check_telefoon,
				  	--phone_work
				  	CASE WHEN 
				  			CASE
								WHEN substr(p.phone_work,1,2) = '00' THEN '+'||regexp_replace(substr(p.phone_work,3,length(p.phone_work)), '[^0-9]+', '', 'g')
								WHEN substr(p.phone_work,1,3) = '+32' THEN '+'||regexp_replace(p.phone_work, '[^0-9]+', '', 'g')
								WHEN substr(p.phone_work,1,1) = '0' THEN '+32'||regexp_replace(substr(p.phone_work,2,length(p.phone_work)), '[^0-9]+', '', 'g')
								WHEN LENGTH(regexp_replace(p.phone_work, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(p.phone_work, '[^0-9]+', '', 'g')
								WHEN LENGTH(p.phone_work) > 0 THEN '+32'||regexp_replace(p.phone_work, '[^0-9]+', '', 'g')
								ELSE p.phone_work
							END
				  		=
				  			CASE
								WHEN substr(bron.telefoonnummer,1,2) = '00' THEN '+'||regexp_replace(substr(bron.telefoonnummer,3,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
								WHEN substr(bron.telefoonnummer,1,3) = '+32' THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
								WHEN substr(bron.telefoonnummer,1,1) = '0' THEN '+32'||regexp_replace(substr(bron.telefoonnummer,2,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
								WHEN LENGTH(regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
								WHEN LENGTH(bron.telefoonnummer) > 0 THEN '+32'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
				  				ELSE bron.telefoonnummer
							END THEN 1 ELSE 0 END check_telefoon_werk,
				  	--mobile
				  	CASE WHEN 
				  			CASE
								WHEN substr(p.mobile,1,2) = '00' THEN '+'||regexp_replace(substr(p.mobile,3,length(p.mobile)), '[^0-9]+', '', 'g')
								WHEN substr(p.mobile,1,3) = '+32' THEN '+'||regexp_replace(p.mobile, '[^0-9]+', '', 'g')
								WHEN substr(p.mobile,1,1) = '0' THEN '+32'||regexp_replace(substr(p.mobile,2,length(p.mobile)), '[^0-9]+', '', 'g')
								WHEN LENGTH(regexp_replace(p.mobile, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(p.mobile, '[^0-9]+', '', 'g')
								WHEN LENGTH(p.mobile) > 0 THEN '+32'||regexp_replace(p.mobile, '[^0-9]+', '', 'g')
								ELSE p.mobile
							END
				  		=
				  			CASE
								WHEN substr(bron.telefoonnummer,1,2) = '00' THEN '+'||regexp_replace(substr(bron.telefoonnummer,3,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
								WHEN substr(bron.telefoonnummer,1,3) = '+32' THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
								WHEN substr(bron.telefoonnummer,1,1) = '0' THEN '+32'||regexp_replace(substr(bron.telefoonnummer,2,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
								WHEN LENGTH(regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
								WHEN LENGTH(bron.telefoonnummer) > 0 THEN '+32'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
				  				ELSE bron.telefoonnummer
							END THEN 1 ELSE 0 END check_gsm
				FROM marketing._av_temp_mindwize bron, res_partner p
					--gegevens van eventuele partner
					LEFT OUTER JOIN res_partner p2 ON p.relation_partner_id = p2.id
					LEFT OUTER JOIN partner_inactive pi ON p.inactive_id = pi.id
					LEFT OUTER JOIN res_partner p3 ON p.active_partner_id = p3.id	
				WHERE RTRIM(LTRIM(LOWER(p.email))) = CASE WHEN RTRIM(LTRIM(LOWER(bron.email))) = '' THEN 'bron@email.com' ELSE RTRIM(LTRIM(LOWER(bron.email))) END 
				--*/
				) x
			) y
		ORDER BY bron_id--, controle, sim_naam DESC	
		) z
	WHERE r = 1);
------------------------------------------------------------------
-- controle email_werk
------------------------------------------------------------------
INSERT INTO marketing._AV_temp_controletabel (
	SELECT *, 'email_werk' AS type_controle, 1 AS lid
	FROM	(
		SELECT y.*, 
		ROW_NUMBER() OVER (PARTITION BY bron_id ORDER BY controle DESC, sim_emailwerk DESC) AS r
		FROM	--myvar v, 
			(
			SELECT x.*, (x.check_naam + x.check_email + x.check_email_work + x.check_telefoon + x.check_telefoon_werk + + x.check_gsm) controle
			FROM (SELECT bron.bron_id bron_id, p.id, 
					p.first_name, p.last_name, RTRIM(LTRIM(bron.Voornaam)) || ' ' || RTRIM(LTRIM(bron.achternaam)) bron_naam, 
					p.email, p.email_work, bron.email bron_email, 
					CASE
						WHEN substr(p.phone,1,2) = '00' THEN '+'||regexp_replace(substr(p.phone,3,length(p.phone)), '[^0-9]+', '', 'g')
						WHEN substr(p.phone,1,3) = '+32' THEN '+'||regexp_replace(p.phone, '[^0-9]+', '', 'g')
						WHEN substr(p.phone,1,1) = '0' THEN '+32'||regexp_replace(substr(p.phone,2,length(p.phone)), '[^0-9]+', '', 'g')
						WHEN LENGTH(regexp_replace(p.phone, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(p.phone, '[^0-9]+', '', 'g')
						WHEN LENGTH(p.phone) > 0 THEN '+32'||regexp_replace(p.phone, '[^0-9]+', '', 'g')
						ELSE p.phone
					END telefoon, 
				  	CASE
						WHEN substr(p.phone_work,1,2) = '00' THEN '+'||regexp_replace(substr(p.phone_work,3,length(p.phone_work)), '[^0-9]+', '', 'g')
						WHEN substr(p.phone_work,1,3) = '+32' THEN '+'||regexp_replace(p.phone_work, '[^0-9]+', '', 'g')
						WHEN substr(p.phone_work,1,1) = '0' THEN '+32'||regexp_replace(substr(p.phone_work,2,length(p.phone_work)), '[^0-9]+', '', 'g')
						WHEN LENGTH(regexp_replace(p.phone_work, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(p.phone_work, '[^0-9]+', '', 'g')
						WHEN LENGTH(p.phone_work) > 0 THEN '+32'||regexp_replace(p.phone_work, '[^0-9]+', '', 'g')
						ELSE p.phone_work
					END  telefoon_werk, 
				  	CASE
						WHEN substr(p.mobile,1,2) = '00' THEN '+'||regexp_replace(substr(p.mobile,3,length(p.mobile)), '[^0-9]+', '', 'g')
						WHEN substr(p.mobile,1,3) = '+32' THEN '+'||regexp_replace(p.mobile, '[^0-9]+', '', 'g')
						WHEN substr(p.mobile,1,1) = '0' THEN '+32'||regexp_replace(substr(p.mobile,2,length(p.mobile)), '[^0-9]+', '', 'g')
						WHEN LENGTH(regexp_replace(p.mobile, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(p.mobile, '[^0-9]+', '', 'g')
						WHEN LENGTH(p.mobile) > 0 THEN '+32'||regexp_replace(p.mobile, '[^0-9]+', '', 'g')
						ELSE p.mobile
					END  gsm, 
				  	CASE
						WHEN substr(bron.telefoonnummer,1,2) = '00' THEN '+'||regexp_replace(substr(bron.telefoonnummer,3,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
						WHEN substr(bron.telefoonnummer,1,3) = '+32' THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
						WHEN substr(bron.telefoonnummer,1,1) = '0' THEN '+32'||regexp_replace(substr(bron.telefoonnummer,2,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
						WHEN LENGTH(regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
						WHEN LENGTH(bron.telefoonnummer) > 0 THEN '+32'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
						ELSE p.mobile
					END  bron_telefoon,
					p.membership_nbr,
					CASE
						WHEN p.inactive_id IN (1,8) THEN p.active_partner_id ELSE 0
					END actieve_partner_id,
					p3.membership_state,
					p.active, p.deceased, p.membership_state status, 
					p.create_uid,
					p2.id, p2.membership_state,
					similarity(p.name,bron.voornaam || ' ' || bron.achternaam) sim_naam,
					similarity(p2.name,bron.Voornaam || ' ' || bron.achternaam) sim_partner,
					similarity(COALESCE(p.email,'_'),bron.email) sim_email,
					similarity(COALESCE(p.email_work,'_'),bron.email) sim_emailwerk,
					--
					CASE WHEN RTRIM(LTRIM(LOWER(p.name))) = RTRIM(LTRIM(LOWER(bron.Voornaam || ' ' || bron.achternaam))) THEN 1 ELSE 0 END check_naam,
					CASE WHEN RTRIM(LTRIM(LOWER(p.email))) = RTRIM(LTRIM(LOWER(bron.email))) THEN 1 ELSE 0 END check_email,
					CASE WHEN RTRIM(LTRIM(LOWER(p.email_work))) = RTRIM(LTRIM(LOWER(bron.email))) THEN 1 ELSE 0 END check_email_work,
				  	--phone
					CASE WHEN 
				  			CASE
								WHEN substr(p.phone,1,2) = '00' THEN '+'||regexp_replace(substr(p.phone,3,length(p.phone)), '[^0-9]+', '', 'g')
								WHEN substr(p.phone,1,3) = '+32' THEN '+'||regexp_replace(p.phone, '[^0-9]+', '', 'g')
								WHEN substr(p.phone,1,1) = '0' THEN '+32'||regexp_replace(substr(p.phone,2,length(p.phone)), '[^0-9]+', '', 'g')
								WHEN LENGTH(regexp_replace(p.phone, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(p.phone, '[^0-9]+', '', 'g')
								WHEN LENGTH(p.phone) > 0 THEN '+32'||regexp_replace(p.phone, '[^0-9]+', '', 'g')
				  				ELSE p.phone
							END
				  		=
				  			CASE
								WHEN substr(bron.telefoonnummer,1,2) = '00' THEN '+'||regexp_replace(substr(bron.telefoonnummer,3,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
								WHEN substr(bron.telefoonnummer,1,3) = '+32' THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
								WHEN substr(bron.telefoonnummer,1,1) = '0' THEN '+32'||regexp_replace(substr(bron.telefoonnummer,2,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
								WHEN LENGTH(regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
								WHEN LENGTH(bron.telefoonnummer) > 0 THEN '+32'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
				  				ELSE bron.telefoonnummer
							END
				  		THEN 1 ELSE 0 END check_telefoon,
				  	--phone_work
				  	CASE WHEN 
				  			CASE
								WHEN substr(p.phone_work,1,2) = '00' THEN '+'||regexp_replace(substr(p.phone_work,3,length(p.phone_work)), '[^0-9]+', '', 'g')
								WHEN substr(p.phone_work,1,3) = '+32' THEN '+'||regexp_replace(p.phone_work, '[^0-9]+', '', 'g')
								WHEN substr(p.phone_work,1,1) = '0' THEN '+32'||regexp_replace(substr(p.phone_work,2,length(p.phone_work)), '[^0-9]+', '', 'g')
								WHEN LENGTH(regexp_replace(p.phone_work, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(p.phone_work, '[^0-9]+', '', 'g')
								WHEN LENGTH(p.phone_work) > 0 THEN '+32'||regexp_replace(p.phone_work, '[^0-9]+', '', 'g')
								ELSE p.phone_work
							END
				  		=
				  			CASE
								WHEN substr(bron.telefoonnummer,1,2) = '00' THEN '+'||regexp_replace(substr(bron.telefoonnummer,3,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
								WHEN substr(bron.telefoonnummer,1,3) = '+32' THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
								WHEN substr(bron.telefoonnummer,1,1) = '0' THEN '+32'||regexp_replace(substr(bron.telefoonnummer,2,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
								WHEN LENGTH(regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
								WHEN LENGTH(bron.telefoonnummer) > 0 THEN '+32'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
				  				ELSE bron.telefoonnummer
							END THEN 1 ELSE 0 END check_telefoon_werk,
				  	--mobile
				  	CASE WHEN 
				  			CASE
								WHEN substr(p.mobile,1,2) = '00' THEN '+'||regexp_replace(substr(p.mobile,3,length(p.mobile)), '[^0-9]+', '', 'g')
								WHEN substr(p.mobile,1,3) = '+32' THEN '+'||regexp_replace(p.mobile, '[^0-9]+', '', 'g')
								WHEN substr(p.mobile,1,1) = '0' THEN '+32'||regexp_replace(substr(p.mobile,2,length(p.mobile)), '[^0-9]+', '', 'g')
								WHEN LENGTH(regexp_replace(p.mobile, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(p.mobile, '[^0-9]+', '', 'g')
								WHEN LENGTH(p.mobile) > 0 THEN '+32'||regexp_replace(p.mobile, '[^0-9]+', '', 'g')
								ELSE p.mobile
							END
				  		=
				  			CASE
								WHEN substr(bron.telefoonnummer,1,2) = '00' THEN '+'||regexp_replace(substr(bron.telefoonnummer,3,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
								WHEN substr(bron.telefoonnummer,1,3) = '+32' THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
								WHEN substr(bron.telefoonnummer,1,1) = '0' THEN '+32'||regexp_replace(substr(bron.telefoonnummer,2,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
								WHEN LENGTH(regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
								WHEN LENGTH(bron.telefoonnummer) > 0 THEN '+32'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
				  				ELSE bron.telefoonnummer
							END THEN 1 ELSE 0 END check_gsm
				FROM marketing._av_temp_mindwize bron, res_partner p
					--gegevens van eventuele partner
					LEFT OUTER JOIN res_partner p2 ON p.relation_partner_id = p2.id
					LEFT OUTER JOIN partner_inactive pi ON p.inactive_id = pi.id
					LEFT OUTER JOIN res_partner p3 ON p.active_partner_id = p3.id	
				WHERE RTRIM(LTRIM(LOWER(p.email_work))) = CASE WHEN RTRIM(LTRIM(LOWER(bron.email))) = '' THEN 'bron@email.com' ELSE RTRIM(LTRIM(LOWER(bron.email))) END 
				--*/
				) x
			) y
		ORDER BY bron_id--, controle, sim_naam DESC	
		) z
	WHERE r = 1);
------------------------------------------------------------------
-- controle telefoon
------------------------------------------------------------------
INSERT INTO marketing._AV_temp_controletabel (
	SELECT *, 'telefoon' AS type_controle, 1 AS lid
	FROM	(
		SELECT y.*, 
		ROW_NUMBER() OVER (PARTITION BY bron_id ORDER BY controle DESC) AS r
		FROM	--myvar v, 
			(
			SELECT x.*, (x.check_naam + x.check_email + x.check_email_work + x.check_telefoon + x.check_telefoon_werk + + x.check_gsm) controle
			FROM (SELECT bron.bron_id bron_id, p.id, 
					p.first_name, p.last_name, RTRIM(LTRIM(bron.Voornaam)) || ' ' || RTRIM(LTRIM(bron.achternaam)) bron_naam, 
					p.email, p.email_work, bron.email bron_email, 
					CASE
						WHEN substr(p.phone,1,2) = '00' THEN '+'||regexp_replace(substr(p.phone,3,length(p.phone)), '[^0-9]+', '', 'g')
						WHEN substr(p.phone,1,3) = '+32' THEN '+'||regexp_replace(p.phone, '[^0-9]+', '', 'g')
						WHEN substr(p.phone,1,1) = '0' THEN '+32'||regexp_replace(substr(p.phone,2,length(p.phone)), '[^0-9]+', '', 'g')
						WHEN LENGTH(regexp_replace(p.phone, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(p.phone, '[^0-9]+', '', 'g')
						WHEN LENGTH(p.phone) > 0 THEN '+32'||regexp_replace(p.phone, '[^0-9]+', '', 'g')
						ELSE p.phone
					END telefoon, 
				  	CASE
						WHEN substr(p.phone_work,1,2) = '00' THEN '+'||regexp_replace(substr(p.phone_work,3,length(p.phone_work)), '[^0-9]+', '', 'g')
						WHEN substr(p.phone_work,1,3) = '+32' THEN '+'||regexp_replace(p.phone_work, '[^0-9]+', '', 'g')
						WHEN substr(p.phone_work,1,1) = '0' THEN '+32'||regexp_replace(substr(p.phone_work,2,length(p.phone_work)), '[^0-9]+', '', 'g')
						WHEN LENGTH(regexp_replace(p.phone_work, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(p.phone_work, '[^0-9]+', '', 'g')
						WHEN LENGTH(p.phone_work) > 0 THEN '+32'||regexp_replace(p.phone_work, '[^0-9]+', '', 'g')
						ELSE p.phone_work
					END  telefoon_werk, 
				  	CASE
						WHEN substr(p.mobile,1,2) = '00' THEN '+'||regexp_replace(substr(p.mobile,3,length(p.mobile)), '[^0-9]+', '', 'g')
						WHEN substr(p.mobile,1,3) = '+32' THEN '+'||regexp_replace(p.mobile, '[^0-9]+', '', 'g')
						WHEN substr(p.mobile,1,1) = '0' THEN '+32'||regexp_replace(substr(p.mobile,2,length(p.mobile)), '[^0-9]+', '', 'g')
						WHEN LENGTH(regexp_replace(p.mobile, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(p.mobile, '[^0-9]+', '', 'g')
						WHEN LENGTH(p.mobile) > 0 THEN '+32'||regexp_replace(p.mobile, '[^0-9]+', '', 'g')
						ELSE p.mobile
					END  gsm, 
				  	CASE
						WHEN substr(bron.telefoonnummer,1,2) = '00' THEN '+'||regexp_replace(substr(bron.telefoonnummer,3,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
						WHEN substr(bron.telefoonnummer,1,3) = '+32' THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
						WHEN substr(bron.telefoonnummer,1,1) = '0' THEN '+32'||regexp_replace(substr(bron.telefoonnummer,2,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
						WHEN LENGTH(regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
						WHEN LENGTH(bron.telefoonnummer) > 0 THEN '+32'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
						ELSE p.mobile
					END  bron_telefoon,
					p.membership_nbr,
					CASE
						WHEN p.inactive_id IN (1,8) THEN p.active_partner_id ELSE 0
					END actieve_partner_id,
					p3.membership_state,
					p.active, p.deceased, p.membership_state status, 
					p.create_uid,
					p2.id, p2.membership_state,
					similarity(p.name,bron.voornaam || ' ' || bron.achternaam) sim_naam,
					similarity(p2.name,bron.Voornaam || ' ' || bron.achternaam) sim_partner,
					similarity(COALESCE(p.email,'_'),bron.email) sim_email,
					similarity(COALESCE(p.email_work,'_'),bron.email) sim_emailwerk,
					--
					CASE WHEN RTRIM(LTRIM(LOWER(p.name))) = RTRIM(LTRIM(LOWER(bron.Voornaam || ' ' || bron.achternaam))) THEN 1 ELSE 0 END check_naam,
					CASE WHEN RTRIM(LTRIM(LOWER(p.email))) = RTRIM(LTRIM(LOWER(bron.email))) THEN 1 ELSE 0 END check_email,
					CASE WHEN RTRIM(LTRIM(LOWER(p.email_work))) = RTRIM(LTRIM(LOWER(bron.email))) THEN 1 ELSE 0 END check_email_work,
				  	--phone
					CASE WHEN 
				  			CASE
								WHEN substr(p.phone,1,2) = '00' THEN '+'||regexp_replace(substr(p.phone,3,length(p.phone)), '[^0-9]+', '', 'g')
								WHEN substr(p.phone,1,3) = '+32' THEN '+'||regexp_replace(p.phone, '[^0-9]+', '', 'g')
								WHEN substr(p.phone,1,1) = '0' THEN '+32'||regexp_replace(substr(p.phone,2,length(p.phone)), '[^0-9]+', '', 'g')
								WHEN LENGTH(regexp_replace(p.phone, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(p.phone, '[^0-9]+', '', 'g')
								WHEN LENGTH(p.phone) > 0 THEN '+32'||regexp_replace(p.phone, '[^0-9]+', '', 'g')
				  				ELSE p.phone
							END
				  		=
				  			CASE
								WHEN substr(bron.telefoonnummer,1,2) = '00' THEN '+'||regexp_replace(substr(bron.telefoonnummer,3,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
								WHEN substr(bron.telefoonnummer,1,3) = '+32' THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
								WHEN substr(bron.telefoonnummer,1,1) = '0' THEN '+32'||regexp_replace(substr(bron.telefoonnummer,2,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
								WHEN LENGTH(regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
								WHEN LENGTH(bron.telefoonnummer) > 0 THEN '+32'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
				  				ELSE bron.telefoonnummer
							END
				  		THEN 1 ELSE 0 END check_telefoon,
				  	--phone_work
				  	CASE WHEN 
				  			CASE
								WHEN substr(p.phone_work,1,2) = '00' THEN '+'||regexp_replace(substr(p.phone_work,3,length(p.phone_work)), '[^0-9]+', '', 'g')
								WHEN substr(p.phone_work,1,3) = '+32' THEN '+'||regexp_replace(p.phone_work, '[^0-9]+', '', 'g')
								WHEN substr(p.phone_work,1,1) = '0' THEN '+32'||regexp_replace(substr(p.phone_work,2,length(p.phone_work)), '[^0-9]+', '', 'g')
								WHEN LENGTH(regexp_replace(p.phone_work, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(p.phone_work, '[^0-9]+', '', 'g')
								WHEN LENGTH(p.phone_work) > 0 THEN '+32'||regexp_replace(p.phone_work, '[^0-9]+', '', 'g')
								ELSE p.phone_work
							END
				  		=
				  			CASE
								WHEN substr(bron.telefoonnummer,1,2) = '00' THEN '+'||regexp_replace(substr(bron.telefoonnummer,3,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
								WHEN substr(bron.telefoonnummer,1,3) = '+32' THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
								WHEN substr(bron.telefoonnummer,1,1) = '0' THEN '+32'||regexp_replace(substr(bron.telefoonnummer,2,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
								WHEN LENGTH(regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
								WHEN LENGTH(bron.telefoonnummer) > 0 THEN '+32'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
				  				ELSE bron.telefoonnummer
							END THEN 1 ELSE 0 END check_telefoon_werk,
				  	--mobile
				  	CASE WHEN 
				  			CASE
								WHEN substr(p.mobile,1,2) = '00' THEN '+'||regexp_replace(substr(p.mobile,3,length(p.mobile)), '[^0-9]+', '', 'g')
								WHEN substr(p.mobile,1,3) = '+32' THEN '+'||regexp_replace(p.mobile, '[^0-9]+', '', 'g')
								WHEN substr(p.mobile,1,1) = '0' THEN '+32'||regexp_replace(substr(p.mobile,2,length(p.mobile)), '[^0-9]+', '', 'g')
								WHEN LENGTH(regexp_replace(p.mobile, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(p.mobile, '[^0-9]+', '', 'g')
								WHEN LENGTH(p.mobile) > 0 THEN '+32'||regexp_replace(p.mobile, '[^0-9]+', '', 'g')
								ELSE p.mobile
							END
				  		=
				  			CASE
								WHEN substr(bron.telefoonnummer,1,2) = '00' THEN '+'||regexp_replace(substr(bron.telefoonnummer,3,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
								WHEN substr(bron.telefoonnummer,1,3) = '+32' THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
								WHEN substr(bron.telefoonnummer,1,1) = '0' THEN '+32'||regexp_replace(substr(bron.telefoonnummer,2,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
								WHEN LENGTH(regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
								WHEN LENGTH(bron.telefoonnummer) > 0 THEN '+32'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
				  				ELSE bron.telefoonnummer
							END THEN 1 ELSE 0 END check_gsm
				FROM marketing._av_temp_mindwize bron, res_partner p
					--gegevens van eventuele partner
					LEFT OUTER JOIN res_partner p2 ON p.relation_partner_id = p2.id
					LEFT OUTER JOIN partner_inactive pi ON p.inactive_id = pi.id
					LEFT OUTER JOIN res_partner p3 ON p.active_partner_id = p3.id	
				WHERE CASE
						WHEN substr(p.phone,1,2) = '00' THEN '+'||regexp_replace(substr(p.phone,3,length(p.phone)), '[^0-9]+', '', 'g')
						WHEN substr(p.phone,1,3) = '+32' THEN '+'||regexp_replace(p.phone, '[^0-9]+', '', 'g')
						WHEN substr(p.phone,1,1) = '0' THEN '+32'||regexp_replace(substr(p.phone,2,length(p.phone)), '[^0-9]+', '', 'g')
						WHEN LENGTH(regexp_replace(p.phone, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(p.phone, '[^0-9]+', '', 'g')
						WHEN LENGTH(p.phone) > 0 THEN '+32'||regexp_replace(p.phone, '[^0-9]+', '', 'g')
						ELSE p.phone
					END
					=
					CASE
						WHEN substr(bron.telefoonnummer,1,2) = '00' THEN '+'||regexp_replace(substr(bron.telefoonnummer,3,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
						WHEN substr(bron.telefoonnummer,1,3) = '+32' THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
						WHEN substr(bron.telefoonnummer,1,1) = '0' THEN '+32'||regexp_replace(substr(bron.telefoonnummer,2,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
						WHEN LENGTH(regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
						WHEN LENGTH(bron.telefoonnummer) > 0 THEN '+32'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
						ELSE bron.telefoonnummer
					END
				--*/
				) x
			) y
		ORDER BY bron_id--, controle, sim_naam DESC	
		) z
	WHERE r = 1);
------------------------------------------------------------------
-- controle telefoon_werk
------------------------------------------------------------------
INSERT INTO marketing._AV_temp_controletabel (
	SELECT *, 'telefoon_werk' AS type_controle, 1 AS lid
	FROM	(
		SELECT y.*, 
		ROW_NUMBER() OVER (PARTITION BY bron_id ORDER BY controle DESC) AS r
		FROM	--myvar v, 
			(
			SELECT x.*, (x.check_naam + x.check_email + x.check_email_work + x.check_telefoon + x.check_telefoon_werk + + x.check_gsm) controle
			FROM (SELECT bron.bron_id bron_id, p.id, 
					p.first_name, p.last_name, RTRIM(LTRIM(bron.Voornaam)) || ' ' || RTRIM(LTRIM(bron.achternaam)) bron_naam, 
					p.email, p.email_work, bron.email bron_email, 
					CASE
						WHEN substr(p.phone,1,2) = '00' THEN '+'||regexp_replace(substr(p.phone,3,length(p.phone)), '[^0-9]+', '', 'g')
						WHEN substr(p.phone,1,3) = '+32' THEN '+'||regexp_replace(p.phone, '[^0-9]+', '', 'g')
						WHEN substr(p.phone,1,1) = '0' THEN '+32'||regexp_replace(substr(p.phone,2,length(p.phone)), '[^0-9]+', '', 'g')
						WHEN LENGTH(regexp_replace(p.phone, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(p.phone, '[^0-9]+', '', 'g')
						WHEN LENGTH(p.phone) > 0 THEN '+32'||regexp_replace(p.phone, '[^0-9]+', '', 'g')
						ELSE p.phone
					END telefoon, 
				  	CASE
						WHEN substr(p.phone_work,1,2) = '00' THEN '+'||regexp_replace(substr(p.phone_work,3,length(p.phone_work)), '[^0-9]+', '', 'g')
						WHEN substr(p.phone_work,1,3) = '+32' THEN '+'||regexp_replace(p.phone_work, '[^0-9]+', '', 'g')
						WHEN substr(p.phone_work,1,1) = '0' THEN '+32'||regexp_replace(substr(p.phone_work,2,length(p.phone_work)), '[^0-9]+', '', 'g')
						WHEN LENGTH(regexp_replace(p.phone_work, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(p.phone_work, '[^0-9]+', '', 'g')
						WHEN LENGTH(p.phone_work) > 0 THEN '+32'||regexp_replace(p.phone_work, '[^0-9]+', '', 'g')
						ELSE p.phone_work
					END  telefoon_werk, 
				  	CASE
						WHEN substr(p.mobile,1,2) = '00' THEN '+'||regexp_replace(substr(p.mobile,3,length(p.mobile)), '[^0-9]+', '', 'g')
						WHEN substr(p.mobile,1,3) = '+32' THEN '+'||regexp_replace(p.mobile, '[^0-9]+', '', 'g')
						WHEN substr(p.mobile,1,1) = '0' THEN '+32'||regexp_replace(substr(p.mobile,2,length(p.mobile)), '[^0-9]+', '', 'g')
						WHEN LENGTH(regexp_replace(p.mobile, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(p.mobile, '[^0-9]+', '', 'g')
						WHEN LENGTH(p.mobile) > 0 THEN '+32'||regexp_replace(p.mobile, '[^0-9]+', '', 'g')
						ELSE p.mobile
					END  gsm, 
				  	CASE
						WHEN substr(bron.telefoonnummer,1,2) = '00' THEN '+'||regexp_replace(substr(bron.telefoonnummer,3,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
						WHEN substr(bron.telefoonnummer,1,3) = '+32' THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
						WHEN substr(bron.telefoonnummer,1,1) = '0' THEN '+32'||regexp_replace(substr(bron.telefoonnummer,2,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
						WHEN LENGTH(regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
						WHEN LENGTH(bron.telefoonnummer) > 0 THEN '+32'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
						ELSE p.mobile
					END  bron_telefoon,
					p.membership_nbr,
					CASE
						WHEN p.inactive_id IN (1,8) THEN p.active_partner_id ELSE 0
					END actieve_partner_id,
					p3.membership_state,
					p.active, p.deceased, p.membership_state status, 
					p.create_uid,
					p2.id, p2.membership_state,
					similarity(p.name,bron.voornaam || ' ' || bron.achternaam) sim_naam,
					similarity(p2.name,bron.Voornaam || ' ' || bron.achternaam) sim_partner,
					similarity(COALESCE(p.email,'_'),bron.email) sim_email,
					similarity(COALESCE(p.email_work,'_'),bron.email) sim_emailwerk,
					--
					CASE WHEN RTRIM(LTRIM(LOWER(p.name))) = RTRIM(LTRIM(LOWER(bron.Voornaam || ' ' || bron.achternaam))) THEN 1 ELSE 0 END check_naam,
					CASE WHEN RTRIM(LTRIM(LOWER(p.email))) = RTRIM(LTRIM(LOWER(bron.email))) THEN 1 ELSE 0 END check_email,
					CASE WHEN RTRIM(LTRIM(LOWER(p.email_work))) = RTRIM(LTRIM(LOWER(bron.email))) THEN 1 ELSE 0 END check_email_work,
				  	--phone
					CASE WHEN 
				  			CASE
								WHEN substr(p.phone,1,2) = '00' THEN '+'||regexp_replace(substr(p.phone,3,length(p.phone)), '[^0-9]+', '', 'g')
								WHEN substr(p.phone,1,3) = '+32' THEN '+'||regexp_replace(p.phone, '[^0-9]+', '', 'g')
								WHEN substr(p.phone,1,1) = '0' THEN '+32'||regexp_replace(substr(p.phone,2,length(p.phone)), '[^0-9]+', '', 'g')
								WHEN LENGTH(regexp_replace(p.phone, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(p.phone, '[^0-9]+', '', 'g')
								WHEN LENGTH(p.phone) > 0 THEN '+32'||regexp_replace(p.phone, '[^0-9]+', '', 'g')
				  				ELSE p.phone
							END
				  		=
				  			CASE
								WHEN substr(bron.telefoonnummer,1,2) = '00' THEN '+'||regexp_replace(substr(bron.telefoonnummer,3,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
								WHEN substr(bron.telefoonnummer,1,3) = '+32' THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
								WHEN substr(bron.telefoonnummer,1,1) = '0' THEN '+32'||regexp_replace(substr(bron.telefoonnummer,2,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
								WHEN LENGTH(regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
								WHEN LENGTH(bron.telefoonnummer) > 0 THEN '+32'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
				  				ELSE bron.telefoonnummer
							END
				  		THEN 1 ELSE 0 END check_telefoon,
				  	--phone_work
				  	CASE WHEN 
				  			CASE
								WHEN substr(p.phone_work,1,2) = '00' THEN '+'||regexp_replace(substr(p.phone_work,3,length(p.phone_work)), '[^0-9]+', '', 'g')
								WHEN substr(p.phone_work,1,3) = '+32' THEN '+'||regexp_replace(p.phone_work, '[^0-9]+', '', 'g')
								WHEN substr(p.phone_work,1,1) = '0' THEN '+32'||regexp_replace(substr(p.phone_work,2,length(p.phone_work)), '[^0-9]+', '', 'g')
								WHEN LENGTH(regexp_replace(p.phone_work, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(p.phone_work, '[^0-9]+', '', 'g')
								WHEN LENGTH(p.phone_work) > 0 THEN '+32'||regexp_replace(p.phone_work, '[^0-9]+', '', 'g')
								ELSE p.phone_work
							END
				  		=
				  			CASE
								WHEN substr(bron.telefoonnummer,1,2) = '00' THEN '+'||regexp_replace(substr(bron.telefoonnummer,3,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
								WHEN substr(bron.telefoonnummer,1,3) = '+32' THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
								WHEN substr(bron.telefoonnummer,1,1) = '0' THEN '+32'||regexp_replace(substr(bron.telefoonnummer,2,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
								WHEN LENGTH(regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
								WHEN LENGTH(bron.telefoonnummer) > 0 THEN '+32'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
				  				ELSE bron.telefoonnummer
							END THEN 1 ELSE 0 END check_telefoon_werk,
				  	--mobile
				  	CASE WHEN 
				  			CASE
								WHEN substr(p.mobile,1,2) = '00' THEN '+'||regexp_replace(substr(p.mobile,3,length(p.mobile)), '[^0-9]+', '', 'g')
								WHEN substr(p.mobile,1,3) = '+32' THEN '+'||regexp_replace(p.mobile, '[^0-9]+', '', 'g')
								WHEN substr(p.mobile,1,1) = '0' THEN '+32'||regexp_replace(substr(p.mobile,2,length(p.mobile)), '[^0-9]+', '', 'g')
								WHEN LENGTH(regexp_replace(p.mobile, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(p.mobile, '[^0-9]+', '', 'g')
								WHEN LENGTH(p.mobile) > 0 THEN '+32'||regexp_replace(p.mobile, '[^0-9]+', '', 'g')
								ELSE p.mobile
							END
				  		=
				  			CASE
								WHEN substr(bron.telefoonnummer,1,2) = '00' THEN '+'||regexp_replace(substr(bron.telefoonnummer,3,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
								WHEN substr(bron.telefoonnummer,1,3) = '+32' THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
								WHEN substr(bron.telefoonnummer,1,1) = '0' THEN '+32'||regexp_replace(substr(bron.telefoonnummer,2,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
								WHEN LENGTH(regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
								WHEN LENGTH(bron.telefoonnummer) > 0 THEN '+32'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
				  				ELSE bron.telefoonnummer
							END THEN 1 ELSE 0 END check_gsm
				FROM marketing._av_temp_mindwize bron, res_partner p
					--gegevens van eventuele partner
					LEFT OUTER JOIN res_partner p2 ON p.relation_partner_id = p2.id
					LEFT OUTER JOIN partner_inactive pi ON p.inactive_id = pi.id
					LEFT OUTER JOIN res_partner p3 ON p.active_partner_id = p3.id	
				WHERE CASE
						WHEN substr(p.phone_work,1,2) = '00' THEN '+'||regexp_replace(substr(p.phone_work,3,length(p.phone_work)), '[^0-9]+', '', 'g')
						WHEN substr(p.phone_work,1,3) = '+32' THEN '+'||regexp_replace(p.phone_work, '[^0-9]+', '', 'g')
						WHEN substr(p.phone_work,1,1) = '0' THEN '+32'||regexp_replace(substr(p.phone_work,2,length(p.phone_work)), '[^0-9]+', '', 'g')
						WHEN LENGTH(regexp_replace(p.phone_work, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(p.phone_work, '[^0-9]+', '', 'g')
						WHEN LENGTH(p.phone_work) > 0 THEN '+32'||regexp_replace(p.phone_work, '[^0-9]+', '', 'g')
						ELSE p.phone_work
					END
					=
					CASE
						WHEN substr(bron.telefoonnummer,1,2) = '00' THEN '+'||regexp_replace(substr(bron.telefoonnummer,3,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
						WHEN substr(bron.telefoonnummer,1,3) = '+32' THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
						WHEN substr(bron.telefoonnummer,1,1) = '0' THEN '+32'||regexp_replace(substr(bron.telefoonnummer,2,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
						WHEN LENGTH(regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
						WHEN LENGTH(bron.telefoonnummer) > 0 THEN '+32'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
						ELSE bron.telefoonnummer
					END
				--*/
				) x
			) y
		ORDER BY bron_id--, controle, sim_naam DESC	
		) z
	WHERE r = 1);
------------------------------------------------------------------
-- controle gsm
------------------------------------------------------------------
INSERT INTO marketing._AV_temp_controletabel (
	SELECT *, 'gsm' AS type_controle, 1 AS lid
	FROM	(
		SELECT y.*, 
		ROW_NUMBER() OVER (PARTITION BY bron_id ORDER BY controle DESC) AS r
		FROM	--myvar v, 
			(
			SELECT x.*, (x.check_naam + x.check_email + x.check_email_work + x.check_telefoon + x.check_telefoon_werk + + x.check_gsm) controle
			FROM (SELECT bron.bron_id bron_id, p.id, 
					p.first_name, p.last_name, RTRIM(LTRIM(bron.Voornaam)) || ' ' || RTRIM(LTRIM(bron.achternaam)) bron_naam, 
					p.email, p.email_work, bron.email bron_email, 
					CASE
						WHEN substr(p.phone,1,2) = '00' THEN '+'||regexp_replace(substr(p.phone,3,length(p.phone)), '[^0-9]+', '', 'g')
						WHEN substr(p.phone,1,3) = '+32' THEN '+'||regexp_replace(p.phone, '[^0-9]+', '', 'g')
						WHEN substr(p.phone,1,1) = '0' THEN '+32'||regexp_replace(substr(p.phone,2,length(p.phone)), '[^0-9]+', '', 'g')
						WHEN LENGTH(regexp_replace(p.phone, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(p.phone, '[^0-9]+', '', 'g')
						WHEN LENGTH(p.phone) > 0 THEN '+32'||regexp_replace(p.phone, '[^0-9]+', '', 'g')
						ELSE p.phone
					END telefoon, 
				  	CASE
						WHEN substr(p.phone_work,1,2) = '00' THEN '+'||regexp_replace(substr(p.phone_work,3,length(p.phone_work)), '[^0-9]+', '', 'g')
						WHEN substr(p.phone_work,1,3) = '+32' THEN '+'||regexp_replace(p.phone_work, '[^0-9]+', '', 'g')
						WHEN substr(p.phone_work,1,1) = '0' THEN '+32'||regexp_replace(substr(p.phone_work,2,length(p.phone_work)), '[^0-9]+', '', 'g')
						WHEN LENGTH(regexp_replace(p.phone_work, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(p.phone_work, '[^0-9]+', '', 'g')
						WHEN LENGTH(p.phone_work) > 0 THEN '+32'||regexp_replace(p.phone_work, '[^0-9]+', '', 'g')
						ELSE p.phone_work
					END  telefoon_werk, 
				  	CASE
						WHEN substr(p.mobile,1,2) = '00' THEN '+'||regexp_replace(substr(p.mobile,3,length(p.mobile)), '[^0-9]+', '', 'g')
						WHEN substr(p.mobile,1,3) = '+32' THEN '+'||regexp_replace(p.mobile, '[^0-9]+', '', 'g')
						WHEN substr(p.mobile,1,1) = '0' THEN '+32'||regexp_replace(substr(p.mobile,2,length(p.mobile)), '[^0-9]+', '', 'g')
						WHEN LENGTH(regexp_replace(p.mobile, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(p.mobile, '[^0-9]+', '', 'g')
						WHEN LENGTH(p.mobile) > 0 THEN '+32'||regexp_replace(p.mobile, '[^0-9]+', '', 'g')
						ELSE p.mobile
					END  gsm, 
				  	CASE
						WHEN substr(bron.telefoonnummer,1,2) = '00' THEN '+'||regexp_replace(substr(bron.telefoonnummer,3,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
						WHEN substr(bron.telefoonnummer,1,3) = '+32' THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
						WHEN substr(bron.telefoonnummer,1,1) = '0' THEN '+32'||regexp_replace(substr(bron.telefoonnummer,2,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
						WHEN LENGTH(regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
						WHEN LENGTH(bron.telefoonnummer) > 0 THEN '+32'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
						ELSE p.mobile
					END  bron_telefoon,
					p.membership_nbr,
					CASE
						WHEN p.inactive_id IN (1,8) THEN p.active_partner_id ELSE 0
					END actieve_partner_id,
					p3.membership_state,
					p.active, p.deceased, p.membership_state status, 
					p.create_uid,
					p2.id, p2.membership_state,
					similarity(p.name,bron.voornaam || ' ' || bron.achternaam) sim_naam,
					similarity(p2.name,bron.Voornaam || ' ' || bron.achternaam) sim_partner,
					similarity(COALESCE(p.email,'_'),bron.email) sim_email,
					similarity(COALESCE(p.email_work,'_'),bron.email) sim_emailwerk,
					--
					CASE WHEN RTRIM(LTRIM(LOWER(p.name))) = RTRIM(LTRIM(LOWER(bron.Voornaam || ' ' || bron.achternaam))) THEN 1 ELSE 0 END check_naam,
					CASE WHEN RTRIM(LTRIM(LOWER(p.email))) = RTRIM(LTRIM(LOWER(bron.email))) THEN 1 ELSE 0 END check_email,
					CASE WHEN RTRIM(LTRIM(LOWER(p.email_work))) = RTRIM(LTRIM(LOWER(bron.email))) THEN 1 ELSE 0 END check_email_work,
				  	--phone
					CASE WHEN 
				  			CASE
								WHEN substr(p.phone,1,2) = '00' THEN '+'||regexp_replace(substr(p.phone,3,length(p.phone)), '[^0-9]+', '', 'g')
								WHEN substr(p.phone,1,3) = '+32' THEN '+'||regexp_replace(p.phone, '[^0-9]+', '', 'g')
								WHEN substr(p.phone,1,1) = '0' THEN '+32'||regexp_replace(substr(p.phone,2,length(p.phone)), '[^0-9]+', '', 'g')
								WHEN LENGTH(regexp_replace(p.phone, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(p.phone, '[^0-9]+', '', 'g')
								WHEN LENGTH(p.phone) > 0 THEN '+32'||regexp_replace(p.phone, '[^0-9]+', '', 'g')
				  				ELSE p.phone
							END
				  		=
				  			CASE
								WHEN substr(bron.telefoonnummer,1,2) = '00' THEN '+'||regexp_replace(substr(bron.telefoonnummer,3,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
								WHEN substr(bron.telefoonnummer,1,3) = '+32' THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
								WHEN substr(bron.telefoonnummer,1,1) = '0' THEN '+32'||regexp_replace(substr(bron.telefoonnummer,2,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
								WHEN LENGTH(regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
								WHEN LENGTH(bron.telefoonnummer) > 0 THEN '+32'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
				  				ELSE bron.telefoonnummer
							END
				  		THEN 1 ELSE 0 END check_telefoon,
				  	--phone_work
				  	CASE WHEN 
				  			CASE
								WHEN substr(p.phone_work,1,2) = '00' THEN '+'||regexp_replace(substr(p.phone_work,3,length(p.phone_work)), '[^0-9]+', '', 'g')
								WHEN substr(p.phone_work,1,3) = '+32' THEN '+'||regexp_replace(p.phone_work, '[^0-9]+', '', 'g')
								WHEN substr(p.phone_work,1,1) = '0' THEN '+32'||regexp_replace(substr(p.phone_work,2,length(p.phone_work)), '[^0-9]+', '', 'g')
								WHEN LENGTH(regexp_replace(p.phone_work, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(p.phone_work, '[^0-9]+', '', 'g')
								WHEN LENGTH(p.phone_work) > 0 THEN '+32'||regexp_replace(p.phone_work, '[^0-9]+', '', 'g')
								ELSE p.phone_work
							END
				  		=
				  			CASE
								WHEN substr(bron.telefoonnummer,1,2) = '00' THEN '+'||regexp_replace(substr(bron.telefoonnummer,3,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
								WHEN substr(bron.telefoonnummer,1,3) = '+32' THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
								WHEN substr(bron.telefoonnummer,1,1) = '0' THEN '+32'||regexp_replace(substr(bron.telefoonnummer,2,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
								WHEN LENGTH(regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
								WHEN LENGTH(bron.telefoonnummer) > 0 THEN '+32'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
				  				ELSE bron.telefoonnummer
							END THEN 1 ELSE 0 END check_telefoon_werk,
				  	--mobile
				  	CASE WHEN 
				  			CASE
								WHEN substr(p.mobile,1,2) = '00' THEN '+'||regexp_replace(substr(p.mobile,3,length(p.mobile)), '[^0-9]+', '', 'g')
								WHEN substr(p.mobile,1,3) = '+32' THEN '+'||regexp_replace(p.mobile, '[^0-9]+', '', 'g')
								WHEN substr(p.mobile,1,1) = '0' THEN '+32'||regexp_replace(substr(p.mobile,2,length(p.mobile)), '[^0-9]+', '', 'g')
								WHEN LENGTH(regexp_replace(p.mobile, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(p.mobile, '[^0-9]+', '', 'g')
								WHEN LENGTH(p.mobile) > 0 THEN '+32'||regexp_replace(p.mobile, '[^0-9]+', '', 'g')
								ELSE p.mobile
							END
				  		=
				  			CASE
								WHEN substr(bron.telefoonnummer,1,2) = '00' THEN '+'||regexp_replace(substr(bron.telefoonnummer,3,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
								WHEN substr(bron.telefoonnummer,1,3) = '+32' THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
								WHEN substr(bron.telefoonnummer,1,1) = '0' THEN '+32'||regexp_replace(substr(bron.telefoonnummer,2,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
								WHEN LENGTH(regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
								WHEN LENGTH(bron.telefoonnummer) > 0 THEN '+32'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
				  				ELSE bron.telefoonnummer
							END THEN 1 ELSE 0 END check_gsm
				FROM marketing._av_temp_mindwize bron, res_partner p
					--gegevens van eventuele partner
					LEFT OUTER JOIN res_partner p2 ON p.relation_partner_id = p2.id
					LEFT OUTER JOIN partner_inactive pi ON p.inactive_id = pi.id
					LEFT OUTER JOIN res_partner p3 ON p.active_partner_id = p3.id	
				WHERE CASE
						WHEN substr(p.mobile,1,2) = '00' THEN '+'||regexp_replace(substr(p.mobile,3,length(p.mobile)), '[^0-9]+', '', 'g')
						WHEN substr(p.mobile,1,3) = '+32' THEN '+'||regexp_replace(p.mobile, '[^0-9]+', '', 'g')
						WHEN substr(p.mobile,1,1) = '0' THEN '+32'||regexp_replace(substr(p.mobile,2,length(p.mobile)), '[^0-9]+', '', 'g')
						WHEN LENGTH(regexp_replace(p.mobile, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(p.mobile, '[^0-9]+', '', 'g')
						WHEN LENGTH(p.mobile) > 0 THEN '+32'||regexp_replace(p.mobile, '[^0-9]+', '', 'g')
						ELSE p.mobile
					END
					=
					CASE
						WHEN substr(bron.telefoonnummer,1,2) = '00' THEN '+'||regexp_replace(substr(bron.telefoonnummer,3,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
						WHEN substr(bron.telefoonnummer,1,3) = '+32' THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
						WHEN substr(bron.telefoonnummer,1,1) = '0' THEN '+32'||regexp_replace(substr(bron.telefoonnummer,2,length(bron.telefoonnummer)), '[^0-9]+', '', 'g')
						WHEN LENGTH(regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
						WHEN LENGTH(bron.telefoonnummer) > 0 THEN '+32'||regexp_replace(bron.telefoonnummer, '[^0-9]+', '', 'g')
						ELSE bron.telefoonnummer
					END
				--*/
				) x
			) y
		ORDER BY bron_id--, controle, sim_naam DESC	
		) z
	WHERE r = 1);
------------------------------------------------------------------
-- SELECT * FROM marketing._AV_temp_controletabel
------------------------------------------------------------------
--volledige selectie ter controle logica procedure
SELECT SQ1.*, u.login FROM
	(SELECT *, ROW_NUMBER() OVER (PARTITION BY bron_id ORDER BY controle DESC) r2
	FROM marketing._AV_temp_controletabel 
	WHERE lid > 0) SQ1
	JOIN res_users u ON u.id = SQ1.create_uid
--WHERE 	SQ1.bron_naam = 'daan stemgee'
WHERE SQ1.r2 = 1
------------------------------------------------------------------
-- opschonen telefoonnummers
-- - niet numerieke tekens verwijderen: regexp_replace(p.phone, '[^0-9]+', '', 'g')
-- - vervangen leading '00' door '+'
-- - vervangen leading '0' door '+32'
-- - toevoegen '+' indien met verwijderen niet numerieke tekens langer dan 10
-- - als aan geen van bovenstaande is voldaan maar lengte is > 0 '+32' toevoegen na verwijderen niet numerieke tekens
-------------------------------------------------------------------
/*
SELECT p.id, p.membership_nbr, p.membership_state, /*partner + dubbel toevoegen*/
	p.email, p.email_work, 
	--p.phone,
	CASE
		WHEN substr(p.phone,1,2) = '00' THEN '+'||regexp_replace(substr(p.phone,3,length(p.phone)), '[^0-9]+', '', 'g')
		WHEN substr(p.phone,1,3) = '+32' THEN regexp_replace(p.phone, '[^0-9]+', '', 'g')
		WHEN substr(p.phone,1,1) = '0' THEN '+32'||regexp_replace(substr(p.phone,2,length(p.phone)), '[^0-9]+', '', 'g')
		WHEN LENGTH(regexp_replace(p.phone, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(p.phone, '[^0-9]+', '', 'g')
		WHEN LENGTH(p.phone) > 0 THEN '+32'||regexp_replace(p.phone, '[^0-9]+', '', 'g')
	END phone, 
	CASE
		WHEN substr(p.mobile,1,2) = '00' THEN '+'||regexp_replace(substr(p.mobile,3,length(p.mobile)), '[^0-9]+', '', 'g')
		WHEN substr(p.mobile,1,3) = '+32' THEN regexp_replace(p.phone, '[^0-9]+', '', 'g')
		WHEN substr(p.mobile,1,1) = '0' THEN '+32'||regexp_replace(substr(p.mobile,2,length(p.mobile)), '[^0-9]+', '', 'g')
		WHEN LENGTH(regexp_replace(p.mobile, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(p.mobile, '[^0-9]+', '', 'g')
		WHEN LENGTH(p.mobile) > 0 THEN '+32'||regexp_replace(p.mobile, '[^0-9]+', '', 'g')
	END mobile, 
	CASE
		WHEN substr(p.phone_work,1,2) = '00' THEN '+'||regexp_replace(substr(p.phone_work,3,length(p.phone_work)), '[^0-9]+', '', 'g')
		WHEN substr(p.phone_work,1,3) = '+32' THEN regexp_replace(p.phone, '[^0-9]+', '', 'g')
		WHEN substr(p.phone_work,1,1) = '0' THEN '+32'||regexp_replace(substr(p.phone_work,2,length(p.phone_work)), '[^0-9]+', '', 'g')
		WHEN LENGTH(regexp_replace(p.phone_work, '[^0-9]+', '', 'g')) > 10 THEN '+'||regexp_replace(p.phone_work, '[^0-9]+', '', 'g')
		WHEN LENGTH(p.phone_work) > 0 THEN '+32'||regexp_replace(p.phone_work, '[^0-9]+', '', 'g')
	END phone_work
FROM res_partner p

WHERE p.active -- AND p.id = 307508 
	AND (COALESCE(p.email,'n/a') <> 'n/a' AND COALESCE(p.email_work,'n/a') <> 'n/a' OR COALESCE(p.phone,'n/a') <> 'n/a' OR COALESCE(p.phone_work,'n/a') <> 'n/a' )
*/