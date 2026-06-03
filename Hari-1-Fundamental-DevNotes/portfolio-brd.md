# BRD — Website Portfolio Personal (Hari 1)

**Versi**: Draft 0.1
**Konteks**: Project akhir Hari 1 pelatihan AI Cursor (Multimatics)
**Stack**: HTML + CSS + JavaScript vanilla, tanpa build tool

> Catatan: BRD ini **khusus Hari 1**. Hari 2 dan 3 melanjutkan project berbeda (DevNotes) — lihat [`../project-brd.md`](../project-brd.md).

---

## 1. Latar Belakang

Sebagai developer, **portfolio personal** adalah artefak yang seringkali dibutuhkan tapi jarang sempat dibuat. Setiap kali ada apply kerja, freelance pitch, atau networking — Anda mencari URL portfolio Anda dan menyadari belum punya / sudah outdated.

Di Hari 1 pelatihan ini, Anda akan membangun **website portfolio personal Anda sendiri** dari nol menggunakan Cursor. Datanya nyata (foto Anda, project Anda, skill Anda) sehingga di akhir hari Anda pulang dengan **artefak yang bisa langsung dipakai**.

## 2. Tujuan

| # | Tujuan | Indikator |
|---|--------|-----------|
| T1 | Setiap peserta punya website portfolio personal yang bisa dishare | URL/folder portfolio aktif di laptop peserta, bisa dibuka di browser |
| T2 | Peserta mempraktikkan 4 mode interaksi Cursor pada konteks nyata | Tab, Cmd/Ctrl+K, Chat, Agent semua terpakai minimal sekali |
| T3 | Peserta paham trade-off prompting (samar vs spesifik) | Refleksi peserta menyebutkan ≥ 2 contoh iterasi prompt |

## 3. Ruang Lingkup

### In-Scope (4 sections wajib)

1. **Hero / About** — foto profil, nama, headline (role / 1 kalimat), bio singkat (≤ 3 paragraf), tombol CTA (mis. "Hubungi Saya", "Lihat Project").
2. **Skills / Tech Stack** — grid icon + label skill yang dikuasai (mis. JS, Python, Docker, dll).
3. **Projects Showcase** — list/grid 3–6 project, masing-masing: thumbnail, judul, deskripsi singkat, tags, link demo & repo.
4. **Contact Form** — form (nama, email, pesan) dengan validasi sisi-client. Submit disimpan ke `localStorage` (simulasi "inbox").

### Out-of-Scope

- Blog / artikel.
- Multi-bahasa.
- Backend / database real (simulasi pakai `localStorage` saja di Hari 1).
- Authentication / admin dashboard.
- Animasi kompleks (parallax, scroll-jacking, dll).
- Image upload / file storage.

## 4. Functional Requirements

| FR# | Deskripsi | Tahap |
|-----|-----------|-------|
| FR-01 | Halaman utama `index.html` menampilkan Hero, Skills, Projects, Contact dalam satu single-page-app (scroll-based). | 1–7 |
| FR-02 | Navigation bar dengan link anchor ke tiap section. Active section ter-highlight saat scroll. | 9 |
| FR-03 | Projects data disimpan di `assets/data.js` (array of objects) — mudah edit, dapat ditambah project baru tanpa ubah HTML. | 5 |
| FR-04 | Contact form: validasi nama (≥2 char), email (format valid), pesan (≥10 char). Tampilkan error inline. | 7 |
| FR-05 | Submit form sukses → simpan ke `localStorage` (key: `portfolio:messages`), tampilkan toast "Pesan terkirim", reset form. | 8 |
| FR-06 | Responsive di mobile (≤ 768px): hamburger menu, layout column, font scale. | 9 |
| FR-07 | Lighthouse score: Performance ≥ 85, Accessibility ≥ 90, Best Practices ≥ 90 di desktop. | 10 |

## 5. Non-Functional Requirements

| NFR# | Aspek | Target |
|------|-------|--------|
| NFR-01 | Performance | First contentful paint < 2s; total bundle < 200 KB |
| NFR-02 | Accessibility | Semantic HTML (`<section>`, `<article>`, `<nav>`), kontras ≥ AA, label form, alt text |
| NFR-03 | Maintainability | Struktur folder konsisten; data terpisah dari markup (`data.js`) |
| NFR-04 | Browser support | Chrome, Firefox, Safari versi terbaru. Tidak perlu IE/legacy |
| NFR-05 | No build tool | Cukup buka `index.html` di browser, tidak ada `npm install` / bundler |

## 6. Model Data

