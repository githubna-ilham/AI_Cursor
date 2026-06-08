# Latihan 06 — Refactor Legacy SQL: 5 Smelly Queries

> 🗺️ **Tahap 16–17 dari 20** | Sebelumnya: Sesi 6 Debugging | Setelah ini: Sesi 8 Testing

**Durasi**: 90 menit
**Tipe**: Hands-on individual
**Output**: 5 file `submissions/<nama>/07_NN_<judul>.md` berisi before/after + bukti behaviour tidak berubah.

---

## Konteks

5 query di `sql-playground/queries/sesi-07-refactor/` adalah query **yang hasilnya BENAR** tapi strukturnya jelek:

- Subquery 3 lapis untuk lookup sederhana
- Magic numbers tersebar di banyak tempat
- Pola JOIN diulang 3x di UNION ALL
- Window expression yang sama ditulis 4x
- SELECT * dari 5 tabel dengan nama ambigu

Tugas Anda: **refactor tanpa mengubah behaviour**. Aturan utama: hasil query baru harus **identik** dengan yang lama (row, kolom, urutan).

---

## Tujuan

Setelah latihan, peserta mampu:

1. **Mengenali code smell SQL umum** (subquery hell, duplicate logic, magic, no DRY).
2. **Apply refactoring SQL pattern** (CTE, named window, shared base, eksplisit kolom).
3. **Verifikasi behaviour-preserving** dengan baseline + diff query.
4. **Memberi AI constraint** supaya tidak rewrite total.

---

## Prasyarat

- Latihan 04 & 05 selesai.
- Database `latihan_sql` masih ada (atau re-apply fresh).
- Familiar dengan CTE (`WITH ... AS`) dan window function.

---

## Langkah Per Query

### A. Baseline (3')

1. Buka file query (mis. `01_subquery_hell.sql`).
2. Run as-is. **Simpan hasil**: screenshot atau `EXPORT RESULT SET` di DBeaver → CSV.
3. Catat: jumlah baris, sum kolom numerik utama, 3 baris pertama.

### B. Identify Smell (2')

Baca header file (smell sudah disebut), atau prompt AI:

```
@file 01_subquery_hell.sql

Tanpa mengubah query, listing semua code smell yang kamu lihat.
Urut dari paling berdampak ke paling minor.
```

### C. Refactor dengan Constraint (8')

```
@file 01_subquery_hell.sql

Refactor query ini dengan constraint:
1. Behaviour HARUS identik (output baris, kolom, urutan sama persis)
2. Target style: CTE (WITH ... AS) — bukan subquery scalar
3. Tidak boleh ubah filter (WHERE clause)
4. Tidak boleh ubah ORDER BY atau LIMIT
5. Tidak boleh tambah/hapus kolom output

Berikan:
- Query versi refactor
- 2 query test untuk verifikasi: COUNT(*) before vs after, SUM(...)
  kolom numerik utama
- 1 paragraf: kenapa versi baru lebih baik
```

### D. Verifikasi (3')

Run query refactor + run query test dari point C. Pastikan:

- `COUNT(*) before = COUNT(*) after` ✅
- `SUM(...) before = SUM(...) after` ✅
- Spot-check 3 baris pertama identik

Kalau ada beda → rollback, prompt ulang dengan info lebih spesifik.

### E. Tulis Submission (4')

`submissions/<nama>/07_01_subquery_hell.md`:

````markdown
# Refactor 01 — Subquery Hell → CTE

**Smell utama**: 3 lapis subquery scalar untuk lookup tier
**Before** (15 lines):
```sql
<paste query lama>
```

**After** (8 lines):
```sql
<paste query refactor>
```

**Bukti behaviour identik**:
- COUNT before: 5 / after: 5 ✅
- SUM(total_spending) before: 4,250,000 / after: 4,250,000 ✅

**Kenapa lebih baik**: ...
````

Ulangi A–E untuk 5 query.

---

## Submit

`submissions/<nama>/`:
- 5 file `07_NN_<judul>.md` dengan before/after + bukti verifikasi
- `refleksi.md` (≤200 kata):
  - Refactor mana yang paling dramatis impact-nya?
  - 1 kali AI ubah behaviour secara tidak sengaja — apa yang Anda lakukan?
  - 1 SQL pattern (CTE/window/dst.) yang akan Anda pakai esok hari

---

## Tips Refactor Aman

| ✅ Lakukan | ❌ Hindari |
|-----------|-----------|
| Run baseline dulu, simpan output | Refactor tanpa baseline |
| 1 smell per commit | Refactor semua smell sekaligus |
| Pakai diff tool (DBeaver Compare Result Sets) | Spot check manual |
| Test edge case (NULL, 0 row, banyak row) | Test happy path saja |
| Beri AI constraint eksplisit | "Bersihkan query ini" (terlalu vague) |
| `git stash` atau backup file sebelum edit | Edit langsung, hilang versi asli |

---

## Common Issues

| Issue | Solusi |
|-------|--------|
| Refactor pakai LATERAL tapi MySQL belum support | Pakai `JOIN (SELECT ... LIMIT 1) sub ON ...` sebagai workaround |
| `Window function not allowed in WHERE` | Wrap di CTE: `WITH t AS (...) SELECT * FROM t WHERE rank = 1` |
| Hasil refactor beda 1 baris | Cek `ORDER BY` — AI sering hilangkan secondary sort key |
| AI tambah kolom yang tidak diminta | Restate constraint: "kolom output harus sama persis", tunjukkan diff |
