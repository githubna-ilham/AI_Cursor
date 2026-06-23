-- ==============================================================
-- Query 03 — "Laporan kinerja sales per kota"
-- BEHAVIOUR: BENAR
-- SMELL: Pola JOIN yang sama (orders + order_items + customers)
--        diulang 3 kali dalam UNION ALL untuk 3 metrik berbeda.
--        Setiap perubahan filter status harus dilakukan 3 tempat.
-- Target refactor: 1 CTE base yang dipakai 3 kali, atau pivot
--                  dengan CASE WHEN agar 1 pass saja.
-- ==============================================================

select 'gross_revenue' as metric, c.city, sum(oi.line_total) as value
from customers c
inner join orders o on o.customer_id = c.id
inner join order_items oi on oi.order_id = o.id
where o.status in ('paid', 'shipped', 'delivered')
  and o.created_at >= '2026-01-01'
group by c.city

union all

select 'order_count' as metric, c.city, count(distinct o.id) as value
from customers c
inner join orders o on o.customer_id = c.id
inner join order_items oi on oi.order_id = o.id
where o.status in ('paid', 'shipped', 'delivered')
  and o.created_at >= '2026-01-01'
group by c.city

union all

select 'unique_customers' as metric, c.city, count(distinct c.id) as value
from customers c
inner join orders o on o.customer_id = c.id
inner join order_items oi on oi.order_id = o.id
where o.status in ('paid', 'shipped', 'delivered')
  and o.created_at >= '2026-01-01'
group by c.city

order by metric, value desc;
