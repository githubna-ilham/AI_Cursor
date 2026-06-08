# Sesi 7 — Refactoring (Smelly Queries)

5 query yang **hasilnya benar** tapi strukturnya jelek. Tugas Anda: refactor dengan bantuan AI tanpa mengubah behaviour.

---

## Aturan Main

1. **Run query asli dulu** → catat / screenshot hasilnya (jadi *baseline behaviour*).
2. Pakai Cursor Chat / Cmd+K untuk refactor:
   - Sebutkan smell yang Anda lihat (atau minta AI list smell-nya dulu)
   - Minta refactor versi (pakai CTE, named window, dst.)
   - **Wajib**: minta AI confirm behaviour tetap sama
3. **Run versi refactor** → bandingkan hasil dengan baseline.
4. **Komparasi readability**: hitung baris kode, hitung level nesting, baca lagi 1 menit kemudian — apakah Anda masih paham?
5. Submit ke `submissions/<nama>/07_<nomor>_<judul>.md` berisi:
   - Smell yang teridentifikasi
   - Query before vs after
   - Bukti behaviour tidak berubah (output sama)
   - 1 kalimat: kenapa versi baru lebih baik

---

## Daftar Smell

| # | File | Smell Utama | Target Refactor |
|---|------|-------------|------------------|
| 01 | `01_subquery_hell.sql` | 3 lapis subquery scalar nested | Pakai CTE (WITH ... AS) |
| 02 | `02_magic_numbers.sql` | Threshold tier 5jt/2.5jt/1jt tersebar 8 tempat | CTE `thresholds` 1 baris per tier |
| 03 | `03_duplicate_join.sql` | JOIN base sama diulang 3x di UNION ALL | CTE shared + aggregate dengan CASE WHEN |
| 04 | `04_running_total_repeat.sql` | Window expr `partition by c.id order by month` 4x | Named window `WINDOW w AS (...)` |
| 05 | `05_select_star_wide.sql` | SELECT * 5 tabel + nama ambigu + subquery scalar | Eksplisit kolom + alias jelas + LATERAL/window |

---

## Prompt Template untuk Refactor

```
@file 01_subquery_hell.sql

Saya mau refactor query ini. Behaviour HARUS tetap sama (output baris
& kolom identik). Smell yang saya lihat:
- Subquery 3 lapis untuk sekedar lookup tier

Tugas kamu:
1. List semua smell yang kamu lihat (boleh lebih dari yang saya sebut)
2. Refactor jadi CTE — gunakan WITH ... AS pattern
3. Berikan query versi baru
4. Berikan query test untuk konfirmasi behaviour sama:
   - Bandingkan COUNT(*) before vs after
   - Bandingkan SUM(...) untuk kolom numerik
5. Komentar 1 paragraf: kenapa versi baru lebih baik

Jangan ubah filter atau urutan output.
```

---

## Aturan Refactor Aman

| ✅ Lakukan | ❌ Hindari |
|-----------|-----------|
| Run baseline dulu, simpan output | Refactor tanpa baseline |
| 1 smell per commit | Refactor semua smell sekaligus |
| Pakai diff tool (DBeaver: Tools → Compare Result Set) | Compare manual hanya beberapa baris |
| Test edge case (NULL, 0 row, banyak row) | Test happy path saja |
| Beri AI constraint "tidak boleh ubah filter" | "Bersihkan query ini" (terlalu vague) |

---

Lanjut: Sesi 8 (Testing) di folder `queries/sesi-08-test/`.
