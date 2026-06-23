-- ==============================================================
-- Query 05 — "Order detail untuk customer support"
-- BEHAVIOUR: BENAR (semua kolom yang dibutuhkan ada)
-- SMELL:
--   1. SELECT * dari 5 tabel — 40+ kolom, banyak yang tidak dipakai
--      di reporting (bikin payload gemuk, sulit di-cache)
--   2. Subquery scalar (latest_payment_status) bisa pecah jadi
--      duplicate row kalau lebih dari 1 payment per order
--   3. Nama kolom output ambigu (column ber-nama 'status'
--      bertumpuk dari orders, payments, shipments)
-- Target refactor:
--   - Pilih kolom secara eksplisit (15 max)
--   - Rename dengan alias jelas: order_status, payment_status, dst.
--   - Pastikan single row per order (gunakan LATERAL / window untuk
--     pick latest payment)
-- ==============================================================

select
  o.*,
  c.*,
  oi.*,
  p.*,
  s.*,
  (select status from payments where order_id = o.id order by created_at desc limit 1) as latest_payment_status
from orders o
left join customers   c  on c.id = o.customer_id
left join order_items oi on oi.order_id = o.id
left join payments    p  on p.order_id = o.id
left join shipments   s  on s.order_id = o.id
where o.id = 14;
