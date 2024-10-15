--SET VARIABLES
DROP TABLE IF EXISTS _AV_myvar;
CREATE TEMP TABLE _AV_myvar 
	(startdatum DATE, einddatum DATE);
INSERT INTO _AV_myvar VALUES('2024-02-01',	--startdatum
				'2024-12-31'	--einddatum
				);
SELECT * FROM _AV_myvar;
--====================================================================
SELECT p.id, p.membership_nbr, 'prioriteit', p.name, p.membership_state, sm.sm_last_debit_date, sm.sm_state,
    COALESCE(COALESCE(p.phone_work,p.phone),'') telefoonnr,
    COALESCE(p.mobile,'') gsm,
    COALESCE(p.first_name,'') as voornaam,
    COALESCE(p.last_name,'') as achternaam,
    COALESCE(p.street2,'') huisnaam,
    CASE
        WHEN c.id = 21 AND p.crab_used = 'true' THEN COALESCE(ccs.name,'')
        ELSE COALESCE(p.street,'')
    END straat,
    CASE
        WHEN c.id = 21 AND p.crab_used = 'true' THEN COALESCE(p.street_nbr,'') ELSE ''
    END huisnummer, 
    COALESCE(p.street_bus,'') bus,
    CASE
        WHEN c.id = 21 AND p.crab_used = 'true' THEN COALESCE(cc.zip,'')
        ELSE COALESCE(p.zip,'')
    END postcode,
    CASE 
        WHEN c.id = 21 THEN COALESCE(cc.name,'') ELSE COALESCE(p.city,'') 
    END woonplaats,
    _crm_land(c.id) land,
    p.email,
    CASE
        WHEN p.address_state_id = 2 THEN 1 ELSE 0
    END adres_verkeerd,
    CASE
        WHEN COALESCE(p.opt_out_letter,'f') = 'f' THEN 0 ELSE 1
    END wenst_geen_post_van_NP,
    CASE
        WHEN COALESCE(p.opt_out,'f') = 'f' THEN 0 ELSE 1
    END wenst_geen_email_van_NP
    --, p.iets_te_verbergen nooit_contacteren
FROM _av_myvar v, res_partner p
    --land, straat, gemeente info
    JOIN res_country c ON p.country_id = c.id
    LEFT OUTER JOIN res_country_city_street ccs ON p.street_id = ccs.id
    LEFT OUTER JOIN res_country_city cc ON p.zip_id = cc.id
    --bank/mandaat info
    --door bank aan mandaat te linken en enkel de mandaat info te nemen ontdubbeling veroorzaakt door meerdere bankrekening nummers
    JOIN (SELECT pb.id pb_id, pb.partner_id pb_partner_id, sm.id sm_id, sm.state sm_state, sm.last_debit_date sm_last_debit_date FROM res_partner_bank pb JOIN sdd_mandate sm ON sm.partner_bank_id = pb.id WHERE sm.state = 'cancel') sm ON pb_partner_id = p.id
WHERE sm.sm_state = 'cancel' and sm.sm_last_debit_date > v.startdatum
    AND NOT(p.membership_state IN ('paid','free','old'))
    AND COALESCE(p.iets_te_verbergen,false) = false -- AND p.opt_out AND p.opt_out_letter
	AND p.id IN (SELECT p.id--, p.membership_state
			   FROM _av_myvar v, res_partner p JOIN account_coda_sdd_refused csf ON p.id = csf.partner_id 
			   WHERE csf.create_date::date BETWEEN v.startdatum AND v.einddatum	--AND p.membership_state = 'waiting'
			   		AND csf.reason <> 'MD07' -- MD07 = Debtor Deceased
			   ORDER BY csf.create_date::date)
ORDER BY sm.sm_last_debit_date DESC