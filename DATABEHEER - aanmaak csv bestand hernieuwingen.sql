SELECT p.id, p.name, p.membership_state status--, p.membership_end, p.membership_stop
FROM res_partner p
	--bank/mandaat info
	LEFT OUTER JOIN (SELECT pb.id pb_id, pb.partner_id pb_partner_id, sm.id sm_id, sm.state sm_state FROM res_partner_bank pb JOIN sdd_mandate sm ON sm.partner_bank_id = pb.id WHERE sm.state = 'valid') sm ON pb_partner_id = p.id
WHERE p.membership_state IN ('paid','invoiced','free') AND p.active
	AND p.membership_end <= '2026-12-31' AND NOT(p.membership_stop > '2026-12-31')
	AND COALESCE(p.membership_cancel,'1900-01-01') = '1900-01-01'
	--AND COALESCE(sm.sm_id,0) = 0
	--AND p.id IN (382413,278938,297033,422680,307879)


/*
-- opzoeken aangemaakt csv bestand
SELECT * --convert_from(decode(encode(db_datas, 'escape'), 'base64'), 'UTF-8') 
FROM ir_attachment 
WHERE res_model = 'wizard.partner.to.renew' 
  ORDER BY id DESC 
LIMIT 10;	

-- opzoeken id's in csv bestand
SELECT convert_from(decode(encode(db_datas, 'escape'), 'base64'), 'UTF-8') 
FROM ir_attachment 
WHERE res_model = 'wizard.partner.to.renew' 
and id = 438270
  ORDER BY id DESC 
LIMIT 10;
*/