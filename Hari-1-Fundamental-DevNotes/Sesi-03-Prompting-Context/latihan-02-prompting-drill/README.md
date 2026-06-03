# Latihan 02 — Prompting Drill: Isi Section Portfolio

> 🗺️ **Tahap 3–6 dari 10** di [Perjalanan Project Hari 1](../../perjalanan-project.md)
> Sebelumnya: Tahap 1–2 (Scaffold + Tour Cursor) di Sesi 2 | Setelah ini: Tahap 7 (Contact form) di Sesi 4

**Durasi**: 60 menit (4 tahap × ~13 menit + review)
**Tipe**: Hands-on individual
**Output**: 4 section portfolio terisi (Hero, Skills, Projects, project detail) + `assets/data.js` + 4 file `tahap-N.md` berisi prompt yang dilatih.

---

## Konteks BRD

Latihan ini mengisi **FR-01 (lengkap)** dan **FR-03** — content portfolio nyata milik Anda. Mengacu wireframe **Section 9** dan model data **Section 6** di [`/Hari-1-Fundamental-DevNotes/portfolio-brd.md`](../../portfolio-brd.md).

Semua tahap menggunakan repo `portfolio/` hasil Sesi 2.

---

## Tujuan

Peserta berlatih menulis prompt produksi pada 4 tahap pengisian section portfolio yang **semua outputnya** membangun portfolio personal Anda. Setiap prompt menerapkan template Cheatsheet (Role + Context + Constraint + Acceptance) dan @-mentions.

---

## Prasyarat

- Lulus Latihan 01 (Tahap 1-2): repo `portfolio/` ada dengan skeleton + CSS variables.
- `prompting-cheatsheet.md` dalam jangkauan.
- File submission di-tempatkan di `portfolio/submissions/<nama>/`.
- **Siapkan data pribadi**: foto profil (boleh `https://i.pravatar.cc/300` placeholder), 6+ skill yang Anda kuasai, 3+ project nyata atau fiksi.

---

## Aturan Main

- Untuk setiap tahap, peserta **wajib**:
  1. Tulis prompt di file `tahap-N.md` **sebelum** dijalankan.
  2. Jalankan di Cursor (Chat / Agent / Cmd+K — bebas, sebutkan mode di file).
  3. Salin output Cursor ke file submission.
  4. Tulis penilaian diri (rubrik di bawah).
- Boleh iterasi (`prompt-v1`, `prompt-v2`), maks 3 iterasi per tahap.
- **Commit di akhir tiap tahap** dengan pesan jelas (mis. `feat: add Hero section (Tahap 3)`).

---

## Tahap

### Tahap 3 — Section Hero / About

Isi `<section id="hero">` dengan: foto profil, nama, headline (role / 1 kalimat), bio 2-3 paragraf, 2 tombol CTA ("Lihat Project", "Hubungi Saya").

**Pertimbangkan untuk prompt Anda**:
- @-mention `@file index.html` & `@file assets/styles.css` sebagai konteks.
- Sebutkan **data pribadi Anda** (nama, headline, bio) langsung di prompt.
- Constraint: pakai CSS variables yang sudah ada di `:root`, tidak boleh inline style.
- Acceptance: tombol CTA pakai `<a href="#contact">` dan `<a href="#projects">` — scroll ke section terkait.

**Hint mode**: Agent atau Cmd+K di `index.html`.

### Tahap 4 — Section Skills

Isi `<section id="skills">` dengan grid icon + label dari minimal 6 skill. Pakai inline SVG sederhana atau Unicode emoji jika belum mau pasang library icon.

**Pertimbangkan untuk prompt Anda**:
- Sebutkan **6+ skill spesifik** yang Anda kuasai.
- Constraint: grid responsive (2 kolom di mobile, 4 kolom di desktop), tanpa library CSS.
- Acceptance: tiap skill ada icon + nama, ter-arrange rapi tanpa overflow.

**Hint mode**: Cmd+K di section skills.

### Tahap 5 — Section Projects + data.js

