-----------------------------------------
--
-- Opsporen van LEDEN met geannuleerd mandaat nav weigeringen binnen een bepaalde periode
--
--------------------------------
--eventueel verder uit te werken voor extra details
-- - eg.: nr rekeningafschrift
--------------------------------
CREATE TABLE marketing._av_geregistreerdewebsitegebruikers (uid integer,Naam text,Email text,Sinds text,Laatste text,ERPid integer,ERPNaam text,Lidnr integer,Einddatum text);
-- manueel importeren; na procedure DROPpen (zie onderaan);
CREATE TABLE marketing._av_suppressionlist (EmailAddress text, Date_ text, Reason text, dummy text);
-- SELECT DISTINCT reason FROM marketing._av_suppressionlist;
-- manueel importeren; na procedure DROPpen (zie onderaan);
-- SELECT a.ERPid,  b.reason FROM marketing._av_geregistreerdewebsitegebruikers a LEFT OUTER JOIN marketing._av_suppressionlist b ON b.emailaddress = a.email WHERE COALESCE(b.reason,'ok')='ok'
-----------------------------------------
--SET VARIABLES
DROP TABLE IF EXISTS _AV_myvar;
CREATE TEMP TABLE _AV_myvar 
	(startdatum DATE, einddatum DATE);
INSERT INTO _AV_myvar VALUES('2023-01-01',	--startdatum
				'2023-12-31'	--einddatum
				);
SELECT * FROM _AV_myvar;
--====================================================================
SELECT	DISTINCT--COUNT(p.id) _aantal, now()::date vandaag
	p.id database_id, 
	p.membership_nbr lidnummer, 
	p.gender AS geslacht,
	p.first_name as voornaam,
	p.last_name as achternaam,
	p.street2 building,
	CASE
		WHEN c.id = 21 AND p.crab_used = 'true' THEN ccs.name
		ELSE p.street
	END straat,
	CASE
		WHEN c.id = 21 AND p.crab_used = 'true' THEN p.street_nbr ELSE ''
	END huisnummer, 
	p.street_bus bus,
	CASE
		WHEN c.id = 21 AND p.crab_used = 'true' THEN cc.zip
		ELSE p.zip
	END postcode,
	CASE 
		WHEN c.id = 21 THEN cc.name ELSE p.city 
	END woonplaats,
	p.postbus_nbr postbus,
	CASE
		WHEN p.country_id = 21 AND substring(p.zip from '[0-9]+')::numeric BETWEEN 1000 AND 1299 THEN 'Brussel' 
		WHEN p.country_id = 21 AND (substring(p.zip from '[0-9]+')::numeric BETWEEN 1500 AND 1999 OR substring(p.zip from '[0-9]+')::numeric BETWEEN 3000 AND 3499) THEN 'Vlaams Brabant'
		WHEN p.country_id = 21 AND substring(p.zip from '[0-9]+')::numeric BETWEEN 2000 AND 2999  THEN 'Antwerpen' 
		WHEN p.country_id = 21 AND substring(p.zip from '[0-9]+')::numeric BETWEEN 3500 AND 3999  THEN 'Limburg' 
		WHEN p.country_id = 21 AND substring(p.zip from '[0-9]+')::numeric BETWEEN 8000 AND 8999  THEN 'West-Vlaanderen' 
		WHEN p.country_id = 21 AND substring(p.zip from '[0-9]+')::numeric BETWEEN 9000 AND 9999  THEN 'Oost-Vlaanderen' 
		WHEN p.country_id = 21 THEN 'Wallonië'
		WHEN p.country_id = 166 THEN 'Nederland'
		WHEN NOT(p.country_id IN (21,166)) THEN 'Buitenland niet NL'
		ELSE 'andere'
	END AS provincie,
	c.name land,
	cc.zip||ccs.id::text||p.street_nbr::text||p.street_bus::text adres_id,
	p.email,
	COALESCE(p.phone_work,p.phone) telefoonnr,
	p.mobile gsm,
	COALESCE(COALESCE(a2.name,a.name),'onbekend') Afdeling,
	COALESCE(mo.name,'') herkomst_lidmaatschap,
	p.membership_state huidige_lidmaatschap_status,
	SQ1.factuur, SQ1.OGM, SQ1.bedrag, SQ1.product,
	COALESCE(p.create_date::date,p.membership_start) aanmaak_datum,
	--ml.date_from lml_date_from,
	p.membership_start Lidmaatschap_startdatum, 
	p.membership_stop Lidmaatschap_einddatum,  
	p.membership_pay_date betaaldatum,
	p.membership_renewal_date hernieuwingsdatum,
	p.membership_end recentste_einddatum_lidmaatschap,
	p.membership_cancel membership_cancel,
	_crm_opzegdatum_membership(p.id) opzegdatum_LML,
	p.active,
	CASE
		WHEN COALESCE(p.no_magazine,'f') = 't' THEN 1 ELSE 0 
	END gn_magazine_gewenst,
	CASE
		WHEN p.address_state_id = 2 THEN 1 ELSE 0
	END adres_verkeerd,
	CASE
		WHEN COALESCE(sm.sm_id,0) > 0 THEN 1 ELSE 0
	END DOMI,
	CASE
		WHEN COALESCE(p.recruiting_organisation_id,0) > 0 THEN 1 ELSE 0
	END via_afdeling,
	CASE
		WHEN COALESCE(p.opt_out_letter,'f') = 'f' THEN 0 ELSE 1
	END wenst_geen_post_van_NP,
	CASE
		WHEN COALESCE(p.opt_out,'f') = 'f' THEN 0 ELSE 1
	END wenst_geen_email_van_NP,
	p.iets_te_verbergen nooit_contacteren,
	CASE WHEN login = 'apiuser' THEN 1 ELSE 0 END via_website,
	CASE WHEN login <> 'apiuser' THEN 1 ELSE 0 END via_andere,
	SQ2.erpid geregistreerdgebruiker,
	SQ2.reason suppressionreason
