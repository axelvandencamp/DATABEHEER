-- ----------------------------------------------------------
-- selectie ID's met adres status "vermoedelijk verkeerd"
-- na 9 maanden nog niet aangepast naar "adres verkeerd"
-- - adres status mag leeggemaakt worden
-- ----------------------------------------------------------
SELECT * 
SELECT partner_id
FROM marketing._m_dwh_partners
WHERE adres_status_vermoedelijk AND COALESCE(adres_status_verkeerd,'false') = 'false'
	AND adres_status_vermoedelijk_datum <= date_trunc('month', now()- interval '9 month')::date
--
SELECT * FROM res_partner_address_state -- adres status leegmaken: id = 17
	