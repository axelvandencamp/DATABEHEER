-------------------------------------
-- export from mykoalect
-- -
-- DELETE FROM marketing._m_stg_koalectv2
-- SELECT * FROM marketing._m_stg_koalectv2
-- -
-- import (manual) into marketing._m_stg_koalectv2
----------------------------------------------------------
-- nieuwe records toevoegen aan marketing._m_dwh_koalectV2
----------------------------------------------------------
INSERT INTO marketing._m_dwh_koalectV2 (procedure, campaign, project, transactie_id, date, status, category, payment_method, tax_receipt, amount, fees,
	net_amount, currency, bank_statement, payout_id, payout_arrival_date, payout_amount, payout_bank_statement, language, firstname,
	lastname, email, gender, business_name, business_vat, birthday,	address_line_1, address_line_2, address_box, address_house_number,
	city, zip_code, country, phone_number, campaign_ID, project_ID, external_reference, user_ID, is_anonymous, terms_of_use, newsletter,
	SMS_Content, Subscription_ID, Is_Subscription, Is_Subscription_Active, Procedure_ID, Updated_at, Procedure_Category, Payment_Provider_Name,
	tax_receipt_allowed, benefiting, national_ID, benefiting_reference, salutation)
SELECT * 
FROM marketing._m_stg_koalectv2
WHERE transactie_id NOT IN (SELECT transactie_id FROM marketing._m_dwh_koalectV2)

SELECT max(date) datum FROM marketing._m_dwh_koalectV2