FROM 	_av_myvar v, res_partner p
	--Voor de ontdubbeling veroorzaakt door meedere lidmaatschapslijnen
	LEFT OUTER JOIN (SELECT MAX(ml.id) ml_id, ml.partner FROM _av_myvar v, membership_membership_line ml JOIN product_product pp ON pp.id = ml.membership_id WHERE  ml.state = 'invoiced' AND pp.membership_product GROUP BY ml.partner) ml ON ml.partner = p.id
	--idem: versie voor jaarwisseling (januari voor vorige jaar)
	--LEFT OUTER JOIN (SELECT * FROM _av_myvar v, membership_membership_line ml JOIN product_product pp ON pp.id = ml.membership_id WHERE  ml.state = 'paid' AND ml.date_to BETWEEN v.startdatum and v.einddatum AND pp.membership_product) ml ON ml.partner = p.id
	--ophalen OGM, bedrag, product
	JOIN _crm_leden_factuurinfo() SQ1 ON SQ1.id = ml.ml_id
	--land, straat, gemeente info
	JOIN res_country c ON p.country_id = c.id
	LEFT OUTER JOIN res_country_city_street ccs ON p.street_id = ccs.id
	LEFT OUTER JOIN res_country_city cc ON p.zip_id = cc.id
	--herkomst lidmaatschap
	LEFT OUTER JOIN res_partner_membership_origin mo ON p.membership_origin_id = mo.id
	--aangemaakt door 
	JOIN res_users u ON u.id = p.create_uid
	--afdeling vs afdeling eigen keuze
	LEFT OUTER JOIN res_partner a ON p.department_id = a.id
	LEFT OUTER JOIN res_partner a2 ON p.department_choice_id = a2.id
	--bank/mandaat info
	--door bank aan mandaat te linken en enkel de mandaat info te nemen ontdubbeling veroorzaakt door meerdere bankrekening nummers
	LEFT OUTER JOIN (SELECT pb.id pb_id, pb.partner_id pb_partner_id, sm.id sm_id, sm.state sm_state FROM res_partner_bank pb JOIN sdd_mandate sm ON sm.partner_bank_id = pb.id WHERE sm.state = 'valid') sm ON pb_partner_id = p.id
	--facturen info
	--LEFT OUTER JOIN account_invoice_line il ON il.id = ml.account_invoice_line
	--LEFT OUTER JOIN account_invoice i ON i.id = il.invoice_id
	--aanspreking
	LEFT OUTER JOIN res_partner_title pt ON p.title = pt.id
	--parnter info
	--LEFT OUTER JOIN res_partner a3 ON i.partner_id = a3.id
	LEFT OUTER JOIN res_partner p6 ON p.relation_partner_id = p6.id
	--wervend lid
	LEFT OUTER JOIN res_partner p2 ON p.recruiting_member_id = p2.id
	--wervende organisatie
	LEFT OUTER JOIN res_partner p5 ON p.recruiting_organisation_id = p5.id
	--tijdschriften
	LEFT OUTER JOIN mailing_mailing mm1 ON mm1.id = p.periodical_1_id
	LEFT OUTER JOIN mailing_mailing mm2 ON mm2.id = p.periodical_2_id
	--geregistreerde gebruikers
	LEFT OUTER JOIN (SELECT a.ERPid,  b.reason
					FROM marketing._av_geregistreerdewebsitegebruikers a
						LEFT OUTER JOIN marketing._av_suppressionlist b ON b.emailaddress = a.email
					WHERE COALESCE(b.reason,'ok')='ok') SQ2 ON SQ2.erpid = p.id
WHERE p.id IN (SELECT p.id--, p.membership_state
			   FROM _av_myvar v, res_partner p JOIN account_coda_sdd_refused csf ON p.id = csf.partner_id 
			   WHERE csf.create_date::date BETWEEN v.startdatum AND v.einddatum	AND p.membership_state = 'waiting'
			   		AND csf.reason <> 'MD07' -- MD07 = Debtor Deceased
			   ORDER BY csf.create_date::date)
-- SELECT * FROM account_coda_sdd_refused csf WHERE reason = 'MD07' -- MD07 = Debtor Deceased
-------------------------------------------------------------
-- DROP TABLE marketing._av_geregistreerdewebsitegebruikers;
-- DROP TABLE marketing._av_suppressionlist;
