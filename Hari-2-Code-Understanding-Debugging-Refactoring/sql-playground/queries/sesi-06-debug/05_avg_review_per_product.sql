-- ==============================================================
-- Query 05 — "Rata-rata rating per produk + jumlah review"
-- LAPORAN BUG:
--   1. Produk yang BELUM PUNYA review tidak muncul sama sekali
--      (padahal di-expect muncul dengan rating null & count 0)
--   2. Produk yang sudah discontinued (is_active=0) juga ikut tampil
--      padahal harusnya tidak
-- Tugas Anda: cari penyebab 2 bug ini, perbaiki keduanya.
-- ==============================================================

select
  p.id,
  p.sku,
  p.name,
  avg(r.rating)     as avg_rating,
  count(r.id)       as total_reviews
from products p
inner join reviews r on r.product_id = p.id
group by p.id, p.sku, p.name
order by avg_rating desc;
