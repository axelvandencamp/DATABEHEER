DROP TABLE IF EXISTS marketing._m_dwh_pomtransactions_tobedeleted;
CREATE TABLE marketing._m_dwh_pomtransactions_tobedeleted (
	Transaction_ID text,
	Transaction_date timestamp,
	Customer_ID integer,
	Document_ID text,
	Amount numeric,
	Communication text,
	Status text,
	Payment_method text,
	Channel text,
	Beneficiary_IBAN text,
	dummy text
);
-----------------------------------
-- import manueel
-----------------------------------
-- bedrag "," vervangen door "."
-- - vervang ",00" door ".00" en ",50" door ".50"
-----------------------------------
SELECT * 
FROM marketing._m_dwh_pomtransactions_tobedeleted
WHERE transaction_date::date = '2025-12-15';
--
SELECT sum(amount) totaal
FROM marketing._m_dwh_pomtransactions_tobedeleted
WHERE transaction_date::date = '2025-12-15';
------------------------------------
-- vergelijken met rekeningafschriften
------------------------------------
-- ERP vs POM
--------------
SELECT bs.name erp_afschrift, bs.date erp_datum_afschrift, bsl.structcomm_message erp_comm, bsl.amount erp_bedrag,
	pom.communication pom_comm, pom.amount pom_amount, pom.transaction_id pom_transactie_id, pom.transaction_date pom_transaction_date,
	bsl.*
FROM   account_bank_statement bs
	INNER JOIN account_bank_statement_line bsl ON bs.id = bsl.statement_id
	FULL OUTER JOIN marketing._m_dwh_pomtransactions_tobedeleted pom ON pom.communication = bsl.structcomm_message
WHERE bs.name IN ('25-221-343')
	--AND bsl.date = '2025-12-15'
	--AND bsl.amount = 0
	AND LOWER(bsl.name) LIKE '%buckaroo%'
ORDER BY transaction_id DESC
--------------
-- POM vs ERP
--------------
SELECT bs.name erp_afschrift, bs.date erp_datum_afschrift, bsl.structcomm_message erp_comm, bsl.amount erp_bedrag,
	pom.communication pom_comm, pom.amount pom_amount, pom.transaction_id pom_transactie_id, pom.transaction_date pom_transaction_date
FROM   marketing._m_dwh_pomtransactions_tobedeleted pom
	LEFT OUTER JOIN account_bank_statement_line bsl ON bsl.structcomm_message = pom.communication
	LEFT OUTER JOIN account_bank_statement bs ON bs.id = bsl.statement_id
--WHERE --bs.name IN ('25-221-345')
	--AND bsl.date = '2025-12-15'
	--AND bsl.amount = 0
	--LOWER(bsl.name) LIKE '%buckaroo%'
ORDER BY pom.transaction_date DESC	

SELECT * FROM account_bank_statement LIMIT 100	

