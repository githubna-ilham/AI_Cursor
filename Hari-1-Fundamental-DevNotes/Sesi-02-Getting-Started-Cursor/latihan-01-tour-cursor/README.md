# Latihan 01 — Build Portfolio Website dengan Cursor

**Durasi**: ± 5–6 jam efektif (satu hari penuh Hari 1)
**Tipe**: Hands-on individual, project berkelanjutan
**Output akhir**: Website portfolio personal Anda (HTML/CSS/JS vanilla) — siap deploy dan dipakai di CV / LinkedIn.

> Latihan ini adalah **satu perjalanan linear 10 tahap**. Anda tidak mengerjakan latihan-latihan terpisah — setiap tahap menambah section atau kemampuan baru ke project yang sama.

---

## Referensi

- BRD lengkap & wireframe: [`../../portfolio-brd.md`](../../portfolio-brd.md)
- Perjalanan project: [`../../perjalanan-project.md`](../../perjalanan-project.md)

---

## Empat Mode Cursor — Pengantar Singkat

Sebelum mulai, pahami kapan masing-masing mode dipakai:

| # | Mode | Cara aktifkan | Cocok untuk |
|---|------|---------------|-------------|
| 1 | **Tab** | Ketik kode → `Tab` | Autocomplete 1–10 baris berdasarkan konteks file aktif |
| 2 | **Cmd/Ctrl+K** | Highlight kode → `Cmd/Ctrl+K` | Modifikasi blok kode yang sudah ada, refactor kecil |
| 3 | **Ask (Chat)** | `Cmd/Ctrl+L` → pilih mode `Ask` | Tanya jawab tentang codebase, brainstorming, tanpa langsung ubah file |
| 4 | **Agent** | Panel yang sama → pilih mode `Agent` (atau `Cmd/Ctrl+I`) | Tugas multi-file: scaffold, fitur dari spec |

**Aturan praktis**: pakai mode yang **paling kecil** yang masih cukup. Tab dulu, baru Cmd+K, baru Chat, baru Agent.

---

## Struktur Output Akhir

```
portfolio/
├── README.md
├── index.html
├── assets/
│   ├── styles.css
│   ├── app.js
│   ├── data.js
│   ├── profile.jpg
│   └── projects/
│       └── *.png
└── submissions/<nama>/
    ├── 01-indexed.png
    ├── 02-tab.png
    ├── 03-inline-edit.png
    ├── 04-chat.png
    ├── 05-agent.png
    └── refleksi.md
```

---

## Tahap 1 — Setup Repo & Struktur File (15')

### 1.1 Buat Folder & Git Init

```bash
mkdir portfolio && cd portfolio
git init
git config user.name "Nama Anda"
git config user.email "email@anda.com"
```

### 1.2 Buka di Cursor

**File → Open Folder** → pilih folder `portfolio/`.

Tunggu indexing selesai (< 30 detik untuk folder kosong). Screenshot status bar → `submissions/<nama>/01-indexed.png`.

### 1.3 Buat Struktur File Awal

Buat file dan folder berikut lewat File Explorer Cursor (klik kanan → New File / New Folder):

```
portfolio/
├── index.html          (kosong)
└── assets/
    ├── styles.css      (kosong)
    └── app.js          (kosong)
```

> File sengaja kosong dulu — Anda akan isi dengan masing-masing mode Cursor di tahap berikutnya.

### 1.4 Commit Pertama

```bash
git add .
git commit -m "chore: init portfolio structure"
```

---

## Tahap 2 — Tour 4 Mode Cursor (30')

### 2a. Mode Tab — Boilerplate HTML

Buka `index.html`. Ketik baris pertama lalu biarkan Tab melengkapi:

```html
<!DOCTYPE html>
```

Tab akan menyarankan boilerplate HTML5. Baca sebelum terima (`Tab` = accept, `Esc` = tolak).

Setelah boilerplate diterima, ketik karakter pertama dari setiap baris berikut dan biarkan Tab melengkapi:

```html
<!-- di dalam <head> -->
<link rel="stylesheet" href="assets/styles.css">

<!-- sebelum </body> -->
<script src="assets/app.js"></script>
```

Screenshot saran Tab yang muncul sebelum diterima → `02-tab.png`.

### 2b. Mode Cmd/Ctrl+K — CSS Variables

Buka `assets/styles.css`. Tulis blok kosong:

```css
:root {
}
```

Highlight blok `:root { }` → tekan `Cmd+K` → ketik:

