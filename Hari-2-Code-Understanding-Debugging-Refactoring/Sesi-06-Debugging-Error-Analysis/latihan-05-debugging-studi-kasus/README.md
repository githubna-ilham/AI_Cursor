# Latihan 05 — Debugging Studi Kasus: 5 Buggy SQL Queries

> 🗺️ **Tahap 13–15 dari 20** | Sebelumnya: Sesi 5 Code Understanding | Setelah ini: Sesi 7 Refactoring

**Durasi**: 90 menit
**Tipe**: Hands-on individual (boleh diskusi tetangga)
**Output**: 5 file `submissions/<nama>/06_NN_<judul>.md` berisi diagnose + fix + verifikasi.

---

## Konteks

5 query di `sql-playground/queries/sesi-06-debug/` adalah query production yang **dilaporkan QA / product owner**:

- Hasil tidak sesuai expectation
- Hilang baris yang harusnya muncul
- Inflasi angka yang tidak masuk akal
- Filter yang tidak bekerja

Tugas Anda: pakai AI sebagai **debugging partner** untuk diagnose + fix tanpa rewrite total.

---

## Tujuan

Setelah latihan, peserta mampu:

1. **Membedakan symptom vs penyebab** (banyak bug terlihat sama tapi root cause beda).
2. **Pakai AI untuk diagnose dulu**, bukan langsung minta fix (anti-pattern utama).
3. **Memverifikasi hipotesis** dengan query investigatif minimal.
4. **Menulis fix minimal** yang menyelesaikan bug tanpa mengubah behaviour lain.

---

## Prasyarat

- Latihan 04 selesai (familiar dengan schema 9 tabel).
- `latihan_sql` database ter-populate fresh (kalau ragu, re-apply `00_schema.sql` + `01_sample_data.sql`).

---

## Langkah Per Bug

Untuk **setiap 5 query** (idealnya semua), loop berikut:

### A. Reproduce (3')

1. Buka file query (mis. `01_inflated_revenue.sql`).
2. **Baca header `LAPORAN BUG`** — itu symptom yang harus Anda reproduce.
3. Run query as-is di MySQL. Catat hasil aktual.

### B. Diagnose dengan AI (5')

Pakai prompt **diagnose dulu, bukan fix langsung**:

```
Query berikut hasilnya salah. Symptom:
<paste isi header LAPORAN BUG>

Query:
<paste isi query>

Tugas kamu:
1. Diagnose: cari penyebab dalam 1-2 kalimat
2. Reproduce: query SELECT pendek (mis. SELECT COUNT(*) FROM ...)
   untuk membuktikan hipotesismu
3. JANGAN beri fix dulu

Saya akan minta fix di prompt berikutnya setelah saya yakin diagnose
benar.
```

### C. Verifikasi Diagnosis (3')

Run query investigatif yang AI sarankan di point 2. Pastikan hasilnya **konsisten** dengan hipotesis.

> ⚠️ Kalau hipotesis AI tidak terbukti, jangan langsung minta fix — minta AI re-diagnose dengan data baru.

### D. Fix (5')

Sekarang minta fix:

```
Hipotesismu benar (output investigatif sesuai). Sekarang:

1. Berikan query fix — ubah seminimal mungkin (jangan rewrite total)
2. Komentar 1 baris di atas baris yang diubah, format:
   -- FIX: <apa yang diubah & kenapa>
3. Query SELECT untuk verifikasi: bandingkan hasil sebelum & sesudah fix
```

### E. Tulis Submission (2')

`submissions/<nama>/06_01_inflated_revenue.md`:

```markdown
# Bug 01 — Inflated Revenue

**Symptom**: ...
**Root cause** (1 paragraf): ...
**Fix**:
\`\`\`sql
<query fix>
\`\`\`
**Verifikasi**: hasil before ~4.9jt → after 1.25jt ✅
**Pelajaran**: ...
```

Ulangi A–E untuk 5 bug.

---

## Submit

`submissions/<nama>/`:
- 5 file `06_NN_<judul>.md`
- `refleksi.md` (≤200 kata):
  - Bug mana paling sulit di-diagnose? Kenapa?
  - 1 kali AI memberi diagnose salah — bagaimana Anda tahu?
  - 1 pelajaran SQL yang Anda dapat dari bug-bug ini

---

## Tips Anti-Pattern

| ❌ Hindari | ✅ Lakukan |
|-----------|-----------|
| "Fix query ini" | "Diagnose dulu, baru fix" |
| Accept fix tanpa verify | Run query sebelum & sesudah, bandingkan output |
| Rewrite total query | Patch minimal — ubah baris yang salah saja |
| Cuma fix happy path | Test edge case lain (kosong, NULL, banyak baris) |
| Lupa save query asli | `git diff` atau backup file sebelum edit |

---

## Common Issues

| Issue | Solusi |
|-------|--------|
| AI fix berhasil tapi `count(*)` baseline tidak match | Mungkin AI ubah lebih dari yang seharusnya, baca diff baris per baris |
| Fix bekerja di sample data tapi rusak di edge case | Generate test case sendiri (mis. order dengan total = NULL) |
| Bug yang Anda fix muncul lagi setelah sample data direset | Itu artinya seeded bug — wajar. Fix di query, jangan di data. |
