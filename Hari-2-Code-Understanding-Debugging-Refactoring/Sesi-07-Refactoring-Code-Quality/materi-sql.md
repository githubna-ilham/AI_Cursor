# Sesi 7 (SQL) — Refactoring & Code Quality

Durasi: 90 menit
Modul: Hari 2 / Sesi 3 dari 4

> Versi SQL dari `materi.md`. Konsep refactoring/code-smell sama, contoh & pattern khusus SQL.

---

## Learning Outcomes

Setelah sesi ini peserta mampu:

1. Mengidentifikasi **5 code smell SQL** umum: subquery hell, magic numbers, duplicate JOIN, repeated window, SELECT * wide.
2. Menerapkan **refactoring behaviour-preserving** dengan disiplin baseline + diff.
3. Memakai pola SQL: **CTE**, **named window**, **view**, **materialized table** sebagai alat refactor.
4. Memberi AI **constraint eksplisit** supaya tidak rewrite total saat refactor.
5. Mengukur dampak refactor: LOC, nesting depth, EXPLAIN simpler.

---

## Konsep Inti

### 1. Refactor ≠ Rewrite

| Aspek | Refactor | Rewrite |
|-------|----------|---------|
| Behaviour | **Identik** (row, kolom, urutan) | Bisa berbeda |
| Risiko | Rendah (dengan baseline) | Tinggi |
| Reversible | Per langkah | Sulit |
| Cocok untuk AI | Sangat — dengan constraint | Hanya bila spec lengkap |

**Aturan utama**: setelah refactor, query harus return **baris, kolom, urutan persis sama**. Tidak ada "lebih lengkap" atau "lebih ringkas tapi 1 kolom hilang".

### 2. Lima Code Smell SQL Paling Sering

#### Smell 1: Subquery Hell (3+ Lapis Nested)

```sql
-- Sulit dibaca, sulit di-debug
select name, total_spending,
  (select c2.tier from customers c2 where c2.id =
     (select c3.id from customers c3 where c3.name = ...)
  ) as tier
from (select customer_id, sum(total) ... ) top;
```

**Refactor**: pecah ke **CTE** (`WITH ... AS`). Tiap CTE = 1 step logis, namanya self-describing.

```sql
with top_spenders as (
  select customer_id, sum(total) as total_spending
  from orders
  where status in ('paid', 'shipped', 'delivered')
  group by customer_id
  order by total_spending desc
  limit 5
)
select c.name, t.total_spending, c.tier
from top_spenders t
join customers c on c.id = t.customer_id;
```

#### Smell 2: Magic Numbers Tersebar

```sql
case
  when spending >= 5000000 then 'platinum'
  when spending >= 2500000 then 'gold'
  when spending >= 1000000 then 'silver'
  else 'regular'
end as suggested_tier,
case
  when tier='regular' and spending >= 1000000 then 'UPGRADE'  -- duplikasi!
  when tier='silver'  and spending >= 2500000 then 'UPGRADE'
  ...
```

Threshold `5jt/2.5jt/1jt` muncul 8 kali. Ubah 1, harus ubah 8. Mudah inkonsisten.

**Refactor**: extract ke CTE constant atau JOIN dengan tabel `thresholds`.

```sql
with thresholds(tier, min_spending) as (
  values ('platinum', 5000000), ('gold', 2500000), ('silver', 1000000), ('regular', 0)
)
-- atau di MySQL:
with thresholds as (
  select 'platinum' as tier, 5000000 as min_spending union all
  select 'gold',     2500000 union all
  select 'silver',   1000000 union all
  select 'regular',  0
)
select c.name, c.tier, s.spending,
  (select tier from thresholds where s.spending >= min_spending order by min_spending desc limit 1) as suggested_tier
from customers c
left join spending s on s.customer_id = c.id;
```

#### Smell 3: Duplicate JOIN Base di UNION

