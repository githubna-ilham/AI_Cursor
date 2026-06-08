# SQL Playground — E-Commerce Mini

> Bahan latihan **Hari 2** pelatihan AI Cursor. Schema ini dipakai di 4 sesi (Code Understanding, Debugging, Refactoring, Testing) — semuanya tentang **SQL**, bukan kode aplikasi.

---

## Apa Ini

Schema database e-commerce sederhana (9 tabel) + sample data realistic. **Anda akan menerima** schema ini dan beberapa query yang sudah ditulis "orang lain" — tugas Anda di Hari 2:

| Sesi | Lensa |
|------|-------|
| **5 — Code Understanding** | Pahami query yang Anda baru lihat pertama kali (CTE, window function, multi-join) |
| **6 — Debugging** | 5 query bermasalah (hasil salah / lambat). Cari sebabnya |
| **7 — Refactoring** | 5 query benar tapi *smelly* (subquery hell, magic, duplicate). Refactor |
| **8 — Testing** | Tulis assertion query untuk validasi data integrity |

Tidak ada aplikasi Next.js/React/dll. **Murni SQL** — pakai DBeaver / MySQL Workbench / Cursor extension untuk menulis & jalankan.

---

## Prasyarat

| Tool | Versi | Cara cek |
|------|-------|----------|
| **MySQL Server** | 8.0+ (atau MariaDB 10.5+) | `mysql --version` |
| **GUI Client** | DBeaver / Workbench / Cursor extension | — |

Kalau belum install, lihat instruksi setup di materi Sesi 5.

---

## Setup (5 menit)

### 1. Buat Database

Di GUI client (DBeaver/Workbench/Cursor), connect ke MySQL Anda, lalu jalankan:

```sql
CREATE DATABASE IF NOT EXISTS latihan_sql
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE latihan_sql;
```

### 2. Apply Schema

Buka file `00_schema.sql` → copy seluruh isi → paste ke editor → jalankan **semua** (biasanya tombol "Execute All" atau `Cmd+Shift+Enter`).

Verifikasi:
```sql
SHOW TABLES;
```
Harus muncul **9 tabel**: `categories, customers, products, orders, order_items, reviews, payments, shipments, inventory_log`.

### 3. Load Sample Data

Buka file `01_sample_data.sql` → paste → jalankan semua.

Verifikasi cepat:
```sql
SELECT 'customers' AS t, COUNT(*) AS n FROM customers
UNION ALL SELECT 'products',    COUNT(*) FROM products
UNION ALL SELECT 'orders',      COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL SELECT 'reviews',     COUNT(*) FROM reviews
UNION ALL SELECT 'payments',    COUNT(*) FROM payments
UNION ALL SELECT 'shipments',   COUNT(*) FROM shipments;
```

Hasil sekitar:

| Tabel | Count |
|-------|-------|
| categories | 7 |
| customers | 12 |
| products | 15 |
| orders | 26 |
| order_items | ~43 |
| reviews | 15 |
| payments | 28 |
| shipments | 23 |

Kalau angkanya beda jauh, ulangi langkah 2-3.

---

## Struktur Schema

```
                    ┌─────────────┐
                    │ categories  │◄────┐ (self-ref parent_id)
                    └──────┬──────┘     │
                           │            │
                           │  N:1       │
                           │            │
┌──────────────┐    ┌──────▼──────┐    ┌──────────────┐
│  customers   │    │  products   │    │ inventory_   │
└──────┬───────┘    └──────┬──────┘    │   log        │
       │                   │            └──────────────┘
       │ 1:N               │ 1:N
       │                   │
       ▼                   │
┌──────────────┐           │
│   orders     │           │
└──────┬───────┘           │
       │ 1:N               │
       ▼                   │
┌──────────────┐    ┌─────▼────────┐
│ order_items  │───►│   (via       │
└──────────────┘    │  product_id) │
       │            └──────────────┘
       │ 1:N (per order)
       ▼
┌──────────────┐  ┌──────────────┐
│  payments    │  │  shipments   │
└──────────────┘  └──────────────┘

reviews:  customer_id N─1, product_id N─1 (unique pair)
```

Lihat `00_schema.sql` untuk detail kolom, index, dan foreign key.

---

## Struktur Folder

```
sql-playground/
├── README.md                   ← file ini
├── 00_schema.sql               ← DDL (CREATE TABLE × 9)
├── 01_sample_data.sql          ← INSERT data
└── queries/
    ├── sesi-05-explore/        ← 8 query untuk dipahami (Sesi 5)
    ├── sesi-06-debug/          ← 5 query bermasalah (Sesi 6)
    ├── sesi-07-refactor/       ← 5 query smelly (Sesi 7)
    └── sesi-08-test/           ← Template assertion (Sesi 8)
```

Folder `queries/` akan diisi bertahap sesuai sesi.

---

## Tips

- **Jangan modifikasi `00_schema.sql` & `01_sample_data.sql`** — itu fondasi yang semua peserta share. Kalau Anda mau eksperimen schema, bikin database baru.
- **Backup database sebelum mulai Sesi 7 (Refactoring)** — kalau refactor melenceng, restore cepat dengan re-run `00_schema.sql` + `01_sample_data.sql`.
- **Pakai `EXPLAIN`** sebelum tanya AI kenapa query lambat. Banyak case bisa terjawab dari `EXPLAIN` saja tanpa AI.

---

## Reset Database

Kalau perlu mulai bersih (mis. data ter-corrupt karena eksperimen UPDATE):

```sql
DROP DATABASE latihan_sql;
CREATE DATABASE latihan_sql CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE latihan_sql;
-- lalu run 00_schema.sql + 01_sample_data.sql lagi
```