```
Isi dengan CSS variables:
- Warna: --color-primary, --color-bg, --color-text, --color-muted
- Font: --font-base, --font-heading
- Spacing: --spacing-sm (8px), --spacing-md (16px), --spacing-lg (32px)
Gunakan palette dark modern (background gelap, accent biru/ungu).
```

Baca diff sebelum accept. Lalu Cmd+K lagi di bawah blok `:root` untuk tambah rules yang memakai variables:

```
Tambah rules CSS yang memakai variables di atas:
- body: background --color-bg, color --color-text, font-family --font-base, margin 0
- nav: display flex, gap --spacing-md, padding --spacing-md
- nav a: color --color-primary, text-decoration none, font-weight 600
- nav a:hover: opacity 0.8
- main section: min-height 60vh, padding --spacing-lg
- footer: padding --spacing-md, color --color-muted, border-top 1px solid --color-muted
- h1, h2, h3: font-family --font-heading
```

Screenshot diff sebelum accept → `03-inline-edit.png`.

### 2c. Mode Ask — Tanya Codebase

Buka panel `Cmd+L` → pilih mode `Ask` → ketik `@` → pilih folder `portfolio/`.

```
Jelaskan struktur project ini dalam 5 bullet.
CSS variables apa yang sudah disiapkan?
```

Tanya follow-up: *"Kalau saya ingin ganti warna primary jadi #2563eb, cukup ubah di mana?"*

Screenshot percakapan → `04-chat.png`.

### 2d. Mode Agent — Scaffold Struktur HTML

Ganti mode ke `Agent`. Prompt:

```
Kerjakan dua file sekaligus:

1. index.html — lengkapi <body>:
   - <header> dengan <nav> berisi 4 link anchor: Home (#hero), Skills (#skills), Projects (#projects), Contact (#contact)
   - <main> dengan 4 <section> kosong (id: hero, skills, projects, contact)
   - <footer> dengan copyright dan placeholder link GitHub/LinkedIn
   Jangan ubah <link> dan <script> yang sudah ada.

2. assets/app.js — tambah fungsi smoothScrollTo(id):
   - Scroll halus ke section dengan id tersebut
   - Guard: cek null sebelum scroll
```

Review setiap perubahan sebelum accept. Buka `index.html` di browser — harus tampil nav + 4 section + footer.

Screenshot panel Agent + hasil di browser → `05-agent.png`.

### Commit Tahap 2

```bash
git add .
git commit -m "feat: scaffold portfolio skeleton + CSS variables (Tahap 1-2)"
```

---

## Tahap 3 — Section Hero / About (30')

Section pertama yang dilihat visitor — perkenalkan diri Anda.

Buka Chat (`Cmd+L`) → mode `Agent` → attach `@file index.html` dan `@file assets/styles.css`.

```
Isi <section id="hero"> di index.html dengan:
- Container flex row (foto kiri, teks kanan) di desktop
- <img> untuk foto profil (src="assets/profile.jpg", alt="Foto [Nama Anda]")
- <h1> nama lengkap Anda
- <p class="headline"> role / tagline 1 kalimat
- <p class="bio"> 2–3 kalimat tentang Anda
- Dua tombol CTA: <a href="#contact"> "Hubungi Saya" dan <a href="#projects"> "Lihat Project"

Tambah CSS yang dibutuhkan di assets/styles.css:
- .hero: display flex, align-items center, gap --spacing-lg
- .hero img: border-radius 50%, width 200px, height 200px, object-fit cover
- .headline: color --color-primary, font-size 1.25rem
- .btn: style tombol dengan --color-primary sebagai background, padding, border-radius
- .btn-outline: variant outline (border --color-primary, background transparent)

Tidak perlu file baru.
```

Ganti `assets/profile.jpg` dengan foto Anda, atau gunakan placeholder sementara:

```html
<img src="https://i.pravatar.cc/200" alt="Foto [Nama Anda]">
```

Buka browser — pastikan foto, nama, headline, bio, dan 2 tombol tampil.

### Commit Tahap 3

```bash
git add .
git commit -m "feat: add Hero section (Tahap 3)"
```

---

## Tahap 4 — Section Skills (20')

Tampilkan tech stack Anda dalam grid.

Buka `assets/app.js`. Tambah array skills dan fungsi render via `Cmd+K`:

