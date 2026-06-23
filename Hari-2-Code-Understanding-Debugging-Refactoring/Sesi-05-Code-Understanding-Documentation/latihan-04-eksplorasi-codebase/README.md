# Latihan 04 — Eksplorasi Database: Kenali Schema dan Data

> 🗺️ **Tahap 11–12 dari 20** di [Perjalanan Project Hari 2](../../perjalanan-project.md)
> Sebelumnya: Hari 1 selesai (SQL prompting drill) | Setelah ini: Sesi 6 Debugging

**Durasi**: 90 menit
**Tipe**: Hands-on individual

---

## Konteks

Anda baru "join project" e-commerce. Yang tersedia hanya dua file:
- `sql-playground/00_schema.sql` — struktur tabel
- `sql-playground/01_sample_data.sql` — data contoh

Tidak ada dokumentasi, tidak ada penjelasan bisnis. Tugas Anda: **pahami database ini** dengan bantuan AI.

---

## Tujuan

Setelah latihan, peserta mampu:

1. Membaca schema SQL dan memahami hubungan antar tabel dengan bantuan AI.
2. Menggunakan **@-mention file** di Cursor Chat untuk attach schema sebagai konteks.
3. Mengajukan pertanyaan bisnis sederhana dan mencari jawabannya langsung dari data.

---

## Prasyarat

- MySQL Server + GUI client (DBeaver / MySQL Workbench / Cursor Database Client) terinstall.
- Cursor aktif, mode Ask (Chat) familiar (dari Hari 1).

---

## Langkah

### 1. Setup (10')

1.1. Buka file `sql-playground/00_schema.sql` di GUI client, lalu eksekusi seluruh isinya untuk membuat database dan semua tabel.

> Kalau schema sudah pernah dibuat sebelumnya, file ini akan DROP dan recreate semua tabel — data lama akan terhapus.

1.2. Buka file `sql-playground/01_sample_data.sql`, lalu eksekusi untuk mengisi data sample ke semua tabel.

1.3. Verifikasi data sudah masuk:

```sql
USE latihan_sql;
SHOW TABLES;
-- expect 9 tabel

SELECT 'customers' AS t, COUNT(*) FROM customers
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'orders', COUNT(*) FROM orders;
```

---

### 2. Kenali Schema dengan AI (20')

Buka Cursor Chat (mode **Ask**), lalu ajukan pertanyaan berikut satu per satu:

**Pertanyaan 1 — Gambaran umum:**

```
@file sql-playground/00_schema.sql

Tolong jelaskan database ini dalam bahasa yang mudah dipahami:
1. Ini database untuk bisnis apa?
2. Ada tabel apa saja?
3. Tabel mana yang paling penting?
```

**Pertanyaan 2 — Hubungan antar tabel:**

```
@file sql-playground/00_schema.sql

Jelaskan hubungan antar tabel di database ini:
1. Tabel mana yang terhubung ke tabel mana?
2. Apa artinya hubungan tersebut dalam konteks bisnis?
   Contoh: "Satu customer bisa punya banyak order"
```

**Pertanyaan 3 — Cek data sample:**

```
@file sql-playground/01_sample_data.sql

Dari data sample ini:
1. Ada berapa customer, produk, dan order?
2. Produk apa saja yang tersedia?
3. Apa status order yang ada?
```

---

### 3. Eksplorasi Data dengan Pertanyaan Bisnis (40')

Pilih **minimal 4** pertanyaan bisnis di bawah, minta AI membuatkan query-nya, lalu jalankan di MySQL:

| # | Pertanyaan Bisnis |
|---|-------------------|
| 1 | Siapa saja customer yang sudah melakukan order? |
| 2 | Produk apa yang paling banyak dipesan? |
| 3 | Berapa total pendapatan dari order yang sudah dibayar? |
| 4 | Customer mana yang paling banyak belanja? |
| 5 | Produk apa yang belum pernah dipesan sama sekali? |
| 6 | Berapa rata-rata nilai order per customer? |

**Cara mengerjakan setiap pertanyaan:**

1. Tanya AI di Cursor Chat:

```
@file sql-playground/00_schema.sql

Buatkan query MySQL untuk menjawab pertanyaan ini:
"[tulis pertanyaan bisnis yang Anda pilih]"

Gunakan tabel yang tersedia di schema ini.
Jelaskan juga apa yang dilakukan query tersebut.
```

2. Jalankan query di MySQL, lihat hasilnya.

3. Kalau hasilnya tidak sesuai ekspektasi, paste hasil aslinya ke chat dan tanya AI lagi: *"kenapa hasilnya seperti ini?"*

---

### 4. Generate ER Diagram (10')

Minta AI membuatkan diagram hubungan antar tabel dan langsung disimpan ke file:

```
@file sql-playground/00_schema.sql

Buatkan ER diagram dalam format Mermaid untuk schema ini.
Tampilkan semua tabel dan hubungan antar tabelnya.
Gunakan format erDiagram.

Simpan hasilnya ke file 05_er_diagram.md
```

---

## Tips

- **Tanya AI dulu, jalankan kemudian** — pahami query sebelum dieksekusi.
- **Tidak harus mengerti semua SQL-nya** — fokus pada apa yang ingin Anda tahu dari data.

---

## Common Issues

| Issue | Solusi |
|-------|--------|
| `Unknown table` saat jalankan query | Pastikan sudah eksekusi `00_schema.sql` terlebih dahulu |
| `Unknown column` | Cek nama kolom di `00_schema.sql` — minta AI untuk menyesuaikan query |
| Data tidak muncul setelah query dijalankan | Pastikan `01_sample_data.sql` sudah dieksekusi |
| Query error tapi tidak tahu kenapa | Copy error message-nya, paste ke Cursor Chat, minta AI menjelaskan |
