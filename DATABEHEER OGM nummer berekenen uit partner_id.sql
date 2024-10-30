SELECT sq1.id, '+++'||substring(sq1.ogm from 1 for 3)||'/'||substring(sq1.ogm from 4 for 4)||'/'||substring(sq1.ogm from 8 for 5)||'+++' ogm, 
	sq1.ogm controle
FROM (
	SELECT p.id,
	 	-- p.id kan 5 of 6 cijfers bevatten: vermenigvuldiging aanpassen om tot lengte van 10 cijfers te komen
		CASE WHEN LENGTH(p.id::text) = 5 THEN p.id::numeric*100000 ELSE p.id::numeric*10000 END p_id_ogm,
		-- berekining van restgetal "%" modulo berekening in postgresql
		((p.id::numeric*10000)%97) mod,
		-- waarde 0 vervangen door 97; lengte restgetal moet 2 zijn, wanneer kleiner dan 10 een 0 voorvoegen
		CASE WHEN ((p.id::numeric*100000)%97)::text = '0' THEN '97'
			WHEN LENGTH(((p.id::numeric*100000)%97)::text) = 1 THEN '0'||((p.id::numeric*100000)%97)::text
			ELSE ((p.id::numeric*100000)%97)::text
		END mod5,
		CASE WHEN ((p.id::numeric*10000)%97)::text = '0' THEN '97'
			WHEN LENGTH(((p.id::numeric*10000)%97)::text) = 1 THEN '0'||((p.id::numeric*10000)%97)::text
			ELSE ((p.id::numeric*10000)%97)::text
		END mod6,
		--
		CASE WHEN LENGTH(p.id::text) = 5 THEN ((p.id::numeric)*100000)::text ELSE ((p.id::numeric)*10000)::text END || 
		CASE WHEN LENGTH(p.id::text) = 5 THEN
				CASE WHEN ((p.id::numeric*100000)%97)::text = '0' THEN '97'
					WHEN LENGTH(((p.id::numeric*100000)%97)::text) = 1 THEN '0'||((p.id::numeric*100000)%97)::text
					ELSE ((p.id::numeric*100000)%97)::text
				END
			ELSE
				CASE WHEN ((p.id::numeric*10000)%97)::text = '0' THEN '97'
					WHEN LENGTH(((p.id::numeric*10000)%97)::text) = 1 THEN '0'||((p.id::numeric*10000)%97)::text
					ELSE ((p.id::numeric*10000)%97)::text
				END
			END ogm,
		LENGTH(((p.id::numeric*10000)%97)::text) len_test
	FROM res_partner p
	WHERE p.id = 407750
	) sq1
ORDER BY sq1.id DESC
LIMIT 1000