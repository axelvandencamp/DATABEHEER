SELECT SUM(sq1."-221- aantal") "221_aantal",
	SUM(sq1."-288- aantal") "288_aantal",
	SUM(sq1."-029- aantal") "029_aantal",
	SUM(sq1."-221- aantal"+sq1."-288- aantal"+sq1."-029- aantal") ru_aantal,
	MAX("-221- DD")  "221_DD",MAX("-288- DD") "288_DD", MAX("-029- DD") "029_DD",
	MAX("-221- DD")+MAX("-288- DD")+MAX("-029- DD") ru_dd,
	datum_afschrift, jaar_afschrift, maand_afschrift, dag_afschrift
FROM (
	SELECT bs.name,
		--aantal lijnen
		CASE WHEN bs.name LIKE '%-221-%' THEN 1 ELSE 0 END AS "-221- aantal" ,
		CASE WHEN bs.name LIKE '%-288-%' THEN 1 ELSE 0 END AS "-288- aantal" ,
		CASE WHEN bs.name LIKE '%-029-%' THEN 1 ELSE 0 END AS "-029- aantal" ,
		--offsett afschrift - validatie
		CASE WHEN bs.name LIKE '%-221-%' 
			THEN date_part('day',AGE(bsl.write_date::date, bs.date))::integer ELSE 0
		END "-221- DD"	,
		CASE WHEN bs.name LIKE '%-288-%' 
			THEN date_part('day',AGE(bsl.write_date::date, bs.date))::integer ELSE 0
		END "-288- DD"	,
		CASE WHEN bs.name LIKE '%-029-%' 
			THEN date_part('day',AGE(bsl.write_date::date, bs.date))::integer ELSE 0
		END "-029- DD"	,

		bsl.write_date::date datum_validatie, 
		bs.date datum_afschrift, date_part('YEAR',bs.date) jaar_afschrift, date_part('MONTH',bs.date) maand_afschrift, date_part('DAY',bs.date) dag_afschrift
	FROM account_bank_statement bs 
		JOIN account_bank_statement_line bsl ON bsl.statement_id = bs.id
	WHERE (bs.name LIKE '%-221-%' OR bs.name LIKE '%-288-%' OR bs.name LIKE '%-029-%' )
		AND bs.state = 'confirm'
		AND bs.date >= '2015-01-01'
	ORDER BY bs.date DESC
	) SQ1
GROUP BY datum_afschrift, jaar_afschrift, maand_afschrift, dag_afschrift
ORDER BY datum_afschrift DESC

/*
SELECT bsl.write_date::date, bsl.* 
FROM account_bank_statement_line bsl
WHERE bsl.statement_id = 25839

SELECT * FROM account_bank_statement bs WHERE bs.name = '20-221-075'
*/
