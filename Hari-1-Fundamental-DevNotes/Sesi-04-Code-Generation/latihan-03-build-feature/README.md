# Latihan 03 — SQL Lanjutan: Agregasi, Multi-JOIN, dan Query Aman

> 🗺️ Bagian dari [Sesi 4 — Code Generation untuk SQL](../materi.md)
> Sebelumnya: Latihan 02 (SQL Dasar, Tahap 1–4) | Setelah ini: Akhir Hari 1

**Durasi**: 60 menit (4 tahap × ~13 menit + review)
**Tipe**: Hands-on individual
**Output**: Query MySQL lebih kompleks — agregasi, multi-JOIN, CTE, dan pola UPDATE/DELETE yang aman.

---

## Konteks

Latihan ini **melanjutkan langsung dari Latihan 02**. Schema dan data yang dipakai **sama persis** — Anda tidak perlu buat ulang kalau masih di session playground yang sama.

Kalau membuka sesi baru, paste ulang schema dari [Latihan 02](../../Sesi-03-Prompting-Context/latihan-02-prompting-drill/README.md#schema--data-mysql-80) ke playground sebelum mulai.

---

## Tahap 5 — Agregasi: GROUP BY, SUM, COUNT (15')

**Tujuan**: Generate query yang meringkas data — dasar laporan bisnis.

### 5.1 Prompt — total order per status

```
Tulis query MySQL untuk menghitung jumlah order per status.
Output: status, jumlah_order (COUNT).
Urutkan jumlah_order terbesar dulu.

Tabel: orders (id, customer_id, status, created_at)
```

**Verifikasi**: totalkan dari data sample — apakah angka per status cocok?

### 5.2 Prompt — total revenue per customer

```
Tulis query MySQL untuk menghitung total belanja (revenue) setiap customer.
Revenue dihitung dari qty * unit_price di tabel order_items.
Hanya hitung order dengan status 'paid' atau 'shipped'.

Output: customer.name, total_revenue (SUM qty * unit_price).
Urutkan total_revenue terbesar dulu.

Tabel:
- customers (id, name)
- orders (id, customer_id, status)
- order_items (id, order_id, product_id, qty, unit_price)

Gunakan GROUP BY customers.id.
```

**Verifikasi**: hitung manual untuk Andi (customer_id=1) — order 1 (paid) dan order 2 (shipped) keduanya masuk. Apakah angka AI cocok?

### 5.3 Iterasi — tambah filter HAVING

Lanjutkan di Chat yang sama:

```
Tambahkan filter: hanya tampilkan customer yang total_revenue-nya
lebih dari 500000.
Gunakan HAVING, bukan WHERE.
```

**Verifikasi**: berapa customer yang lolos? Cek manual dari hasil Tahap 5.2.

---

## Tahap 6 — Multi-JOIN: 3+ Tabel (15')

**Tujuan**: Generate query yang menggabungkan 3 atau 4 tabel sekaligus.

### 6.1 Prompt — detail order lengkap

```
Tulis query MySQL untuk menampilkan detail setiap item order beserta:
- nama customer
- nama produk
- kategori produk
- qty dan unit_price
- subtotal (qty * unit_price)
- status order

Hanya tampilkan order dengan status 'paid' atau 'shipped'.
Urutkan berdasarkan order_id, lalu product_id.

Tabel:
- customers (id, name)
- orders (id, customer_id, status)
- order_items (id, order_id, product_id, qty, unit_price)
- products (id, name, category)

Gunakan alias tabel (c, o, oi, p) agar query lebih ringkas.
```

**Verifikasi**:
- Hitung manual: berapa baris yang harusnya muncul? (hitung order_items yang order-nya paid/shipped)
- Apakah subtotal setiap baris benar? Cek beberapa baris secara manual.

### 6.2 Prompt — produk yang belum pernah dipesan

```
Tulis query MySQL untuk menampilkan produk yang BELUM PERNAH ada di order_items.
Output: sku, name, category, stock.

Tabel:
- products (id, sku, name, category, stock)
- order_items (product_id)

Gunakan LEFT JOIN dan filter WHERE order_items.product_id IS NULL.
```

**Verifikasi**: dari 5 produk di sample data, produk mana yang tidak ada di order_items sama sekali? Cek manual.

---

## Tahap 7 — CTE: WITH Clause (15')

**Tujuan**: Generate query dengan CTE untuk memecah logika kompleks jadi bagian yang lebih mudah dibaca.

### 7.1 Prompt — top 3 customer berdasarkan total belanja

```
Tulis query MySQL menggunakan CTE (WITH clause) untuk menemukan
top 3 customer dengan total belanja terbesar sepanjang waktu.

Langkah:
1. CTE pertama (customer_spending): hitung total_revenue per customer_id
   dari order_items JOIN orders, hanya status 'paid' atau 'shipped'
2. Query utama: JOIN customer_spending ke tabel customers,
   ambil 3 teratas ORDER BY total_revenue DESC LIMIT 3

Output: customer.name, customer.city, total_revenue

Tabel:
- customers (id, name, city)
- orders (id, customer_id, status)
- order_items (order_id, qty, unit_price)
```

**Verifikasi**: hasilnya harus konsisten dengan Tahap 5.2. Apakah top 3 sama?

### 7.2 Prompt — iterasi tambah kolom

Lanjutkan di Chat yang sama:

```
Tambahkan kolom jumlah_order (COUNT DISTINCT order_id) ke dalam CTE customer_spending,
lalu tampilkan juga di query utama.
Jangan ubah logika filter dan urutan.
```

**Verifikasi**: apakah jumlah order setiap customer cocok dengan data sample?

---

## Tahap 8 — UPDATE/DELETE Aman: SELECT Dulu, Aksi Kemudian (15')

**Tujuan**: Praktikkan pola paling penting untuk query destruktif — verifikasi sebelum eksekusi.

### 8.1 Prompt — UPDATE stok produk Electronics

```
Saya ingin menambah stok sebesar 10 untuk semua produk dengan category = 'Electronics'.

Tulis TIGA query berurutan:
1. SELECT — tampilkan produk Electronics yang akan terpengaruh (id, sku, name, stock sekarang)
2. UPDATE — tambah stock = stock + 10 untuk produk tersebut
3. SELECT — verifikasi hasilnya (id, sku, name, stock setelah update)

Kondisi WHERE harus identik di semua query.
Tambahkan komentar langkah di setiap query.

Tabel: products (id, sku, name, category, stock)
```

**Cara jalankan**:
1. Jalankan query SELECT (#1) — catat produk dan stok awal.
2. Verifikasi: ada 3 produk Electronics (SKU-001, SKU-002, SKU-005).
3. Jalankan UPDATE (#2).
4. Jalankan SELECT verifikasi (#3) — stok semua sudah bertambah 10.

### 8.2 Prompt — soft delete order lama

```
Saya ingin menandai order lama sebagai tidak aktif (soft delete).
Definisi "lama": order dengan status 'cancelled' atau created_at sebelum 2026-05-01.

Tulis DUA query:
1. SELECT — tampilkan order yang akan terdampak (id, customer_id, status, created_at)
2. UPDATE — set status = 'archived' untuk order tersebut

Gunakan kondisi WHERE yang sama persis di kedua query.
Tambahkan komentar: "Verifikasi SELECT sebelum menjalankan UPDATE."

Tabel: orders (id, customer_id, status, created_at)
```

**Verifikasi**:
- Dari data sample, order mana yang created_at sebelum 2026-05-01 atau statusnya cancelled?
- Apakah AI menggunakan `OR` atau `AND`? Mana yang benar untuk kebutuhan di atas?

---

## Tips

- **Pecah query kompleks jadi CTE.** Lebih mudah di-review dan di-debug — Latihan 02 tidak butuh CTE, tapi Tahap 7 menunjukkan kapan CTE berguna.
- **Verifikasi multi-JOIN dengan hand-count.** Data sample kita kecil — hitung manual lebih cepat daripada percaya langsung ke output AI.
- **Pola 3 query (SELECT → aksi → SELECT verifikasi)** adalah kebiasaan yang wajib dibawa ke production.
- **AI sering salah di HAVING vs WHERE.** HAVING untuk filter setelah agregasi, WHERE untuk filter sebelum GROUP BY.

---

## Common Issues

| Issue | Solusi |
|-------|--------|
| CTE tidak dikenali (syntax error) | Pastikan playground pakai MySQL 8.0 — CTE (WITH) tidak tersedia di MySQL 5.7 |
| GROUP BY error karena kolom tidak di-aggregate | Tambahkan semua kolom non-agregat ke GROUP BY |
| LEFT JOIN menghasilkan NULL di kolom kanan | Ini normal untuk produk yang tidak ada di order_items — gunakan filter IS NULL untuk mencarinya |
| HAVING vs WHERE tertukar | AI kadang pakai WHERE untuk filter agregasi — minta koreksi eksplisit |
| UPDATE kena lebih banyak baris dari harapan | Jalankan SELECT dulu dengan WHERE yang sama, hitung baris yang muncul |
| Soft delete mengubah terlalu banyak order | Cek kondisi OR vs AND di WHERE — pastikan logikanya sesuai kebutuhan |
