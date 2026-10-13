--GRATIS LEDEN: verschillende manieren om deze op te halen
------------------------------------------------------------
--METHODE 1 zoals gewoonlijk

SELECT p.id, p.create_date::date, p.name naam, mo.name herkomst,
		--p.street adres, p.zip postcode, p.city woonplaats, 
		pfc.name "type", p.free_member_comment omschrijving, /*p.free_membership_class_id,*/ p.active
FROM res_partner p
	LEFT OUTER JOIN res_partner_free_class pfc ON p.free_membership_class_id = pfc.id
	LEFT OUTER JOIN res_partner_membership_origin mo ON mo.id = p.membership_origin_id
WHERE p.free_member AND p.active --AND mo.name IN ('Gratis Lidmaatschap','J.N.M. ouwe sok')
		--AND pfc.name = 'Pers'
ORDER BY pfc.name

--METHODE 2: huidige gratis leden en historiek oude gratis leden (aangemaakt door Kristien)

SELECT *
FROM marketing._m_dwh_gratisleden
--WHERE gratis_lid = true


--TER INFO
------------------------------------------------------------
--leden die na een gratis lidmaatschap lid blijven

SELECT p.id, p.create_date::date, p.name naam, pfc.name "type", p.free_member_comment omschrijving, mo.name herkomst, p.membership_state, p.active
FROM res_partner p
	JOIN res_partner_free_class pfc ON p.free_membership_class_id = pfc.id
	LEFT OUTER JOIN res_partner_membership_origin mo ON mo.id = p.membership_origin_id
WHERE p.membership_state = 'paid' AND p.active 
ORDER BY pfc.name

--leden die na een gratis lidmaatschap geen lid blijven, maar wel ooit betalend lid waren

SELECT p.id, p.create_date::date, p.name naam, mo.name herkomst, p.membership_state, p.membership_start, p.membership_end,
		--p.street adres, p.zip postcode, p.city woonplaats, 
		pfc.name "type", p.free_member_comment omschrijving, /*p.free_membership_class_id,*/ p.active
FROM res_partner p
	LEFT OUTER JOIN res_partner_free_class pfc ON p.free_membership_class_id = pfc.id
	LEFT OUTER JOIN res_partner_membership_origin mo ON mo.id = p.membership_origin_id
WHERE p.membership_state IN ('waiting','wait_member','old', 'invoiced') AND p.active AND mo.name IN ('Gratis Lidmaatschap','J.N.M. ouwe sok')
ORDER BY pfc.name

--leden die na een gratis lidmaatschap op 'none' staan, dus nooit betaald hebben voor een lidmaatschap

SELECT p.id, p.create_date::date, p.name naam, mo.name herkomst, p.membership_state, p.membership_start, p.membership_end,
		--p.street adres, p.zip postcode, p.city woonplaats, 
		pfc.name "type", p.free_member_comment omschrijving, /*p.free_membership_class_id,*/ p.active
FROM res_partner p
	LEFT OUTER JOIN res_partner_free_class pfc ON p.free_membership_class_id = pfc.id
	LEFT OUTER JOIN res_partner_membership_origin mo ON mo.id = p.membership_origin_id
WHERE p.membership_state IN ('none') AND p.active AND mo.name IN ('Gratis Lidmaatschap','J.N.M. ouwe sok')
ORDER BY pfc.name

--leden die na een gratis lidmaatschap op 'canceled' staan

SELECT p.id, p.create_date::date, p.name naam, mo.name herkomst, p.membership_state, p.membership_start, p.membership_end,
		--p.street adres, p.zip postcode, p.city woonplaats, 
		pfc.name "type", p.free_member_comment omschrijving, /*p.free_membership_class_id,*/ p.active
FROM res_partner p
	LEFT OUTER JOIN res_partner_free_class pfc ON p.free_membership_class_id = pfc.id
	LEFT OUTER JOIN res_partner_membership_origin mo ON mo.id = p.membership_origin_id
