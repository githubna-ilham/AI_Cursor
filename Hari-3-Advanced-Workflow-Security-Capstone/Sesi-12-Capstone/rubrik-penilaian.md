# Rubrik Penilaian Capstone

**Total bobot**: 100%
**Skala per dimensi**: 1 (Kurang) — 2 (Cukup) — 3 (Baik) — 4 (Sangat Baik)
**Skor akhir**: rata-rata tertimbang dari 4 dimensi.

---

## Ringkasan Bobot

| Dimensi | Bobot | Fokus |
|---------|-------|-------|
| 1. Functionality | 30% | Apakah solusi berjalan & memenuhi requirement? |
| 2. AI Utilization | 30% | Sejauh mana AI dipakai dengan cerdas, bukan buta? |
| 3. Code Quality | 20% | Apakah kode bersih, teruji, aman? |
| 4. Presentation | 20% | Apakah cerita disampaikan jelas & meyakinkan? |

---

## Dimensi 1 — Functionality (30%)

| Level | Skor | Deskriptor |
|-------|------|------------|
| Kurang | 1 | Solusi tidak berjalan atau requirement utama tidak terpenuhi. Demo gagal tanpa fallback. |
| Cukup | 2 | Happy path jalan. Satu atau dua requirement utama hilang. Edge case belum ditangani. |
| Baik | 3 | Semua requirement utama terpenuhi. Edge case umum ditangani. CI hijau. |
| Sangat Baik | 4 | Semua requirement + minimal 1 bonus (resilience, observability, perf benchmark). Demo mulus. |

**Indikator objektif**:
- Demo selesai tanpa intervensi mendadak.
- CI workflow hijau.
- README cukup untuk reviewer menjalankan ulang.

---

## Dimensi 2 — AI Utilization (30%)

| Level | Skor | Deskriptor |
|-------|------|------------|
| Kurang | 1 | AI hanya dipakai sebagai autocomplete sederhana. Tidak ada bukti prompt terencana. Atau, AI dipakai tetapi output diterima mentah tanpa koreksi (terlihat dari bug naif). |
| Cukup | 2 | AI dipakai di 2–3 tahap (mis. generate + test). Tidak ada refleksi sadar. |
| Baik | 3 | AI dipakai di 4+ tahap (sesuai brief). Tim dapat menunjukkan prompt kunci & koreksi yang dilakukan. |
| Sangat Baik | 4 | Pemakaian AI strategis & terdokumentasi. Tim secara eksplisit menyebut bagian yang AI **tidak** dipakai dan alasannya. Ada prompt library / rules file yang berkualitas. |

**Indikator objektif**:
- Slide 5 (AI Techniques) terisi konkret, bukan generic.
- `.cursorrules` ada & relevan.
- Tim bisa jawab "kapan AI bukan jawabannya?".

---

## Dimensi 3 — Code Quality (20%)

| Level | Skor | Deskriptor |
|-------|------|------------|
| Kurang | 1 | Struktur kacau, tanpa tes, ada credential hardcoded atau secret leak. |
| Cukup | 2 | Struktur cukup mengikuti konvensi stack. Test minimal (< 30% coverage pada modul utama). Tidak ada secret leak yang terlihat. |
| Baik | 3 | Struktur jelas (lapisan, naming konsisten). Test bermakna untuk happy + sebagian edge. Tidak ada warning lint serius. `.cursorignore` & secret scan aktif. |
| Sangat Baik | 4 | Lapisan jelas + dokumentasi inline tepat. Test menanggap edge case real. CI multi-stage. Ada ADR singkat. Resilience pattern dimana relevan. |

**Indikator objektif**:
- `npm test` / `pytest` jalan & hijau.
- Lint pass.
- Tidak ada `.env*` ter-commit.
- Commit history bermakna (bukan satu commit "final").

---

## Dimensi 4 — Presentation (20%)

| Level | Skor | Deskriptor |
|-------|------|------------|
| Kurang | 1 | Tidak terstruktur, demo gagal tanpa cadangan, tim tidak bisa menjawab pertanyaan dasar. |
| Cukup | 2 | Struktur mengikuti template, namun cerita kurang. Demo selesai tetapi terburu-buru. Jawaban Q&A umum saja. |
| Baik | 3 | Cerita jelas: problem → solusi → demo → AI → lesson. Demo mulus. Jawaban Q&A spesifik. Semua anggota berbicara. |
| Sangat Baik | 4 | Cerita memikat, fokus pada *insight* bukan fitur. Demo profesional dengan fallback. Q&A dijawab dengan konteks teknis & bisnis. Slide bersih, mudah dibaca. |

**Indikator objektif**:
- Selesai dalam ≤ 7 menit.
- Setiap anggota berkontribusi minimal 30 detik.
- Demo punya fallback (video/screenshot).
- Pertanyaan juri dijawab spesifik, bukan "kami akan pertimbangkan".

---

## Kartu Skor (Template untuk Juri)

```
Tim         : ____________________
Opsi proyek : ____________________

[ ] Functionality   : __ / 4   × 30% = ____
[ ] AI Utilization  : __ / 4   × 30% = ____
[ ] Code Quality    : __ / 4   × 20% = ____
[ ] Presentation    : __ / 4   × 20% = ____

Total: ____ / 4.00

Catatan kualitatif:
- Kekuatan utama   : 
- Area perbaikan   : 
- Apresiasi khusus : 
```

---

## Klasifikasi Akhir

| Total Skor | Klasifikasi |
|------------|-------------|
| 3.50 – 4.00 | **Distinguished** — pantas dijadikan studi kasus internal |
| 2.75 – 3.49 | **Proficient** — siap pakai di tim, dengan polishing kecil |
| 2.00 – 2.74 | **Developing** — fondasi ada, butuh latihan lanjutan |
| < 2.00 | **Needs Support** — rekomendasi reinforcement |

---

## Catatan untuk Fasilitator

- Beri **feedback tertulis tiap tim** sebelum penutupan hari.
- Sampaikan skor secara **konstruktif**, bukan kompetitif — capstone bukan turnamen.
- Identifikasi 1–2 tim yang **layak diundang sharing** ke kelas berikutnya.
- Simpan rubrik terisi untuk **laporan post-training** ke Multimatics.
