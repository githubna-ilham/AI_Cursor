# Sesi 8 (SQL) — Pengujian Data dan Peer Review Assertion

Durasi: 90 menit

## Konteks Sesi

Bayangkan tiga bulan ke depan seorang auditor datang dan mengajukan pertanyaan: *"Bagaimana cara tim Anda memastikan data di database tetap **konsisten**? Misalnya, apakah setiap order berstatus 'delivered' dipastikan memiliki catatan shipment?"*

Apabila jawaban Anda adalah *"...karena tim melakukan pengecekan manual setiap bulan"*, auditor akan mempertanyakan prosesnya. Jawaban yang lebih meyakinkan adalah: *"Kami memiliki 20 assertion query yang berjalan setiap malam. Apabila ada yang gagal, tim langsung menerima notifikasi."*

Sesi ini melatih cara membangun **mekanisme pemantauan otomatis untuk data**.

---

## Yang Akan Anda Pelajari

1. Apa itu **assertion query** dan perbedaannya dari pengujian aplikasi biasa
2. Pola **AAA (Arrange–Act–Assert)** sebagai kerangka penulisan assertion
3. **7 jenis aturan** yang paling umum diperiksa (NULL, keunikan, FK, dan sebagainya)
4. Cara mengonversi **aturan bisnis** menjadi SQL assertion
5. Cara melakukan **peer review** assertion menggunakan checklist 7 poin

---

## 1. Pengujian SQL Berbeda dari Pengujian Aplikasi

**Analogi**: di sebuah gedung terdapat:
- **Kamera CCTV** → memantau apakah pintu dalam keadaan tertutup
- **Alarm asap** → aktif apabila terdeteksi kebakaran
- **Sensor pintu** → mengirim notifikasi apabila pintu terbuka di malam hari

Ini bukan "pengujian" dalam arti mencoba menekan tombol, melainkan **pemantauan otomatis** yang aktif saat terdapat kondisi yang tidak sesuai.

Untuk data, konsepnya serupa:

| Untuk Kode Aplikasi | Untuk Data SQL |
|---------------------|----------------|
| Klik tombol, periksa apakah hasilnya sesuai ekspektasi | Jalankan query, periksa apakah ada baris yang melanggar aturan |
| Menggunakan library pengujian (Jest, Pytest, JUnit) | Menggunakan assertion query (SELECT...) |

Intinya: apabila **integritas data terjamin**, hasil query yang Anda tulis di Sesi 5–7 dapat dipercaya.

---

## 2. Pola AAA untuk Assertion SQL

Pola **AAA (Arrange–Act–Assert)** adalah cara menyusun setiap skenario pengujian menjadi tiga blok berurutan. Tujuannya: setiap assertion mudah dipahami dalam hitungan detik karena strukturnya selalu konsisten.

| Blok | Artinya | Yang Dilakukan dalam Konteks SQL |
|------|---------|----------------------------------|
| **Arrange** | Siapkan | Sisipkan data uji — termasuk data yang valid maupun data yang sengaja melanggar aturan |
| **Act** | Jalankan | Eksekusi assertion query (SELECT yang menerapkan aturan bisnis) |
| **Assert** | Verifikasi | Periksa hasilnya: 0 baris berarti data valid, N baris berarti terdapat N pelanggar |

**Contoh penerapan AAA pada assertion SQL:**

```sql
-- ==============================
-- ARRANGE: siapkan data uji
-- ==============================
-- Data valid: stok bernilai positif
INSERT INTO products (id, sku, name, price, stock) VALUES (901, 'TEST-001', 'Produk Uji A', 50000, 10);
-- Data pelanggar: stok bernilai negatif (harus terdeteksi)
INSERT INTO products (id, sku, name, price, stock) VALUES (902, 'TEST-002', 'Produk Uji B', 50000, -5);

-- ==============================
-- ACT: jalankan assertion
-- ==============================
SELECT id, sku, stock
FROM products
WHERE stock < 0;

-- ==============================
-- ASSERT: verifikasi hasil
-- ==============================
-- Ekspektasi: hanya id=902 yang muncul (1 baris)
-- Apabila 0 baris → assertion tidak mendeteksi pelanggar (false negative)
-- Apabila id=901 juga muncul → logika query salah (false positive)

-- Bersihkan data uji setelah selesai
DELETE FROM products WHERE id IN (901, 902);
```

