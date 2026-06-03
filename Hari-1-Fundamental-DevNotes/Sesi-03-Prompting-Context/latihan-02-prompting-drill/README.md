# Latihan 02 — Prompting Drill: Halaman Detail DevNotes

> 🗺️ **Tahap 3–6 dari 10** di [Perjalanan Project DevNotes](../../perjalanan-project.md)
> Sebelumnya: Tahap 1–2 (Scaffold + Tour Cursor) di Sesi 2 | Setelah ini: Tahap 7 (Storage layer) di Sesi 4

**Durasi**: 45 menit (5 skenario × ~8 menit + peer review)
**Tipe**: Hands-on individual + peer review
**Sesi**: Sesi 3 — Prompting & Context Management
**Output**: `notes/[id].html` (halaman detail catatan) + 5 file `skenario-N.md` berisi prompt yang dilatih.

---

## Konteks BRD

Latihan ini menyelesaikan **FR-02** (baca detail catatan tanpa login). Mengacu mockup **Section 11.2** di [`/project-brd.md`](../../../project-brd.md). Semua skenario menggunakan repo `devnotes/` hasil Sesi 2.

---

## Tujuan

Peserta berlatih menulis prompt produksi pada 5 skenario kerja nyata yang **semua outputnya berkontribusi** ke pembangunan halaman detail DevNotes. Setiap prompt menerapkan template Cheatsheet (Role + Context + Constraint + Acceptance).

---

## Prasyarat

- Lulus Latihan 01 (repo `devnotes/` ada dengan home page + MOCK_NOTES).
- `prompting-cheatsheet.md` dalam jangkauan.
- File submission di-tempatkan di `devnotes/submissions/<nama>/`.

---

## Aturan Main

- Untuk setiap skenario, peserta **wajib**:
  1. Tulis prompt di file `skenario-N.md` **sebelum** dijalankan.
  2. Jalankan di Cursor (Chat / Composer / K — bebas, sebutkan mode di file).
  3. Salin output Cursor ke file submission.
  4. Tulis penilaian diri (rubrik di bawah).
- Boleh iterasi (`prompt-v1`, `prompt-v2`), maks 3 iterasi per skenario.

---

## Skenario

### Skenario 1 — Eksplorasi Codebase Sendiri

> Anggap rekan baru Anda buka repo `devnotes/`. Dalam 5 menit dia harus paham strukturnya. Buat prompt yang menghasilkan ringkasan arsitektur, file kunci, dan 3 pertanyaan yang biasanya muncul.

**Hint mode**: Chat dengan `@folder devnotes`.

### Skenario 2 — Tambah Field di Mock Data

> Mock data Anda di Sesi 2 punya field `title`, `author`, `createdAt`, `excerpt`. Untuk halaman detail, butuh field tambahan: `body_md` (markdown lengkap), `id` (string slug), dan `is_public` (boolean). Buat prompt untuk memperbarui `MOCK_NOTES` minimal 3 item lengkap dengan field baru, gaya markdown realistis (heading, list, code block).

**Hint mode**: Cmd/Ctrl+K di array `MOCK_NOTES` atau Chat.

### Skenario 3 — Generate Halaman Detail

> Buat halaman `notes/[id].html` yang menampilkan detail satu catatan berdasarkan `?id=` di URL. Layout mengikuti mockup 11.2 BRD: tombol "← Kembali", judul, meta (author + waktu + visibility), body markdown ter-render. Buat prompt yang menghasilkan file ini lengkap dengan logic JS membaca query string, lookup dari MOCK_NOTES, dan render markdown (boleh import library `marked` via CDN).

**Hint mode**: Composer dengan `@file index.html` + `@file assets/app.js` sebagai context.

### Skenario 4 — Link Home → Detail

> Halaman home harus link ke `notes/[id].html?id=<slug>`. Buat prompt untuk mengubah `renderNotes()` agar tiap kartu wrap dalam `<a>` dengan href yang benar. Output: diff minimal, tidak mengubah style.

**Hint mode**: Cmd/Ctrl+K dengan highlight fungsi `renderNotes()`.

### Skenario 5 — 404 Handling

> Kalau `?id=` tidak ada atau tidak match, tampilkan empty state sesuai mockup 11.6 ("Catatan tidak ditemukan" + tombol kembali). Buat prompt yang menghasilkan kode penanganan ini di `notes/[id].html`, tidak boleh memanggil `alert()` atau redirect otomatis.

**Hint mode**: Chat dengan `@file notes/[id].html` + `@docs` untuk pattern URL handling.

---

## Rubrik Penilaian Diri

Setiap skenario dinilai 0–4 di **5 dimensi**:

| Dimensi              | 0          | 1                 | 2             | 3                | 4                            |
| -------------------- | ---------- | ----------------- | ------------- | ---------------- | ---------------------------- |
| Kejelasan tujuan     | Tidak ada  | Vague             | Ada tapi multi | 1 kalimat jelas  | + alasan bisnis (ref FR/BRD) |
| Konteks (@-mention)  | Tidak ada  | 1, kurang tepat   | 1 tepat       | 2 tepat          | 3+ tepat & efisien           |
| Constraint           | Tidak ada  | Generik           | 1 kritikal    | 2–3 kritikal     | + ranked priority            |
| Acceptance           | Tidak ada  | "harus jalan"     | Subjektif     | Terukur          | Terukur + contoh I/O         |
| Output sesuai        | Tidak      | Sebagian          | Mostly        | Sesuai           | Sesuai + tanpa hallucination |

**Lolos skenario**: total ≥ 12/20.
**Lolos latihan**: minimal 4/5 skenario lolos **DAN** halaman detail dapat dibuka di browser (klik 1 kartu home → muncul detail).

---

## Submit

Folder `devnotes/submissions/<nama>/` berisi:

- `skenario-1.md` … `skenario-5.md` (prompt + output + penilaian diri).
- `refleksi.md` (≤200 kata) menjawab:
  1. Skenario tersulit & mengapa.
  2. Pola prompting paling efektif untuk Anda.
  3. 1 template yang akan Anda pakai minggu depan.

Kode tambahan ter-commit di repo dengan pesan jelas (mis. `feat: add detail page (FR-02)`).

---

## Peer Review Singkat (5 menit terakhir)

- Tukar `skenario-3.md` (paling kompleks) dengan tetangga.
- Beri 1 catatan: bagian terkuat & 1 saran perbaikan prompt.

---

## Common Issues

| Issue                                          | Solusi                                                                |
| ---------------------------------------------- | --------------------------------------------------------------------- |
| Output AI generik                              | Tambah @-mention; tambah constraint spesifik (ref mockup BRD)         |
| AI memperkenalkan library yang tidak diminta   | Tolak; minta solusi tanpa dependency tambahan atau via CDN saja       |
| Markdown render menampilkan HTML mentah        | Pastikan output `marked.parse()` di-set ke `innerHTML`, bukan `textContent` |
| 404 page redirect ke home tanpa pesan          | Iterasi prompt dengan constraint "tampilkan pesan, jangan auto-redirect" |
| Composer ngubah file di luar scope             | Reset Composer, sebut file tepat di prompt + tambahkan "jangan ubah index.html" |
