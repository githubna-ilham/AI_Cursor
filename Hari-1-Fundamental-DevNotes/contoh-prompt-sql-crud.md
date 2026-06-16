# Contoh Prompt CRUD SQL di Cursor

Kumpulan prompt siap pakai untuk menulis query SQL dengan bantuan AI di Cursor. Semua contoh menggunakan konteks studi kasus yang relevan untuk developer — bisa langsung dipakai atau diadaptasi ke project Anda.

> **Cara pakai**: Buka Cursor → Cmd/Ctrl+K atau Chat → paste prompt → review output → sesuaikan ke schema Anda.

---

## Setup Konteks (Penting Sebelum Mulai)

Sebelum prompt CRUD, beri AI konteks schema Anda. Cara termudah: **attach file migration / schema** dengan `@file`.

```
Saya akan bekerja dengan database berikut. Gunakan schema ini sebagai referensi untuk semua query.

@file database/migrations/create_users_table.sql
@file database/migrations/create_orders_table.sql

Jawab setiap pertanyaan SQL saya dengan mengikuti konvensi penamaan di file tersebut.
```

---

## 1. CREATE TABLE

### 1.1 Buat tabel baru dari deskripsi bisnis

```
Buatkan SQL untuk membuat tabel `products` di MySQL 8.0 dengan ketentuan:
- id: primary key, auto increment, unsigned bigint
- name: varchar 255, tidak boleh null
- description: text, boleh null
- price: decimal(10,2), tidak boleh null, default 0
- stock: int unsigned, default 0
- category_id: foreign key ke tabel `categories(id)`, ON DELETE SET NULL
- is_active: tinyint(1), default 1
- created_at dan updated_at: timestamp, auto-managed

Tambahkan index pada kolom `category_id` dan `is_active`.
Sertakan komentar singkat di tiap kolom.
```

### 1.2 Buat tabel pivot / junction table

```
Buatkan SQL untuk tabel pivot `order_items` yang menghubungkan tabel `orders` dan `products`:
- id: primary key, auto increment
- order_id: FK ke orders(id), ON DELETE CASCADE
- product_id: FK ke products(id), ON DELETE RESTRICT
- quantity: int, tidak boleh null, minimum 1
- unit_price: decimal(10,2) — harga snapshot saat order, bukan referensi ke tabel products
- subtotal: decimal(10,2) generated column (quantity * unit_price)

Tambahkan composite unique key pada (order_id, product_id).
```

### 1.3 Tambah kolom ke tabel yang sudah ada

```
Tulis ALTER TABLE untuk menambahkan kolom `deleted_at` (soft delete) ke tabel `users` yang sudah ada:
- Type: timestamp, boleh null (null = tidak dihapus)
- Tambahkan index pada kolom ini
- Pastikan tidak ada data yang hilang (safe migration)

Database: MySQL 8.0
```

---

## 2. INSERT INTO

### 2.1 Insert satu baris dengan data literal

```
Tulis INSERT INTO untuk menambahkan satu produk baru ke tabel `products`:
- name: "Laptop Gaming X1"
- description: "Laptop untuk gaming dan programming"
- price: 15000000
- stock: 10
- category_id: 3
- is_active: true

Format query agar mudah dibaca (tiap kolom di baris terpisah).
```

### 2.2 Insert banyak baris sekaligus (bulk insert)

```
Tulis bulk INSERT untuk memasukkan 5 kategori awal ke tabel `categories(id, name, slug, created_at)`:
- Electronics / electronics
- Fashion / fashion
- Books / books
- Sports / sports
- Home & Living / home-living

Gunakan format multi-values INSERT INTO yang efisien.
Tambahkan NOW() untuk kolom created_at.
```

### 2.3 Insert dengan data dari SELECT (INSERT INTO ... SELECT)

