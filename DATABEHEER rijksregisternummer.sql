SELECT COUNT(p.id) aantal --, p.national_id_nbr
FROM res_partner p
WHERE COALESCE(p.national_id_nbr,'_') <> '_'
	AND p.active
-------------------
SELECT p.id --, p.national_id_nbr
FROM res_partner p
WHERE COALESCE(p.national_id_nbr,'_') <> '_'
	AND p.active = false
-----------------------
-- aanpassingen in 2024
-----------------------
SELECT p.id, COALESCE(p.national_id_nbr,'_') national_id_nbr, u.login, p.write_date::date write_date 
FROM res_partner p 
	JOIN res_users u ON u.id = p.write_uid
WHERE 	u.login IN ('griet.vanddriessche','kristien.vercauteren','diederik.willems','lynn.sneyers','vera.baetens','linsay.bollen','axel.vandencamp') 
	AND (COALESCE(p.national_id_nbr,'_') <> '_')
	AND p.write_date::date >= '2024-01-01'
	

	