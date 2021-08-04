-------------------------------------------
-- SQ1: resultaat van "_crm_partnerinfo()" geeft contact info van elke partner
-- SQ2: ophalen van LEDEN die meer dan 1x gebruik maakten van Lampiris aanbieding
-- - SQ3: ophalen lidmaatschapslijnen aan €14
-- - SQ4: ophalen meest recente lidmaatschapslijn met huidig bedrag
-- - - SQ5: ophalen alle lidmaatschaplijnen/partner en bepalen laatste lijn
--------------------------------------------
SELECT sq2.name_template, sq2.r aantal, sq2.member_price bedrag, sq2.huidig_lidmaatschap
	, sq1.*
FROM _crm_partnerinfo() sq1
	JOIN
		(
		SELECT sq3.partner, sq3.name_template, sq3.member_price, sq4.member_price huidig_lidmaatschap,
				MAX(sq3.r) r
		FROM (
			SELECT ml.partner, pp.name_template, ml.member_price,
				ROW_NUMBER() OVER (PARTITION BY ml.partner ORDER BY ml.id DESC) AS r
			FROM membership_membership_line ml
				JOIN product_product pp ON pp.id = ml.membership_id
			WHERE pp.membership_product
				AND ml.member_price = 14
				--AND ml.partner = 268977
			) SQ3
			JOIN
			(
			SELECT ml.partner, ml.member_price FROM
				(
				SELECT ml.partner, pp.name_template, MAX(ml.id) ml_id
				FROM membership_membership_line ml
					JOIN product_product pp ON pp.id = ml.membership_id
				WHERE pp.membership_product
				GROUP BY ml.partner, pp.name_template
				) SQ5
				JOIN membership_membership_line ml ON ml.id = sq5.ml_id
			) SQ4 ON sq4.partner = sq3.partner
			JOIN res_partner p ON p.id = sq3.partner
		WHERE p.active
			AND sq3.r > 1
			--AND p.id = 264752
		GROUP BY sq3.partner, sq3.name_template, sq3.member_price, sq4.member_price
		) sq2
ON sq1.partner_id = sq2.partner
