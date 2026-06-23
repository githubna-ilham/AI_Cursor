-- ==============================================================
-- Query 04 — "Order yang status-nya paid atau shipped DAN totalnya > 1jt"
-- LAPORAN BUG: Hasil tetap menampilkan order 'paid' dengan total
--              di bawah 1jt (mis. Order id=17 = 45rb, id=22 = 650rb,
--              id=26 = 600rb). Padahal kita minta total > 1jt.
-- Tugas Anda: cari kenapa filter total tidak berlaku untuk semua,
--             lalu perbaiki.
-- ==============================================================

select
  o.id,
  o.status,
  o.total,
  c.name as customer
from orders o
inner join customers c on c.id = o.customer_id
where o.status = 'paid'
   or o.status = 'shipped'
  and o.total > 1000000
order by o.total desc;
