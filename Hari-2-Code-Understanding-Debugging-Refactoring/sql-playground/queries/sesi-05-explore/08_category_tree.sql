-- ==============================================================
-- Query: 08 — Recursive Category Tree (with Path)
-- Source: Admin dashboard, navigasi kategori
-- ==============================================================

with recursive category_tree as (
  select
    id,
    name,
    parent_id,
    cast(name as char(255))                  as path,
    1                                        as depth
  from categories
  where parent_id is null

  union all

  select
    c.id,
    c.name,
    c.parent_id,
    cast(concat(ct.path, ' > ', c.name) as char(255)) as path,
    ct.depth + 1                                       as depth
  from categories c
  inner join category_tree ct on ct.id = c.parent_id
)
select
  ct.id,
  ct.depth,
  concat(repeat('  ', ct.depth - 1), '- ', ct.name) as indented_name,
  ct.path,
  (select count(*) from products p where p.category_id = ct.id and p.is_active = 1) as active_products,
  (
    select coalesce(sum(oi.line_total), 0)
    from order_items oi
    inner join products p on p.id = oi.product_id
    inner join orders o on o.id = oi.order_id
    where p.category_id = ct.id
      and o.status in ('paid', 'shipped', 'delivered')
  ) as category_revenue
from category_tree ct
order by ct.path;
