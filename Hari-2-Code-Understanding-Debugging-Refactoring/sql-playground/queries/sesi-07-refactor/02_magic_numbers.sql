-- ==============================================================
-- Query 02 — "Tier upgrade suggestion"
-- BEHAVIOUR: BENAR (mirip query Sesi 5 #06)
-- SMELL: Magic numbers tersebar (5000000, 2500000, 1000000, 500000)
--        + magic intervals (12 month) + tier name string literal
-- Target refactor:
--   - Extract threshold ke CTE (WITH thresholds AS) atau variable
--   - Hilangkan duplikasi nilai 1000000/2500000 yang muncul 2x
-- ==============================================================

select
  c.id,
  c.name,
  c.tier as current_tier,
  coalesce(s.spending, 0) as spending_12mo,
  case
    when coalesce(s.spending, 0) >= 5000000 then 'platinum'
    when coalesce(s.spending, 0) >= 2500000 then 'gold'
    when coalesce(s.spending, 0) >= 1000000 then 'silver'
    else 'regular'
  end as suggested_tier,
  case
    when c.tier = 'regular'  and coalesce(s.spending, 0) >= 1000000 then 'UPGRADE'
    when c.tier = 'silver'   and coalesce(s.spending, 0) >= 2500000 then 'UPGRADE'
    when c.tier = 'gold'     and coalesce(s.spending, 0) >= 5000000 then 'UPGRADE'
    when c.tier = 'platinum' and coalesce(s.spending, 0) <  2500000 then 'DOWNGRADE'
    when c.tier = 'gold'     and coalesce(s.spending, 0) <  1000000 then 'DOWNGRADE'
    when c.tier = 'silver'   and coalesce(s.spending, 0) <  500000  then 'DOWNGRADE'
    else 'NO_CHANGE'
  end as action
from customers c
left join (
  select customer_id, sum(total) as spending
  from orders
  where status in ('paid', 'shipped', 'delivered')
    and created_at >= date_sub(curdate(), interval 12 month)
  group by customer_id
) s on s.customer_id = c.id
order by spending_12mo desc;
