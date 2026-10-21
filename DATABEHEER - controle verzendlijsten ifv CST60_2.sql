-------------------------------
-- type verzendlijsten
----------------------
SELECT DISTINCT mcf.id, mcf.name
FROM res_partner p
	JOIN res_crm_marketing_contact_history mch ON mch.history_id = p.id
	JOIN res_crm_marketing_contact_fase mcf ON mcf.id = mch.contact_fase
	JOIN res_crm_marketing_extra_info mei ON mei.info_id = mch.history_id AND mei.datetime::date = mch.datetime::date
WHERE mcf.id IN (24,25,26)
-------------------------------
-- verzendlijsten per gekozen type
-------------------------------
SELECT DISTINCT CASE WHEN mei.info LIKE '%#19833' THEN replace(mei.info,'Vinderhoutse bossen','Zevenbergenbos') ELSE mei.info END AS "info", mei.datetime::date
FROM res_partner p
	JOIN res_crm_marketing_contact_history mch ON mch.history_id = p.id AND mch.partner_type = 9
	JOIN res_crm_marketing_contact_fase mcf ON mcf.id = mch.contact_fase
	JOIN res_crm_marketing_extra_info mei ON mei.info_id = mch.history_id AND mei.datetime::date = mch.datetime::date AND mei.partner_type = 9
WHERE mcf.id = 26 -- $P{prm_lijst}
ORDER by mei.datetime::date DESC
-------------------------------
SELECT * FROM res_crm_marketing_partner_type -- "Databeheer/Ledenservice" = 9
SELECT * FROM res_crm_marketing_extra_info mei LIMIT 10
SELECT * FROM res_crm_marketing_contact_history mch LIMIT 10
-------------------------------
-- contacten per verzendlijst
-------------------------------
SELECT p.id, p.name, mei.info, mei.datetime::date
FROM res_partner p
	JOIN res_crm_marketing_contact_history mch ON mch.history_id = p.id
	JOIN res_crm_marketing_contact_fase mcf ON mcf.id = mch.contact_fase
	JOIN res_crm_marketing_extra_info mei ON mei.info_id = mch.history_id AND mei.datetime::date = mch.datetime::date
WHERE mcf.id = 26 -- $P{prm_lijst}
	AND mei.info LIKE '%stopzetting%'
	--AND (COALESCE(mei.info,'_') = '_' OR mei.info = '')
ORDER by mei.datetime::date DESC