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

**Contoh prompt** (ganti placeholder `<...>` dengan data Anda):

```
Isi <section id="hero"> di @file index.html dengan layout 2 kolom:

Kolom kiri (text):
- Headline H1: "Halo, saya <Nama Anda>"
- Sub-headline H2: "<Role Anda, mis. Backend Engineer berbasis di Jakarta>"
- Bio 2 paragraf: <paragraf 1: latar belakang singkat>. <paragraf 2: minat & nilai>
- 2 tombol CTA berdampingan:
  - "Lihat Project" → <a href="#projects">, style primary
  - "Hubungi Saya" → <a href="#contact">, style outline

Kolom kanan (image):
- <img> profil pakai https://i.pravatar.cc/400 (placeholder)
- Bentuk lingkaran, ukuran ~280px

Constraints:
- Pakai CSS variables yang ada di :root (--color-primary, --spacing-lg, dst).
  Tambah rules di @file assets/styles.css, jangan inline style.
- Mobile (max-width 768px): kolom jadi 1, image di atas, text di bawah.
- Hero min-height 90vh, content vertically centered.

Tidak perlu animasi rumit. Tidak perlu library.
```

**Hint mode**: Agent atau Cmd+K di `index.html`.

### Tahap 4 — Section Skills

Isi `<section id="skills">` dengan grid icon + label dari minimal 6 skill. Pakai inline SVG sederhana atau Unicode emoji jika belum mau pasang library icon.

**Pertimbangkan untuk prompt Anda**:
- Sebutkan **6+ skill spesifik** yang Anda kuasai.
- Constraint: grid responsive (2 kolom di mobile, 4 kolom di desktop), tanpa library CSS.
- Acceptance: tiap skill ada icon + nama, ter-arrange rapi tanpa overflow.

**Contoh prompt** (ganti list skill dengan punya Anda):

```
Isi <section id="skills"> di @file index.html dengan grid skill.

Heading: "Tech Stack" (H2).

Skills (gunakan list saya, jangan diganti):
- JavaScript (emoji 🟨)
- TypeScript (emoji 🔷)
- React (emoji ⚛️)
- Node.js (emoji 🟢)
- PostgreSQL (emoji 🐘)
- Docker (emoji 🐳)
- Git (emoji 🌳)
- Figma (emoji 🎨)

Markup: tiap skill jadi <div class="skill-card"> berisi emoji
(span ukuran besar) + nama skill (p).

Constraints di @file assets/styles.css:
- Grid responsive pakai grid-template-columns: repeat(auto-fit, minmax(140px, 1fr))
  → otomatis 4 kolom di desktop, 2 di mobile, tanpa media query manual
- Gap pakai --spacing-md
- Tiap card: padding --spacing-md, background sedikit lebih terang dari --color-bg,
  border-radius 8px, hover scale 1.05 transition 150ms
- Emoji font-size 2.5rem, di tengah
```

**Hint mode**: Cmd+K di section skills.

### Tahap 5 — Section Projects + data.js

Bikin file baru `assets/data.js` berisi array `PROJECTS` (minimal 3 project, schema lihat BRD Section 6). Render section projects dari data ini, **bukan hardcoded di HTML**.

**Pertimbangkan untuk prompt Anda**:
- @-mention `@file index.html` sebagai konteks markup.
- Sebutkan struktur object project (id, title, description, thumbnail, tags, demo, repo).
- **Sebutkan minimal 3 project nyata Anda** (atau project fiksi yang dideskripsikan baik).
- Constraint: render lewat JS (fetch dari `window.PROJECTS`), tidak hardcoded `<article>` di HTML.
- Acceptance: tambah/ubah project = ubah `data.js`, tidak sentuh HTML.

**Contoh prompt** (ganti 3 project dengan project Anda):

```
Buat fitur Projects yang ter-render dari data array (bukan hardcoded).
Konteks: @file index.html, @file assets/app.js.

1. Buat file baru assets/data.js:
   window.PROJECTS = [
     {
       id: 'p1',
       title: '<Judul Project 1, mis. Sistem Antrian Klinik>',
       description: '<Deskripsi singkat 1 kalimat>',
       thumbnail: 'https://picsum.photos/seed/p1/600/400',
       tags: ['React', 'Supabase', 'Tailwind'],
       demo: 'https://demo.example.com',
       repo: 'https://github.com/anda/repo1',
     },
     { id: 'p2', ... project Anda kedua ... },
     { id: 'p3', ... project Anda ketiga ... },
   ];

2. Tambah <script src="assets/data.js"></script> di index.html SEBELUM
   <script src="assets/app.js"></script>. Section #projects biarkan
   kosong (akan diisi runtime).

3. Di assets/app.js, tambah fungsi renderProjects():
   - Baca window.PROJECTS
   - Untuk tiap project, buat <article class="project-card"> berisi
     <img>, <h3>, <p>, <ul class="tags">, dan 2 tombol link demo & repo
   - Append ke <section id="projects">
   - Panggil saat DOMContentLoaded

Constraints:
- Tidak boleh hardcode <article> project di index.html
- Tambah/ubah project = cukup ubah PROJECTS di data.js
- Tambah CSS di styles.css: .project-card grid layout, thumbnail
  aspect-ratio 3/2 object-cover, tags inline-block dengan padding kecil
```

**Hint mode**: Agent dengan scope `index.html` + `assets/data.js` + `assets/app.js`.

### Tahap 6 — Project Detail / Hover State

Tambah interaksi pada kartu project: hover effect (transisi visual) + klik kartu buka modal/expanded view berisi deskripsi panjang + screenshot besar + tombol close.

**Pertimbangkan untuk prompt Anda**:
- Sebutkan: hover = scale ringan + shadow + transisi 200ms. Klik = modal centered + backdrop blur.
- Constraint: modal pakai `<dialog>` element (native HTML), tidak pakai library.
- Acceptance: tutup modal pakai `Esc` atau klik backdrop. Body scroll lock saat modal terbuka.

**Contoh prompt**:

```
Tambah interaksi pada kartu project di portfolio.
Konteks: @file index.html, @file assets/app.js, @file assets/styles.css.

1. Update model project di assets/data.js: tambah field
   `longDescription` (string, 2-3 paragraf untuk modal detail).
   Saya akan isi sendiri konten paragrafnya.

2. Hover state pada .project-card di styles.css:
   - transition: transform 200ms ease, box-shadow 200ms ease
   - hover: transform scale(1.03), box-shadow shadow halus
   - cursor: pointer

3. Modal pakai elemen native <dialog> (BUKAN div + overlay manual):
   - Append 1 <dialog id="project-modal"> di akhir <body> di index.html
   - Isi modal: tombol close (×), thumbnail besar, judul, longDescription,
     tags, dan 2 tombol link demo + repo
   - Modal centered, max-width 720px, backdrop blur 4px
   - Tutup: tombol close, klik backdrop, atau tekan Esc

4. Di app.js:
   - Klik .project-card → cari project dari window.PROJECTS pakai data-id
   - Inject konten project ke modal, panggil modal.showModal()
   - Tombol close & klik backdrop (event.target === dialog) → modal.close()
   - Body scroll lock saat modal terbuka (overflow: hidden), reset saat tutup

Constraints:
- Native <dialog>, tidak pakai library modal
- Esc auto-handled oleh <dialog>, jangan duplicate listener
- Test: buka modal → background tidak ikut scroll
```

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
