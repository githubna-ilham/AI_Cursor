# Sesi 7 (SQL) — Merapikan Query yang Berantakan

Durasi: 90 menit

## Bayangkan Skenario Ini

Anda buka file SQL yang dipakai bagian Finance. Query-nya 100 baris, subquery 3 lapis, sama nilai threshold ditulis 8 kali, susah dibaca.

Hasilnya **benar**. Tapi setiap kali ada perubahan kecil (mis. naikkan tier threshold), Anda harus edit 8 tempat. Sering lupa salah satu → bug.

Sesi 7 melatih cara **merapikan query** tanpa mengubah hasilnya. Istilah teknisnya: **refactoring**.

---

## Yang Akan Anda Pelajari

1. Beda **refactor** vs **rewrite** (penting — sering tertukar)
2. **5 ciri** query yang perlu dirapikan (code smell)
3. **5 cara** merapikan (CTE, named window, view, dst.)
4. Cara minta AI rapikan **tanpa mengubah hasilnya**

---

## 1. Refactor ≠ Rewrite

**Analogi**: ruang tamu Anda berantakan. Ada 2 cara:

| Pendekatan | Yang dilakukan | Risiko |
|------------|----------------|--------|
| **Refactor** | Rapikan: pindah sofa, gulung karpet, tata ulang | Rendah — barangnya sama, posisinya berubah |
| **Rewrite** | Bongkar total, beli furniture baru | Tinggi — bisa kelupaan barang penting |

Sama dengan query SQL:

| Aspek | Refactor | Rewrite |
|-------|----------|---------|
| Hasil query | **Sama persis** | Bisa beda |
| Risiko | Rendah | Tinggi |
| Cocok untuk AI | Sangat (dengan aturan) | Hanya kalau spec lengkap |

**Aturan utama**: setelah refactor, baris/kolom/urutan output query **harus identik**.

---

## 2. Lima Ciri Query Perlu Dirapikan

Anggap "code smell" sebagai **bau tidak enak** — bukan langsung rusak, tapi tanda ada masalah.

### Ciri 1: Subquery Bertingkat-Tingkat

```sql
SELECT name,
  (SELECT tier FROM customers WHERE id =
     (SELECT id FROM customers WHERE name =
        (SELECT name FROM customers WHERE ...)
     )
  ) AS tier
FROM ...
```

**Masalah**: 3 lapis subquery untuk lookup sederhana. Susah dibaca, susah di-debug. Saat ada perubahan, harus telusuri tiga lapis.

**Solusi**: pakai **CTE** (`WITH ... AS`). Anggap CTE seperti "variabel temporer untuk tabel".

```sql
WITH top_spenders AS (
  SELECT customer_id, SUM(total) AS spending
  FROM orders
  WHERE status IN ('paid', 'shipped', 'delivered')
  GROUP BY customer_id
)
SELECT c.name, t.spending, c.tier
FROM top_spenders t
JOIN customers c ON c.id = t.customer_id;
```

Lebih panjang sedikit, tapi **jauh** lebih mudah dibaca dan diubah.

### Ciri 2: Angka Sama Ditulis Berkali-Kali

```sql
CASE
  WHEN spending >= 5000000 THEN 'platinum'
  WHEN spending >= 2500000 THEN 'gold'
  WHEN spending >= 1000000 THEN 'silver'
  ELSE 'regular'
END,
CASE
  WHEN tier='regular' AND spending >= 1000000 THEN 'UPGRADE'  -- 1jt ulang
  WHEN tier='silver'  AND spending >= 2500000 THEN 'UPGRADE'  -- 2,5jt ulang
  WHEN tier='gold'    AND spending >= 5000000 THEN 'UPGRADE'  -- 5jt ulang
  ...
```

Threshold 5jt/2.5jt/1jt muncul **8 kali**. Tahun depan tim marketing minta naikkan jadi 7,5jt/3,5jt/1,5jt → harus edit 8 tempat. Lupa satu = bug.

**Solusi**: buat CTE constant.

