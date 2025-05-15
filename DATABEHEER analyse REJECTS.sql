SELECT p.id partner_id, /*p.active,*/ csf.* 
--SELECT DISTINCT csf.mandate_ref
--SELECT DISTINCT p.id
FROM res_partner p 
	JOIN account_coda_sdd_refused csf ON p.id = csf.partner_id  
WHERE csf.create_date::date BETWEEN '2023-12-01' AND '2024-03-31'
	AND reason LIKE '%SL01'



SELECT sq1.jaar, sq1.maand, sq1.reason, COUNT(sq1.id) aantal, sq1.type_rej
--SELECT COUNT(sq1.id) aantal
FROM (
	SELECT p.id, csf.mandate_ref, EXTRACT(year FROM csf.create_date) jaar, EXTRACT(month FROM csf.create_date) maand, csf.reason, 
		CASE
			WHEN csf.comm LIKE '%GIFT%' THEN 'gift'
			WHEN csf.comm LIKE '%LIDM%' THEN 'lidm'
			ELSE 'diff'
		END type_rej
	--SELECT DISTINCT(csf.mandate_ref)
	FROM res_partner p 
		JOIN account_coda_sdd_refused csf ON p.id = csf.partner_id  
	WHERE csf.create_date::date BETWEEN '2024-12-01' AND '2025-03-31'
	) sq1
WHERE sq1.type_rej = 'lidm'	
GROUP BY 	sq1.maand, sq1.jaar, sq1.reason, sq1.type_rej
