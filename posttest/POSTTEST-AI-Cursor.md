# Posttest — Pelatihan AI Cursor: AI-Powered Coding & Developer Productivity

> Diisi peserta di akhir Hari 3 setelah Capstone selesai.
>
> **Durasi:** ± 15 menit
> **Tujuan:** Mengukur kenaikan kompetensi, mengevaluasi kualitas penyampaian, dan mengumpulkan masukan perbaikan untuk batch berikutnya.

---

## BAGIAN A — Identitas

**A1. Nama Lengkap**
**A2. Email / Kontak**
**A3. Organisasi**

---

## BAGIAN B — Pemahaman Konseptual (5 soal pilihan ganda)

**B1. Mana yang BUKAN bagian dari "context" yang dapat Anda ikat ke prompt Cursor?**

- @file
- @folder
- @docs
- @memory

**B2. Manakah strategi prompting yang PALING efektif untuk meminta refactor fungsi panjang?**

- "Perbaiki fungsi ini agar lebih bersih"
- "Refactor fungsi X dengan constraint: pertahankan signature, extract sub-fungsi, jangan ubah behavior, tunjukkan diff dulu sebelum apply"
- "Tulis ulang seluruh file"
- "Buat kode ini lebih cepat"

**B3. "Hallucination" pada AI coding tool paling tepat dideskripsikan sebagai:**

- AI lambat merespons
- AI menghasilkan kode yang valid sintaks tapi memanggil API/fungsi yang tidak ada
- AI menolak menjawab
- AI memformat ulang kode

**B4. Untuk perubahan multi-file (mis. menambah fitur lintas modul), fitur Cursor yang paling sesuai adalah:**

- Autocomplete (Tab)
- Inline Edit (Cmd+K)
- Chat (Cmd+L)
- Agent / Composer (Cmd+I)

**B5. Praktik berikut yang PALING tidak aman untuk kode produksi:**

- Review setiap diff yang AI usulkan sebelum apply
- Menambahkan `.cursorrules` agar konsisten dengan tim
- Menempelkan production database connection string ke chat publik untuk debugging
- Mengaktifkan Privacy Mode di Cursor

---

## BAGIAN C — Praktik (3 soal skenario singkat)

**C1.** Anda menerima error berikut dari production log:

```
TypeError: Cannot read properties of undefined (reading 'id')
  at handleOrder (src/services/order.ts:42)
```

Tuliskan prompt yang Anda kirim ke Cursor untuk mulai debugging — sertakan context mention yang relevan. (3-5 baris)

> _______________________________________________________

**C2.** Sebutkan 3 langkah yang Anda lakukan SEBELUM menekan tombol "Apply" pada saran AI yang mengubah 6 file.

> 1. _______________________________________________________
> 2. _______________________________________________________
> 3. _______________________________________________________

**C3.** Tim Anda hendak mengadopsi Cursor secara organisasi. Sebutkan 3 kebijakan / aturan internal yang Anda usulkan agar penggunaan aman dan etis.

> 1. _______________________________________________________
> 2. _______________________________________________________
> 3. _______________________________________________________

---

## BAGIAN D — Self-Assessment Sesudah Pelatihan

Beri nilai diri Anda 1–5 untuk tiap area di bawah **SESUDAH** mengikuti pelatihan.
_(1 = belum bisa, 5 = bisa mengajarkan)_

| Area                                                          | Sebelum (dari pretest) | Sesudah |
| ------------------------------------------------------------- | ---------------------- | ------- |
| D1. Memakai Cursor untuk code generation kontekstual          | __                     | □1 □2 □3 □4 □5 |
| D2. Mengelola konteks dengan @-mentions & `.cursorrules`      | __                     | □1 □2 □3 □4 □5 |
| D3. Debugging error/stack trace dengan AI                     | __                     | □1 □2 □3 □4 □5 |
| D4. Refactoring kode legacy dengan AI                         | __                     | □1 □2 □3 □4 □5 |
| D5. Menulis unit test & code review berbantuan AI             | __                     | □1 □2 □3 □4 □5 |
| D6. Memakai Cursor untuk Git workflow (commit, PR)            | __                     | □1 □2 □3 □4 □5 |
| D7. Menerapkan praktik aman & etis penggunaan AI di coding    | __                     | □1 □2 □3 □4 □5 |

> Kolom **Sebelum** disalin dari hasil pretest peserta yang bersangkutan.

---

## BAGIAN E — Evaluasi Pelatihan

**E1. Materi sesuai dengan ekspektasi saya** _(1=sangat tidak setuju, 5=sangat setuju)_
□1 □2 □3 □4 □5

**E2. Materi disampaikan dengan jelas oleh fasilitator** □1 □2 □3 □4 □5

**E3. Porsi hands-on cukup** □1 □2 □3 □4 □5

**E4. Studi kasus relevan dengan pekerjaan saya** □1 □2 □3 □4 □5

**E5. Saya akan merekomendasikan pelatihan ini ke rekan kerja** _(NPS, 0-10)_
□0 □1 □2 □3 □4 □5 □6 □7 □8 □9 □10

**E6. Sesi yang PALING bermanfaat untuk saya:**

- Sesi 1: Intro AI-Assisted Coding
- Sesi 2: Getting Started with Cursor
- Sesi 3: Prompting & Context
- Sesi 4: Code Generation
- Sesi 5: Code Understanding & Documentation
- Sesi 6: Debugging & Error Analysis
- Sesi 7: Refactoring
- Sesi 8: Testing & Code Review
- Sesi 9: Advanced Workflow
- Sesi 10: Security & Ethics
- Sesi 11: Best Practices & Performance
- Sesi 12: Capstone

**E7. Sesi yang PALING perlu diperbaiki** _(opsional)_
> _______________________________________________________

---

## BAGIAN F — Masukan Terbuka

**F1. Hal yang akan saya terapkan SEGERA setelah pelatihan ini:**
> _______________________________________________________

**F2. Kendala / kekhawatiran saya menerapkan Cursor di tim:**
> _______________________________________________________

**F3. Topik lanjutan yang ingin saya pelajari setelah ini:**
> _______________________________________________________

**F4. Saran perbaikan untuk batch berikutnya:**
> _______________________________________________________

**F5. Hal lain yang ingin disampaikan ke fasilitator / Multimatics:**
> _______________________________________________________

---

## Kunci Jawaban (untuk fasilitator)

**Bagian B — Pemahaman Konseptual**

| Soal | Jawaban             |
| ---- | ------------------- |
| B1   | @memory             |
| B2   | "Refactor fungsi X dengan constraint..." |
| B3   | AI menghasilkan kode yang valid sintaks tapi memanggil API/fungsi yang tidak ada |
| B4   | Agent / Composer    |
| B5   | Menempelkan production DB connection string ke chat publik |

**Bagian C** — penilaian rubrik:
- C1: prompt menyebut `@file` (order.ts), error message lengkap, dan minta root cause (bukan symptom). Skor 0/1/2/3.
- C2: minimal mencakup (a) baca diff per file, (b) jalankan test, (c) verifikasi tidak ada call ke fungsi tidak eksis / linter pass.
- C3: minimal mencakup (a) Privacy Mode + larangan upload kode sensitif ke AI publik, (b) review wajib sebelum merge, (c) larangan paste secret/PII.

**Bagian D**: Hitung **delta** rata-rata (sesudah − sebelum). Target keberhasilan pelatihan: rata-rata delta ≥ 1.0 poin.

**Bagian E**: NPS = % Promoter (9-10) − % Detractor (0-6). Target NPS ≥ 50.

---

— Terima kasih atas partisipasi Anda. Tim Multimatics
