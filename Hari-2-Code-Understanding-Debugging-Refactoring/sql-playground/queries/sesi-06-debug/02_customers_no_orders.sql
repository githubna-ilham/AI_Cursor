-- ==============================================================
-- Query 02 — "Customer yang belum pernah order"
-- LAPORAN BUG: Hasil query selalu kosong (0 baris), padahal di data
--              jelas ada customer baru yang belum pernah order, yaitu
--              Mira Anggraini (id=13, daftar Juni 2026).
--              Padahal kalau kita SELECT * FROM customers WHERE id = 13,
--              datanya ada.
-- Petunjuk: tabel orders punya record dengan customer_id NULL
--           (dari fitur guest checkout). Coba pelajari pengaruhnya
--           terhadap operator NOT IN.
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
