# Lab 02 — Prompting Drill

**Durasi**: 35 menit (5 skenario × ~7 menit)
**Tipe**: Hands-on individual + peer review
**Sesi**: Sesi 3 — Prompting & Context Management

---

## Tujuan

Peserta berlatih menulis prompt produksi pada 5 skenario kerja nyata, menerapkan template Cheatsheet, dan mengevaluasi output sendiri dengan rubrik.

---

## Prasyarat

- Lulus Lab 01 (Cursor siap pakai).
- Sample repo Lab 01 masih terbuka. <!-- STACK-PLACEHOLDER: bila perlu repo khusus dengan bug-bug tersedia -->
- `prompting-cheatsheet.md` dalam jangkauan.

---

## Aturan Main

- Untuk setiap skenario, peserta **wajib**:
  1. Tulis prompt di file `submissions/<nama>/skenario-N.md` **sebelum** dijalankan.
  2. Jalankan di Cursor (Chat / Composer / K — bebas, sebutkan mode di file).
  3. Salin output Cursor ke file submission.
  4. Tulis penilaian diri (lihat rubrik di bawah).
- Tidak boleh skip skenario, walau merasa "tidak sesuai stack". Adaptasi.
- Boleh iterasi (`prompt-v1`, `prompt-v2`), maks 3 iterasi per skenario.

---

## Skenario

### Skenario 1 — Eksplorasi Codebase
> Anda baru pertama kali buka repo ini. Dalam waktu 5 menit, Anda harus paham strukturnya cukup untuk meeting standup. Buat prompt yang menghasilkan ringkasan arsitektur, entry point, dan 3 file paling kritis.

Hint mode: **Chat** dengan `@folder`.

### Skenario 2 — Generate Fungsi dari Spec
> Buat fungsi <!-- STACK-PLACEHOLDER: contoh `validateIndonesianNIK(nik: string)` --> yang memvalidasi format dan checksum. Buatlah prompt yang menghasilkan implementasi + minimal 5 unit test, sesuai gaya repo.

Hint mode: **Cmd/Ctrl+K** di file kosong atau **Chat**.

### Skenario 3 — Refactor Lokal
> Pilih 1 fungsi di repo yang panjangnya >40 baris. Buat prompt untuk merefactor agar lebih readable, **tanpa** mengubah interface publik dan tetap lulus test.

Hint mode: **Cmd/Ctrl+K** dengan highlight fungsi.

### Skenario 4 — Debug Error
> Skenario: ada error fiktif di terminal: <!-- STACK-PLACEHOLDER: pesan error spesifik stack -->. Buat prompt untuk mendapatkan (a) root cause hypothesis, (b) 2 opsi fix dengan trade-off, (c) test regresi.

Hint mode: **Chat** dengan `@terminal` + `@file`.

### Skenario 5 — Generate Dokumentasi
> Buat prompt untuk menghasilkan section "Arsitektur" di README.md proyek ini (≤30 baris) berdasarkan struktur folder aktual. Tidak boleh ada klaim yang tidak terverifikasi di kode.

Hint mode: **Composer** atau **Chat** dengan `@folder`.

---

## Rubrik Penilaian Diri

Setiap skenario dinilai 0–4 di **5 dimensi**:

| Dimensi | 0 | 1 | 2 | 3 | 4 |
|---------|---|---|---|---|---|
| Kejelasan tujuan | Tidak ada | Vague | Ada tapi multi | 1 kalimat jelas | + alasan bisnis |
| Konteks (@-mention) | Tidak ada | 1, kurang tepat | 1 tepat | 2 tepat | 3+ tepat & efisien |
| Constraint | Tidak ada | Generik | 1 kritikal | 2–3 kritikal | + ranked priority |
| Acceptance | Tidak ada | "harus jalan" | Subjektif | Terukur | Terukur + contoh I/O |
| Output sesuai | Tidak | Sebagian | Mostly | Sesuai | Sesuai + tanpa hallucination |

**Lolos skenario**: total ≥ 12/20.
**Lolos lab**: minimal 4/5 skenario lolos.

---

## Submit

Folder `submissions/<nama>/` berisi:

- `skenario-1.md` … `skenario-5.md` (prompt + output + penilaian diri).
- `refleksi.md` (≤200 kata) menjawab:
  1. Skenario tersulit & mengapa.
  2. Pola prompting paling efektif untuk Anda.
  3. 1 template yang akan Anda pakai minggu depan.

---

## Peer Review Singkat (5 menit terakhir)

- Tukar `skenario-3.md` dengan tetangga.
- Beri 1 catatan: bagian terkuat & saran perbaikan.

---

## Common Issues

| Issue | Solusi |
|-------|--------|
| Output AI generik | Tambah @-mention; tambah constraint spesifik |
| AI "hallucinate" library/API | Pakai `@docs <library>` atau sebutkan versi |
| Prompt terlalu panjang, AI bingung | Pecah jadi beberapa prompt, atau prioritaskan 3 constraint |
| Composer ngawur ubah banyak file | Scope ulang dengan @-mention file spesifik |
