/*
--------------------------------------------------
-- vaste tabel
-- - NIET droppen
-- - NIET opnieuw aanmaken
--------------------------------------------------
-- DROP TABLE marketing._m_dwh_koalectv2;
CREATE TABLE marketing._m_dwh_koalectv2 (
	"Procedure"	varchar,
	Campaign varchar,
	Project varchar,
	"ID" integer,
	"Date" text,
	Status varchar,
	Category varchar,
	Payment_method varchar,
	Tax_receipt varchar,
	amount text,
	Fees text,
	Net_amount text,
	Currency varchar,
	Bank_statement varchar,
	Payout_ID varchar,
	Payout_arrival_date text,
	Payout_amount text,
	Payout_bank_statement varchar,
	"Language" varchar,
	Firstname varchar,
	Lastname varchar,
	Email varchar,
	Gender varchar,
	Business_Name varchar,
	Business_VAT varchar,
	Birthday text,	
	Address_Line_1 varchar,
	Address_Line_2 varchar,
	Address_Box varchar,
	Address_House_Number varchar,
	City varchar,
	Zip_code varchar,
	Country varchar,
	Phone_Number varchar,
	Campaign_ID varchar,
	Project_ID varchar,
	External_reference varchar,
	User_ID varchar,
	Is_Anonymous varchar,
	Terms_of_Use varchar,
	Newsletter varchar,
	SMS_Content varchar,
	Subscription_ID varchar,
	Is_Subscription varchar,
	Is_Subscription_Active varchar,
	Procedure_ID varchar,
	Updated_at varchar,
	Procedure_Category varchar,
	Payment_Provider_Name varchar,
	Tax_Receipt_Allowed varchar,
	Benefiting varchar,
	National_ID varchar
	);

SELECT * FROM marketing._m_dwh_koalectv2 ORDER BY "Date" ASC;