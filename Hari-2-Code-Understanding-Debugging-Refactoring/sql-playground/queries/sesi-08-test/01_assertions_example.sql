-- ==============================================================
-- Contoh Assertion Queries untuk schema E-Commerce Mini
-- Jalankan satu-satu — kalau hasil > 0 baris = ada bug data
-- ==============================================================

-- ---- T1: orders.subtotal harus sama dengan sum(order_items.line_total) ----
-- (di sample data, sengaja ada mismatch — ini akan FAIL)
select
  o.id                                                 as order_id,
  o.subtotal                                           as header_subtotal,
  coalesce(sum(oi.line_total), 0)                      as detail_sum,
  o.subtotal - coalesce(sum(oi.line_total), 0)         as difference
from orders o
left join order_items oi on oi.order_id = o.id
group by o.id, o.subtotal
having o.subtotal <> coalesce(sum(oi.line_total), 0);

-- ---- T2: orders.total harus = subtotal - discount ----
select
  id, subtotal, discount, total, (subtotal - discount) as expected_total
from orders
where total <> (subtotal - discount);

-- ---- T3: payments.amount untuk status 'success' harus = orders.total ----
select
  p.id as payment_id, p.order_id, p.amount, o.total
from payments p
inner join orders o on o.id = p.order_id
where p.status = 'success'
  and p.amount <> o.total;

-- ---- T4: shipments.delivered_at harus >= shipped_at (kalau keduanya ada) ----
select id, order_id, shipped_at, delivered_at
from shipments
where delivered_at is not null
  and shipped_at  is not null
  and delivered_at < shipped_at;

-- ---- T5: tidak ada order yang berstatus 'delivered' tapi tidak punya shipment ----
select o.id, o.status
from orders o
left join shipments s on s.order_id = o.id
where o.status = 'delivered'
  and s.id is null;

-- ---- T6: tidak ada review dengan rating di luar 1-5 ----
select id, customer_id, product_id, rating
from reviews
where rating < 1 or rating > 5;

-- ---- T7: customer.tier hanya boleh nilai enum yang diizinkan ----
select id, name, tier
from customers
where tier not in ('regular', 'silver', 'gold', 'platinum');

-- ---- T8: products.stock tidak boleh negatif ----
select id, sku, stock
from products
where stock < 0;

-- ---- T9: orders.created_at <= updated_at ----
select id, created_at, updated_at
from orders
where updated_at < created_at;

-- ---- T10: tidak ada duplicate (customer_id, product_id) di reviews ----
select customer_id, product_id, count(*) as dup
from reviews
group by customer_id, product_id
having count(*) > 1;
