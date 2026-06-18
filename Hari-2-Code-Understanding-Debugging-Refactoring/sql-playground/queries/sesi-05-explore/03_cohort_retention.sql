-- ==============================================================
-- Query: 03 — Cohort Retention (Bulan Sign-up vs Bulan Order)
-- Source: Analytics team, growth report
-- ==============================================================

with first_order as (
  select customer_id, min(date_format(created_at, '%Y-%m')) as cohort_month
  from orders
  where status not in ('cancelled', 'refunded')
  group by customer_id
),
order_activity as (
  select
    fo.cohort_month,
    date_format(o.created_at, '%Y-%m') as activity_month,
    o.customer_id
  from first_order fo
  inner join orders o on o.customer_id = fo.customer_id
  where o.status not in ('cancelled', 'refunded')
)
select
  cohort_month,
  activity_month,
  period_number,
  active_customers,
  cohort_size,
  round(active_customers * 100.0 / cohort_size, 1) as retention_pct
from (
  select
    oa.cohort_month,
    oa.activity_month,
    period_diff(replace(oa.activity_month, '-', ''), replace(oa.cohort_month, '-', '')) as period_number,
    count(distinct oa.customer_id) as active_customers,
    (select count(distinct customer_id) from first_order fo2 where fo2.cohort_month = oa.cohort_month) as cohort_size
  from order_activity oa
  group by oa.cohort_month, oa.activity_month
) t
order by cohort_month, period_number;
