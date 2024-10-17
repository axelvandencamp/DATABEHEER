SELECT p.id, p.name, p.membership_state
FROM res_partner p
WHERE p.membership_state IN ('paid','invoiced','free')
	AND p.membership_end <= '2024-12-31' AND NOT(p.membership_stop = '2025-12-31')
	AND COALESCE(p.membership_cancel,'1900-01-01') = '1900-01-01'