WHERE p.membership_state IN ('canceled') AND p.active AND mo.name IN ('Gratis Lidmaatschap','J.N.M. ouwe sok')
ORDER BY pfc.name

--gratis leden aangebracht via collega's: free_member_comment aanpassen per collega:

--Joost
SELECT p.id, p.create_date::date, p.name naam, mo.name herkomst,
		--p.street adres, p.zip postcode, p.city woonplaats, 
		pfc.name "type", p.free_member_comment omschrijving, /*p.free_membership_class_id,*/ p.active
FROM res_partner p
	LEFT OUTER JOIN res_partner_free_class pfc ON p.free_membership_class_id = pfc.id
	LEFT OUTER JOIN res_partner_membership_origin mo ON mo.id = p.membership_origin_id
WHERE p.free_member AND p.active --AND mo.name IN ('Gratis Lidmaatschap','J.N.M. ouwe sok')
		--AND pfc.name = 'Pers'
		AND free_member_comment LIKE '%Joost%'
ORDER BY pfc.name

--Filip
SELECT p.id, p.create_date::date, p.name naam, mo.name herkomst,
		--p.street adres, p.zip postcode, p.city woonplaats, 
		pfc.name "type", p.free_member_comment omschrijving, /*p.free_membership_class_id,*/ p.active
FROM res_partner p
	LEFT OUTER JOIN res_partner_free_class pfc ON p.free_membership_class_id = pfc.id
	LEFT OUTER JOIN res_partner_membership_origin mo ON mo.id = p.membership_origin_id
WHERE p.free_member AND p.active --AND mo.name IN ('Gratis Lidmaatschap','J.N.M. ouwe sok')
		--AND pfc.name = 'Pers'
		AND free_member_comment LIKE '%Filip%'
ORDER BY pfc.name

--Sander
SELECT p.id, p.create_date::date, p.name naam, mo.name herkomst,
		--p.street adres, p.zip postcode, p.city woonplaats, 
		pfc.name "type", p.free_member_comment omschrijving, /*p.free_membership_class_id,*/ p.active
FROM res_partner p
	LEFT OUTER JOIN res_partner_free_class pfc ON p.free_membership_class_id = pfc.id
	LEFT OUTER JOIN res_partner_membership_origin mo ON mo.id = p.membership_origin_id
WHERE p.free_member AND p.active --AND mo.name IN ('Gratis Lidmaatschap','J.N.M. ouwe sok')
		--AND pfc.name = 'Pers'
		AND free_member_comment LIKE '%Sander%'
ORDER BY pfc.name

--Natalie
SELECT p.id, p.create_date::date, p.name naam, mo.name herkomst,
		--p.street adres, p.zip postcode, p.city woonplaats, 
		pfc.name "type", p.free_member_comment omschrijving, /*p.free_membership_class_id,*/ p.active
FROM res_partner p
	LEFT OUTER JOIN res_partner_free_class pfc ON p.free_membership_class_id = pfc.id
	LEFT OUTER JOIN res_partner_membership_origin mo ON mo.id = p.membership_origin_id
WHERE p.free_member AND p.active --AND mo.name IN ('Gratis Lidmaatschap','J.N.M. ouwe sok')
		--AND pfc.name = 'Pers'
		AND free_member_comment LIKE '%Natalie%'
ORDER BY pfc.name

--Marco
SELECT p.id, p.create_date::date, p.name naam, mo.name herkomst,
		--p.street adres, p.zip postcode, p.city woonplaats, 
		pfc.name "type", p.free_member_comment omschrijving, /*p.free_membership_class_id,*/ p.active
FROM res_partner p
	LEFT OUTER JOIN res_partner_free_class pfc ON p.free_membership_class_id = pfc.id
	LEFT OUTER JOIN res_partner_membership_origin mo ON mo.id = p.membership_origin_id
WHERE p.free_member AND p.active --AND mo.name IN ('Gratis Lidmaatschap','J.N.M. ouwe sok')
		--AND pfc.name = 'Pers'
		AND free_member_comment LIKE '%Marco%'
