# Latihan 02 — Prompting Drill: SQL Dasar

> 🗺️ Bagian dari [Sesi 3 — Prompting & Context](../materi.md)
> Sebelumnya: Latihan 01 (Build Portfolio) di Sesi 2 | Setelah ini: Latihan 03 (SQL Lanjutan) di Sesi 4

**Durasi**: 60 menit (4 tahap × ~13 menit + review)
**Tipe**: Hands-on individual
**Output**: Query MySQL dasar (SELECT, INSERT, UPDATE, DELETE) yang Anda generate lewat Cursor dan verifikasi di SQL playground.

---

## Konteks

Sesi 3 mengajarkan cara menyusun prompt yang baik. Latihan ini melatih prompt dengan domain **SQL dasar** — mudah diverifikasi karena hasilnya jelas: query jalan atau tidak, hasilnya sesuai atau tidak.

Latihan ini adalah **Tahap 1–4**. Latihan 03 melanjutkan dengan query yang lebih kompleks (Tahap 5–8) menggunakan schema dan data yang sama persis.

---

## Schema & Data (MySQL 8.0)

**Paste SQL ini ke playground Anda sebelum mulai.** Playground yang bisa dipakai:
- [db-fiddle.com](https://www.db-fiddle.com) — pilih **MySQL 8.0** (rekomendasi, gratis, tanpa install)
- MySQL lokal via Laravel Herd + DBeaver / TablePlus

```sql
-- ==== SCHEMA ====
CREATE TABLE customers (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(120) UNIQUE NOT NULL,
  city VARCHAR(60),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products (
  id INT AUTO_INCREMENT PRIMARY KEY,
  sku VARCHAR(20) UNIQUE NOT NULL,
  name VARCHAR(120) NOT NULL,
  category VARCHAR(60),
  price DECIMAL(12,2) NOT NULL,
  stock INT DEFAULT 0
);

CREATE TABLE orders (
  id INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT,
  status VARCHAR(20) DEFAULT 'pending',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (customer_id) REFERENCES customers(id)
);

CREATE TABLE order_items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT,
  product_id INT,
  qty INT NOT NULL,
  unit_price DECIMAL(12,2) NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders(id),
  FOREIGN KEY (product_id) REFERENCES products(id)
);

-- ==== SAMPLE DATA ====
INSERT INTO customers (name, email, city) VALUES
  ('Andi',  'andi@x.com',  'Jakarta'),
  ('Budi',  'budi@x.com',  'Bandung'),
  ('Citra', 'citra@x.com', 'Jakarta'),
  ('Dewi',  'dewi@x.com',  'Surabaya'),
  ('Eka',   'eka@x.com',   'Jakarta');

INSERT INTO products (sku, name, category, price, stock) VALUES
  ('SKU-001', 'Mouse Wireless',   'Electronics', 150000, 50),
  ('SKU-002', 'Keyboard Mech',    'Electronics', 850000, 20),
  ('SKU-003', 'Notebook A5',      'Stationery',  35000,  200),
  ('SKU-004', 'Coffee Beans 1kg', 'Grocery',     180000, 30),
  ('SKU-005', 'USB Cable',        'Electronics', 45000,  100);

INSERT INTO orders (customer_id, status, created_at) VALUES
  (1, 'paid',      '2026-04-15'),
  (1, 'shipped',   '2026-05-02'),
  (2, 'paid',      '2026-05-10'),
  (3, 'paid',      '2026-05-12'),
  (3, 'cancelled', '2026-05-13'),
  (4, 'shipped',   '2026-06-01'),
  (5, 'pending',   '2026-06-05');

INSERT INTO order_items (order_id, product_id, qty, unit_price) VALUES
  (1, 1, 2, 150000), (1, 3, 5, 35000),
  (2, 2, 1, 850000),
  (3, 4, 3, 180000), (3, 5, 2, 45000),
  (4, 1, 1, 150000), (4, 2, 1, 850000),
  (6, 3, 10, 35000),
  (7, 4, 1, 180000);
```

---

## Tahap 1 — SELECT Dasar (15')

**Tujuan**: Generate query SELECT sederhana dengan filter, urutan, dan limit.

### 1.1 Buka Cursor Chat (`Cmd+L` / `Ctrl+L`)

Paste schema di atas ke chat terlebih dahulu agar AI tahu struktur tabel.

### 1.2 Prompt 1 — filter kota

```
Tulis query MySQL untuk menampilkan semua customer yang tinggal di Jakarta.
Output: id, name, email, city.
Urutkan berdasarkan name A–Z.

Tabel: customers (id, name, email, city, created_at)
```

**Verifikasi**: jalankan di playground — harus muncul 3 baris (Andi, Citra, Eka).

### 1.3 Prompt 2 — status dan limit

```
Tulis query MySQL untuk menampilkan 3 order terbaru yang statusnya 'paid' atau 'shipped'.
Output: id, customer_id, status, created_at.
Urutkan created_at terbaru dulu.

Tabel: orders (id, customer_id, status, created_at)
```

**Verifikasi**: harus muncul tepat 3 baris, semua berstatus paid atau shipped.

### 1.4 Prompt 3 — filter produk berdasarkan kategori

```
Tulis query MySQL untuk menampilkan semua produk dengan category = 'Electronics'
dan stock lebih dari 30.
Output: sku, name, price, stock.
Urutkan price dari termurah.

Tabel: products (id, sku, name, category, price, stock)
```

**Verifikasi**: periksa secara manual dari data sample — produk mana yang lolos filter ini?

---

## Tahap 2 — SELECT dengan JOIN (15')

**Tujuan**: Generate query yang menggabungkan dua tabel.

### 2.1 Prompt — daftar order beserta nama customer

```
Tulis query MySQL untuk menampilkan semua order beserta nama customer-nya.
Output: order.id, customer.name, customer.city, order.status, order.created_at.
Urutkan order.created_at terbaru dulu.

Tabel:
- orders (id, customer_id, status, created_at)
- customers (id, name, email, city)

Gunakan INNER JOIN.
```

**Verifikasi**: semua 7 order harus muncul dengan nama customer yang benar.

### 2.2 Iterasi — filter tambahan

Setelah dapat query di atas, lanjutkan di Chat yang sama:

```
Tambahkan filter: hanya tampilkan order dengan status = 'paid'.
Jangan ubah bagian lain dari query.
```

**Verifikasi**: harus muncul 3 baris (order id 1, 3, 4).

---

## Tahap 3 — INSERT dan UPDATE (15')

**Tujuan**: Generate query yang memodifikasi data dengan aman.

### 3.1 Prompt — INSERT produk baru

```
Tulis query MySQL untuk menambah produk baru ke tabel products:
- sku: 'SKU-006'
- name: 'Standing Desk Mat'
- category: 'Office'
- price: 320000
- stock: 15

Tabel: products (id, sku, name, category, price, stock)
Kolom id adalah AUTO_INCREMENT, jangan disertakan.
```

**Verifikasi**: jalankan INSERT, lalu SELECT * FROM products WHERE sku = 'SKU-006' — harus muncul 1 baris.

### 3.2 Prompt — UPDATE dengan WHERE spesifik

```
Tulis query MySQL untuk mengubah harga produk SKU-002 menjadi 900000
dan stock menjadi 25.

Tabel: products (id, sku, name, category, price, stock)
Gunakan WHERE sku = 'SKU-002' agar hanya 1 baris yang terupdate.
```

**Verifikasi**: setelah UPDATE, SELECT price, stock FROM products WHERE sku = 'SKU-002' harus mengembalikan 900000 dan 25.

---

## Tahap 4 — DELETE dengan SELECT Verifikasi (15')

**Tujuan**: Praktikkan pola aman: SELECT dulu, baru DELETE.

### 4.1 Prompt

```
Saya ingin menghapus semua order dengan status = 'cancelled'.
Tulis DUA query secara berurutan:
1. SELECT untuk melihat baris yang akan dihapus (id, customer_id, status, created_at)
2. DELETE untuk menghapus baris tersebut

Gunakan kondisi WHERE yang identik di kedua query.
Tambahkan komentar: "Jalankan SELECT dulu, verifikasi hasilnya, baru jalankan DELETE."

Tabel: orders (id, customer_id, status, created_at)
```

**Verifikasi**:
- Jalankan SELECT dulu → harus muncul 1 baris (order id 5, status cancelled).
- Setelah yakin benar, jalankan DELETE.
- SELECT ulang dengan kondisi yang sama → harus 0 baris.

---

## Tips

- **Sebut nama tabel dan kolom di prompt.** AI tidak tahu schema Anda kecuali Anda ceritakan.
- **Sebut dialect MySQL di prompt.** Sintaks MySQL beda dengan PostgreSQL (mis. `LIMIT` sama, tapi `DATE_FORMAT` vs `date_trunc`).
- **Selalu SELECT sebelum DELETE/UPDATE.** Ini kebiasaan yang harus terbentuk dari awal.
- **Verifikasi manual untuk data kecil.** Sample data ini kecil — Anda bisa hitung manual lebih cepat daripada debug.

---

## Common Issues

| Issue | Solusi |
|-------|--------|
| AI pakai PostgreSQL syntax | Tambahkan "MySQL 8.0" di prompt |
| Query hasil 0 baris | Cek WHERE filter — apakah case sensitive? Status pakai huruf kecil semua |
| AI tambah tabel yang tidak ada | Tambahkan constraint: "hanya pakai tabel yang saya sebutkan" |
| INSERT gagal karena constraint | Cek apakah SKU sudah ada (UNIQUE); cek foreign key |
| UPDATE kena semua baris | Pastikan WHERE ada — kalau AI lupa, minta ulang dengan "tambahkan WHERE spesifik" |