```sql
select 'gross_revenue', city, sum(oi.line_total) from customers c
  join orders o on o.customer_id = c.id
  join order_items oi on oi.order_id = o.id
  where o.status in (...) and o.created_at >= '2026-01-01'
  group by city
union all
select 'order_count', city, count(distinct o.id) from customers c
  join orders o on o.customer_id = c.id
  join order_items oi on oi.order_id = o.id
  where o.status in (...) and o.created_at >= '2026-01-01'  -- SAMA persis
  group by city
union all
select 'unique_customers', city, count(distinct c.id) from customers c
  -- ... pola sama lagi
```

JOIN base + filter sama diulang 3x. Ubah satu, harus ubah 3.

**Refactor**: CTE shared + aggregate dengan `CASE WHEN` untuk pivot, atau gunakan 1 base CTE lalu 3 SELECT dari sana.

```sql
with base as (
  select c.city, o.id as order_id, c.id as customer_id, oi.line_total
  from customers c
  join orders o on o.customer_id = c.id
  join order_items oi on oi.order_id = o.id
  where o.status in ('paid','shipped','delivered')
    and o.created_at >= '2026-01-01'
)
select city,
  sum(line_total)          as gross_revenue,
  count(distinct order_id) as order_count,
  count(distinct customer_id) as unique_customers
from base
group by city;
```

#### Smell 4: Window Expression Diulang

```sql
sum(sum(o.total)) over (partition by c.id order by month) as running_total,
avg(sum(o.total)) over (partition by c.id order by month) as running_avg,
count(*)          over (partition by c.id order by month) as months_so_far
```

Frame window `partition by c.id order by month` ditulis 3-5x. Verbose, mudah salah saat ubah.

**Refactor**: pakai **named window**.

```sql
select
  sum(sum(o.total)) over w as running_total,
  avg(sum(o.total)) over w as running_avg,
  count(*) over w          as months_so_far
from ...
window w as (partition by c.id order by month);
```

#### Smell 5: SELECT * Wide + Nama Ambigu

```sql
select o.*, c.*, oi.*, p.*, s.*
from orders o
left join customers c on ...
left join order_items oi on ...
left join payments p on ...
left join shipments s on ...
where o.id = 14;
```

Masalah:
1. 40+ kolom output, banyak tidak dipakai
2. Nama `status` ambigu (ada di orders, payments, shipments)
3. Subtle bug: kalau `payments` lebih dari 1 per order, output row duplicate

**Refactor**: eksplisit kolom + alias jelas + pakai LATERAL/window untuk pick 1 baris.

```sql
select
  o.id              as order_id,
  o.status          as order_status,
  o.total           as order_total,
  c.name            as customer_name,
  c.email           as customer_email,
  latest_p.method   as payment_method,
  latest_p.status   as payment_status,
  s.tracking_no,
  s.status          as shipment_status
from orders o
join customers c on c.id = o.customer_id
left join lateral (
  select method, status from payments where order_id = o.id order by created_at desc limit 1
) latest_p on true
left join shipments s on s.order_id = o.id
where o.id = 14;
```

### 3. Pola Refactor SQL

| Pola | Kapan Pakai | Trade-off |
|------|-------------|-----------|
| **CTE (`WITH ... AS`)** | Ada step logis berlapis | Sedikit overhead vs subquery (umumnya dapat re-write oleh optimizer) |
| **Named window** | Frame window sama dipakai 2+ tempat | Hanya untuk MySQL 8+ |
| **View** | Query yang sama dipakai banyak tempat di app | Bisa hide complexity dari caller |
| **Materialized table / summary** | Aggregate mahal sering di-query | Stale data, perlu refresh |
| **Index** | Performance | Slow write, butuh storage |

### 4. Disiplin Behaviour-Preserving

Aturan emas refactor:

1. **Baseline dulu**. Run query asli, simpan output (screenshot atau export CSV).
2. **1 smell per commit**. Jangan rapikan semua sekaligus.
3. **Diff verifikasi**. Bandingkan:
   - `COUNT(*)` before vs after
   - `SUM(...)` kolom numerik utama before vs after
   - Spot-check 3 baris pertama
4. **Edge case**. Test dengan 0 row, NULL, banyak row.
5. **Commit message jelas**. `refactor: subquery hell → CTE in 01_top_spenders.sql`.

### 5. Pakai AI sebagai Refactor Accelerator

Prompt dengan **constraint eksplisit** supaya AI tidak liar:

```
@file 01_subquery_hell.sql

Refactor query ini dengan constraint:
1. Behaviour HARUS identik (output baris, kolom, urutan sama persis)
2. Target style: CTE (WITH ... AS) — bukan subquery scalar
3. Tidak boleh ubah WHERE clause
4. Tidak boleh ubah ORDER BY atau LIMIT
5. Tidak boleh tambah/hapus kolom output

Berikan:
- Query versi refactor
- 2 query test: COUNT(*) before vs after, SUM(...) kolom numerik
- 1 paragraf: kenapa versi baru lebih baik
```

Constraint #1 dan #5 paling penting — itu yang sering AI langgar.

### 6. Mengukur Dampak Refactor

| Metrik | Sebelum | Sesudah | Cara |
|--------|---------|---------|------|
| LOC query | — | — | `wc -l` |
| Nesting depth | — | — | hitung level `(` terdalam |
| Kolom output | — | — | `SHOW COLUMNS FROM result` (atau hitung manual) |
| EXPLAIN type | — | — | `EXPLAIN <query>` |
| Eksekusi (ms) | — | — | `EXPLAIN ANALYZE` |

Refactor yang baik: LOC ↓ atau ≈ sama, nesting ↓, EXPLAIN tidak lebih buruk.

Refactor yang **buruk** secara metric:
- LOC naik banyak (tanpa alasan kuat seperti readability dramatis)
- EXPLAIN jadi `ALL` padahal sebelumnya `ref`
- Hasil beda (behaviour berubah)

### 7. Anti-pattern Refactor

| ❌ Hindari | ✅ Lakukan |
|-----------|-----------|
| "Bersihkan query ini" (vague) | Constraint eksplisit |
| Refactor + ubah behaviour sekaligus | Pisah jadi 2 commit |
| Tidak baca diff AI | Selalu review baris per baris |
| Apply ke file tanpa baseline | Run baseline dulu, simpan output |
| Mengganti CTE jadi subquery "lebih ringkas" | Trade-off readability vs LOC: readability menang |

---

## Demo Live (15 menit)

Skenario: query `01_subquery_hell.sql` di review meeting di-flag jelek.

Langkah:

1. **Baseline**: run, catat 5 baris hasil + sum total_spending.
2. **Identifikasi smell** (AI prompt): list smell-nya.
3. **Refactor 1**: subquery scalar `tier` → JOIN dengan customers di outer.
4. **Verify**: COUNT, SUM, spot check 5 baris match.
5. **Commit**: `refactor(01): subquery scalar tier → join`.
6. **Refactor 2**: derived table → CTE.
7. **Verify lagi**, commit.

---

## Hands-on Latihan

Lihat [`latihan-06-refactor-legacy/`](./latihan-06-refactor-legacy/).

---

## Wrap-up & Q&A

1. Beda CTE vs subquery dari sisi optimizer — kapan beda performance?
2. Apa beda "smelly but works" vs "needs refactor now"?
3. Bagaimana negotiate dengan PM kalau refactor butuh sprint?

---

## Bacaan Lanjutan

- *Refactoring* — Martin Fowler (bab umum, tidak SQL-specific tapi prinsipnya berlaku)
- *SQL Antipatterns* — Bill Karwin (Part III: Query Antipatterns)
- *Modern SQL* — Markus Winand <https://modern-sql.com/>
