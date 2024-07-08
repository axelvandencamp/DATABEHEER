-------------------------------------
-- export from mykoalect
-- import (manual) into marketing._m_stg_koalectv2
----------------------------------------------------------
-- nieuwe records toevoegen aan marketing._m_dwh_koalectV2
----------------------------------------------------------
INSERT INTO marketing._m_dwh_koalectV2 ("Procedure", Campaign, Project, transactie_id, "Date", Status, Category, Payment_method, Tax_receipt, amount, Fees,
	Net_amount, Currency, Bank_statement, Payout_ID, Payout_arrival_date, Payout_amount, Payout_bank_statement, "Language", Firstname,
	Lastname, Email, Gender, Business_Name, Business_VAT, Birthday,	Address_Line_1, Address_Line_2, Address_Box, Address_House_Number,
	City, Zip_code, Country, Phone_Number, Campaign_ID, Project_ID, External_reference, User_ID, Is_Anonymous, Terms_of_Use, Newsletter,
	SMS_Content, Subscription_ID, Is_Subscription, Is_Subscription_Active, Procedure_ID, Updated_at, Procedure_Category, Payment_Provider_Name,
	Tax_Receipt_Allowed, Benefiting, National_ID, "Benefiting_reference", salutation)
SELECT * 
FROM marketing._m_stg_koalectv2
WHERE transactie_id NOT IN (SELECT transactie_id FROM marketing._m_dwh_koalectV2)

SELECT * FROM marketing._m_dwh_koalectV2
