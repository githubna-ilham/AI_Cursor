# Latihan 07 — Testing SQL: Assertion Queries

> 🗺️ **Tahap 18–20 dari 20** | Sebelumnya: Sesi 7 Refactoring | Setelah ini: Hari 3 (Advanced Workflow)

**Durasi**: 90 menit
**Tipe**: Hands-on individual

---

## Konteks

Database `latihan_sql` hingga sesi ini **belum memiliki satu pun regression test**. Pada Sesi 8, Anda akan:

1. Memahami pola assertion query (mengembalikan 0 baris = lolos).
2. Menjalankan 10 contoh assertion yang sudah tersedia — beberapa akan **gagal** karena data sample sengaja dibuat memiliki inkonsistensi.
3. **Menulis 5 assertion baru** untuk aturan bisnis yang belum tercakup.

---

## Tujuan

Setelah latihan, peserta mampu:

1. Memahami pola **assertion = SELECT yang mengembalikan 0 baris saat data valid**.
2. Mengonversi aturan bisnis (dalam bahasa Indonesia) menjadi SQL assertion.
3. Membedakan **bug data** dan **bug assertion** saat hasil tidak sesuai ekspektasi.

---

## Prasyarat

- Latihan 04, 05, 06 selesai.
- Database `latihan_sql` masih tersedia.

---

## Langkah

### 1. Pahami Pola Assertion (10')

Baca `sql-playground/queries/sesi-08-test/README.md` dan `00_template.sql`. Pahami:

- Konvensi: 0 baris = lolos, N baris = gagal
- Cara menghitung hasil otomatis menggunakan wrapper `SELECT COUNT(*) FROM (...)`

### 2. Jalankan 10 Assertion yang Sudah Ada (15')

Buka `sql-playground/queries/sesi-08-test/01_assertions_example.sql`. Jalankan setiap assertion satu per satu.

Beberapa assertion akan **gagal** — hal ini sudah direncanakan. Data sample sengaja memiliki inkonsistensi kecil. Diskusikan: apakah ini bug pada data, atau bug pada logika assertion?

### 3. Tulis 5 Assertion Baru (30')

Pilih **5 aturan bisnis** dari daftar di bawah (atau buat sendiri yang relevan dengan schema):

1. Order berstatus `cancelled` atau `refunded` tidak boleh memiliki shipment dengan status `delivered`.
2. Total `qty_change` bertipe `out` di `inventory_log` per produk harus sama dengan total `qty` di `order_items` untuk produk tersebut yang berstatus delivered.
3. `payments.status = 'success'` harus selalu disertai `paid_at IS NOT NULL`.
4. Customer dengan `tier = 'platinum'` harus memiliki total belanja 12 bulan terakhir minimal 2,5 juta.
5. Produk dengan `is_active = 0` tidak boleh memiliki order yang belum selesai.
6. Tidak ada order yang tidak memiliki minimal 1 baris di `order_items`.
7. Setiap `categories.parent_id` (apabila ada) harus merujuk ke kategori yang valid.
8. `reviews.created_at` harus lebih besar atau sama dengan `customers.created_at` — review tidak boleh dibuat sebelum customer mendaftar.

Gunakan template prompt berikut:

```
Tuliskan assertion query SQL untuk MySQL.

Konvensi: query SELECT yang mengembalikan 0 baris apabila aturan terpenuhi,
dan N baris (berisi id + kolom yang relevan) apabila terdapat pelanggar.

Schema: @file ../../sql-playground/00_schema.sql

Aturan bisnis yang perlu diperiksa:
"<paste aturan bisnis>"

Berikan:
1. Query SELECT assertion
2. Komentar 1 baris di atas query: deskripsi aturan
3. Contoh output apabila terdapat pelanggar (1-2 baris data dummy)
```

Jalankan semua assertion yang telah ditulis dan perhatikan hasilnya.

---

## Tips

- **Uji assertion sebelum digunakan** — sisipkan baris data yang sengaja melanggar aturan, pastikan assertion benar-benar mendeteksinya.
- **Utamakan kualitas**: lebih baik 3 assertion yang solid daripada 5 assertion yang tidak akurat.
- **Periksa data sample terlebih dahulu** sebelum menulis assertion — agar aturan yang dibuat realistis dengan kondisi data yang ada.

---

## Common Issues

| Issue | Solusi |
|-------|--------|
| Assertion lolos padahal ada bug pada data | Periksa logika — sering terjadi karena `WHERE x IS NULL` terlewat, atau `<>` tidak menangani NULL |
| Assertion gagal padahal data jelas valid | False positive — assertion terlalu ketat, periksa edge case pada aturan bisnis |
| Performa lambat pada tabel besar | Tambahkan index, atau materialize subquery menggunakan CTE |
| Sulit memformulasikan aturan bisnis ke dalam SQL | Pecah menjadi 2 langkah: rumuskan dalam bahasa Indonesia yang terstruktur terlebih dahulu, baru terjemahkan ke SQL |
