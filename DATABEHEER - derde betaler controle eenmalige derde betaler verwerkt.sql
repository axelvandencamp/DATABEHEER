-- #19809
-- De logica van "Eenmalige 3de Betaler" gaat bij het aanmaken van factuur het veld "3de Betaler Verwerkt" op "waar" zetten.
-- Achteraf "Eenmalige 3de Betaler" heeft geen invloed meer achteraf met op het veld "3de Betaler Verwerkt".
-- -------------------------------
-- is de "eenmalige derde betaler" voor een bepaald ID als op "3de betaler verwerkt" gezet?
-- -------------------------------
select p.third_payer_id,
	  p2.third_payer_amount,
	  p.third_payer_invoice,
	  p2.third_payer_one_time,
	  p.third_payer_processed,
	  p2.abo_company,
	  p2.company_deal
from res_partner p
	JOIN res_partner p2 ON p2.id = p.third_payer_id
where p.id = 403244
	and p.third_payer_id = p2.id
	--and (p.third_payer_processed = False or p.third_payer_processed IS NULL
	--  or p2.third_payer_one_time = False or p2.third_payer_one_time IS NULL)
-- ----------------------
-- gegevens partner(s) opzoeken obv 3de betaler id
-- ----------------------
select p.id partner_id, p.membership_state status, p.third_payer_id,
	  p2.third_payer_amount,
	  p.third_payer_invoice,
	  p2.third_payer_one_time,
	  p.third_payer_processed,
	  p2.abo_company,
	  p2.company_deal
from res_partner p
	JOIN res_partner p2 ON p2.id = p.third_payer_id
where p2.id = 14821
	and p.third_payer_id = p2.id