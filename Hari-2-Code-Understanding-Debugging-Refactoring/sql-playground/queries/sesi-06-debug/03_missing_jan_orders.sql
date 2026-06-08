-- ==============================================================
-- Query 03 — "Order yang dibuat di Januari 2026"
-- LAPORAN BUG: Order id=28 tanggal 2026-01-31 18:45:00 tidak muncul
--              di hasil. Padahal tanggal 31 Januari jelas masih bulan
--              Januari.
-- Tugas Anda: cari kenapa hilang, lalu perbaiki tanpa mengubah
--             intent "ambil order Januari" jadi tanggal lain.
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