```sql
WITH thresholds AS (
  SELECT 'platinum' AS tier, 5000000 AS min_spending UNION ALL
  SELECT 'gold',     2500000 UNION ALL
  SELECT 'silver',   1000000 UNION ALL
  SELECT 'regular',  0
)
-- threshold cuma di 1 tempat. Ubah sekali, beres.
```

### Ciri 3: Pola JOIN Diulang-Ulang

```sql
SELECT 'revenue', city, SUM(oi.line_total)
FROM customers c JOIN orders o ON ... JOIN order_items oi ON ...
WHERE o.status IN ('paid','shipped','delivered') AND o.created_at >= '2026-01-01'
GROUP BY city

UNION ALL

SELECT 'order_count', city, COUNT(DISTINCT o.id)
FROM customers c JOIN orders o ON ... JOIN order_items oi ON ...
WHERE o.status IN ('paid','shipped','delivered') AND o.created_at >= '2026-01-01'  -- SAMA persis
GROUP BY city
-- ...diulang 3-4 kali
```

JOIN + filter sama dicopy-paste 3x. Ubah satu, harus ubah 3.

**Solusi**: bikin CTE base, hitung semua metric dari sana sekaligus.

```sql
WITH base AS (
  SELECT c.city, o.id AS order_id, c.id AS customer_id, oi.line_total
  FROM customers c
  JOIN orders o ON o.customer_id = c.id
  JOIN order_items oi ON oi.order_id = o.id
  WHERE o.status IN ('paid','shipped','delivered')
    AND o.created_at >= '2026-01-01'
)
SELECT city,
  SUM(line_total)            AS revenue,
  COUNT(DISTINCT order_id)   AS order_count,
  COUNT(DISTINCT customer_id) AS unique_customers
FROM base
GROUP BY city;
```

Filter cuma 1 tempat. Output sama persis.

### Ciri 4: `SELECT *` Banyak Tabel

```sql
SELECT o.*, c.*, oi.*, p.*, s.*
FROM orders o LEFT JOIN customers c ON ... LEFT JOIN order_items oi ON ...
LEFT JOIN payments p ON ... LEFT JOIN shipments s ON ...
WHERE o.id = 14;
```

**Masalah**:
1. **40+ kolom** keluar, banyak yang tidak Anda perlukan
2. Nama kolom **ambigu** — ada `status` di orders, payments, shipments. Mau pakai yang mana?
3. Kalau ada 2 payment per order → baris jadi duplicate

**Solusi**: pilih kolom eksplisit + alias jelas.

```sql
SELECT
  o.id             AS order_id,
  o.status         AS order_status,
  o.total          AS order_total,
  c.name           AS customer_name,
  p.status         AS payment_status,
  s.status         AS shipment_status
FROM orders o
LEFT JOIN customers c ON c.id = o.customer_id
LEFT JOIN payments p  ON p.order_id = o.id
LEFT JOIN shipments s ON s.order_id = o.id
WHERE o.id = 14;
```

Sekarang jelas mana `status` yang dipakai.

### Ciri 5: Rumus Window Ditulis Berkali-Kali

```sql
SUM(...)   OVER (PARTITION BY customer ORDER BY month)
AVG(...)   OVER (PARTITION BY customer ORDER BY month)
COUNT(...) OVER (PARTITION BY customer ORDER BY month)
-- frame "partition by customer order by month" ditulis 3 kali
```

**Solusi**: pakai **named window**.

```sql
SUM(...)   OVER w,
AVG(...)   OVER w,
COUNT(...) OVER w
...
WINDOW w AS (PARTITION BY customer ORDER BY month);
```

Frame cuma di-define 1 kali. Ubah sekali, semua ikut.

---

## 3. Aturan Emas Refactor Aman

**Refactor query yang sudah jalan = berbahaya kalau ceroboh.** Ikuti urutan ini:

```
1. BASELINE      → run query asli, simpan hasilnya
2. IDENTIFY      → tahu code smell apa yang mau diatasi
3. REFACTOR      → ubah strukturnya
4. VERIFY        → bandingkan hasil baru vs baseline
5. COMMIT        → 1 smell = 1 commit
```