```
Tambah di bawah smoothScrollTo:

const SKILLS = [
  { name: "JavaScript", emoji: "🟨" },
  { name: "PHP", emoji: "🐘" },
  { name: "Python", emoji: "🐍" },
  { name: "MySQL", emoji: "🗄️" },
  { name: "Git", emoji: "🌿" },
  { name: "Laravel", emoji: "🔴" }
];

function renderSkills() {
  // Cari <section id="skills">, buat <ul class="skills-grid">,
  // tiap <li> berisi emoji + nama skill. Guard jika section tidak ada.
}

document.addEventListener('DOMContentLoaded', () => {
  renderSkills();
});
```

Setelah AI generate, periksa hasilnya dan jalankan manual di browser console untuk verifikasi.

Tambah CSS di `styles.css` via Cmd+K:

```
Tambah CSS untuk .skills-grid:
- display grid, grid-template-columns repeat(auto-fill, minmax(120px, 1fr))
- gap --spacing-md
- list-style none, padding 0

Tiap li: display flex flex-col align-items center, gap --spacing-sm,
padding --spacing-md, background rgba(255,255,255,0.05),
border-radius 8px, hover transform scale(1.05) transition 0.2s
```

Tambah skill Anda sendiri ke array SKILLS sesuai yang paling sering Anda pakai.

### Commit Tahap 4

```bash
git add .
git commit -m "feat: add Skills section dengan grid render (Tahap 4)"
```

---

## Tahap 5 — Section Projects + data.js (30')

Data project dipisah ke file tersendiri agar mudah diupdate.

### 5.1 Buat assets/data.js

Buat file `assets/data.js` (File Explorer Cursor → klik kanan → New File).

Isi via Chat → mode `Ask` dulu untuk diskusi struktur, lalu switch ke `Agent` untuk generate:

```
Buat file assets/data.js berisi:

const PROFILE = {
  name: "[Nama Anda]",
  headline: "[Role / Tagline Anda]",
  bio: "[Bio singkat 2-3 kalimat]",
  photo: "assets/profile.jpg",
  social: {
    github: "https://github.com/[username]",
    linkedin: "https://linkedin.com/in/[username]",
    email: "[email@anda.com]"
  }
};

const PROJECTS = [
  {
    id: "project-1",
    title: "[Judul Project 1]",
    description: "[Deskripsi singkat 1-2 kalimat]",
    thumbnail: "assets/projects/project-1.png",
    tags: ["JavaScript", "HTML"],
    demo: "#",
    repo: "#"
  },
  // buat 2 project lagi dengan struktur yang sama
];

// Export via window agar bisa diakses dari app.js
window.PROFILE = PROFILE;
window.PROJECTS = PROJECTS;
```

Ganti placeholder dengan data Anda sendiri (boleh fiksi yang masuk akal).

### 5.2 Link data.js ke HTML

Tambah script tag di `index.html` sebelum `app.js`:

```html
<script src="assets/data.js"></script>
<script src="assets/app.js"></script>
```

### 5.3 Render Projects

Di `assets/app.js`, tambah fungsi `renderProjects()` via `Cmd+K`:

```
Tambah fungsi renderProjects() di app.js:
- Ambil data dari window.PROJECTS
- Cari <section id="projects">, tambah <h2>Projects</h2> dan <div class="projects-grid">
- Tiap project: kartu dengan thumbnail, title, description, tags (sebagai <span>),
  link demo dan repo
- Guard: tampilkan pesan "Belum ada project" jika array kosong
- Panggil renderProjects() di dalam DOMContentLoaded yang sudah ada
```

Tambah CSS untuk grid project di `styles.css` via Cmd+K:

```
Tambah CSS untuk .projects-grid dan .project-card:
- Grid 3 kolom auto-fill minmax(280px, 1fr), gap --spacing-md
- Kartu: background rgba(255,255,255,0.05), border-radius 12px, overflow hidden,
  hover transform translateY(-4px) transition 0.2s, cursor pointer
- Thumbnail: width 100%, height 180px, object-fit cover
- Konten kartu: padding --spacing-md
- Tags: flex wrap, gap 8px, margin-top --spacing-sm
- Tag item: background --color-primary dengan opacity 0.2, padding 2px 8px, border-radius 4px, font-size 0.75rem
- Link demo & repo: inline-flex, gap 8px, margin-top --spacing-sm
```

Refresh browser — 3 kartu project harus tampil dalam grid.

### Commit Tahap 5

```bash
git add .
git commit -m "feat: add Projects section + data.js (Tahap 5)"
```

---

## Tahap 6 — Project Detail / Hover State (20')

Tambahkan interaksi: hover effect dan modal saat kartu diklik.

Di `assets/app.js` via `Cmd+K`:

