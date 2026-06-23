# Sesi 8 — Testing (Assertion Queries)

Database ini belum punya satu pun **regression test** untuk data integrity. Tugas Anda di Sesi 8:

1. Pahami pola **assertion query** (file `00_template.sql`).
2. Pelajari contoh assertion di `01_assertions_example.sql` — ada 10 test untuk schema kita.
3. **Tulis 5 assertion baru** untuk validasi yang belum ada (lihat ide di bawah).
4. Run semua → fix data atau adjust assertion sampai semua pass (atau identify true bug di data).

---

## Konvensi Assertion (dbt-style)

> **Test = SELECT yang return 0 baris saat PASS, N baris saat FAIL.**

Setiap baris yang muncul adalah 1 row yang melanggar invariant. Mudah di-investigate karena Anda langsung lihat ID-nya.

Contoh:
```sql
-- T: products.stock tidak boleh negatif
select id, sku, stock
from products
where stock < 0;
```

Jalankan:
- Hasil 0 baris → **PASS** ✅
- Hasil 3 baris → **FAIL**, ada 3 produk dengan stock negatif

Untuk hitung pass/fail otomatis:
```sql
select count(*) as failed_rows from (
  <assertion query>
) t;
-- failed_rows = 0 → pass
```

---

## File di Folder Ini

| File | Isi |
|------|-----|
| `00_template.sql` | 8 template umum (null check, unique, FK orphan, range, enum, sum invariant, density, temporal) |
| `01_assertions_example.sql` | 10 assertion siap pakai untuk schema e-commerce mini |

---

## Tugas Sesi 8: Tulis 5 Assertion Baru

Beberapa ide invariant yang **belum** ada di `01_assertions_example.sql`:

1. Setiap order yang berstatus `cancelled` atau `refunded` tidak boleh punya `shipment` dengan status `delivered`.
2. Total `qty_change` di `inventory_log` per produk dengan `movement_type='out'` harus sama dengan total `qty` di `order_items` untuk produk itu (yang ber-status delivered).
3. `payments.status='success'` harus selalu punya `paid_at IS NOT NULL`.
4. Setiap customer dengan `tier='platinum'` harus punya total spending 12 bulan terakhir minimum threshold (mis. 2.5jt).
5. Tidak boleh ada `products.is_active=0` yang masih punya order belum delivered (`status IN ('pending','paid','shipped')`).

Pakai Cursor Chat untuk bantu nulis — minta AI:
- Pahami invariant dari deskripsi business rule
- Tulis SELECT yang return baris pelanggar
- Kasih komentar invariant di atas query

---

## Prompt Template untuk AI

```
Bantu tulis assertion query SQL untuk MySQL.

Konvensi: query SELECT yang return 0 baris saat invariant terpenuhi,
N baris (id + kolom relevant) saat ada pelanggar.

Schema: @file 00_schema.sql

Invariant yang harus di-cek:
"<paste invariant dalam bahasa Indonesia, mis. 'order yang cancelled
tidak boleh punya shipment delivered'>"

Output:
1. Query SELECT
2. Komentar 1 baris di atas: deskripsi invariant
3. Sample output saat ada pelanggar (1-2 baris contoh)
```

---

## Bonus: Integrasi ke CI/CD

Kalau project ini dipakai production, assertion query bisa dijalankan otomatis:

- **dbt**: setiap assertion jadi `tests/*.sql` — built-in `dbt test`
- **Manual cron**: shell script jalankan tiap assertion, alert kalau `failed_rows > 0`
- **Great Expectations**: tool Python untuk data quality

Tidak perlu implementasi di Sesi 8 — cukup tahu polanya.
