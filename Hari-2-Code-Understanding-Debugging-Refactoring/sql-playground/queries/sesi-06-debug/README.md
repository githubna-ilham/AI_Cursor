# Sesi 6 — Debugging (Buggy Queries)

5 query "production" yang **hasilnya salah**. Tugas Anda: cari penyebab + perbaiki dengan bantuan AI.

---

## Aturan Main

1. **Baca laporan bug** di header file query terlebih dahulu (bayangkan ini dari product owner / QA).
2. **Run query** as-is di MySQL → lihat hasil aktual vs hasil yang diharapkan.
3. Pakai Cursor Chat (mode **Ask** atau **Agent**) untuk debug:
   - Paste query + sebutkan symptom
   - Minta AI: "Cari penyebab. Jangan langsung fix — sebutkan dulu *kenapa* hasilnya seperti itu."
4. **Verifikasi** hipotesis AI dengan query investigatif (mis. `SELECT COUNT(*) FROM ...`).
5. **Tulis fix** + komentar 1 baris menjelaskan kesalahan asli.
6. Submit ke `submissions/<nama>/06_<nomor>_<judul>.md` berisi:
   - Diagnosis dalam 1 paragraf
   - Query setelah fix
   - Verifikasi (hasil sebelum vs sesudah)

---

## Daftar Bug

| # | File | Symptom | Domain Bug |
|---|------|---------|-----------|
| 01 | `01_inflated_revenue.sql` | Total customer ~4.9jt (8 order), hand-count cuma 1.25jt (2 order) | JOIN explosion |
| 02 | `02_customers_no_orders.sql` | Hasil selalu 0 baris, padahal data ada | NULL handling (`NOT IN`) |
| 03 | `03_missing_jan_orders.sql` | Order 25 Jan 15:30 tidak muncul di filter 1-31 Jan | DATE vs DATETIME pitfall |
| 04 | `04_paid_or_refunded.sql` | Hasil ikut `refunded` & `cancelled` | Operator precedence (`AND`/`OR`) |
| 05 | `05_avg_review_per_product.sql` | Produk tanpa review hilang + discontinued ikut tampil | JOIN type (INNER vs LEFT) + missing WHERE |

---

## Prompt Template untuk Debugging

```
Saya punya query SQL berikut yang hasilnya salah. Symptom:
<paste laporan bug dari header file>

Query:
<paste query>

Tugas kamu:
1. Diagnose: cari penyebab dalam 1-2 kalimat.
2. Reproduce: query SELECT pendek untuk membuktikan hipotesis kamu
   (mis. "select count(*) from ... where ..." untuk tunjukkan masalah).
3. Fix: query versi benar dengan komentar yang menjelaskan apa yang
   diubah.
4. Test: query SELECT untuk verifikasi fix bekerja.

Jangan beri fix dulu sebelum diagnose. Saya ingin paham kenapa, bukan
hanya hasilnya.
```

> 💡 **Tip**: AI sering "memperbaiki" tanpa benar-benar diagnose — output jadi query lain yang kebetulan benar, tapi peserta tidak belajar. Minta diagnose dulu, baru fix.

---

## Anti-Pola Saat Debug dengan AI

| ❌ Hindari | ✅ Lakukan |
|-----------|-----------|
| "Fix query ini" | "Diagnose dulu, baru fix" |
| Accept fix tanpa run | Selalu run di MySQL untuk verifikasi |
| Lupa cek edge case lain | Setelah fix, run query investigatif lain untuk pastikan tidak break case lain |
| Reset semua dan rewrite | Patch minimal — ubah baris yang salah saja, jangan rewrite total |

---

Lanjut: Sesi 7 (Refactoring) di folder `queries/sesi-07-refactor/`.