```js
// assets/data.js

const PROFILE = {
  name: "Nama Anda",
  headline: "Full-Stack Developer | AI Enthusiast",
  bio: "3 paragraf cerita Anda...",
  photo: "assets/profile.jpg",
  social: {
    github: "https://github.com/...",
    linkedin: "https://linkedin.com/in/...",
    email: "you@example.com"
  }
};

const SKILLS = [
  { name: "JavaScript", icon: "js", level: "advanced" },
  { name: "Python", icon: "python", level: "intermediate" },
  // ...
];

const PROJECTS = [
  {
    id: "devnotes",
    title: "DevNotes",
    description: "Aplikasi catatan teknis...",
    thumbnail: "assets/projects/devnotes.png",
    tags: ["Next.js", "Supabase"],
    demo: "https://...",
    repo: "https://github.com/..."
  },
  // ...
];

// Schema "message" untuk localStorage
{
  id: "msg-2026-06-03-001",
  name: "Pengirim",
  email: "sender@example.com",
  message: "isi pesan",
  receivedAt: "2026-06-03T10:00:00Z"
}
```

## 7. Constraints (Tech Stack — Hari 1)

| Layer | Pilihan |
|-------|---------|
| Markup | HTML5 semantic |
| Styling | CSS modern (Flexbox, Grid, custom properties). **Tidak pakai Tailwind/Bootstrap** untuk Hari 1 supaya fokus fundamental |
| Behavior | JavaScript vanilla (ES6+), no framework, no build tool |
| Icon | Inline SVG atau library CDN ringan (mis. lucide via `<script>`) |
| Font | Google Fonts via `<link>` |
| Image | Foto pribadi peserta (boleh placeholder dari unsplash.com kalau belum sempat foto) |

## 8. Success Criteria (akhir Hari 1)

Peserta lulus Hari 1 jika:

1. Website portfolio bisa dibuka di browser dengan **4 sections lengkap** (Hero, Skills, Projects, Contact).
2. **Project list** berisi minimal 3 project dengan data realistis (boleh project lama atau project fiksi yang dideskripsikan baik).
3. **Contact form** bisa di-submit, validasi jalan, pesan tersimpan di `localStorage`.
4. **Repo Git** dengan commit history (minimal 6 commit bermakna).
5. (Bonus) Deploy ke GitHub Pages / Netlify / Vercel — gratis dan cepat.

---

## 9. Wireframe (low-fidelity)

### Layout single-page (desktop)

```
┌──────────────────────────────────────────────────────────────┐
│  [Logo/Nama]            Home  Skills  Projects  Contact      │  ← Nav sticky
├──────────────────────────────────────────────────────────────┤
│                                                              │
│            [Foto]    Nama Anda                               │  ← Hero
│                      Full-Stack Developer                    │
│                      3 paragraf bio singkat tentang Anda... │
│                      [Hubungi Saya]  [Lihat Project]         │
│                                                              │
├──────────────────────────────────────────────────────────────┤
│  Skills                                                      │  ← Skills
│  ┌────┐ ┌────┐ ┌────┐ ┌────┐ ┌────┐ ┌────┐                  │
│  │ JS │ │ Py │ │ Go │ │SQL │ │Git │ │AWS │  ...             │
│  └────┘ └────┘ └────┘ └────┘ └────┘ └────┘                  │
├──────────────────────────────────────────────────────────────┤
│  Projects                                                    │  ← Projects
│  ┌──────────┐  ┌──────────┐  ┌──────────┐                   │
│  │[thumb]   │  │[thumb]   │  │[thumb]   │                   │
│  │ Title    │  │ Title    │  │ Title    │                   │
│  │ Deskripsi│  │ Deskripsi│  │ Deskripsi│                   │
│  │ [demo]   │  │ [demo]   │  │ [demo]   │                   │
│  │ [repo]   │  │ [repo]   │  │ [repo]   │                   │
│  └──────────┘  └──────────┘  └──────────┘                   │
├──────────────────────────────────────────────────────────────┤
│  Contact                                                     │  ← Contact
│  ┌────────────────────────────────────────────────────────┐ │
│  │  Nama:    [________________]                           │ │
│  │  Email:   [________________]                           │ │
│  │  Pesan:   [________________]                           │ │
│  │           [________________]                           │ │
│  │           [   Kirim Pesan   ]                          │ │
│  └────────────────────────────────────────────────────────┘ │
├──────────────────────────────────────────────────────────────┤
│  © 2026 Nama Anda · GitHub · LinkedIn · Email                │
└──────────────────────────────────────────────────────────────┘
```

### Toast sukses submit

```
        ┌─────────────────────────────────┐
        │ ✓ Pesan terkirim, terima kasih! │
        └─────────────────────────────────┘
                  (auto-hide 3 detik)
```

---

## 10. Catatan

- Foto profil: kalau peserta belum sempat siapkan foto, boleh pakai placeholder (mis. `https://i.pravatar.cc/300`).
- Data project: boleh diisi project nyata (kerjaan, hobi, capstone bootcamp) atau project fiksi yang dideskripsikan dengan baik.
- Style: tidak ada style "wajib". Peserta bebas eksplorasi via Cursor — minimal/brutalist, gradient modern, retro, dll. Yang penting **layout dan accessibility-nya benar**.
