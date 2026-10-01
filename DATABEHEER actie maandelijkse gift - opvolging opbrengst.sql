---------------------------------------------------------------
-- alle betaalde facturen (niet CN) van deelnemers aan de actie
-- -
-- SQ2: deelnemers actie
-- dpa: SEPA_Giften opdracht
-- ddl: factuurlijnen SEPA_Giften
-- SQ1: factuur info betaalde facturen (niet door CN)
-- aaa: project info
-- -------------------------------------------------------------
--=================================================================
--temp table: formulieren + projectcodes koalect data
DROP TABLE IF EXISTS koalect_actie_maandelijkse_gift;
CREATE TEMP TABLE koalect_actie_maandelijkse_gift 
	(actie_formulier TEXT, project_code TEXT );

INSERT INTO koalect_actie_maandelijkse_gift --VALUES
	(SELECT DISTINCT form_name, external_reference FROM marketing._m_dwh_koalectdata_m_gift);
-- SELECT * FROM marketing._m_dwh_koalectdata_m_gift WHERE contributor_firstname = 'Xavier'
-- SELECT * FROM marketing._m_dwh_koalectdata_m_gift WHERE contributor_lastname = 'Van Cutsem'
-- SELECT DISTINCT form_name, external_reference FROM marketing._m_dwh_koalectdata_m_gift WHERE created_date::date < '2026-01-01'
SELECT * FROM koalect_actie_maandelijkse_gift;
--====================================================================
SELECT p.id, p.name naam_deelnemer, sq2.partner_id, sq2.name, 
	REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(COALESCE(LOWER(sq2.info),'n/a'),chr(9),''),chr(10),''),chr(11),''),chr(12),''),chr(13),'') info,
	sq2.date, sq2.email,
	COALESCE(sq1.i_id,0) i_id, COALESCE(sq1.i_reference,'') i_reference, COALESCE(sq1.i_number,'') i_number, COALESCE(sq1.i_amount_total,0) i_amount_total, COALESCE(sq1.i_date_invoice,'1900-01-01') i_date_invoice, --sq1.cn_factuurnr, 
	dpa.id dpa_id, dpa.partner_id dpa_partner_id,
	CASE WHEN COALESCE(dpa.donation_cancel,'1900-01-01') > '1900-01-01' THEN p.id ELSE 0 END dpa_opgezegd,
	COALESCE(ddl.id,0) ddl_id, /*ddl.analytic_account_id ddl_analytic_account_id, ddl.invoice_id ddl_invoice_id,*/
	/*aaa.id aaa_id,*/ COALESCE(aaa.code,'') project, COALESCE(aaa.name,'') project_name
--SELECT DISTINCT p.id
FROM /*koalect_actie_maandelijkse_gift k,*/ res_partner p 
	JOIN
	-- SQ2: deelname actie
	(SELECT DISTINCT p.id partner_id, mcf.name, mei.info, mch.datetime::date date, p.email
	FROM res_partner p
		JOIN res_crm_marketing_contact_history mch ON mch.history_id = p.id
		JOIN res_crm_marketing_contact_fase mcf ON mcf.id = mch.contact_fase
		JOIN res_crm_marketing_extra_info mei ON mei.info_id = mch.history_id AND mei.datetime::date = mch.datetime::date
	WHERE mcf.id = 1039 AND mei.author <> 584   -- Jasmine Verbruggen uitsluiten om de verzendlijst van de actie uit 042025 uit te filteren;
	--ORDER BY mch.datetime::date DESC
	--WHERE mcf.id = 1039 -- mei.author niet meer nodig vanaf 2026
	) SQ2 ON sq2.partner_id = p.id -- AND sq2.info = k.actieformulier
	JOIN donation_partner_account dpa ON dpa.partner_id = p.id
	JOIN account_analytic_account aaa2 ON aaa2.id = dpa.analytic_account_id
	LEFT OUTER JOIN donation_donation_line ddl ON ddl.donation_id = dpa.id 
	LEFT OUTER JOIN account_analytic_account aaa ON aaa.id = ddl.analytic_account_id
	--JOIN account_invoice i ON i.id = ddl.invoice_id
	-- SQ1: betaalde factuur niet door credit_nota
	LEFT OUTER JOIN (
		SELECT i.id i_id, i.reference i_reference, i.number i_number, i.amount_total i_amount_total, i.date_invoice i_date_invoice,
			cn.id cn_id, cn.factuurnr cn_factuurnr, cn.reference cn_reference
		FROM account_invoice i
			LEFT OUTER JOIN marketing._m_dwh_creditnotas cn ON cn.reference = i.reference
		WHERE i.state = 'paid'
			AND COALESCE(cn.factuurnr,'_') = '_' -- factuur betaald (niet door cn)
			--AND NOT(COALESCE(cn.factuurnr,'_') = '_') -- enkel factuur betaald door creditnota's
		) SQ1 ON sq1.i_id = ddl.invoice_id
	
	
	
WHERE interval_type = 'M' 
	--AND NOT(aaa.code = 'F-03010')
	 --AND aaa2.code IN (SELECT DISTINCT project_code FROM koalect_actie_maandelijkse_gift)
	 --AND REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(COALESCE(LOWER(sq2.info),'n/a'),chr(9),''),chr(10),''),chr(11),''),chr(12),''),chr(13),'') LIKE '%scheldemeersen/d'
ORDER BY sq2.date DESC --dpa.partner_id


------------------------------
-- projecten 062026
-- - NP WAL bouw natuurcentrum Beveren
-- - NP Aalst Beneden-Dender
-- - NP Brugge Polders Koolkerke Dudzele
-- - NP Middenkust Zwaanhoek
-- - NP Genk Stiemerbeekvallei