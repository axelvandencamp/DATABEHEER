--SELECT *
SELECT COUNT(id) aantal
FROM marketing._m_dwh_koalectdata_M_gift dwh
WHERE dwh.created_date::date >= '2026-06-01'
--ORDER BY dwh.created_date DESC