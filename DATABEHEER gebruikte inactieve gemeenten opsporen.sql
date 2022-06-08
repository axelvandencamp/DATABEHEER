SELECT p.id, p.active, p.membership_state, cc.zip, cc.name, p.zip, p.city
FROM res_partner p
	JOIN res_country_city cc ON cc.id = p.zip_id
WHERE cc.zip = '1050'
	--cc.zip BETWEEN '3500' AND '3999'
	AND cc.active = 'false'
	AND p.country_id = 21
	AND p.active = 'false'
	
SELECT * 
FROM res_country_city	
WHERE zip = '1050'