# Perjalanan Hari 2 — Eksplorasi Codebase SQL

Hari 2 dirancang sebagai **satu perjalanan linear** dengan **satu codebase**: schema e-commerce mini di `sql-playground/` (9 tabel + ~150 row sample data + ~25 query). Tiap tahap memakai codebase ini dengan **"lensa berbeda"** untuk melatih skill yang berbeda.

**Anda TIDAK membangun project** seperti Hari 1. Anda **menerima** codebase yang sudah jadi (mensimulasikan kondisi nyata: developer baru join project).

---

## Filosofi

Realita developer profesional:
- **80% waktu** dihabiskan **memahami kode orang lain**, bukan menulis kode baru.
- Bug paling sering muncul di **edge case** yang AI saja tidak nangkap tanpa konteks.
- Refactor besar tanpa test = roulette.

Hari 2 melatih 4 skill ini di domain yang **universal**: SQL.

---

## Setup Sekali di Awal Hari 2

Sebelum Tahap 11, pastikan:

1. **MySQL Server 8.0+** terinstall & jalan (lihat materi Sesi 5).
2. **GUI client** tersedia: DBeaver / MySQL Workbench / Cursor Database Client.
3. **Apply schema**:
   ```sql
   -- jalankan di GUI:
   SOURCE sql-playground/00_schema.sql;
   SOURCE sql-playground/01_sample_data.sql;
   ```
   Atau copy-paste isi 2 file itu ke editor → run.
4. **Verifikasi**:
   ```sql
   USE latihan_sql;
   SHOW TABLES;
   -- expect 9 tabel
   ```

Kalau setup lulus, Anda siap mulai Tahap 11.

---

## 10 Tahap Hari 2 (Tahap 11–20)

### 🔍 Sesi 5 — Code Understanding (Lensa: "Saya Baru Join Project")

**Latihan 04** · `sql-playground/queries/sesi-05-explore/`

#### Tahap 11. Setup + Smoke Test Codebase
- Apply schema + sample data
- Verifikasi 9 tabel ada, sample count match
- Buka folder query di Cursor
- Smoke test: run 1 query random, pastikan editor + result panel jalan

#### Tahap 12. Eksplorasi 4–8 Query + Dokumentasi
- Baca header tiap query, terka logika dulu
- Pakai Cursor Chat (mode Ask) dengan @-mention file
- Generate docstring per query (TL;DR, asumsi bisnis, edge case)
- Generate ER diagram (Mermaid) untuk schema
- Tulis architecture note (≤300 kata)

**Output**: 4–8 docstring + ER + arsitektur, di `submissions/<nama>/`

---

### 🐛 Sesi 6 — Debugging (Lensa: "5 Bug Dilaporkan")

**Latihan 05** · `sql-playground/queries/sesi-06-debug/`

#### Tahap 13. Debug Bug 1 — JOIN Explosion (`01_inflated_revenue.sql`)
- Reproduce: total customer ~4.9jt, hand-count cuma 1.25jt
- Diagnose dengan AI (constraint: diagnose dulu, BUKAN fix langsung)
- Verifikasi hipotesis dengan query investigatif
- Apply fix minimal
- Pelajaran: cara AI bisa skip pertanyaan "kenapa" kalau diminta fix terlalu cepat

#### Tahap 14. Debug Bug 2 — NULL Trap (`02_customers_no_orders.sql`)
- Reproduce: query selalu return 0 baris
- Cari masalah NOT IN dengan NULL
- Fix dengan NOT EXISTS atau IS NOT NULL filter
- Pelajaran: NULL adalah "tiga-nilai logic" (true/false/unknown)

#### Tahap 15. Debug 3 Bug Lain (Pilih 3 dari 3 sisanya)
- `03_missing_jan_orders.sql` — BETWEEN DATE vs DATETIME
- `04_paid_or_refunded.sql` — operator precedence AND/OR
- `05_avg_review_per_product.sql` — INNER vs LEFT JOIN + missing WHERE
- Rotasi: kalau peserta cepat, kerjakan semua 5

**Output**: 5 file `submissions/<nama>/06_NN_<judul>.md` dengan diagnose, fix, verifikasi

---

### 🧹 Sesi 7 — Refactoring (Lensa: "Behaviour Benar, Struktur Jelek")

**Latihan 06** · `sql-playground/queries/sesi-07-refactor/`

#### Tahap 16. Refactor "Subquery Hell" + "Magic Numbers"
- `01_subquery_hell.sql` → CTE pattern (`WITH thresholds AS ...`)
- `02_magic_numbers.sql` → extract tier thresholds ke CTE constant
- Run baseline dulu, simpan output
- Verifikasi behaviour identik dengan COUNT + SUM compare

#### Tahap 17. Refactor 3 Sisanya (Pilih 2 dari 3)
- `03_duplicate_join.sql` → CTE shared + CASE WHEN aggregate
- `04_running_total_repeat.sql` → named window
- `05_select_star_wide.sql` → eksplisit kolom + alias jelas

**Output**: 5 file `07_NN_<judul>.md` dengan before/after + bukti behaviour identik

---

### 🧪 Sesi 8 — Testing (Lensa: "Belum Punya Regression Test")

**Latihan 07** · `sql-playground/queries/sesi-08-test/`

#### Tahap 18. Pahami + Run Existing Assertions
- Baca template assertion + contoh
- Run 10 assertion yang sudah ada — beberapa sengaja fail
- Diskusi: bug data atau bug assertion?

#### Tahap 19. Tulis 5 Assertion Baru
- Pilih 5 invariant business rule yang belum dicover
- Pakai AI dengan template prompt
- Test sendiri sebelum di-review (inject dummy row pelanggar)

#### Tahap 20. Validasi & Refleksi
- Test tiap assertion dengan inject dummy row pelanggar
- Pastikan assertion benar nangkap (tidak false positive/negative)
- Refleksi: kalau production, mana yang dijalankan harian vs mingguan

**Output**: 5 assertion baru + bukti validasi + refleksi

---

## Tracker Tahap

| Tahap | Sesi | Lensa | Output |
|-------|------|-------|--------|
| 11 | 5 | Setup | DB ready, smoke test pass |
| 12 | 5 | Understanding | 4–8 docstring + ER + arsitektur |
| 13 | 6 | Debug | Fix bug 1 (JOIN explosion) |
| 14 | 6 | Debug | Fix bug 2 (NULL trap) |
| 15 | 6 | Debug | Fix 3 bug lain |
| 16 | 7 | Refactor | CTE + thresholds extract |
| 17 | 7 | Refactor | 2 refactor lanjutan |
| 18 | 8 | Test | Run 10 assertion existing |
| 19 | 8 | Test | Tulis 5 assertion baru |
| 20 | 8 | Test | Validasi assertion dengan dummy data + refleksi |

---

## Kalau Anda Tertinggal

Hari 2 padat. Kalau di tengah jalan merasa tertinggal:

- **Sesi 5**: minimum 4 query dipahami, bukan 8. Sisa boleh di-skip.
- **Sesi 6**: minimum 2 bug di-fix. 3 sisa bisa dibahas group.
- **Sesi 7**: minimum 2 refactor. 3 sisa bisa skip.
- **Sesi 8**: minimum 3 assertion baru. Peer review tetap wajib.

Yang penting: keluar dari Hari 2 dengan **intuisi 4 skill** ini, bukan medali sempurna di semua tahap.

---

## Lanjut Hari 3

Hari 3 akan **bertukar role**: dari "menerima codebase" jadi "deliver fitur baru" dengan governance, security, dan workflow git profesional. Mengambil project capstone (boleh kembali ke domain sendiri).
