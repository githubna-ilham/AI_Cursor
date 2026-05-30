# Panduan Import Pretest ke Google Form

Dokumen ini menjelaskan cara memindahkan isi `PRETEST-AI-Cursor.md` ke Google Form.

## Pemetaan Tipe Pertanyaan

| No.    | Tipe di Markdown                     | Tipe di Google Form                          |
| ------ | ------------------------------------ | -------------------------------------------- |
| 1–3    | Isian singkat                        | **Short answer**                             |
| 4      | Pilih salah satu role                | **Multiple choice** (+ opsi "Lainnya")       |
| 5      | Pengalaman                           | **Multiple choice**                          |
| 6–8    | Boleh pilih > 1                      | **Checkboxes** (+ opsi "Lainnya")            |
| 9      | IDE utama                            | **Multiple choice** (+ opsi "Lainnya")       |
| 10     | VCS                                  | **Multiple choice** (+ opsi "Lainnya")       |
| 11–18  | Skala 1–5                            | **Linear scale** (1–5) atau **Grid (multi)** |
| 19, 21 | Boleh pilih > 1                      | **Checkboxes**                               |
| 20, 22 | Frekuensi / skala                    | **Multiple choice** / **Linear scale**       |
| 23     | Kebijakan AI                         | **Multiple choice**                          |
| 24–28  | Pilihan ganda baseline               | **Multiple choice** (1 jawaban)              |
| 29–33  | Isian panjang                        | **Paragraph**                                |

> **Tip efisiensi:** Soal 11–18 sebaiknya digabung ke **satu Grid pertanyaan** (Multiple-choice grid) dengan baris = area skill, kolom = nilai 1–5. Lebih ringkas dan cepat diisi peserta.

## Pembagian Section (Halaman) di Google Form

Buat satu **Section** per bagian agar peserta tidak overwhelmed:

1. **Section 1** — Identitas & Profil Peserta (soal 1–5)
2. **Section 2** — Stack & Tools (soal 6–10)
3. **Section 3** — Self-Assessment Skill (soal 11–18, gabung jadi Grid)
4. **Section 4** — AI Tools Familiarity (soal 19–23)
5. **Section 5** — Baseline Knowledge (soal 24–28)
6. **Section 6** — Ekspektasi & Pain Points (soal 29–33)

## Setting yang Disarankan

- **Pengaturan → Respons:** ✅ Collect email addresses, ✅ Limit to 1 response (jika via SSO), ❌ Allow response editing
- **Pengaturan → Presentasi:** ✅ Show progress bar, ✅ Shuffle question order (untuk Bagian 5 saja — opsional)
- **Pengaturan → Quizzes:** Aktifkan **HANYA** jika ingin auto-grade Bagian 5 sebagai indikator. Jawaban benar Bagian 5:
  - Soal 24 → "AI sebaiknya dianggap sebagai 'pair programmer'..."
  - Soal 25 → "Jumlah token / informasi yang bisa 'dilihat' AI..."
  - Soal 26 → "Hallucination"
  - Soal 27 → "Review setiap saran AI, jalankan test, dan commit lewat code review biasa"
  - Soal 28 → "Potensi kebocoran data / IP organisasi"

> ⚠️ Jika Quiz mode diaktifkan, **jangan tampilkan skor ke peserta** — pretest ini bersifat profiling, bukan ujian.

## Analisis Hasil

Setelah peserta mengisi, ekspor ke Google Sheets dan kelompokkan:

- **Profil stack dominan** (soal 6–8) → menentukan bahasa contoh kode utama
- **Distribusi level** (soal 11–18 rata-rata) → menentukan kedalaman materi (basic emphasis vs advanced emphasis)
- **AI literacy** (soal 19–22) → menentukan apakah Sesi 1–2 perlu diperdalam atau dipercepat
- **Kebijakan AI** (soal 23) → menentukan penekanan Sesi 10 (Security & Governance)
- **Pain points & use case** (soal 30–31) → bahan studi kasus debugging & refactoring
- **Ide capstone** (soal 32) → daftar opsi project Hari 3

## Estimasi Waktu Distribusi

| Aktivitas                       | Waktu        |
| ------------------------------- | ------------ |
| Pretest dikirim ke peserta      | H-7 sebelum hari pelatihan |
| Deadline pengisian              | H-3          |
| Analisis hasil oleh fasilitator | H-2 (1–2 jam) |
| Penyesuaian materi & contoh kode| H-1          |