```
Tulis query untuk menyalin semua produk dari tabel `products_archive` ke `products`,
khusus produk yang `archived_at` lebih dari 1 tahun lalu dan `is_active = 1`.

Kolom yang disalin: name, description, price, category_id.
Set is_active = 0 dan created_at = NOW() untuk semua baris yang disalin.
```

---

## 3. SELECT

### 3.1 SELECT dasar dengan filter

```
Tulis SELECT untuk mengambil semua produk yang:
- is_active = 1
- stock > 0
- price antara 100000 dan 5000000

Kolom yang diambil: id, name, price, stock
Urutkan berdasarkan price dari termurah ke termahal.
Batasi 20 baris.
```

### 3.2 SELECT dengan JOIN

```
Tulis query untuk mengambil detail order beserta informasi buyer dan item-nya:
- Tabel: orders, users (sebagai buyer), order_items, products
- Kolom yang diambil:
  - orders.id AS order_id
  - orders.created_at AS order_date
  - users.name AS buyer_name
  - users.email
  - products.name AS product_name
  - order_items.quantity
  - order_items.unit_price
  - order_items.subtotal
- Filter: orders dari 30 hari terakhir, status order = 'PAID'
- Urutkan berdasarkan orders.created_at DESC
```

### 3.3 SELECT dengan agregasi dan GROUP BY

```
Tulis query untuk laporan penjualan per kategori bulan ini:
- Tampilkan: nama kategori, jumlah produk terjual (sum quantity), total revenue (sum subtotal)
- Hanya order dengan status 'PAID'
- Filter: order di bulan dan tahun saat ini
- Urutkan berdasarkan total revenue tertinggi
- Sertakan kategori yang belum ada penjualan sekalipun (gunakan LEFT JOIN)

Tabel yang terlibat: categories, products, order_items, orders
```

### 3.4 SELECT dengan subquery / CTE

```
Tulis query menggunakan CTE (WITH clause) untuk menemukan top 5 customer
berdasarkan total belanja sepanjang waktu:
- CTE pertama: hitung total_spent per user_id dari tabel orders (status PAID)
- CTE kedua: rank user berdasarkan total_spent
- Query final: tampilkan nama, email, total_spent, rank
- Hanya tampilkan rank 1-5

Database: MySQL 8.0 (dukung CTE).
```

### 3.5 SELECT untuk pengecekan duplikat

```
Tulis query untuk menemukan email duplikat di tabel `users`:
- Tampilkan email yang muncul lebih dari sekali
- Sertakan jumlah kemunculan (count) dan id pertama yang terdaftar
- Urutkan berdasarkan count DESC

Gunakan GROUP BY dan HAVING.
```

---

## 4. UPDATE

### 4.1 UPDATE satu baris berdasarkan ID

```
Tulis UPDATE untuk mengubah harga dan stok produk dengan id = 42:
- price menjadi 12500000
- stock ditambah 5 (bukan di-set ke 5, tapi increment)
- updated_at di-set ke waktu sekarang

Pastikan query aman: tambahkan LIMIT 1 untuk mencegah update tidak sengaja ke banyak baris.
```

### 4.2 UPDATE banyak baris dengan kondisi

```
Tulis UPDATE untuk menonaktifkan (is_active = 0) semua produk yang:
- Stock = 0
- Tidak ada order dalam 90 hari terakhir (tidak ada di order_items untuk order dengan created_at >= 90 hari lalu)

Gunakan subquery atau JOIN di UPDATE.
Database: MySQL 8.0.
```

### 4.3 UPDATE dengan nilai dari tabel lain (UPDATE JOIN)

```
Tulis UPDATE JOIN di MySQL untuk mengupdate kolom `total_amount` di tabel `orders`
berdasarkan sum dari order_items.subtotal yang sesuai.

Ini untuk recalculate ulang total order yang mungkin tidak sinkron.
Hanya update order dengan status 'PENDING'.
```

---

## 5. DELETE

### 5.1 DELETE dengan konfirmasi via SELECT dulu

