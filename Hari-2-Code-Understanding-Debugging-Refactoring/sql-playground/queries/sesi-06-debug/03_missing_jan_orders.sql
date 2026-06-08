-- ==============================================================
-- Query 03 — "Order yang dibuat di Januari 2026"
-- LAPORAN BUG: Order id=12 tanggal 2026-01-25 15:30:00 tidak
--              muncul di hasil. Padahal jelas masih Januari.
-- Tugas Anda: cari kenapa hilang, lalu perbaiki tanpa mengubah
--             "antara 1 Jan sampai 31 Jan" jadi tanggal lain.
-- ==============================================================

select
  id,
  customer_id,
  status,
  total,
  created_at
from orders
where created_at between '2026-01-01' and '2026-01-31'
order by created_at;
