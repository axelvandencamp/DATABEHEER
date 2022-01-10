-----------------------------------------------------
-- overzicht unieke derde betalers
-- LEDEN lijst per Derde Betaler ID
-----------------------------------------------------
SELECT DISTINCT p.id, p.name, p.third_payer_id
FROM res_partner p
WHERE p.membership_nbr IN ('534029','300003','118865','423658','338019','451381','254121','107467','256966','406135','328802','338095','299792','318372','460846','427188','578411','414908','443608','101258','221608','410734','242510','105346','212754','252267','275224','216963','447073','482475','404816','483140','104277','100096','447080','300406','297313','401623','287087','505451','229977','344871','250122','329768','249402','330672','219865','260585','209118','235787','286772','108081','326564','275143','326547','277857','413058','109908','500503','236811','336760','447083','340532','221577','236503','286927','518739','109894','500191','101396','404373','504604','212755')
WHERE COALESCE(p.third_payer_id,0) <> 0
-----------------------
-- leden per 3e betaler
-----------------------
SELECT p.third_payer_id, p2.name, p.create_date::date, SQ1.* 
FROM res_partner p
	JOIN marketing._crm_partnerinfo() SQ1 ON SQ1.partner_id = p.id
	JOIN res_partner p2 ON p2.id = p.third_payer_id
WHERE p.third_payer_id = 338356 --COALESCE(p.third_payer_id,0) <> 0
ORDER BY p.create_date::date DESC
-----------------------------------------------------

-----------------------------------------------------
-- DERDE BETALER FACTUREN met ledenlijst per factuur
-----------------------------------------------------
SELECT tpi.id, i.id "3debetaler_factuur_id", i.internal_number "3debetaler_factuur", i.reference "3debetaler_ogm", i.amount_total "3debetaler_bedrag", p.id "3debetaler_id", p.name "3debetaler",
		i2.id lidmaatschap_factuur_id, i2.internal_number lidmaatschap_factuur, i2.reference lidmaatschap_ogm, tpil.amount lidmaatschap_bedrag, p2.id lidmaatschap_id, p2.membership_nbr lidnummer, p2.name lid, 
		pp.name_template product
FROM membership_third_payer_invoice tpi
	JOIN account_invoice i ON i.id = tpi.invoice_id
	JOIN res_partner p ON p.id = i.commercial_partner_id
	--JOIN account_invoice_line il ON il.invoice_id = i.id
	JOIN membership_third_payer_invoice_line tpil ON tpil.third_payer_invoice_id = tpi.id
	JOIN membership_membership_line ml ON ml.id = tpil.membership_line_id
	JOIN account_invoice_line il2 ON il2.id = ml.account_invoice_line
	JOIN account_invoice i2 ON il2.invoice_id = i2.id
	JOIN res_partner p2 ON p2.id = ml.partner AND p2.id = i2.membership_partner_id
	JOIN product_product pp ON pp.id = ml.membership_id
	/*JOIN product_template pt ON pt.id = pp.product_tmpl_id
	JOIN res_partner p ON p.id = ml.partner
	JOIN marketing._crm_partnerinfo() SQ1 ON SQ1.partner_id = p.id*/
--WHERE i.number = '' OR i.reference = '+++328/1340/05495+++'
WHERE i.commercial_partner_id = 338356  AND tpi.id = 30
	--AND sq1.partner_id IN (302007,302193,56792,206991)
	--tpi.create_date::date = '2020-11-27'
ORDER BY il.invoice_id
/*
SELECT * FROM membership_third_payer_invoice_line tpil WHERE tpil.third_payer_invoice_id = 21
SELECT * FROM membership_third_payer_invoice tpi
SELECT * FROM account_invoice i WHERE id = 1245769
SELECT * FROM account_invoice_line il WHERE id = 1181558
SELECT * FROM membership_membership_line WHERE partner = 89121
SELECT * FROM product_product pp WHERE pp.name_template = 'Gewoon lid' LIMIT 10
*/
-----------------------------------------------------
-- derde betalers met factuur + status
-----------------------------------------------------
SELECT DISTINCT tpi.id tpi_id, tpi.invoice_id, i.name, i.state, i.number, i.reference, p.id, p.name
FROM membership_third_payer_invoice tpi
	JOIN account_invoice i ON i.id = tpi.invoice_id
	JOIN account_invoice_line il ON il.invoice_id = i.id
	JOIN membership_third_payer_invoice_line tpil ON tpil.third_payer_invoice_id = tpi.id
	JOIN membership_membership_line ml ON ml.id = tpil.membership_line_id
	JOIN res_partner p ON p.id = tpil.third_payer_id