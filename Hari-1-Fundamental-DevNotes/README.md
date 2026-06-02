# HARI 1 — Fundamental AI Cursor (Project: DevNotes Web Statis)

**Penyelenggara**: Multimatics
**Durasi**: 1 hari penuh (8 jam efektif, 4 sesi × 90 menit + break)
**Target peserta**: Developer profesional (Backend, Frontend, Full-Stack, DevOps, Data Engineer)
**Prasyarat**: Familiar dengan minimal 1 bahasa pemrograman, Git basic, terminal/CLI basic.
**Project akhir Hari 1**: Web statis **DevNotes** (HTML/CSS/JS vanilla) — feed publik + halaman detail + form new note dengan persistensi `localStorage`. Lihat BRD lengkap di [`/project-brd.md`](../project-brd.md).

---

## Tujuan Hari 1

Hari pertama membentuk **fondasi mental dan teknis** peserta sebelum masuk ke topik lanjutan di Hari 2 (BE Next.js + Supabase + Vercel) dan Hari 3 (FE Next.js terintegrasi BE). Fokusnya bukan "menulis kode lebih cepat", tetapi **mengubah cara berpikir** developer dalam berkolaborasi dengan AI sambil menghasilkan **artefak nyata** yang akan dilanjutkan 2 hari berikutnya:

1. Memahami posisi AI coding assistant dalam siklus pengembangan modern.
2. Menguasai Cursor sebagai IDE — bukan sekadar VS Code dengan ChatGPT.
3. Membangun keterampilan prompting yang reproducible dan context-aware.
4. Menghasilkan web statis DevNotes fungsional (FR-01, FR-02, FR-04 versi lokal) dengan kualitas yang dapat dipertanggungjawabkan.

---

## Learning Outcomes Hari 1

Setelah menyelesaikan Hari 1, peserta mampu:

- **Menjelaskan** perbedaan AI-assisted coding vs traditional coding beserta implikasi pada proses review dan testing.
- **Mempraktikkan** instalasi, konfigurasi, dan navigasi Cursor IDE pada mesin kerja masing-masing.
- **Menyusun** prompt yang efektif menggunakan teknik role-based, context-based, dan constraint-based dengan @-mentions.
- **Menghasilkan** sebuah fitur fungsional (CRUD sederhana) di stack pilihan menggunakan kombinasi Tab, Inline Edit (Cmd/Ctrl+K), dan Chat/Composer.
- **Mengevaluasi** output AI menggunakan kriteria correctness, security, dan maintainability.

---

## Alur Sesi

```mermaid
flowchart LR
    A[Sesi 1<br/>Introduction<br/>AI Coding] --> B[Sesi 2<br/>Getting Started<br/>Cursor]
    B --> C[Sesi 3<br/>Prompting &<br/>Context]
    C --> D[Sesi 4<br/>Code<br/>Generation]
    D --> E[Recap &<br/>Persiapan Hari 2]
```

| Sesi | Topik                              | Output Utama (kontribusi ke project DevNotes)                                 |
| ---- | ---------------------------------- | ----------------------------------------------------------------------------- |
| 1    | Introduction to AI-Assisted Coding | Pemahaman lanskap + diskusi adaptasi DevNotes ke konteks peserta              |
| 2    | Getting Started with Cursor        | Repo `devnotes/` ter-scaffold + `index.html` (feed publik dummy) — FR-01      |
| 3    | Prompting & Context Management     | `notes/[id].html` (halaman detail dengan markdown render) — FR-02             |
| 4    | Code Generation Fundamentals       | `new.html` + localStorage CRUD (create/edit/delete) — FR-04, FR-06 (lokal)    |

---

## Jadwal Harian (contoh, dapat disesuaikan)

| Waktu | Kegiatan | Durasi |
|-------|----------|--------|
| 08.30 – 09.00 | Registrasi & Pre-test singkat | 30' |
| 09.00 – 10.30 | **Sesi 1**: Introduction to AI-Assisted Coding | 90' |
| 10.30 – 10.45 | Coffee break | 15' |
| 10.45 – 12.15 | **Sesi 2**: Getting Started with Cursor (+ Lab 01) | 90' |
| 12.15 – 13.15 | Lunch | 60' |
| 13.15 – 14.45 | **Sesi 3**: Prompting & Context (+ Lab 02) | 90' |
| 14.45 – 15.00 | Coffee break | 15' |
| 15.00 – 16.30 | **Sesi 4**: Code Generation (+ Lab 03) | 90' |
| 16.30 – 17.00 | Recap, Q&A, briefing Hari 2 | 30' |

---

## Struktur Folder

```
Hari-1-Fundamental/
├── README.md                                  <- file ini
├── Sesi-01-Introduction-AI-Coding/
│   └── materi.md
├── Sesi-02-Getting-Started-Cursor/
│   ├── materi.md
│   ├── instalasi-checklist.md
│   └── latihan-01-tour-cursor/README.md
├── Sesi-03-Prompting-Context/
│   ├── materi.md
│   ├── prompting-cheatsheet.md
│   └── latihan-02-prompting-drill/README.md
└── Sesi-04-Code-Generation/
    ├── materi.md
    └── latihan-03-build-feature/README.md
```

---

## Catatan untuk Fasilitator

- Stack Hari 1 **fixed**: HTML + CSS + JavaScript vanilla (no build tool). Ini disepakati di BRD untuk membuat fundamental Cursor terisolasi dari kompleksitas framework. Migrasi ke Next.js terjadi di Hari 2 Sesi 7.
- Pastikan peserta sudah membaca [`/project-brd.md`](../project-brd.md) — minimal Section 1, 4, 5, 11 — sebelum latihan dimulai.
- Pastikan koneksi internet stabil — Cursor butuh akses ke model provider dan CDN (untuk `marked.js`).
- **Setiap latihan menambah file ke repo `devnotes/`** milik peserta. Repo ini akan dibawa ke Hari 2. Pastikan setiap peserta commit & (opsional) push ke GitHub di akhir hari.
- Setiap sesi diakhiri dengan **mini-checkpoint**: peserta menulis 1 hal yang dipelajari + 1 pertanyaan terbuka.
- Peserta yang sangat tertinggal di Sesi 2 boleh `git clone` referensi DevNotes (kalau fasilitator menyediakannya) — tapi catat & dorong untuk catch-up di luar jam.

---

## Persiapan Sebelum Hari 1

Peserta diharapkan datang dengan:

- Laptop dengan minimum RAM 8 GB, free disk 5 GB.
- Akun GitHub/GitLab aktif.
- Akun email kerja untuk login Cursor.
- Sudah membaca [cursor.com/docs/get-started](https://cursor.com/docs/get-started) (≈10 menit).

Lihat detail di `Sesi-02-Getting-Started-Cursor/instalasi-checklist.md`.
