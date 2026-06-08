-- ==============================================================
-- Query 02 — "Customer yang belum pernah order"
-- LAPORAN BUG: Hasil query selalu kosong (0 baris), padahal di
--              data jelas ada customer baru yang belum order
--              (mis. customer Lina, id=12, belum punya order
--              sebelum Mei 2026).
-- Tugas Anda: cari kenapa 0 baris, lalu perbaiki.
-- ==============================================================

select
  c.id,
  c.name,
  c.email,
  c.created_at as signed_up_at
from customers c
where c.id not in (
  select customer_id from orders
)
order by c.created_at desc;
