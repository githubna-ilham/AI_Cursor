-- ==============================================================
-- Query: 04 — Inventory Discrepancy Check
-- Source: Warehouse audit, dijalankan tiap Jumat
-- ==============================================================

select
  p.id,
  p.sku,
  p.name,
  p.stock                                    as stock_recorded,
  coalesce(il.net_movement, 0)               as movement_from_log,
  p.stock - coalesce(il.net_movement, 0)     as discrepancy,
  case
    when il.net_movement is null then 'NO_LOG_DATA'
    when p.stock = il.net_movement then 'OK'
    when p.stock > il.net_movement then 'STOCK_EXCESS'
    else 'STOCK_SHORTAGE'
  end                                        as status,
  il.last_movement_at
from products p
left join (
  select
    product_id,
    sum(qty_change) as net_movement,
    max(created_at) as last_movement_at
  from inventory_log
  group by product_id
) il on il.product_id = p.id
where p.is_active = 1
order by abs(p.stock - coalesce(il.net_movement, 0)) desc;