ORDER BY pfc.name

--Dorien
SELECT p.id, p.create_date::date, p.name naam, mo.name herkomst,
		--p.street adres, p.zip postcode, p.city woonplaats, 
		pfc.name "type", p.free_member_comment omschrijving, /*p.free_membership_class_id,*/ p.active
FROM res_partner p
	LEFT OUTER JOIN res_partner_free_class pfc ON p.free_membership_class_id = pfc.id
	LEFT OUTER JOIN res_partner_membership_origin mo ON mo.id = p.membership_origin_id
WHERE p.free_member AND p.active --AND mo.name IN ('Gratis Lidmaatschap','J.N.M. ouwe sok')
		--AND pfc.name = 'Pers'
		AND free_member_comment LIKE '%Dorien%'
ORDER BY pfc.name

--Quinten
SELECT p.id, p.create_date::date, p.name naam, mo.name herkomst,
		--p.street adres, p.zip postcode, p.city woonplaats, 
		pfc.name "type", p.free_member_comment omschrijving, /*p.free_membership_class_id,*/ p.active
FROM res_partner p
	LEFT OUTER JOIN res_partner_free_class pfc ON p.free_membership_class_id = pfc.id
	LEFT OUTER JOIN res_partner_membership_origin mo ON mo.id = p.membership_origin_id
WHERE p.free_member AND p.active --AND mo.name IN ('Gratis Lidmaatschap','J.N.M. ouwe sok')
		--AND pfc.name = 'Pers'
		AND free_member_comment LIKE '%Quinten%'
ORDER BY pfc.name

--Pieter
SELECT p.id, p.create_date::date, p.name naam, mo.name herkomst,
		--p.street adres, p.zip postcode, p.city woonplaats, 
		pfc.name "type", p.free_member_comment omschrijving, /*p.free_membership_class_id,*/ p.active
FROM res_partner p
	LEFT OUTER JOIN res_partner_free_class pfc ON p.free_membership_class_id = pfc.id
	LEFT OUTER JOIN res_partner_membership_origin mo ON mo.id = p.membership_origin_id
WHERE p.free_member AND p.active --AND mo.name IN ('Gratis Lidmaatschap','J.N.M. ouwe sok')
		--AND pfc.name = 'Pers'
		AND free_member_comment LIKE '%Pieter%'
ORDER BY pfc.name

--Luk
SELECT p.id, p.create_date::date, p.name naam, mo.name herkomst,
		--p.street adres, p.zip postcode, p.city woonplaats, 
		pfc.name "type", p.free_member_comment omschrijving, /*p.free_membership_class_id,*/ p.active
FROM res_partner p
	LEFT OUTER JOIN res_partner_free_class pfc ON p.free_membership_class_id = pfc.id
	LEFT OUTER JOIN res_partner_membership_origin mo ON mo.id = p.membership_origin_id
WHERE p.free_member AND p.active --AND mo.name IN ('Gratis Lidmaatschap','J.N.M. ouwe sok')
		--AND pfc.name = 'Pers'
		AND free_member_comment LIKE '%Luk%'
ORDER BY pfc.name

--JNM
SELECT p.id, p.create_date::date, p.name naam, mo.name herkomst,
		--p.street adres, p.zip postcode, p.city woonplaats, 
		pfc.name "type", p.free_member_comment omschrijving, /*p.free_membership_class_id,*/ p.active
FROM res_partner p
	LEFT OUTER JOIN res_partner_free_class pfc ON p.free_membership_class_id = pfc.id
	LEFT OUTER JOIN res_partner_membership_origin mo ON mo.id = p.membership_origin_id
WHERE p.free_member AND p.active --AND mo.name IN ('Gratis Lidmaatschap','J.N.M. ouwe sok')
		--AND pfc.name = 'Pers'
		AND free_member_comment LIKE '%JNM%'
ORDER BY pfc.name