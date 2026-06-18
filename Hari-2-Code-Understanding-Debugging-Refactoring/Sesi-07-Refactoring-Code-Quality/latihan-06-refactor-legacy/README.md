# Latihan 06 — Refactor Legacy SQL: 5 Smelly Queries

> 🗺️ **Tahap 16–17 dari 20** | Sebelumnya: Sesi 6 Debugging | Setelah ini: Sesi 8 Testing

**Durasi**: 90 menit
**Tipe**: Hands-on individual

---

## Konteks

5 query di `sql-playground/queries/sesi-07-refactor/` adalah query **yang hasilnya BENAR** tetapi strukturnya bermasalah:

- Subquery 3 lapis untuk lookup sederhana
- Magic number tersebar di banyak tempat
- Pola JOIN diulang 3 kali di UNION ALL
- Window expression yang sama ditulis 4 kali
- SELECT * dari 5 tabel dengan nama kolom yang ambigu

Tugas Anda: **refactor tanpa mengubah hasil**. Aturan utama: output query baru harus **identik** dengan yang lama — baris, kolom, dan urutan harus sama persis.

---

## Tujuan

Setelah latihan, peserta mampu:

1. Mengenali code smell SQL yang umum (subquery bertingkat, logika duplikat, magic number).
2. Menerapkan pola refactoring SQL (CTE, named window, shared base, kolom eksplisit).
3. Memverifikasi bahwa hasil query tidak berubah menggunakan baseline dan query perbandingan.
4. Memberikan batasan yang jelas kepada AI agar tidak melakukan rewrite secara total.

---

## Prasyarat

- Latihan 04 & 05 selesai.
- Database `latihan_sql` masih tersedia (atau jalankan ulang `00_schema.sql` + `01_sample_data.sql`).
- Familiar dengan CTE (`WITH ... AS`) dan window function.

---

## Langkah Per Query

### A. Baseline (3')

1. Buka file query (contoh: `01_subquery_hell.sql`).
2. Jalankan apa adanya. **Simpan hasilnya**: screenshot atau ekspor ke CSV.
3. Catat: jumlah baris, jumlah kolom numerik utama, dan 3 baris pertama.

### B. Identifikasi Code Smell (2')

Baca bagian header file (smell biasanya sudah disebutkan), atau ajukan pertanyaan ke AI:

```
@file 01_subquery_hell.sql

Tanpa mengubah query, sebutkan semua code smell yang Anda temukan.
Urutkan dari yang paling berdampak hingga yang paling minor.
```

### C. Refactor dengan Batasan (8')

```
@file 01_subquery_hell.sql

Refactor query ini dengan aturan berikut:
1. Hasil HARUS identik (baris, kolom, dan urutan sama persis)
2. Target: gunakan CTE (WITH ... AS) — bukan subquery scalar
3. Tidak boleh mengubah klausa WHERE
4. Tidak boleh mengubah ORDER BY atau LIMIT
5. Tidak boleh menambah atau menghapus kolom output

Berikan:
- Query versi refactor
- 2 query verifikasi: COUNT(*) sebelum vs sesudah, SUM(...) kolom numerik utama
- 1 paragraf penjelasan mengapa versi baru lebih baik
```

### D. Verifikasi (3')

Jalankan query refactor dan query verifikasi dari langkah C. Pastikan:

- `COUNT(*) sebelum = COUNT(*) sesudah` ✅
- `SUM(...) sebelum = SUM(...) sesudah` ✅
- Spot-check 3 baris pertama identik

Apabila terdapat perbedaan → kembalikan ke versi semula, lalu prompt ulang dengan informasi yang lebih spesifik.

Ulangi A–D untuk setiap query.

---

## Tips Refactor Aman

| ✅ Lakukan | ❌ Hindari |
|-----------|-----------|
| Jalankan baseline terlebih dahulu, simpan outputnya | Refactor tanpa baseline |
| 1 code smell per commit | Refactor semua smell sekaligus |
| Gunakan diff tool (DBeaver Compare Result Sets) | Pengecekan manual saja |
| Uji edge case (NULL, 0 baris, banyak baris) | Hanya menguji kondisi normal |
| Berikan batasan eksplisit kepada AI | "Bersihkan query ini" (terlalu samar) |
| Backup file atau gunakan `git stash` sebelum mengedit | Mengedit langsung tanpa salinan |

---

## Common Issues

| Issue | Solusi |
|-------|--------|
| Refactor menggunakan LATERAL tetapi MySQL belum mendukung | Gunakan `JOIN (SELECT ... LIMIT 1) sub ON ...` sebagai solusi alternatif |
| `Window function not allowed in WHERE` | Bungkus dalam CTE: `WITH t AS (...) SELECT * FROM t WHERE rank = 1` |
| Hasil refactor berbeda 1 baris | Periksa `ORDER BY` — AI sering menghilangkan secondary sort key |
| AI menambahkan kolom yang tidak diminta | Tegaskan kembali batasan: "kolom output harus sama persis", tunjukkan perbedaannya |
