-- ==============================================================
-- Query: 07 — Order Status Funnel
-- Source: Ops dashboard, real-time monitoring
-- ==============================================================

with status_count as (
  select
    status,
    count(*)               as orders_in_status,
    sum(total)             as total_value,
    avg(total)             as avg_value
  from orders
  where created_at >= date_sub(curdate(), interval 90 day)
  group by status
),
all_orders as (
  select count(*) as n, sum(total) as v
  from orders
  where created_at >= date_sub(curdate(), interval 90 day)
)
select
  sc.status,
  sc.orders_in_status,
  round(sc.orders_in_status * 100.0 / a.n, 1)                  as pct_of_orders,
  sc.total_value,
  round(sc.total_value * 100.0 / nullif(a.v, 0), 1)            as pct_of_value,
  round(sc.avg_value, 0)                                       as avg_order_value,
  case sc.status
    when 'pending'   then 1
    when 'paid'      then 2
    when 'shipped'   then 3
    when 'delivered' then 4
    when 'cancelled' then 90
    when 'refunded'  then 91
    else 99
  end                                                          as funnel_order
from status_count sc
cross join all_orders a
order by funnel_order;
