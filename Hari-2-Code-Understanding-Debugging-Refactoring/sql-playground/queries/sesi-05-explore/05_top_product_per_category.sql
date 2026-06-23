-- ==============================================================
-- Query: 05 — Top 3 Selling Product per Main Category
-- Source: Procurement team, untuk restock planning
-- ==============================================================

with product_sales as (
  select
    coalesce(parent.id, cat.id)            as main_category_id,
    coalesce(parent.name, cat.name)        as main_category,
    p.id                                   as product_id,
    p.sku,
    p.name                                 as product_name,
    sum(oi.qty)                            as units_sold,
    sum(oi.line_total)                     as revenue
  from order_items oi
  inner join orders     o     on o.id = oi.order_id
  inner join products   p     on p.id = oi.product_id
  inner join categories cat   on cat.id = p.category_id
  left  join categories parent on parent.id = cat.parent_id
  where o.status in ('paid', 'shipped', 'delivered')
  group by coalesce(parent.id, cat.id), coalesce(parent.name, cat.name),
           p.id, p.sku, p.name
),
ranked as (
  select
    main_category,
    sku,
    product_name,
    units_sold,
    revenue,
    rank()       over (partition by main_category_id order by revenue desc)        as revenue_rank,
    dense_rank() over (partition by main_category_id order by units_sold desc)     as units_rank,
    sum(revenue) over (partition by main_category_id)                              as category_total
  from product_sales
)
select
  main_category,
  revenue_rank,
  sku,
  product_name,
  units_sold,
  revenue,
  round(revenue * 100.0 / category_total, 1) as share_of_category_pct
from ranked
where revenue_rank <= 3
order by main_category, revenue_rank;
