-- ==============================================================
-- Query 01 — "Top 5 customer berdasarkan revenue 2026"
-- BEHAVIOUR: BENAR (jangan ubah output)
-- SMELL: Subquery 3 lapis (sulit dibaca, sulit di-debug)
-- Target refactor: pakai CTE (WITH ... AS) supaya rata
-- ==============================================================

select
  name,
  total_spending,
  total_orders,
  (select c2.tier from customers c2 where c2.id =
     (select c3.id from customers c3 where c3.name =
        (select c4.name from customers c4 where c4.id = top.customer_id)
     )
  ) as tier
from (
  select
    customer_id,
    sum(total) as total_spending,
    count(*)   as total_orders,
    (select name from customers where id = o.customer_id) as name
  from orders o
  where o.status in ('paid', 'shipped', 'delivered')
    and o.created_at >= '2026-01-01'
  group by customer_id
  order by sum(total) desc
  limit 5
) top;