**Manfaat pola AAA dalam konteks SQL:**
- **Arrange** yang eksplisit memastikan kondisi awal selalu diketahui — tidak bergantung pada data yang ada sebelumnya.
- **Act** yang terisolasi (satu query, satu aturan) memudahkan identifikasi penyebab kegagalan.
- **Assert** yang tertulis sebagai komentar menjadi dokumentasi ekspektasi yang dapat dibaca oleh anggota tim lain.

---

## 3. Pola Assertion: 0 Baris = Aman

**Konvensi yang digunakan**:
- Tulis SELECT yang **mengembalikan 0 baris apabila semua data valid**
- Apabila muncul N baris, berarti terdapat N pelanggar — masing-masing dengan ID yang dapat diselidiki

Contoh: "stok tidak boleh bernilai negatif".

```sql
SELECT id, sku, stock
FROM products
WHERE stock < 0;
```

Hasil:
- 0 baris → ✅ Data valid
- 3 baris → ❌ Terdapat 3 produk dengan stok negatif, misalnya id 7, 12, 15. Perlu diselidiki penyebabnya.

Pola ini **sangat efektif** karena:
- *Self-explanatory*: query sekaligus berfungsi sebagai dokumentasi aturan bisnis
- Mudah ditelusuri: ID pelanggar langsung muncul pada hasil
- Mudah diotomatisasi: cukup hitung `COUNT(*)`, apabila > 0 berarti assertion gagal

---

## 4. Tujuh Jenis Aturan yang Paling Umum

Berikut adalah jenis-jenis aturan yang paling sering diterapkan. Pelajari polanya agar dapat menggunakannya kembali di berbagai skenario.

### Aturan 1: Kolom Tidak Boleh Kosong

```sql
-- T: products.price wajib terisi
SELECT id, sku FROM products WHERE price IS NULL;
```

### Aturan 2: Kombinasi Nilai Harus Unik

```sql
-- T: satu customer hanya boleh memberikan satu review per produk
SELECT customer_id, product_id, COUNT(*) AS jumlah_duplikat
FROM reviews
GROUP BY customer_id, product_id
HAVING COUNT(*) > 1;
```

### Aturan 3: Setiap Referensi Harus Mengarah ke Data yang Ada

```sql
-- T: setiap order_items.product_id harus memiliki entri di tabel products
SELECT oi.id, oi.product_id
FROM order_items oi
LEFT JOIN products p ON p.id = oi.product_id
WHERE p.id IS NULL;
```

### Aturan 4: Nilai Harus Berada dalam Batas yang Wajar

```sql
-- T: rating harus bernilai antara 1 dan 5
SELECT id FROM reviews WHERE rating < 1 OR rating > 5;
```

### Aturan 5: Status Hanya Boleh Berisi Nilai yang Diizinkan

```sql
-- T: tier customer hanya boleh bernilai salah satu dari 4 opsi berikut
SELECT id, tier FROM customers
WHERE tier NOT IN ('regular', 'silver', 'gold', 'platinum');
```

### Aturan 6: Total di Tabel A Harus Konsisten dengan Total di Tabel B

```sql
-- T: subtotal order harus sama dengan jumlah line_total dari order_items
SELECT o.id, o.subtotal, COALESCE(SUM(oi.line_total), 0) AS total_detail
FROM orders o
LEFT JOIN order_items oi ON oi.order_id = o.id
GROUP BY o.id, o.subtotal
HAVING o.subtotal <> COALESCE(SUM(oi.line_total), 0);
```

