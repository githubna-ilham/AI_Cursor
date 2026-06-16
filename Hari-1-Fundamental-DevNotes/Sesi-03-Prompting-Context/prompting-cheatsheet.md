# Prompting Cheatsheet — SQL di Cursor

Cetak / pin di samping monitor. Berlaku untuk Chat dan Composer.

---

## 1. Template Cepat

### Template Universal

```
[Role]       Sebagai <peran>,
[Goal]       tulis query MySQL untuk <hasil yang diinginkan>.
[Context]    Tabel: <nama_tabel> (<kolom1, kolom2, ...>)
             Filter: <kondisi WHERE>
[Constraint]
  - Dialect: MySQL 8.0
  - Jangan pakai <subquery / CTE / fungsi tertentu>.
  - Output kolom: <kolom apa saja yang diharapkan>
[Acceptance]
  - Hasil harus bisa langsung di-paste ke playground tanpa edit.
  - Sebutkan asumsi sebelum query kalau ada.
```

### Template SELECT dengan JOIN

```
Tulis query MySQL untuk <tujuan laporan>.

Tabel:
- <tabel1> (<kolom-kolom>)
- <tabel2> (<kolom-kolom>)

Output: <kolom1>, <kolom2>, <agregasi jika ada>
Filter: <kondisi WHERE>
Urutkan: <ORDER BY>
Batasi: <LIMIT jika perlu>

Gunakan <INNER / LEFT> JOIN.
```

### Template Agregasi

```
Tulis query MySQL untuk menghitung <metrik> per <dimensi>.

Tabel: <nama tabel dan relasi>
Agregasi: SUM / COUNT / AVG untuk <kolom>
Group: per <kolom group>
Filter sebelum group (WHERE): <kondisi>
Filter setelah group (HAVING): <kondisi agregat jika ada>
Urutan: <ORDER BY>
```

### Template UPDATE / DELETE Aman

```
Saya ingin <update/delete> baris yang memenuhi kondisi: <kondisi>.

Tulis DUA query berurutan:
1. SELECT — tampilkan baris yang akan terpengaruh (<kolom yang relevan>)
2. <UPDATE/DELETE> — eksekusi perubahan

Kondisi WHERE harus identik di kedua query.
Tambahkan komentar: "Jalankan SELECT dulu, verifikasi, baru eksekusi."

Tabel: <nama> (<kolom-kolom>)
```

### Template Diagnosa Data

```
Berdasarkan schema dan sample data berikut, jawab pertanyaan:

[paste schema]
[paste sample data atau kondisi data]

Pertanyaan:
1. <pertanyaan investigasi 1>
2. <pertanyaan investigasi 2>

Output: <jumlah> query terpisah dengan label A/B/C,
plus penjelasan 1 kalimat untuk tiap query.
```

---

## 2. @-Mentions: Kapan Pakai Apa

| Skenario | @-mention |
|----------|-----------|
| Paste file schema SQL sebagai konteks | `@file schema.sql` |
| Referensi query yang sudah ada | `@file queries/report.sql` |
| Tanya tentang migration / DDL | `@file migrations/` |
| Cari contoh query di codebase | `@code <nama fungsi query>` |
| Cari dokumentasi fungsi MySQL | `@docs MySQL` |
| Cari solusi error SQL di internet | `@web "<pesan error>"` |
| Lihat output error dari terminal / DB client | `@terminal` |
| Lanjutkan diskusi schema sebelumnya | `@past chat` |

> Untuk SQL: selalu mulai dengan paste schema di chat terlebih dahulu, baru gunakan @-mention untuk file pendukung.

---

## 3. Do / Don't

### Do

- Sebutkan **dialect** di setiap prompt awal: "MySQL 8.0" atau "PostgreSQL 16".
- Sebutkan **nama tabel dan kolom** yang relevan — AI tidak tahu schema Anda.
- **SELECT dulu sebelum UPDATE/DELETE** — minta AI tuliskan keduanya sekaligus.
- Sebut **tipe JOIN** yang diinginkan (INNER / LEFT / RIGHT) agar AI tidak menebak.
- Pecah query kompleks: mulai dari SELECT dasar, iterasi tambah JOIN / agregasi.
- Minta AI **sebutkan asumsi** sebelum menulis query kalau ada bagian yang ambigu.
- **Jalankan di playground** sebelum eksekusi ke database produksi.
- Reset chat saat berganti schema atau topik berbeda.

### Don't