Bikin file baru `assets/data.js` berisi array `PROJECTS` (minimal 3 project, schema lihat BRD Section 6). Render section projects dari data ini, **bukan hardcoded di HTML**.

**Pertimbangkan untuk prompt Anda**:
- @-mention `@file index.html` sebagai konteks markup.
- Sebutkan struktur object project (id, title, description, thumbnail, tags, demo, repo).
- **Sebutkan minimal 3 project nyata Anda** (atau project fiksi yang dideskripsikan baik).
- Constraint: render lewat JS (fetch dari `window.PROJECTS`), tidak hardcoded `<article>` di HTML.
- Acceptance: tambah/ubah project = ubah `data.js`, tidak sentuh HTML.

**Hint mode**: Agent dengan scope `index.html` + `assets/data.js` + `assets/app.js`.

### Tahap 6 — Project Detail / Hover State

Tambah interaksi pada kartu project: hover effect (transisi visual) + klik kartu buka modal/expanded view berisi deskripsi panjang + screenshot besar + tombol close.

**Pertimbangkan untuk prompt Anda**:
- Sebutkan: hover = scale ringan + shadow + transisi 200ms. Klik = modal centered + backdrop blur.
- Constraint: modal pakai `<dialog>` element (native HTML), tidak pakai library.
- Acceptance: tutup modal pakai `Esc` atau klik backdrop. Body scroll lock saat modal terbuka.

**Hint mode**: Agent dengan multi-file edit (CSS untuk hover, JS untuk modal logic, HTML untuk `<dialog>`).

---

## Rubrik Penilaian Diri

Setiap tahap dinilai 0–4 di **5 dimensi**:

| Dimensi              | 0          | 1                 | 2             | 3                | 4                              |
| -------------------- | ---------- | ----------------- | ------------- | ---------------- | ------------------------------ |
| Kejelasan tujuan     | Tidak ada  | Vague             | Ada tapi multi | 1 kalimat jelas  | + alasan bisnis (ref BRD)      |
| Konteks (@-mention)  | Tidak ada  | 1, kurang tepat   | 1 tepat       | 2 tepat          | 3+ tepat & efisien             |
| Constraint           | Tidak ada  | Generik           | 1 kritikal    | 2–3 kritikal     | + ranked priority              |
| Acceptance           | Tidak ada  | "harus jalan"     | Subjektif     | Terukur          | Terukur + contoh perilaku      |
| Output sesuai        | Tidak      | Sebagian          | Mostly        | Sesuai           | Sesuai + tanpa hallucination   |

**Lolos tahap**: total ≥ 12/20.
**Lolos latihan**: minimal 3/4 tahap lolos **DAN** keempat section terlihat di browser dengan data nyata Anda.

---

## Submit

Folder `portfolio/submissions/<nama>/` berisi:

- `tahap-3.md` … `tahap-6.md` (prompt + output + penilaian diri).
- `refleksi.md` (≤200 kata) menjawab:
  1. Tahap tersulit & mengapa.
  2. Pola prompting paling efektif untuk Anda.
  3. 1 template yang akan Anda pakai minggu depan.

Commit per tahap dengan pesan jelas (`feat: add Skills section (Tahap 4)`, dst).

---

## Common Issues

| Issue                                          | Solusi                                                                |
| ---------------------------------------------- | --------------------------------------------------------------------- |
| Output AI generik / pakai data placeholder     | Tegaskan di prompt: "pakai data berikut: <data nyata Anda>"           |
| AI memperkenalkan library yang tidak diminta   | Tolak; minta solusi tanpa dependency tambahan                         |
| Grid skill tidak responsive                    | Cek media query; tambah `grid-template-columns: repeat(auto-fit, minmax(...))` |
| Project card tidak ke-render                   | Cek di DevTools: apakah `PROJECTS` array ter-load? Cek urutan `<script>` |
| Modal tidak buka                               | `dialog.showModal()` (bukan `dialog.show()`); cek event listener      |
| Agent ngubah file di luar scope                | Reset Agent, sebut file tepat di prompt + tambahkan "jangan ubah CSS variables" |
