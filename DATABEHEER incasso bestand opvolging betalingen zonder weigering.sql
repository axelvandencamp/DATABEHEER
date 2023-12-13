--------------------------------------------------
-- INCASSO BESTAND opvolging contacten zonder weigering: weigeringen worden verwijderd uit de betaallijnen
--------------------------------------------------
SELECT po.reference, pl.name, pl.communication, pl.communication2, pl.partner_id,
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
FROM res_partner p 
	JOIN payment_line pl ON pl.partner_id = p.id
	JOIN payment_order po ON pl.order_id = po.id 
		--land, straat, gemeente info
	JOIN res_country c ON p.country_id = c.id
	LEFT OUTER JOIN res_country_city_street ccs ON p.street_id = ccs.id
	LEFT OUTER JOIN res_country_city cc ON p.zip_id = cc.id
WHERE po.reference IN ('2023/05863','2023/05864')	
