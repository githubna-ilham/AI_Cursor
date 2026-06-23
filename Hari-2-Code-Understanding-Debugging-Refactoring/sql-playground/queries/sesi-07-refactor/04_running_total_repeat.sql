-- ==============================================================
-- Query 04 — "Running total revenue per customer per bulan"
-- BEHAVIOUR: BENAR
-- SMELL: Window expression yang sama (PARTITION BY customer ORDER BY month)
--        diulang 4 kali. Verbose, mudah salah saat ubah definisi.
-- Target refactor: pakai NAMED WINDOW (window w as (...))
--                  sehingga definisi window cukup ditulis 1x.
-- ==============================================================

select
  c.id          as customer_id,
  c.name,
  date_format(o.created_at, '%Y-%m') as month,
  sum(o.total)  as month_revenue,
  sum(sum(o.total)) over (partition by c.id order by date_format(o.created_at, '%Y-%m'))                          as running_total,
  avg(sum(o.total)) over (partition by c.id order by date_format(o.created_at, '%Y-%m'))                          as running_avg,
  count(*) over (partition by c.id order by date_format(o.created_at, '%Y-%m'))                                   as months_so_far,
  first_value(sum(o.total)) over (partition by c.id order by date_format(o.created_at, '%Y-%m'))                  as first_month_revenue
from customers c
inner join orders o on o.customer_id = c.id
where o.status in ('paid', 'shipped', 'delivered')
group by c.id, c.name, date_format(o.created_at, '%Y-%m')
order by c.id, month;