### Aturan 7: Urutan Waktu Harus Logis

```sql
-- T: tanggal pengiriman harus lebih awal dari tanggal penerimaan
SELECT id FROM shipments
WHERE delivered_at < shipped_at;
```

---

## 5. Mengonversi Aturan Bisnis Menjadi SQL Assertion

Ini adalah keterampilan terpenting di Sesi 8. Diberikan aturan dalam bahasa Indonesia, Anda perlu mengonversinya menjadi assertion SQL.

**Contoh aturan bisnis**:
> "Customer dengan tier 'platinum' harus memiliki total belanja 12 bulan terakhir minimal 2,5 juta rupiah."

**Pendekatan yang digunakan**:

1. **Tentukan definisi pelanggar**
   → Customer bertier platinum yang spending 12 bulan terakhir < 2,5 juta

2. **Identifikasi tabel yang terlibat**
   → `customers` (untuk tier) + `orders` (untuk total spending)

3. **Tulis SELECT untuk pelanggar tersebut**:

```sql
-- T: customer platinum harus memiliki spending >= 2.500.000 dalam 12 bulan terakhir
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
Tolong tuliskan assertion query SQL untuk MySQL.

Pola: SELECT yang mengembalikan 0 baris apabila data valid,
dan N baris (berisi ID + kolom yang relevan) apabila ada pelanggar.

Schema: @file ../../sql-playground/00_schema.sql

Aturan bisnis yang perlu diperiksa:
"<tuliskan aturan dalam bahasa Indonesia>"

Berikan:
1. Query SELECT assertion
2. Komentar 1 baris di atas query: deskripsi aturan
3. Contoh output apabila terdapat pelanggar (1–2 baris data dummy)
```

---

## 6. Validasi Assertion Sebelum Digunakan: Checklist 7 Poin

Sebelum assertion digunakan di lingkungan produksi, lakukan verifikasi menggunakan daftar berikut:

| # | Aspek yang Diperiksa | Pertanyaan |
|---|----------------------|------------|
| 1 | Komentar deskriptif | Apakah pembaca dapat memahami aturannya tanpa membaca SQL? |
| 2 | Sintaks valid | Apakah query dapat dijalankan tanpa error? |
| 3 | Logika benar | Dengan 2–3 baris data uji, apakah assertion berhasil mendeteksi pelanggar? |
| 4 | Pola 0-baris-aman | Apakah query mengembalikan 0 baris saat data dalam kondisi normal? |
| 5 | Tidak false alarm | Apakah semua baris yang muncul memang merupakan pelanggar nyata? |
| 6 | Tidak melewatkan pelanggar | Apakah ada pelanggar yang seharusnya terdeteksi tetapi tidak muncul? |
| 7 | Performa memadai | Apakah tidak terdapat full table scan pada tabel besar? (periksa dengan EXPLAIN) |

Salah satu cara paling efektif untuk memvalidasi adalah dengan **menjalankan ulang assertion sebelum dan sesudah menyisipkan data uji yang melanggar** — lihat bagian berikutnya untuk panduan lengkapnya.

---

## 7. False Alarm dan Bug yang Lolos

Terdapat dua jenis kegagalan assertion:

| Tipe | Artinya | Risiko |
|------|---------|--------|
| **False Alarm** (false positive) | Assertion melaporkan masalah padahal data sebenarnya valid | Engineer menghabiskan waktu menyelidiki bug yang tidak ada → alert mulai diabaikan → bug nyata pun ikut terlewat |
| **Bug yang Lolos** (false negative) | Assertion menyatakan data valid padahal sebenarnya bermasalah | Bug masuk ke produksi sebelum tim mengetahuinya |

Cara kalibrasi: **sisipkan data uji yang sengaja melanggar aturan**, lalu pastikan assertion berhasil mendeteksinya.

