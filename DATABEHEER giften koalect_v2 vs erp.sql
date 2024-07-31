/*
SELECT COUNT(transactie_id) --procedure, campaign, project, transactie_id, date_, status, category, payment_method, tax_receipt, amount, fees, net_amount, currency, bank_statement, payout_id, payout_arrival_date, payout_amount, payout_bank_statement, language_, firstname, lastname, email, gender, business_name, business_vat, birthday, address_line_1, address_line_2, address_box, address_house_number, city, zip_code, country, phone_number, campaign_id, project_id, external_reference, user_id, is_anonymous, terms_of_use, newsletter, sms_content, subscription_id, is_subscription, is_subscription_active, procedure_id, updated_at, procedure_category, payment_provider_name, tax_receipt_allowed, benefiting, national_id, benefiting_reference
	FROM marketing._av_temp_koalectv2import;
	
DELETE FROM marketing._av_temp_koalectv2import


SELECT * FROM marketing._av_temp_koalectv2import
*/
DROP TABLE IF EXISTS _AV_myvar;
CREATE TEMP TABLE _AV_myvar 
	(startdatum DATE, einddatum DATE);
INSERT INTO _AV_myvar VALUES('2023-10-01',	--startdatum
				'2024-12-31');
----------------------
SELECT k.procedure k_procedure, k.campaign k_campaign, k.project k_project, k.benefiting_reference k_projectcode, sq1.erp_projcode, sq1.erp_projnaam, k.transactie_id k_transactie_id, sq1.erp_trans, k.date k_date, k.tax_receipt k_taxreceipt,
	k.net_amount k_bedrag, sq1.erp_bedrag,
	k.firstname k_firstname, k.lastname k_lastname, sq1.erp_naam, sq1.partner_id, sq1.erp_boeking, k.address_line_1 k_straat, k.address_house_number k_huisnr, k.address_box k_busnr, k.city k_city, k.zip_code k_postcode, 
	k.email k_email, k.national_id k_NN, 
	k.business_name k_bedrijf, k.business_vat k_btwnummer
FROM marketing._m_dwh_koalectv2 k
	LEFT OUTER JOIN
		(SELECT REPLACE(REPLACE(REPLACE(aml.name,';',','),chr(10),' '),chr(13), ' ') AS erp_descr,
			REPLACE(regexp_replace(REPLACE(REPLACE(REPLACE(aml.name,';',','),chr(10),' '),chr(13), ' '), '\D','','g'),'00000','') erp_trans,
			p.name as erp_naam,
			p.id partner_id,
			COALESCE(COALESCE(aaa3.code,aaa2.code),aaa1.code) AS erp_projcode,
			COALESCE(COALESCE(aaa3.name,aaa2.name),aaa1.name) AS erp_projnaam,		
			(aml.credit - aml.debit) erp_bedrag,
			am.name AS erp_boeking
			--, LOWER(REPLACE(REPLACE(REPLACE(REPLACE(aml.name,';',','),chr(10),' '),chr(13), ' '),' ','')) filter_str
		FROM _av_myvar v, account_move am
			INNER JOIN account_move_line aml ON aml.move_id = am.id
			INNER JOIN account_account aa ON aa.id = aml.account_id
			LEFT OUTER JOIN res_partner p ON p.id = aml.partner_id
			LEFT OUTER JOIN account_analytic_account aaa1 ON aml.analytic_dimension_1_id = aaa1.id
			LEFT OUTER JOIN account_analytic_account aaa2 ON aml.analytic_dimension_2_id = aaa2.id
			LEFT OUTER JOIN account_analytic_account aaa3 ON aml.analytic_dimension_3_id = aaa3.id
			JOIN res_company rc ON aml.company_id = rc.id 
			JOIN res_country c ON p.country_id = c.id
			LEFT OUTER JOIN res_country_city_street ccs ON p.street_id = ccs.id
			LEFT OUTER JOIN res_country_city cc ON p.zip_id = cc.id
			LEFT OUTER JOIN res_partner_title pt ON p.title = pt.id
			--afdeling vs afdeling eigen keuze
			LEFT OUTER JOIN res_partner a ON p.department_id = a.id
			LEFT OUTER JOIN res_partner a2 ON p.department_choice_id = a2.id
			--link naar partner		
			LEFT OUTER JOIN res_partner a5 ON p.relation_partner_id = a5.id
		WHERE (aa.code = '732100' OR  aa.code = '732000')
			AND LOWER(aml.name) LIKE '%buckaroo%'
			AND aml.date BETWEEN v.startdatum AND v.einddatum
			AND (p.active = 't' OR (p.active = 'f' AND COALESCE(p.deceased,'f') = 't'))	--van de inactieven enkele de overleden contacten meenemen
			/*AND (LOWER(REPLACE(REPLACE(REPLACE(REPLACE(aml.name,';',','),chr(10),' '),chr(13), ' '),' ','')) LIKE v.filter_str1
				OR LOWER(REPLACE(REPLACE(REPLACE(REPLACE(aml.name,';',','),chr(10),' '),chr(13), ' '),' ','')) LIKE v.filter_str2)*/
			--AND p.id = v.testID
		 	AND LENGTH(REPLACE(regexp_replace(REPLACE(REPLACE(REPLACE(aml.name,';',','),chr(10),' '),chr(13), ' '), '\D','','g'),'00000','')) <= 6
		ORDER BY aml.date
		) SQ1 ON SQ1.erp_trans  = k.transactie_id::text
WHERE sq1.partner_id IN (351547,404990)
/*WHERE bank_statement LIKE 'Expeditie%'
	AND LOWER(benefiting) LIKE '%keigat%'*/
--WHERE LOWER(k.project) LIKE '%iris%'
		
		