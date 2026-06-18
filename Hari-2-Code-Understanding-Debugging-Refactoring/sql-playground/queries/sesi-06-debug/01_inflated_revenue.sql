-- ==============================================================
-- Query 01 — "Total revenue per customer bulan Mei 2026"
-- LAPORAN BUG: Andi (customer 1) muncul dengan total ~4.9jt
--              dengan 8 order, padahal cek manual cuma 2 order
--              total 1.25jt (Order 22 = 650rb, Order 26 = 600rb).
-- Tugas Anda: cari penyebab inflasi angka, lalu perbaiki.
-- ==============================================================

select
  c.id,
  c.name,
  count(o.id)                as total_orders,
  sum(o.total)               as total_revenue
from customers c
left join orders   o   on o.customer_id = c.id
left join payments p   on p.order_id    = o.id
left join shipments s  on s.order_id    = o.id
where o.created_at >= '2026-05-01'
  and o.created_at <= '2026-05-31'
  and o.status in ('paid', 'shipped', 'delivered')
group by c.id, c.name
order by total_revenue desc;
