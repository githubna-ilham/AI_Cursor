# Sesi 8 (SQL) — Testing & Code Review

Durasi: 90 menit
Modul: Hari 2 / Sesi 4 dari 4

> Versi SQL dari `materi.md`. Test untuk SQL = assertion query (data integrity), bukan unit test imperatif.

---

## Learning Outcomes

Setelah sesi ini peserta mampu:

1. Memahami **assertion query dbt-style**: 0 baris = pass, N baris = fail.
2. Menulis assertion untuk **6 kategori invariant**: null, unique, FK orphan, range, enum, sum invariant, temporal.
3. Mengonversi **business rule** (bahasa Indonesia) jadi assertion SQL dengan bantuan AI.
4. Melakukan **peer code review** assertion menggunakan 7-point checklist.
5. Mengenali **false positive** & **false negative** dalam test data integrity.

---

## Konsep Inti

### 1. Test SQL Itu Apa?

Untuk kode aplikasi (Java/Python/JS), "test" = function call + assert hasil. Mudah.

Untuk SQL, lebih nuanced. Apa yang dites?

| Jenis Test SQL | Tujuan | Tool |
|----------------|--------|------|
| **Data integrity** (paling penting) | Apakah data di DB konsisten dengan business rule? | Assertion query (dbt, manual) |
| **Query correctness** | Apakah query return hasil yang diharapkan? | Test data + expected output (dbtest, sqitch verify) |
| **Schema validity** | Apakah migration jalan tanpa error? | CI run `mysql < migration.sql` |
| **Performance** | Apakah query memenuhi SLA latency? | EXPLAIN regression, slow query log |

Sesi 8 fokus pada **data integrity** — yang paling sering tidak ada, dan paling sering bikin bug production.

### 2. Pola Assertion dbt-Style

**Konvensi**: assertion = `SELECT` yang return **0 baris saat invariant terpenuhi**, **N baris (id + kolom relevant) saat ada pelanggar**.

Contoh: "stock tidak boleh negatif"

```sql
-- assertion
select id, sku, stock
from products
where stock < 0;
```

Jalankan:
- 0 baris → **PASS** ✅
- 3 baris → **FAIL**: ada 3 produk dengan stock negatif. Investigate ID-nya.

Wrapper untuk pass/fail otomatis:

```sql
select count(*) as failed_rows from (
  <assertion query>
) t;
-- failed_rows = 0 → pass
```

Kenapa pola ini bagus:
- **Direkomendasikan dbt** (industry standard data engineering)
- **Self-documenting**: query = test, hasil = list pelanggar (langsung bisa investigate)
- **Composable**: bisa di-CI/CD dengan threshold (mis. "fail kalau failed_rows > 10")

### 3. Enam Kategori Invariant

#### 3.1 NULL Check

Kolom yang seharusnya tidak null:

```sql
-- T: products.price tidak boleh null
select id, sku from products where price is null;
```

#### 3.2 Unique Check

Kombinasi unik:

```sql
-- T: tidak boleh duplicate (customer_id, product_id) di reviews
select customer_id, product_id, count(*) as dup
from reviews
group by customer_id, product_id
having count(*) > 1;
```

#### 3.3 FK Orphan

Setiap FK di child harus exist di parent:

```sql
-- T: setiap order_items.product_id harus exist di products
select oi.id, oi.product_id
from order_items oi
left join products p on p.id = oi.product_id
where p.id is null;
```

#### 3.4 Range Check

Nilai numerik dalam batas yang masuk akal:

```sql
-- T: rating harus 1-5
select id from reviews where rating < 1 or rating > 5;
```

#### 3.5 Enum / Allowed Values

Kolom string yang hanya boleh nilai tertentu:

```sql
-- T: customer.tier hanya 4 nilai yang diizinkan
select id, tier from customers
where tier not in ('regular', 'silver', 'gold', 'platinum');
```

#### 3.6 Sum Invariant

Total di tabel A harus = total di tabel B (denormalized data consistency):

```sql
-- T: orders.subtotal harus = sum(order_items.line_total) untuk order yang sama
select o.id, o.subtotal, coalesce(sum(oi.line_total), 0) as detail_sum
from orders o
left join order_items oi on oi.order_id = o.id
group by o.id, o.subtotal
having o.subtotal <> coalesce(sum(oi.line_total), 0);
```

#### 3.7 Temporal Consistency (Bonus)

Kolom waktu yang harus terurut:

```sql
-- T: delivered_at >= shipped_at
select id from shipments
where delivered_at is not null
  and shipped_at  is not null
  and delivered_at < shipped_at;
```

### 4. Konversi Business Rule → SQL Assertion

Skill kunci di Sesi 8: ambil **business rule bahasa manusia**, jadikan **SQL assertion**.

Contoh rule:
> "Customer dengan tier 'platinum' harus punya total spending 12 bulan terakhir minimal 2.5 juta."

Langkah konversi:

1. **Tentukan invariant**: "Customer platinum yang spending 12-mo < 2.5jt = pelanggar."
2. **Identifikasi tabel**: `customers` (tier) + `orders` (spending 12-mo).
3. **Tulis SELECT pelanggar**:

```sql
-- T: platinum customer harus spending >= 2.5jt dalam 12 bulan terakhir
select
  c.id, c.name, c.tier,
  coalesce(s.spending_12mo, 0) as spending_12mo
from customers c
left join (
  select customer_id, sum(total) as spending_12mo
  from orders
  where status in ('paid', 'shipped', 'delivered')
    and created_at >= date_sub(curdate(), interval 12 month)
  group by customer_id
) s on s.customer_id = c.id
where c.tier = 'platinum'
  and coalesce(s.spending_12mo, 0) < 2500000;
```

Prompt template untuk AI:

```
Bantu tulis assertion query SQL untuk MySQL.

Konvensi: SELECT yang return 0 baris saat invariant terpenuhi,
N baris (id + kolom relevant) saat ada pelanggar.

Schema: @file ../../sql-playground/00_schema.sql

Invariant:
"<paste rule dalam bahasa Indonesia>"

Output:
1. Query SELECT
2. Komentar 1 baris di atas: deskripsi invariant
3. Sample output saat ada pelanggar (1-2 baris contoh)
```

### 5. Code Review Assertion: 7-Point Checklist

Saat review assertion teman, periksa 7 hal ini:

| # | Kriteria | Pertanyaan |
|---|----------|------------|
| 1 | **Komentar invariant jelas** | Apakah saya paham apa yang dites tanpa baca SQL? |
| 2 | **Syntax-correct** | Apakah query bisa di-run? |
| 3 | **Logika benar** | Dengan 2-3 row dummy, apakah assertion benar nangkap pelanggar? |
| 4 | **Pola dbt-style** | Return 0 baris saat pass? |
| 5 | **No false positive** | Apakah pelanggar yang muncul **memang** melanggar? (jangan strict berlebihan) |
| 6 | **No false negative** | Apakah ada pelanggar yang seharusnya muncul tapi tidak? |
| 7 | **Performance reasonable** | Tidak ada Cartesian / full scan tabel besar tanpa filter |

### 6. False Positive vs False Negative

| Term | Artinya | Risiko |
|------|---------|--------|
| **False Positive** | Assertion fail padahal data **benar** | Engineer chase bug yang tidak ada, lelah, mulai ignore alert |
| **False Negative** | Assertion pass padahal data **salah** | Bug tidak ke-detect, masuk ke production |

Test data dummy untuk kalibrasi:

```sql
-- Inject pelanggar dummy untuk test "stock tidak boleh negatif"
update products set stock = -5 where id = 999;
-- run assertion → harus muncul id=999
-- restore: update products set stock = ... where id = 999;
```

### 7. Integrasi ke CI/CD

Assertion bisa dijalankan otomatis sebagai data quality gate:

| Tool | Cocok untuk |
|------|-------------|
| **dbt test** | Project dbt — assertion jadi `tests/*.sql` |
| **Great Expectations** | Python-based, pakai DataFrame |
| **Manual cron + script** | Setup minimal, full kontrol |
| **GitHub Actions** | Run assertion di staging tiap deploy |

Threshold umum:
- **Hard fail**: `failed_rows > 0` untuk invariant kritis (mis. orphan FK)
- **Warn only**: `failed_rows > N` untuk invariant tolerance (mis. subtotal mismatch acceptable < 1%)

### 8. Anti-pattern Test SQL

| ❌ Hindari | ✅ Lakukan |
|-----------|-----------|
| Assertion tanpa komentar invariant | Komentar 1 baris di atas, jelaskan rule |
| Test happy path saja | Inject dummy pelanggar untuk kalibrasi |
| Assertion yang return semua kolom | Cukup id + kolom yang melanggar (investigate-friendly) |
| Pakai SELECT * di assertion | Eksplisit kolom |
| 1 assertion gigantis dengan banyak invariant | 1 assertion = 1 invariant (single responsibility) |
| Skip review assertion teman | Peer review = catch false pos/neg |

---

## Demo Live (15 menit)

Skenario: business rule baru dari product manager — "Order yang `cancelled` tidak boleh punya shipment `delivered`."

Langkah:

1. **Konversi rule**: identifikasi tabel (`orders` + `shipments`).
2. **Prompt AI** dengan template.
3. **Review query AI**: cek 7 point.
4. **Test dengan dummy data**: insert order cancelled + shipment delivered → run assertion → harus muncul.
5. **Cleanup dummy**, commit assertion.

---

## Hands-on Latihan

Lihat [`latihan-07-testing-review/`](./latihan-07-testing-review/).

---

## Wrap-up & Q&A

1. Beda *data quality test* (yang kita pelajari) dengan *integration test*?
2. Kapan assertion harus jadi **hard fail** vs **warning**?
3. Kalau assertion lama mulai sering false positive, apa tindakan pertama?

---

## Bacaan Lanjutan

- dbt Tests docs: <https://docs.getdbt.com/docs/build/data-tests>
- *Designing Data-Intensive Applications* — Martin Kleppmann (ch.10 — Reliability)
- Great Expectations: <https://greatexpectations.io/>
