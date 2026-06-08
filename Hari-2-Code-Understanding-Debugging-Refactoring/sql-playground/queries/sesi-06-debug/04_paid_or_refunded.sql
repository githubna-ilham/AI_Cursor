-- ==============================================================
-- Query 04 — "Order yang status-nya paid atau shipped DAN totalnya > 1jt"
-- LAPORAN BUG: Hasil ikut menampilkan order dengan status 'refunded'
--              dan 'cancelled'. Padahal jelas tidak diminta.
-- Tugas Anda: cari kenapa filter tidak bekerja, perbaiki.
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
