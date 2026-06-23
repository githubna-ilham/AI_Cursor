-- ==============================================================
-- Query: 01 — Customer Lifetime Value (LTV)
-- Source: Request marketing team, Q1 2026
-- ==============================================================

select
  c.id,
  c.name,
  c.tier,
  c.city,
  count(distinct o.id)                       as total_orders,
  sum(o.total)                               as lifetime_value,
  round(avg(o.total), 0)                     as avg_order_value,
  min(o.created_at)                          as first_order_at,
  max(o.created_at)                          as last_order_at,
  datediff(max(o.created_at), min(o.created_at)) as customer_lifespan_days
from customers c
inner join orders o on o.customer_id = c.id
where o.status not in ('cancelled', 'refunded')
group by c.id, c.name, c.tier, c.city
having sum(o.total) > 500000
order by lifetime_value desc
limit 10;
