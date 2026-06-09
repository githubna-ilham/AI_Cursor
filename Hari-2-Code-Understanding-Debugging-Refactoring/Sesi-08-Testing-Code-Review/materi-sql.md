# Sesi 8 (SQL) — Test untuk Data + Review Teman

Durasi: 90 menit

## Bayangkan Skenario Ini

3 bulan lagi auditor datang. Mereka tanya: *"Bagaimana cara kalian memastikan data di database **konsisten**? Mis. setiap order yang berstatus 'delivered' pasti punya catatan shipment?"*

Kalau jawaban Anda *"...karena tim mengecek manual tiap bulan"* → auditor mengangkat alis. Yang ingin dia dengar: *"Kami punya 20 assertion query yang berjalan tiap malam. Kalau ada yang gagal, channel Slack tim langsung menerima notifikasi."*

Sesi 8 melatih cara membangun "**alarm otomatis untuk data**".

---

## Yang Akan Anda Pelajari

1. Apa itu **assertion query** dan kenapa beda dari test biasa
2. **7 jenis aturan** yang sering perlu di-cek (NULL, unik, FK, dst.)
3. Cara ubah **aturan bisnis** jadi SQL test
4. Cara **review** assertion teman dengan checklist 7-poin

---

## 1. Test untuk SQL Itu Beda

**Analogi**: di rumah Anda ada:
- **CCTV** → memantau apakah pintu ditutup
- **Alarm asap** → bunyi kalau ada kebakaran
- **Sensor pintu** → notifikasi kalau pintu terbuka di malam hari

Bukan "tes" dalam arti coba klik tombol. Tapi **monitor otomatis** yang nyala kalau ada yang aneh.

Untuk data, "test" yang sama:

| Untuk Kode Aplikasi | Untuk Data SQL |
|---------------------|----------------|
| Klik tombol, cek hasil sesuai expectation | Jalankan query, cek tidak ada row yang melanggar aturan |
| Pakai library (Jest, Pytest, JUnit) | Pakai assertion query (SELECT...) |

Inti: kalau data **integritas terjamin**, query yang Anda tulis di Sesi 5-7 hasilnya bisa dipercaya.

---

## 2. Pola Assertion: 0 Baris = Aman

**Konvensi sederhana**:
- Tulis SELECT yang **return 0 baris kalau semua aman**
- Kalau muncul N baris → ada N pelanggar, masing-masing punya ID untuk Anda investigate

Contoh: "stok tidak boleh negatif".

```sql
SELECT id, sku, stock
FROM products
WHERE stock < 0;
```

Jalankan:
- 0 baris → ✅ AMAN
- 3 baris → ❌ Ada 3 produk dengan stok negatif, mis. id 7, 12, 15. Investigate kenapa.

Pola ini **sangat efektif** karena:
- Self-explanatory: query itu sendiri sekaligus jadi dokumentasi aturannya
- Mudah ditelusuri: ID pelanggar langsung muncul di hasil
- Mudah diotomatisasi: cukup hitung `count(*)`, kalau > 0 berarti gagal

---

## 3. Tujuh Jenis Aturan Paling Sering

Ini "menu" aturan yang biasa dipakai. Hafalkan polanya.

### Aturan 1: Kolom Tidak Boleh Kosong

```sql
-- T: products.price wajib ada
SELECT id, sku FROM products WHERE price IS NULL;
```

### Aturan 2: Kombinasi Harus Unik

```sql
-- T: 1 customer hanya boleh 1 review per produk
SELECT customer_id, product_id, COUNT(*) AS dup
FROM reviews
GROUP BY customer_id, product_id
HAVING COUNT(*) > 1;
```

### Aturan 3: Setiap Referensi Wajib Mengarah ke Data yang Ada

```sql
-- T: setiap order_items.product_id harus ada di products
SELECT oi.id, oi.product_id
FROM order_items oi
LEFT JOIN products p ON p.id = oi.product_id
WHERE p.id IS NULL;
```

### Aturan 4: Nilai dalam Batas Wajar

```sql
-- T: rating harus 1-5
SELECT id FROM reviews WHERE rating < 1 OR rating > 5;
```

### Aturan 5: Status Hanya Nilai yang Diizinkan

```sql
-- T: tier customer cuma 4 nilai
SELECT id, tier FROM customers
WHERE tier NOT IN ('regular', 'silver', 'gold', 'platinum');
```

### Aturan 6: Total di Tabel A Harus Sama dengan Total di Tabel B

```sql
-- T: subtotal order harus = jumlah line_total dari order_items
SELECT o.id, o.subtotal, COALESCE(SUM(oi.line_total), 0) AS detail_sum
FROM orders o
LEFT JOIN order_items oi ON oi.order_id = o.id
GROUP BY o.id, o.subtotal
HAVING o.subtotal <> COALESCE(SUM(oi.line_total), 0);
```

### Aturan 7: Waktu Harus Logis (Tidak Mundur)

```sql
-- T: tanggal kirim harus sebelum tanggal terima
SELECT id FROM shipments
WHERE delivered_at < shipped_at;
```

---

## 4. Cara Ubah Aturan Bisnis Jadi SQL

Ini skill paling penting di Sesi 8. Diberikan aturan bahasa Indonesia, Anda harus bisa ubah jadi assertion SQL.

**Contoh aturan**:
> "Customer dengan tier 'platinum' harus punya total belanja 12 bulan terakhir minimal 2,5 juta."

**Cara pikir**:

1. **Apa pelanggarnya?**
   → "Customer platinum yang spending 12-mo < 2,5 juta"

2. **Tabel mana?**
   → `customers` (untuk tier) + `orders` (untuk spending)

3. **Tulis SELECT pelanggar**:

```sql
-- T: platinum customer harus spending >= 2.5jt dalam 12 bulan terakhir
SELECT c.id, c.name, c.tier,
       COALESCE(s.spending_12mo, 0) AS spending_12mo
FROM customers c
LEFT JOIN (
  SELECT customer_id, SUM(total) AS spending_12mo
  FROM orders
  WHERE status IN ('paid', 'shipped', 'delivered')
    AND created_at >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
  GROUP BY customer_id
) s ON s.customer_id = c.id
WHERE c.tier = 'platinum'
  AND COALESCE(s.spending_12mo, 0) < 2500000;
```

**Template prompt untuk AI**:

```
Bantu tulis assertion query SQL untuk MySQL.

Aturan: SELECT yang return 0 baris kalau aman, N baris (id + kolom
relevan) kalau ada pelanggar.

Schema: @file ../../sql-playground/00_schema.sql

Aturan bisnis yang harus di-cek:
"<paste aturan dalam bahasa Indonesia>"

Beri saya:
1. Query SELECT
2. Komentar 1 baris di atas: deskripsi aturan
3. Contoh output kalau ada pelanggar (1-2 baris dummy)
```

---

## 5. Validasi Assertion Anda Sendiri: Checklist 7-Poin

Sebelum assertion dipakai ke production, cek 7 hal ini sendiri:

| # | Yang dicek | Pertanyaan |
|---|------------|------------|
| 1 | Komentar jelas | Apakah pembaca paham aturannya tanpa baca SQL? |
| 2 | Syntax benar | Query-nya bisa di-run tanpa error? |
| 3 | Logika benar | Dengan 2-3 row dummy, apakah benar nangkap pelanggar? |
| 4 | Pola 0-baris-aman | Return 0 baris saat data normal? |
| 5 | Tidak false alarm | Pelanggar yang muncul **memang** melanggar aturan? |
| 6 | Tidak miss pelanggar | Adakah pelanggar yang seharusnya muncul tapi tidak? |
| 7 | Performance ok | Tidak ada full scan tabel besar (cek dengan EXPLAIN) |

Anda bisa pakai checklist ini sebagai daftar verifikasi setelah menulis tiap assertion. Salah satu cara terbaik adalah dengan **menjalankan ulang assertion sebelum & sesudah inject dummy row pelanggar** (lihat seksi berikutnya).

---

## 6. False Alarm vs Bug Lewat

Dua tipe error assertion:

| Tipe | Artinya | Risiko |
|------|---------|--------|
| **False Alarm** (false positive) | Assertion bilang "ada masalah" padahal datanya benar | Engineer capek kejar bug yang tidak ada → mulai ignore alert → bug nyata pun ke-skip |
| **Bug Lewat** (false negative) | Assertion bilang "aman" padahal datanya salah | Bug masuk production, customer komplain duluan |

Cara kalibrasi: **inject data dummy yang melanggar**, pastikan assertion benar nangkap.

```sql
-- Inject pelanggar dummy
UPDATE products SET stock = -5 WHERE id = 999;
-- Run assertion → harus muncul id=999
-- Cleanup
UPDATE products SET stock = ... WHERE id = 999;
```

Kalau assertion **tidak nangkap** → false negative. Perbaiki query.

---

## 7. Jalankan Otomatis (Bonus)

Kalau project sudah serius, assertion bisa jalan otomatis tiap malam:

| Tool | Cocok untuk |
|------|-------------|
| **Cron + shell script** | Setup minimal, kontrol penuh |
| **dbt test** | Project pakai dbt — assertion jadi `tests/*.sql` |
| **GitHub Actions** | Run tiap deploy ke staging |
| **Great Expectations** | Python-based, untuk team data |

Aturan ringan:
- **Hard fail** (block deploy): aturan kritis seperti FK orphan
- **Warning saja**: aturan dengan tolerance (mis. subtotal mismatch < 1% bisa diterima)

---

## 8. Jangan Lakukan Ini

| ❌ Salah | ✅ Benar |
|---------|---------|
| Assertion tanpa komentar | Komentar 1 baris di atas |
| Test happy path saja | Inject dummy pelanggar untuk kalibrasi |
| Return semua kolom | Cukup ID + kolom yang melanggar |
| 1 assertion gigantis (banyak aturan) | 1 assertion = 1 aturan |
| Pakai `SELECT *` | Eksplisit kolom |
| Skip validasi sendiri sebelum production | Wajib — pakai checklist 7-poin di seksi 5 |

---

## Demo Live (15 menit)

Aturan baru dari PM: *"Order yang `cancelled` tidak boleh punya shipment yang sudah `delivered`."*

Bersama fasilitator:

1. **Konversi aturan**: pelanggar = order cancelled + shipment delivered
2. **Prompt AI** dengan template
3. **Review query AI**: cek 7-poin
4. **Test dengan dummy**: insert order cancelled + shipment delivered → run → harus muncul
5. **Cleanup dummy**, commit

---

## Lanjut ke Latihan

[`latihan-07-testing-review/`](./latihan-07-testing-review/)

---

## Ringkasan 1 Halaman

- **Test SQL = monitor otomatis untuk data**. Beda dari unit test aplikasi.
- **Pola**: SELECT yang return **0 baris kalau aman**, N baris kalau ada pelanggar.
- **7 jenis aturan**: NULL, unik, FK orphan, range, status enum, sum invariant, temporal.
- **Konversi aturan bisnis → SQL**: cara pikir 3 langkah (pelanggar apa → tabel mana → SELECT).
- **Review pakai checklist 7-poin**: komentar, syntax, logika, pola, false alarm, miss, performance.
- **Kalibrasi**: inject dummy pelanggar untuk pastikan assertion benar nangkap.
- **Otomatisasi**: cron / dbt / GitHub Actions kalau project sudah serius.
