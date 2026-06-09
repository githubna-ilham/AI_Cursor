# Latihan 07 — Testing SQL: Assertion Queries

> 🗺️ **Tahap 18–20 dari 20** | Sebelumnya: Sesi 7 Refactoring | Setelah ini: Hari 3 (Advanced Workflow)

**Durasi**: 90 menit
**Tipe**: Hands-on individual
**Output**: 5 assertion baru + refleksi.

---

## Konteks

Database `latihan_sql` sampai sini **tidak punya satu pun regression test**. Anda di Sesi 8 akan:

1. Memahami pola assertion query dbt-style (return 0 baris = pass).
2. Run 10 contoh assertion yang sudah ada — beberapa akan **fail** (data sample sengaja ada mismatch).
3. **Tulis 5 assertion baru** untuk invariant yang belum dicover.

---

## Tujuan

Setelah latihan, peserta mampu:

1. Memahami pola **assertion = SELECT yang return 0 baris saat pass**.
2. **Mengonversi business rule** (bahasa Indonesia) jadi SQL assertion.
3. **Membedakan bug data vs bug assertion** saat test fail.

---

## Prasyarat

- Latihan 04, 05, 06 selesai.
- Database `latihan_sql` masih ada.

---

## Langkah

### 1. Pahami Pola Assertion (10')

Baca `sql-playground/queries/sesi-08-test/README.md` + `00_template.sql`. Pahami:

- Konvensi: 0 baris = pass, N baris = fail
- Cara hitung pass otomatis dengan wrapper `select count(*) from (...)`

### 2. Run 10 Assertion Existing (15')

Buka `sql-playground/queries/sesi-08-test/01_assertions_example.sql`. Jalankan 10 assertion satu-satu.

Catat di `submissions/<nama>/08_test_results.md`:

| # | Assertion | Hasil (rows) | Pass/Fail | Catatan |
|---|-----------|--------------|-----------|---------|
| T1 | subtotal = sum line_total | 5 baris | FAIL | Data sample sengaja mismatch |
| T2 | total = subtotal - discount | 0 | PASS | |
| ... | | | | |

Beberapa **akan fail** — ini **expected**. Sample data sengaja ada subtle mismatch. Diskusikan: ini bug data atau bug assertion?

### 3. Tulis 5 Assertion Baru (30')

Pilih **5 invariant** dari list di bawah (atau buat sendiri yang relevan):

1. Order yang `cancelled`/`refunded` tidak boleh punya shipment `delivered`.
2. Total `qty_change` `out` di `inventory_log` per produk = total `qty` di `order_items` produk itu (yang ber-status delivered).
3. `payments.status='success'` harus selalu punya `paid_at IS NOT NULL`.
4. Customer `tier='platinum'` harus punya spending 12-mo ≥ 2.5jt.
5. Produk `is_active=0` tidak boleh punya order belum delivered.
6. Tidak ada order tanpa minimal 1 `order_items`.
7. Setiap `categories.parent_id` (kalau ada) harus point ke kategori valid.
8. `reviews.created_at` harus >= `customer.created_at` (review tidak boleh sebelum customer signup).

Pakai prompt template:

```
Bantu tulis assertion query SQL untuk MySQL.

Konvensi: query SELECT yang return 0 baris saat invariant terpenuhi,
N baris (id + kolom relevant) saat ada pelanggar.

Schema: @file ../../sql-playground/00_schema.sql

Invariant yang harus di-cek:
"<paste invariant>"

Output:
1. Query SELECT
2. Komentar 1 baris di atas: deskripsi invariant
3. Sample output saat ada pelanggar (1-2 baris contoh)
```

Simpan ke `submissions/<nama>/08_my_assertions.sql` (5 query).

Run semua. Catat hasil di `08_test_results.md` (lanjut tabel dari step 2).

### 4. Refleksi (5')

`submissions/<nama>/refleksi.md` (≤200 kata):

- Invariant mana paling sulit di-encode ke SQL?
- Kalau project ini production, assertion mana yang akan Anda jalankan **harian** vs **mingguan**?
- 1 pelajaran SQL yang Anda dapat dari latihan ini.

---

## Submit

`submissions/<nama>/`:
- `08_test_results.md` (tabel hasil 10 existing + 5 baru)
- `08_my_assertions.sql` (5 assertion baru Anda)
- `refleksi.md`

---

## Tips

- **Tes assertion sendiri sebelum di-review** — masukkan dummy row yang melanggar, pastikan assertion benar-benar nangkap.
- **Pelan-pelan**: lebih baik 3 assertion solid daripada 5 assertion vague.
- **Lihat sample data dulu** sebelum write assertion — biar tidak buat invariant yang tidak realistis.

---

## Common Issues

| Issue | Solusi |
|-------|--------|
| Assertion pass padahal ada bug data | Cek logika — sering `WHERE x IS NULL` lupa, atau `<>` lupa handle NULL |
| Assertion fail tapi data jelas valid | False positive — assertion terlalu strict, cek edge case business rule |
| Performance lambat di tabel besar | Tambah index, atau materialize subquery dengan CTE |
| Sulit nulis invariant ke SQL | Pecah jadi 2 langkah: bahasa Indonesia terstruktur → SQL |
