-- ==============================================================
-- Query: 02 — Monthly Revenue per Category
-- Source: Dashboard finance, refresh tiap akhir bulan
-- ==============================================================

select
  date_format(o.created_at, '%Y-%m')         as month,
  coalesce(parent.name, cat.name)            as main_category,
  count(distinct o.id)                       as orders_count,
  sum(oi.line_total)                         as gross_revenue,
  sum(case when o.discount > 0 then oi.line_total * (o.discount / o.subtotal) else 0 end) as discount_alloc,
  sum(oi.line_total) - sum(case when o.discount > 0 then oi.line_total * (o.discount / o.subtotal) else 0 end) as net_revenue
from orders o
inner join order_items oi on oi.order_id = o.id
inner join products    p  on p.id  = oi.product_id
inner join categories  cat on cat.id = p.category_id
left  join categories  parent on parent.id = cat.parent_id
where o.status in ('paid', 'shipped', 'delivered')
  and o.created_at >= '2026-01-01'
group by date_format(o.created_at, '%Y-%m'), coalesce(parent.name, cat.name)
order by month desc, net_revenue desc;
