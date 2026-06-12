-- --------------------------------------------------------------------------
-- -- actie maandelijkse gift                                              --
-- -- opvolging: [partner_id] in verzendlijst vs [partner_id] is deelnemer --
-- --------------------------------------------------------------------------
-- prefix "vz" = verzendlijst; "dn" = deelnemer
SELECT p.id, p.name,
	sq1.name vz_name, sq1.info vz_info, sq1.date vz_date,
	sq2.name dn_name, sq2.info dn_info, sq2.date dn_info
FROM 
	res_partner p
	JOIN
	-- SQ1: verzendlijst actie
	(SELECT DISTINCT p.id partner_id, mcf.name, mei.info, mch.datetime::date date, p.email
	FROM res_partner p
		JOIN res_crm_marketing_contact_history mch ON mch.history_id = p.id
		JOIN res_crm_marketing_contact_fase mcf ON mcf.id = mch.contact_fase
		JOIN res_crm_marketing_extra_info mei ON mei.info_id = mch.history_id AND mei.datetime::date = mch.datetime::date
	WHERE mcf.id = 1039 AND mei.info LIKE '%#24184' --mcf.id specifiek voor actie uit 042025;
	--WHERE mcf.id = 24 AND mei.info LIKE '%#27044' --mcf.id gebruikt vanaf 2026
		-- mcf.id = 'actie maandelijkse gift'
	) SQ1
	ON p.id = sq1.partner_id
	LEFT OUTER JOIN
	-- SQ2: deelname actie
	(SELECT DISTINCT p.id partner_id, mcf.name, mei.info, mch.datetime::date date, p.email
	FROM res_partner p
		JOIN res_crm_marketing_contact_history mch ON mch.history_id = p.id
		JOIN res_crm_marketing_contact_fase mcf ON mcf.id = mch.contact_fase
		JOIN res_crm_marketing_extra_info mei ON mei.info_id = mch.history_id AND mei.datetime::date = mch.datetime::date
	WHERE mcf.id = 1039 AND mei.author <> 584   -- specifiek voor actie uit 042025; vanaf 2026 is [mcf.id] verschillend zodat daarop kan gefilterd worden
	--WHERE mcf.id = 1039 -- mei.author niet meer nodig vanaf 2026
	) SQ2
	ON sq2.partner_id = sq1.partner_id
ORDER BY sq1.date, sq2.date


