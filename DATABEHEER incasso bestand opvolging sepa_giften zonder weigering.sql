--------------------------------------------------
-- INCASSO BESTAND opvolging contacten zonder weigering: 
-- - met partner info
-- - met SEPA_Giften opdracht info
-- - obv [_AV_myvar].[datum_inning] > [payment_order].[execution_date]
--------------------------------------------------
--SET VARIABLES
DROP TABLE IF EXISTS _AV_myvar;
CREATE TEMP TABLE _AV_myvar 
	(datum_inning DATE);

INSERT INTO _AV_myvar VALUES('2023-11-01');
SELECT * FROM _AV_myvar;
-----------------------------------------------------
-- informatie over weigeringen + partner_info ophalen
-----------------------------------------------------
SELECT weigering.reference, weigering.name, weigering.partner_id, weigering.voornaam, weigering.achternaam,
	weigering.huisnaam, weigering.straat, weigering.huisnummer, weigering.bus, weigering.postcode, weigering.woonplaats,
	weigering.postbus, weigering.land, weigering.lid, weigering.wenst_geen_post_van_np geen_post, weigering.wenst_geen_email_van_np geen_mail,
	weigering.nooit_contacteren, weigering.overleden,
	opdracht.internal_number factuur, opdracht.project_code project_code, opdracht.project project, opdracht.interval_type, opdracht.donation_start, opdracht.last_invoice_date
FROM
--SELECT * FROM
	(SELECT po.reference, pl.name, regexp_replace(pl.communication, '[^0-9]+', '', 'g') communication, pl.communication2, pl.partner_id,
		CASE WHEN COALESCE(p.membership_state,'geen_lid') IN ('paid','invoiced','free') THEN 'LID' ELSE 'geen_lid' END lid,
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
		COALESCE(p.postbus_nbr,'') postbus,
		_crm_land(c.id) land,
		CASE
			WHEN COALESCE(p.opt_out_letter,'f') = 'f' THEN 0 ELSE 1
		END wenst_geen_post_van_NP,
		CASE
			WHEN COALESCE(p.opt_out,'f') = 'f' THEN 0 ELSE 1
		END wenst_geen_email_van_NP,
		p.iets_te_verbergen nooit_contacteren,
		p.deceased overleden
	FROM _AV_myvar v, res_partner p 
		JOIN payment_line pl ON pl.partner_id = p.id
		JOIN payment_order po ON pl.order_id = po.id 
			--land, straat, gemeente info
		JOIN res_country c ON p.country_id = c.id
		LEFT OUTER JOIN res_country_city_street ccs ON p.street_id = ccs.id
		LEFT OUTER JOIN res_country_city cc ON p.zip_id = cc.id
	WHERE po.execution_date >  v.datum_inning
	ORDER BY regexp_replace(pl.communication, '[^0-9]+', '', 'g')
	) weigering
JOIN
--------------------------------------
-- informatie over SEPA Giften ophalen
--------------------------------------
	(SELECT DISTINCT i.internal_number, regexp_replace(i.reference, '[^0-9]+', '', 'g') reference, dpa.partner_id, aaa.code project_code, aaa.name project, p.name, dpa.interval_type, dpa.interval_number, dpa.donation_amount bedrag, /*ddl.invoice_id, i.state,*/ dpa.next_invoice_date, dpa.donation_start, dpa.last_invoice_date, dpa.donation_cancel,
		ddl.aanmaak_factuur, ddl.amount_total, ROW_NUMBER() OVER(PARTITION BY dpa.partner_id ORDER BY dpa.donation_amount asc) AS r
	FROM _AV_myvar v, res_partner p
		JOIN donation_partner_account dpa ON p.id = dpa.partner_id
	 	JOIN account_analytic_account aaa ON aaa.id = dpa.analytic_account_id
		JOIN (SELECT pb.id pb_id, pb.partner_id pb_partner_id, sm.id sm_id, sm.state sm_state, pb.bank_bic sm_bank_bic, pb.acc_number sm_acc_number FROM res_partner_bank pb JOIN sdd_mandate sm ON sm.partner_bank_id = pb.id WHERE sm.state = 'valid') sm ON pb_partner_id = p.id
		LEFT OUTER JOIN (SELECT MAX(date_invoice) aanmaak_factuur, partner_id, amount_total, invoice_id FROM donation_donation_line GROUP BY partner_id, amount_total, invoice_id) ddl 
			ON dpa.partner_id = ddl.partner_id AND dpa.donation_amount = ddl.amount_total
		JOIN account_invoice i ON i.id = ddl.invoice_id
	WHERE COALESCE(dpa.donation_cancel,now()::date) >= v.datum_inning
	ORDER BY regexp_replace(i.reference, '[^0-9]+', '', 'g')) opdracht
-- koppelen dmv ogm code
ON weigering.communication = opdracht.reference
--LIMIT 100

/*
SELECT aaa.code, aaa.name FROM account_analytic_account aaa WHERE aaa.id = 5553

SELECT * FROM donation_partner_account dpa LIMIT 10
SELECT * FROM donation_donation_line ddl WHERE ddl.partner_id IN (240632,374192)

SELECT * FROM payment_order po WHERE po.execution_date > '2023-12-01' LIMIT 100
*/