- Jangan prompt tanpa schema: "tampilkan semua order customer" → AI akan menebak nama kolom.
- Jangan campur banyak operasi dalam 1 prompt: SELECT + INSERT + UPDATE sekaligus.
- Jangan langsung eksekusi ke produksi tanpa verifikasi di data dummy.
- Jangan pakai pronoun ambigu ("tabel ini", "kolom itu", "yang tadi").
- Jangan ngotot lebih dari 4 iterasi pada prompt yang sama — reset dengan konteks lebih lengkap.
- Jangan asumsikan AI tahu data di tabel Anda — berikan sample data kalau hasilnya kritis.
- Jangan lewati `EXPLAIN` untuk query dengan JOIN di tabel besar.

---

## 4. Contoh: Buruk vs Baik

### Contoh 1 — SELECT Laporan

**Buruk**
```
buatkan laporan penjualan per kategori
```

**Baik**
```
Tulis query MySQL untuk laporan penjualan per kategori bulan ini.

Tabel:
- categories (id, name)
- products (id, category_id, name)
- order_items (id, order_id, product_id, qty, unit_price)
- orders (id, status, created_at)

Output: category_name, total_qty (SUM qty), total_revenue (SUM qty * unit_price)
Filter: MONTH(orders.created_at) = bulan ini, YEAR = tahun ini, status = 'paid'
Group: per categories.id
Urutan: total_revenue DESC

Gunakan LEFT JOIN agar kategori tanpa penjualan tetap muncul.
MySQL 8.0.
```

---

### Contoh 2 — UPDATE Aman

**Buruk**
```
update harga semua produk elektronik jadi diskon 10%
```

**Baik**
```
Saya ingin memberi diskon 10% pada semua produk dengan category = 'Electronics'.

Tulis DUA query berurutan:
1. SELECT — tampilkan id, sku, name, price (sekarang) untuk produk yang akan terpengaruh
2. UPDATE — set price = price * 0.9 untuk produk yang sama

Kondisi WHERE harus identik di kedua query.
Tambahkan komentar: "Jalankan SELECT dulu, verifikasi jumlah baris, baru UPDATE."

Tabel: products (id, sku, name, category, price)
MySQL 8.0.
```

---

### Contoh 3 — Query Diagnostik

**Buruk**
```
kenapa produk ini tidak muncul di laporan?
```

**Baik**
```
Berdasarkan schema dan sample data berikut, bantu saya investigasi:

[schema: products, orders, order_items seperti di latihan]

Masalah: produk SKU-005 tidak muncul di ringkasan penjualan bulan Mei.

Pertanyaan:
1. Berapa kali SKU-005 muncul di order_items?
2. Apa status order untuk tiap kemunculan tersebut?
3. Apakah ada order SKU-005 yang statusnya 'cancelled' atau 'pending'?

Tulis 3 query terpisah (A, B, C) dengan label dan penjelasan 1 kalimat.
MySQL 8.0.
```

---

## 5. Pola Iterasi SQL

Ketika query hasil generate tidak sesuai harapan, gunakan umpan balik spesifik:

| Masalah yang ditemukan | Contoh umpan balik ke AI |
|------------------------|--------------------------|
| JOIN salah (hasil duplikat) | "Hasil mengandung baris duplikat — kemungkinan CROSS JOIN. Periksa kondisi ON di JOIN antara orders dan order_items." |
| WHERE salah | "Filter status belum ada. Tambahkan `WHERE orders.status IN ('paid', 'shipped')` sebelum GROUP BY." |
| GROUP BY hilang kolom | "Ada error 'not in GROUP BY'. Tambahkan `categories.name` ke GROUP BY atau gunakan fungsi agregat." |
| Masih pakai subquery | "Kamu masih pakai subquery di baris 5. Tulis ulang dengan murni JOIN tanpa SELECT bersarang." |
| Dialect tidak sesuai | "Ini syntax PostgreSQL (`date_trunc`). Kita pakai MySQL — ganti dengan `DATE_FORMAT` atau `MONTH()`." |
| Hasil 0 baris | "Query jalan tapi 0 baris. Cek filter tanggal — apakah MONTH() dan YEAR() sudah sesuai data sample?" |

---

## 6. Quick Self-check Sebelum Submit Prompt SQL

- [ ] Sudah sebut **dialect** (MySQL 8.0)?
- [ ] Sudah sebut **nama tabel dan kolom** yang relevan?
- [ ] Sudah tentukan **tipe JOIN** (INNER / LEFT)?
- [ ] Sudah sebut **kolom output** yang diharapkan?
- [ ] Sudah sebut **filter WHERE** dan **ORDER BY**?
- [ ] Untuk UPDATE/DELETE: sudah minta **SELECT verifikasi dulu**?
- [ ] Bebas pronoun ambigu ("tabel ini", "kolom itu")?
- [ ] Sudah siapkan **playground** untuk verifikasi hasil?