```
Saya ingin menghapus data guest user yang tidak pernah melakukan order.
Tolong buatkan DUA query:
1. SELECT dulu — untuk memastikan data yang akan dihapus (tampilkan id, email, created_at)
2. DELETE yang identik kondisinya dengan SELECT di atas

Kondisi: users.role = 'guest' AND tidak ada record di tabel orders dengan user_id yang cocok.
Tambahkan komentar penjelasan di tiap query.
```

### 5.2 Soft delete (UPDATE is_deleted / deleted_at)

```
Aplikasi saya pakai soft delete — tidak benar-benar hapus baris, tapi set kolom `deleted_at`.

Tulis query soft delete untuk menghapus semua produk di category_id = 7
yang tidak pernah masuk ke order_items sama sekali.

Setelah query DELETE/UPDATE, tulis juga query SELECT untuk memverifikasi hasilnya.
```

### 5.3 DELETE dengan foreign key (cascade awareness)

```
Saya ingin menghapus order dengan id = 150 beserta semua order_items-nya.
Foreign key `order_items.order_id` sudah dikonfigurasi ON DELETE CASCADE.

Tulis:
1. Query DELETE singkat untuk order tersebut
2. Query verifikasi bahwa order_items sudah ikut terhapus

Jelaskan di komentar mengapa CASCADE bisa berbahaya jika dikonfigurasi salah.
```

---

## 6. Query Lanjutan (Bonus)

### 6.1 EXPLAIN — optimasi query

```
Query saya lambat saat dijalankan di tabel `orders` yang sudah ada 1 juta baris:

SELECT * FROM orders WHERE user_id = 42 AND status = 'PAID' ORDER BY created_at DESC;

Tolong:
1. Tulis query EXPLAIN untuk menganalisa query ini
2. Rekomendasikan index apa yang perlu ditambahkan
3. Tulis ALTER TABLE untuk menambahkan index tersebut
4. Jelaskan mengapa index yang direkomendasikan lebih efisien
```

### 6.2 Stored procedure sederhana

```
Buatkan stored procedure `sp_monthly_sales_report` di MySQL yang:
- Menerima 2 parameter: tahun (INT) dan bulan (INT)
- Mengembalikan result set: category_name, total_orders, total_revenue
- Hanya dari order berstatus 'PAID'
- Mengurutkan berdasarkan total_revenue DESC

Sertakan DROP PROCEDURE IF EXISTS sebelum CREATE.
```

### 6.3 Konversi query ke Laravel Eloquent / Query Builder

```
Konversi query SQL berikut ke Laravel Query Builder (bukan Eloquent Model):

SELECT
  c.name AS category_name,
  COUNT(DISTINCT o.id) AS total_orders,
  SUM(oi.subtotal) AS total_revenue
FROM categories c
LEFT JOIN products p ON p.category_id = c.id
LEFT JOIN order_items oi ON oi.product_id = p.id
LEFT JOIN orders o ON o.id = oi.order_id AND o.status = 'PAID'
WHERE MONTH(o.created_at) = ? AND YEAR(o.created_at) = ?
GROUP BY c.id, c.name
ORDER BY total_revenue DESC;

Gunakan DB::table(), join(), selectRaw(), groupBy(), dan parameter binding yang aman.
```

---

## Tips Penggunaan di Cursor

| Situasi | Mode yang dipakai |
|---|---|
| Query pendek (1–5 baris) | **Tab** — autocomplete saat mengetik |
| Tulis/modifikasi 1 query di file | **Cmd/Ctrl+K** di posisi kursor |
| Query kompleks butuh diskusi | **Chat** — tempel schema + tanya |
| Generate banyak query + file migrasi | **Agent** — beri scope folder yang jelas |

> **Ingat**: selalu review output query sebelum dijalankan — terutama UPDATE dan DELETE. Jalankan di environment development dulu, bukan langsung production.