```
Tambah fungsi modal project di app.js:

function openProjectModal(project) {
  // Buat <div class="modal-overlay"> yang menutupi layar
  // Di dalamnya: <div class="modal-content"> berisi
  //   - thumbnail, title, description lengkap, tags, link demo & repo
  //   - tombol close (×) di pojok kanan atas
  // Klik overlay di luar modal = tutup modal
  // Tekan Escape = tutup modal
  // append ke document.body
}

// Pasang event klik ke setiap .project-card di renderProjects()
// sehingga klik kartu memanggil openProjectModal(project)
```

Tambah CSS modal di `styles.css` via Cmd+K:

```
Tambah CSS untuk modal:
- .modal-overlay: position fixed, inset 0, background rgba(0,0,0,0.7),
  display flex, align-items center, justify-content center, z-index 1000
- .modal-content: background --color-bg, border-radius 12px, max-width 600px,
  width 90%, max-height 80vh, overflow-y auto, padding --spacing-lg, position relative
- .modal-close: position absolute, top --spacing-md, right --spacing-md,
  background none, border none, color --color-text, font-size 1.5rem, cursor pointer
```

Test: klik kartu project → modal terbuka. Klik overlay atau tekan Escape → modal tutup.

### Commit Tahap 6

```bash
git add .
git commit -m "feat: add project card hover + modal detail (Tahap 6)"
```

---

## Tahap 7 — Section Contact Form + Validasi (25')

### 7.1 Buat Form HTML

Di `index.html`, isi `<section id="contact">` via Agent:

```
Isi <section id="contact"> di index.html dengan:
- <h2>Hubungi Saya</h2>
- <form id="contact-form"> berisi:
  - Field nama: <input type="text" id="name" name="name" placeholder="Nama Anda">
    dengan <label> dan <span class="field-error" id="name-error">
  - Field email: <input type="email" id="email" name="email" placeholder="Email Anda">
    dengan <label> dan <span class="field-error" id="email-error">
  - Field pesan: <textarea id="message" name="message" placeholder="Tulis pesan...">
    dengan <label> dan <span class="field-error" id="message-error">
  - <button type="submit">Kirim Pesan</button>
Tidak ada framework. Tidak ada file baru.
```

### 7.2 Fungsi Validasi

Di `assets/app.js` via Cmd+K:

```
Tambah fungsi validasi contact form:

function validateField(name, value) {
  // name bisa: 'name', 'email', 'message'
  // return: { valid: boolean, error: string | null }
  // Rules:
  //   name: wajib, min 2 karakter
  //   email: wajib, format email valid (regex sederhana)
  //   message: wajib, min 10 karakter
}

function showFieldError(fieldId, message) {
  // Tampilkan error di <span id="${fieldId}-error">
  // Tambah class 'invalid' ke input/textarea
}

function clearFieldError(fieldId) {
  // Hapus error dan class 'invalid'
}
```

Tambah CSS untuk state invalid di `styles.css` via Cmd+K:

```
Tambah CSS untuk form contact:
- form: display flex flex-col, gap --spacing-md, max-width 560px
- label: font-weight 600, margin-bottom 4px
- input, textarea: width 100%, padding --spacing-sm --spacing-md,
  background rgba(255,255,255,0.08), border 1px solid transparent,
  border-radius 8px, color --color-text, font-family --font-base
- input:focus, textarea:focus: outline none, border-color --color-primary
- input.invalid, textarea.invalid: border-color #ef4444
- .field-error: color #ef4444, font-size 0.8rem, margin-top 4px, display block
- textarea: min-height 120px, resize vertical
```

Test validasi: submit form kosong → semua field harus tampil error inline.

### Commit Tahap 7

```bash
git add .
git commit -m "feat: add Contact form + inline validation (Tahap 7)"
```

---

## Tahap 8 — Navigation Sticky + Responsive Mobile (30')

### 8.1 Navigation Sticky

Di `styles.css` via Cmd+K:

```
Update styles header/nav:
- header: position sticky, top 0, z-index 100,
  background --color-bg dengan backdrop-filter blur(8px),
  border-bottom 1px solid rgba(255,255,255,0.1)
- nav: display flex, justify-content space-between, align-items center,
  padding --spacing-sm --spacing-lg
- .nav-logo: font-weight 700, color --color-primary, text-decoration none, font-size 1.2rem
- .nav-links: display flex, gap --spacing-md, list-style none
- .nav-links a.active: border-bottom 2px solid --color-primary
```

Di `assets/app.js` via Cmd+K:

```
Tambah fungsi highlight nav link aktif saat scroll:

function initActiveNav() {
  const sections = document.querySelectorAll('main section[id]');
  const navLinks = document.querySelectorAll('.nav-links a');

  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        navLinks.forEach(link => {
          link.classList.toggle('active', link.getAttribute('href') === '#' + entry.target.id);
        });
      }
    });
  }, { threshold: 0.5 });

  sections.forEach(s => observer.observe(s));
}
// Panggil initActiveNav() di DOMContentLoaded
```

### 8.2 Hamburger Menu Mobile

Di `index.html` via Agent, tambah tombol hamburger di dalam `<nav>`:

```
Tambah tombol hamburger di dalam <nav>, setelah .nav-logo:
<button class="nav-toggle" aria-label="Toggle menu" aria-expanded="false">
  <span></span><span></span><span></span>
</button>

Tombol ini hanya tampil di mobile (hidden di desktop via CSS).
```

Di `styles.css` via Cmd+K:

```
Tambah responsive CSS untuk mobile (max-width: 768px):
- .nav-toggle: display block, background none, border none, cursor pointer, padding 8px
  Tiap <span>: display block, width 24px, height 2px, background --color-text,
  margin 5px 0, transition 0.3s
- .nav-links: display none secara default di mobile
- .nav-links.open: display flex, flex-direction column, position absolute,
  top 100%, left 0, right 0, background --color-bg, padding --spacing-md,
  border-bottom 1px solid rgba(255,255,255,0.1)
- Hero: flex-direction column, text-align center di mobile
- .projects-grid: grid-template-columns 1fr di mobile
- .hero img: width 140px, height 140px di mobile

Di desktop (min-width: 769px): .nav-toggle display none
```

Di `assets/app.js` via Cmd+K:

```
Tambah fungsi toggle hamburger menu:

function initMobileNav() {
  const toggle = document.querySelector('.nav-toggle');
  const navLinks = document.querySelector('.nav-links');
  if (!toggle || !navLinks) return;

  toggle.addEventListener('click', () => {
    const isOpen = navLinks.classList.toggle('open');
    toggle.setAttribute('aria-expanded', isOpen);
  });

  // Tutup menu saat klik link
  navLinks.querySelectorAll('a').forEach(link => {
    link.addEventListener('click', () => {
      navLinks.classList.remove('open');
      toggle.setAttribute('aria-expanded', false);
    });
  });
}
// Panggil initMobileNav() di DOMContentLoaded
```

Test: DevTools → toggle device toolbar → nav harus berubah jadi hamburger di ≤ 768px.

### Commit Tahap 8

```bash
git add .
git commit -m "feat: nav sticky + active highlight + mobile hamburger (Tahap 8)"
```

---

## Refleksi & Submit

Tulis `submissions/<nama>/refleksi.md` (5–8 kalimat):

1. Mode Cursor mana yang paling membantu, dan untuk tugas apa?
2. Momen mana ketika Anda menolak saran AI (`Esc`) dan kenapa?
3. Kalau mengulang project ini, apa yang akan Anda lakukan berbeda?
4. Skill apa yang terasa paling dibantu oleh AI, dan skill apa yang tetap harus Anda kerjakan manual?

---

## Tips

- **Mulai dari mode terkecil.** Tab dulu, baru Cmd+K, baru Agent. Bukan sebaliknya.
- **Baca diff sebelum accept.** Terutama Agent yang bisa menyentuh banyak file sekaligus.
- **Commit kecil, sering.** Mudah revert kalau AI menghasilkan perubahan tidak diinginkan.
- **Data milik Anda.** Isi dengan project, skill, dan bio nyata Anda — bukan placeholder — agar portfolio ini benar-benar siap dipakai.
- **Pakai `Esc` tanpa rasa bersalah.** Menolak saran AI adalah skill, bukan kegagalan.

---

## Common Issues

| Issue | Solusi |
|---|---|
| Agent bikin `package.json` atau `node_modules/` | Tolak. Tambahkan ke prompt: "no build tool, no npm" |
| Tab tidak muncul | Settings → Features → Cursor Tab → aktifkan; restart Cursor |
| Halaman blank putih | DevTools console → biasanya path `assets/styles.css` salah |
| Modal tidak menutup saat tekan Escape | Pastikan `keydown` listener di `document`, bukan di elemen modal |
| Lighthouse skor rendah di Performance | Kompres foto (< 200KB), tambah `loading="lazy"` di `<img>` |
| localStorage tidak tersimpan | Buka via server lokal (bukan file://) — gunakan Live Server extension |
