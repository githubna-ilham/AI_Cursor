-- ==============================================================
-- Query: 06 — Customer Tier Upgrade Suggestion
-- Source: CRM team, monthly upsell campaign
-- ==============================================================

select
  c.id,
  c.name,
  c.email,
  c.tier                                     as current_tier,
  coalesce(s.spending_last_12mo, 0)          as spending_12mo,
  case
    when coalesce(s.spending_last_12mo, 0) >= 5000000 then 'platinum'
    when coalesce(s.spending_last_12mo, 0) >= 2500000 then 'gold'
    when coalesce(s.spending_last_12mo, 0) >= 1000000 then 'silver'
    else 'regular'
  end                                        as suggested_tier,
  case
    when c.tier = 'regular'  and coalesce(s.spending_last_12mo, 0) >= 1000000 then 'UPGRADE_TO_SILVER'
    when c.tier = 'silver'   and coalesce(s.spending_last_12mo, 0) >= 2500000 then 'UPGRADE_TO_GOLD'
    when c.tier = 'gold'     and coalesce(s.spending_last_12mo, 0) >= 5000000 then 'UPGRADE_TO_PLATINUM'
    when c.tier = 'platinum' and coalesce(s.spending_last_12mo, 0) <  2500000 then 'CONSIDER_DOWNGRADE'
    when c.tier = 'gold'     and coalesce(s.spending_last_12mo, 0) <  1000000 then 'CONSIDER_DOWNGRADE'
    when c.tier = 'silver'   and coalesce(s.spending_last_12mo, 0) <  500000  then 'CONSIDER_DOWNGRADE'
    else 'NO_CHANGE'
  end                                        as action
from customers c
left join (
  select customer_id, sum(total) as spending_last_12mo
  from orders
  where status in ('paid', 'shipped', 'delivered')
    and created_at >= date_sub(curdate(), interval 12 month)
  group by customer_id
) s on s.customer_id = c.id
where coalesce(s.spending_last_12mo, 0) > 0
order by spending_12mo desc;
