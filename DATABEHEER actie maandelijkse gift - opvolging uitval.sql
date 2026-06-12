-- -----------------------------------
-- -- actie maandelijkse gift       --
-- -- opvolging: deelnemer vs uital --
--                                  -- 
-- -- UNDER CONSTRUCTION            --
-- -----------------------------------
-- prefix "vz" = verzendlijst; "dn" = deelnemer
SELECT 
	CASE
		WHEN ddl.aanmaak_factuur < (date_trunc('month', now()) - interval '2 month') THEN 'uitval'
		ELSE 'actief'
	END uitval,
	ddl.aanmaak_factuur laatste_factuur, ddl.amount_total factuur_bedrag,
	p.id, p.name,
	sq2.*,
	dpa.interval_type dpa_interval, dpa.donation_amount dpa_bedrag,
	aaa.code project, aaa.name project_naam,
	COALESCE(sm.sm_state,'invalid') mandaat,
	--
	dpa.id dpa_id, dpa.donation_cancel dpa_cancel, dpa.donation_end dpa_end,
	aaa.id aaa_id, sm.pb_id, sm.sm_id
FROM res_partner p
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
	JOIN
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
	-- SEPA GIFT opdracht
	LEFT OUTER JOIN donation_partner_account dpa ON p.id = dpa.partner_id
	-- PROJECT: analytische code
	LEFT OUTER JOIN account_analytic_account aaa ON aaa.id = dpa.analytic_account_id
	-- MANDAAT INFO
	LEFT OUTER JOIN (SELECT pb.id pb_id, pb.partner_id pb_partner_id, sm.id sm_id, sm.state sm_state, pb.bank_bic sm_bank_bic, pb.acc_number sm_acc_number 
			FROM res_partner_bank pb JOIN sdd_mandate sm ON sm.partner_bank_id = pb.id 
			WHERE sm.state = 'valid') sm ON pb_partner_id = p.id
	-- GIFT FACTUUR info    
	LEFT OUTER JOIN (SELECT MAX(date_invoice) aanmaak_factuur, partner_id, amount_total FROM donation_donation_line GROUP BY partner_id, amount_total) ddl 
		ON dpa.partner_id = ddl.partner_id AND dpa.donation_amount = ddl.amount_total
WHERE dpa.interval_type = 'M'
ORDER BY ddl.aanmaak_factuur ASC