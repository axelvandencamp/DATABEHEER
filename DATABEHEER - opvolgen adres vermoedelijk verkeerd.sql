-- ----------------------------------------------------------
-- selectie ID's met adres status "vermoedelijk verkeerd"
-- na 9 maanden nog niet aangepast naar "adres verkeerd"
-- - adres status mag leeggemaakt worden
-- ----------------------------------------------------------
SELECT * 
SELECT dwh_p.partner_id
FROM marketing._m_dwh_partners dwh_p
	JOIN res_partner p ON p.id = dwh_p.partner_id
WHERE adres_status_vermoedelijk AND COALESCE(adres_status_verkeerd,'false') = 'false'
	AND adres_status_vermoedelijk_datum <= date_trunc('month', now()- interval '9 month')::date
	AND p.active
--
SELECT * FROM res_partner_address_state -- adres status leegmaken: id = 17
	