Cara cek **hasil identik**:

```sql
-- Test 1: jumlah baris sama
SELECT COUNT(*) FROM (<query asli>) t;    -- mis. 5
SELECT COUNT(*) FROM (<query refactor>) t; -- harus 5

-- Test 2: total angka utama sama
SELECT SUM(revenue) FROM (<query asli>) t;    -- mis. 12_500_000
SELECT SUM(revenue) FROM (<query refactor>) t; -- harus 12_500_000

-- Test 3: 3 baris pertama identik (manual cek)
```

Kalau ada beda → **rollback**, refactor ulang lebih hati-hati.

---

## 4. Cara Minta AI Rapikan (Tanpa Liar)

**Anti-pattern**:
> "Bersihkan query ini" → AI rewrite total, hasilnya mungkin beda.

**Pola benar — kasih aturan**:

```
@file 01_subquery_hell.sql

Refactor query ini dengan aturan:
1. Hasil HARUS sama persis (baris, kolom, urutan identik)
2. Target: pakai CTE (WITH ... AS)
3. Tidak boleh ubah WHERE clause
4. Tidak boleh ubah ORDER BY atau LIMIT
5. Tidak boleh tambah/hapus kolom output

Beri saya:
- Query versi refactor
- 2 query test untuk verifikasi: COUNT(*) dan SUM(...)
- 1 paragraf: kenapa versi baru lebih baik
```

Aturan #1 dan #5 **paling penting** — itu yang sering AI langgar.

---

## 5. Ukur Dampaknya

Refactor yang baik bisa diukur:

| Yang diukur | Sebelum | Sesudah |
|-------------|---------|---------|
| Jumlah baris kode | 30 | 18 |
| Lapis subquery | 3 | 0 (pakai CTE) |
| Repetisi nilai/pola | 8 tempat | 1 tempat |
| Kecepatan EXPLAIN | (sama atau lebih cepat) | |
| Mudah dibaca? | (rasakan sendiri setelah 1 hari) | |

Refactor **buruk** kalau:
- Baris kode naik dramatis tanpa alasan kuat
- EXPLAIN jadi lebih lambat
- Hasil beda (artinya: itu bukan refactor, itu rewrite)

---

## 6. Jangan Lakukan Ini

| ❌ Salah | ✅ Benar |
|---------|---------|
| "Bersihkan query ini" (vague) | Kasih aturan eksplisit |
| Refactor + ubah behavior sekaligus | Pisah jadi 2 commit |
| Tidak run baseline | Wajib run + simpan output |
| Skip review diff AI | Baca diff baris per baris |
| Refactor 5 hal sekaligus | 1 smell = 1 commit |
| Ganti CTE jadi subquery "supaya ringkas" | Readability > LOC |

---

## Demo Live (15 menit)

Buka `sql-playground/queries/sesi-07-refactor/01_subquery_hell.sql`. Bareng fasilitator:

1. **Baseline**: run, catat 5 baris hasil + sum kolom revenue
2. **Identify**: subquery scalar 3 lapis untuk lookup tier
3. **Refactor**: extract jadi CTE
4. **Verify**: COUNT + SUM match
5. **Commit**: `refactor(01): subquery → CTE`
6. **Refactor lagi** kalau masih ada smell

---

## Lanjut ke Latihan

[`latihan-06-refactor-legacy/`](./latihan-06-refactor-legacy/)

---

## Ringkasan 1 Halaman

- **Refactor = rapikan tanpa ubah hasil**. Rewrite = bongkar total.
- **5 code smell SQL**: subquery hell, magic numbers, duplicate JOIN, SELECT *, repeated window.
- **5 cara merapikan**: CTE, named window, view, eksplisit kolom, threshold constant.
- **Urutan kerja**: baseline → identify → refactor → verify → commit.
- Minta AI dengan **aturan eksplisit**, terutama "hasil HARUS sama persis".
- Ukur: LOC turun, nesting turun, EXPLAIN tidak lebih buruk, hasil identik.
