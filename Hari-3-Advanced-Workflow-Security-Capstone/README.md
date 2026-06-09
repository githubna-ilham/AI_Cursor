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

> 💡 Cara install termudah: **Laravel Herd** (tersedia untuk Mac & Windows) — bundle PHP + Composer + Node. Setup 5 menit.
> - Mac: <https://herd.laravel.com>
> - Windows: <https://herd.laravel.com/windows>

---

## Output Akhir Hari 3

Aplikasi web Laravel (jalan di lokal) dengan:

- **Dashboard Data Quality**: badge PASS/FAIL untuk 10 assertion + drill-down detail pelanggar
- **Dashboard Business**: chart revenue per bulan, top customer LTV, top product, filter date range
- **Auth sederhana**: login dengan email + password (Laravel Breeze)
- **Polish**: error handling minimal + validasi input form
- **Presentasi**: demo 5 menit + dokumentasi setup

> 💡 Deploy production (Railway / Hostinger / VPS) opsional dikerjakan di rumah setelah workshop selesai.

---

## Jadwal Harian (Acuan)

| Waktu          | Sesi                                                | Durasi |
| -------------- | --------------------------------------------------- | ------ |
| 08.30 – 09.00  | Registrasi & recap Hari 2                           | 30'    |
| 09.00 – 10.30  | **Sesi 9**: Security, Ethics & Governance (materi)  | 90'    |
| 10.30 – 10.45  | Coffee break                                        | 15'    |
| 10.45 – 12.15  | **Sesi 10**: Setup Laravel + Dashboard Data Quality | 90'    |
| 12.15 – 13.15  | ISHOMA                                              | 60'    |
| 13.15 – 14.45  | **Sesi 11**: Dashboard Business Metrics             | 90'    |
| 14.45 – 15.00  | Coffee break                                        | 15'    |
| 15.00 – 16.30  | **Sesi 12**: Auth + Capstone presentation          | 90'    |
| 16.30 – 17.00  | Wrap-up & evaluasi pelatihan                        | 30'    |

---

## Struktur Folder

```
Hari-3-Advanced-Workflow-Security-Capstone/
├── README.md                                            <- file ini
├── perjalanan-project.md                                <- 10 tahap (BACA DULU)
├── Sesi-09-Security-Ethics-Governance/                  <- Sesi 9: MATERI ONLY (no latihan)
│   └── materi.md                                        <- Security materi utama
├── Sesi-10-Setup-Laravel/                               <- Sesi 10: Setup + Data Quality Dashboard
│   ├── materi-laravel-1-setup.md                        <- Setup Laravel + Eloquent
│   ├── materi-laravel-2-data-quality.md                 <- Dashboard Data Quality
│   ├── latihan-08-laravel-setup/                        <- Tahap 21-22
│   └── latihan-09-data-quality-dashboard/               <- Tahap 23-25
├── Sesi-11-Best-Practices-Performance/                  <- Sesi 11: Business Dashboard
│   ├── materi-laravel.md
│   └── latihan-10-business-dashboard/                   <- Tahap 26-28
└── Sesi-12-Capstone/                                    <- Sesi 12: Auth + Capstone
    ├── materi-laravel.md
    ├── latihan-11-capstone-presentation/                <- Tahap 29-30
    └── (file capstone lama: opsi-project, panduan, rubrik, template)
```

---

## Prasyarat Hari 3

- Telah menyelesaikan Hari 2 (database `latihan_sql` ada, schema + sample data + view assertion sudah di-apply).
- **PHP 8.2+** terinstall:
  - **Mac**: Laravel Herd (<https://herd.laravel.com>) atau `brew install php@8.3`
  - **Windows**: Laravel Herd for Windows (<https://herd.laravel.com/windows>) atau XAMPP
- **Composer** terinstall (bundled di Herd).
- **MySQL** masih jalan dari Hari 2.
- Cursor aktif.
- (Opsional) Akun GitHub untuk backup repo.

> 💡 **Cursor shortcut**: di Mac pakai `Cmd+...`, di Windows pakai `Ctrl+...`. Mis. `Cmd+L` (Mac) = `Ctrl+L` (Windows) untuk buka Chat.

Detail setup ada di materi Sesi 10 (`materi-laravel-1-setup.md`).