```sql
-- Sisipkan data pelanggar sebagai uji coba
UPDATE products SET stock = -5 WHERE id = 999;
-- Jalankan assertion → id=999 harus muncul pada hasil
-- Bersihkan data uji setelah selesai
UPDATE products SET stock = ... WHERE id = 999;
```

Apabila assertion tidak mendeteksi pelanggar tersebut, berarti terjadi *false negative*. Perbaiki logika query sebelum digunakan.

---

## 8. Menjalankan Assertion Secara Otomatis (Bonus)

Apabila proyek sudah berada di tahap yang lebih serius, assertion dapat dijalankan secara otomatis:

| Tool | Cocok untuk |
|------|-------------|
| **Cron + shell script** | Setup minimal dengan kontrol penuh |
| **dbt test** | Proyek yang menggunakan dbt — assertion disimpan sebagai `tests/*.sql` |
| **GitHub Actions** | Dijalankan setiap deploy ke staging |
| **Great Expectations** | Berbasis Python, cocok untuk tim data |

Panduan dasar:
- **Gagal keras** (*hard fail*, blokir deploy): untuk aturan kritis seperti FK orphan
- **Peringatan saja**: untuk aturan dengan toleransi tertentu (misalnya, selisih subtotal < 1% masih dapat diterima)

---

## 9. Anti-Pattern yang Perlu Dihindari

| ❌ Tidak Disarankan | ✅ Praktik yang Tepat |
|---------------------|----------------------|
| Assertion tanpa komentar deskriptif | Sertakan komentar 1 baris di atas query |
| Hanya menguji kondisi normal (happy path) | Sisipkan data uji pelanggar untuk kalibrasi |
| Mengembalikan semua kolom | Cukup tampilkan ID dan kolom yang relevan dengan pelanggaran |
| Satu assertion untuk banyak aturan sekaligus | Satu assertion = satu aturan bisnis |
| Menggunakan `SELECT *` | Pilih kolom secara eksplisit |
| Melewati validasi mandiri sebelum digunakan di produksi | Wajib menggunakan checklist 7 poin di bagian 6 |

---

## Demo Live (15 menit)

Aturan baru dari Product Manager: *"Order berstatus 'cancelled' tidak boleh memiliki shipment dengan status 'delivered'."*

Ikuti langkah bersama fasilitator:

1. **Konversi aturan**: pelanggar = order berstatus cancelled yang memiliki shipment berstatus delivered
2. **Prompt ke AI** menggunakan template dari bagian 5
3. **Review query AI**: gunakan checklist 7 poin
4. **Uji dengan data dummy**: sisipkan order cancelled + shipment delivered → jalankan assertion → pelanggar harus terdeteksi
5. **Bersihkan data uji**, lakukan commit

---

## Lanjut ke Latihan

[`latihan-07-testing-review/`](./latihan-07-testing-review/)

---

## Ringkasan

- **Pengujian SQL = pemantauan otomatis untuk data**. Berbeda dari pengujian unit aplikasi.
- **Pola AAA**: Arrange (siapkan data uji) → Act (jalankan assertion) → Assert (verifikasi 0 baris = aman).
- **Pola dasar**: SELECT yang mengembalikan **0 baris apabila data valid**, dan N baris apabila terdapat pelanggar.
- **7 jenis aturan**: NULL, keunikan, FK orphan, rentang nilai, status enum, konsistensi jumlah, urutan waktu.
- **Mengonversi aturan bisnis → SQL**: pendekatan 3 langkah (definisikan pelanggar → identifikasi tabel → tulis SELECT).
- **Peer review dengan checklist 7 poin**: komentar, sintaks, logika, pola, false alarm, pelanggar yang terlewat, performa.
- **Kalibrasi**: sisipkan data uji pelanggar untuk memastikan assertion berfungsi dengan benar.
- **Otomatisasi**: gunakan cron, dbt, atau GitHub Actions apabila proyek sudah berada di tahap produksi.
