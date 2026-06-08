# HARI 2 — Code Understanding, Debugging & Refactoring (SQL Focus)

**Penyelenggara**: Multimatics

Hari ke-2 pelatihan AI Cursor. Anda akan **menerima codebase SQL** (schema e-commerce mini + ~25 query) dan menjadikannya bahan eksplorasi dengan **4 lensa berbeda** di 4 sesi.

> 📋 Detail 10 tahap, urutan kerja, dan checkpoint per tahap ada di [`perjalanan-project.md`](./perjalanan-project.md). **Baca file itu sebelum mulai latihan apa pun di Hari 2.**

---

## Pivot Pendekatan: SQL, Bukan Aplikasi

Hari 1 melatih **bikin dari nol** (portfolio HTML/CSS/JS + SQL prompting drill).
Hari 2 melatih **memahami yang sudah ada** — kenyataan kerja developer sehari-hari.

**Stack**: MySQL 8.0+ (atau MariaDB 10.5+) + GUI client pilihan.
**Tidak ada Next.js, tidak ada framework**. Murni SQL.

---

## Output Akhir Hari 2

Folder `submissions/<nama>/` berisi:

- **Sesi 5** (Tahap 11–12): 4–8 docstring query + ER diagram + architecture note
- **Sesi 6** (Tahap 13–15): 2–5 bug report dengan diagnose, fix, verifikasi
- **Sesi 7** (Tahap 16–17): 2–5 refactor before/after dengan bukti behaviour identik
- **Sesi 8** (Tahap 18–20): 5 assertion query baru + 1 peer review report

---

## Jadwal Harian (Acuan)

| Waktu          | Sesi                                  | Durasi |
| -------------- | ------------------------------------- | ------ |
| 08.30 – 09.00  | Registrasi & recap Hari 1             | 30'    |
| 09.00 – 10.30  | **Sesi 5**: Code Understanding         | 90'    |
| 10.30 – 10.45  | Coffee break                          | 15'    |
| 10.45 – 12.15  | **Sesi 6**: Debugging                  | 90'    |
| 12.15 – 13.15  | ISHOMA                                | 60'    |
| 13.15 – 14.45  | **Sesi 7**: Refactoring                | 90'    |
| 14.45 – 15.00  | Coffee break                          | 15'    |
| 15.00 – 16.30  | **Sesi 8**: Testing & Review           | 90'    |
| 16.30 – 17.00  | Wrap-up & briefing Hari 3             | 30'    |

---

## Struktur Folder

```
Hari-2-Code-Understanding-Debugging-Refactoring/
├── README.md                                          <- file ini
├── perjalanan-project.md                              <- 10 tahap (BACA DULU)
├── sql-playground/                                    <- codebase yang dipakai 4 sesi
│   ├── README.md                                      <- setup MySQL + apply schema
│   ├── 00_schema.sql                                  <- 9 tabel + RLS + index
│   ├── 01_sample_data.sql                             <- ~150 row realistic
│   └── queries/
│       ├── sesi-05-explore/                           <- 8 query untuk dipahami
│       ├── sesi-06-debug/                             <- 5 query bermasalah
│       ├── sesi-07-refactor/                          <- 5 query smelly
│       └── sesi-08-test/                              <- template assertion + contoh
├── Sesi-05-Code-Understanding-Documentation/
│   ├── materi.md
│   └── latihan-04-eksplorasi-codebase/                <- Tahap 11–12
├── Sesi-06-Debugging-Error-Analysis/
│   ├── materi.md
│   └── latihan-05-debugging-studi-kasus/              <- Tahap 13–15
├── Sesi-07-Refactoring-Code-Quality/
│   ├── materi.md
│   └── latihan-06-refactor-legacy/                    <- Tahap 16–17
└── Sesi-08-Testing-Code-Review/
    ├── materi.md
    └── latihan-07-testing-review/                     <- Tahap 18–20
```

---

## Prasyarat Hari 2

- Telah menyelesaikan Hari 1 (portfolio + SQL prompting drill familiar).
- **MySQL 8.0+** terinstall + GUI client (DBeaver / Workbench / Cursor Database Client extension).
- Cursor aktif, mode Ask & Cmd+K familiar.
- Tidak perlu install Node, Next.js, Supabase, atau apa pun lain.
