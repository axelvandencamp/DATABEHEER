------------------
-- selecteer alle partner_id met "adres vermoedelijk verkeer" geregistreerd langer dan 9 maanden geleden
-- laatste veld is waarde voor update van het "adres status" veld naar LEEG
------------------
SELECT p_dwh.partner_id, p_dwh.adres_status_vermoedelijk, p_dwh.adres_status_vermoedelijk_datum, p_dwh.adres_status_verkeerd, p_dwh.adres_status_verkeerd_datum
	, 17 as address_state_id
FROM marketing._m_dwh_partners p_dwh
	-- enkele actieven?  (nog toe te voegen)
WHERE p_dwh.adres_status_vermoedelijk
	--AND p_dwh.adres_status_verkeerd
	AND p_dwh.adres_status_vermoedelijk_datum < CURRENT_DATE - INTERVAL '9 months' - (EXTRACT(DAY FROM CURRENT_DATE) - 1) * INTERVAL '1 day'
ORDER BY p_dwh.adres_status_vermoedelijk_datum ASC


------------------
-- 9 maanden terug
------------------
-- SELECT CURRENT_DATE - INTERVAL '9 months' - (EXTRACT(DAY FROM CURRENT_DATE) - 1) * INTERVAL '1 day';
------------------
-- adres statussen
------------------
-- SELECT * FROM res_partner_address_state
------------------