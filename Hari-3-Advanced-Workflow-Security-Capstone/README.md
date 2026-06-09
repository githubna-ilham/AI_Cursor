# HARI 3 — Build Dashboard dengan Laravel

**Penyelenggara**: Multimatics

Hari ke-3 pelatihan AI Cursor. Anda akan **membangun aplikasi web Laravel** yang menampilkan dashboard dari database `latihan_sql` (hasil kerja Hari 2). Project nyata, deploy-able, siap dipresentasikan.

> 📋 Detail 10 tahap, urutan kerja, dan checkpoint per tahap ada di [`perjalanan-project.md`](./perjalanan-project.md). **Baca file itu sebelum mulai latihan apa pun di Hari 3.**

---

## Lensa Hari 3: Dari Data ke Aplikasi

Hari 2 membangun fondasi data (schema, query, view). Hari 3 menambahkan **lapisan aplikasi** di atasnya: peserta menjadi konsumen view yang sudah dirancang.

Realita developer profesional:
- 70% kasus membangun aplikasi = wrapping logic SQL ke UI yang ramah user
- Hari 1 membangun UI tanpa data, Hari 2 mengelola data tanpa UI, Hari 3 menggabungkan keduanya.

---

## Stack

- **PHP 8.2+** + **Laravel 11** (framework)
- **Blade** (server-side templating)
- **Tailwind CSS** (styling)
- **Chart.js** (visualisasi chart, via CDN)
- **MySQL 8.0+** dengan database `latihan_sql` dari Hari 2

> 💡 Cara install termudah di Mac: **Laravel Herd** (bundle PHP + Composer + Node). Setup 5 menit.

---

## Output Akhir Hari 3

Aplikasi web Laravel dengan:

- **Dashboard Data Quality**: badge PASS/FAIL untuk 10 assertion + drill-down detail pelanggar
- **Dashboard Business**: chart revenue per bulan, top customer LTV, top product, filter date range
- **Auth sederhana**: login dengan email + password (Laravel Breeze)
- **Deploy**: aplikasi terakses publik via Railway / shared hosting / VPS
- **Presentasi**: demo 5 menit + dokumentasi setup

---

## Jadwal Harian (Acuan)

| Waktu          | Sesi                                                | Durasi |
| -------------- | --------------------------------------------------- | ------ |
| 08.30 – 09.00  | Registrasi & recap Hari 2                           | 30'    |
| 09.00 – 10.30  | **Sesi 9**: Setup Laravel + Connect MySQL           | 90'    |
| 10.30 – 10.45  | Coffee break                                        | 15'    |
| 10.45 – 12.15  | **Sesi 10**: Dashboard Data Quality                 | 90'    |
| 12.15 – 13.15  | ISHOMA                                              | 60'    |
| 13.15 – 14.45  | **Sesi 11**: Dashboard Business Metrics             | 90'    |
| 14.45 – 15.00  | Coffee break                                        | 15'    |
| 15.00 – 16.30  | **Sesi 12**: Auth + Deploy + Capstone presentation  | 90'    |
| 16.30 – 17.00  | Wrap-up & evaluasi pelatihan                        | 30'    |

---

## Struktur Folder

```
Hari-3-Advanced-Workflow-Security-Capstone/
├── README.md                                            <- file ini
├── perjalanan-project.md                                <- 10 tahap (BACA DULU)
├── Sesi-09-Advanced-Workflow/
│   ├── materi.md                                        <- versi lama (untuk referensi)
│   ├── materi-laravel.md                                <- Sesi 9 versi Laravel
│   └── latihan-08-git-workflow/                         <- Tahap 21-22 (setup + first page)
├── Sesi-10-Security-Ethics-Governance/
│   ├── materi.md                                        <- versi lama
│   ├── materi-laravel.md                                <- Sesi 10 (Data Quality Dashboard)
│   └── studi-kasus-kebocoran-data.md
├── Sesi-11-Best-Practices-Performance/
│   ├── materi.md                                        <- versi lama
│   └── materi-laravel.md                                <- Sesi 11 (Business Dashboard)
└── Sesi-12-Capstone/
    ├── materi-laravel.md                                <- Sesi 12 (Auth + Deploy)
    ├── opsi-project.md                                  <- versi lama
    ├── panduan-capstone.md                              <- versi lama
    ├── rubrik-penilaian.md                              <- versi lama
    └── template-presentasi.md
```

---

## Prasyarat Hari 3

- Telah menyelesaikan Hari 2 (database `latihan_sql` ada, schema + sample data + view assertion sudah di-apply).
- **PHP 8.2+** terinstall (via Laravel Herd / Homebrew).
- **Composer** terinstall (bundled di Herd).
- **MySQL** masih jalan dari Hari 2.
- Akun **Railway** atau **GitHub** (untuk deploy gratis).
- Cursor aktif.

Detail setup ada di materi Sesi 9.
