# Perjalanan Hari 3 — Security + Build Dashboard Laravel

Hari 3 dirancang sebagai **kombinasi 1 sesi konsep + 3 sesi build**: peserta belajar tanggung jawab keamanan & etika dulu (Sesi 9), kemudian membangun aplikasi Laravel yang konsumsi data Hari 2.

**Output akhir**: aplikasi Laravel yang jalan di lokal, siap dipresentasikan.

---

## Filosofi

Hari 1 = bangun UI tanpa data (portfolio static)
Hari 2 = kelola data tanpa UI (SQL playground)
Hari 3 = belajar **tanggung jawab** + **gabung keduanya** dalam aplikasi

Sesi 9 (Security) bukan side topic — itu pondasi etis sebelum bangun aplikasi yang akan dipakai user nyata.

---

## Stack & Tools

- **PHP 8.2+** + **Laravel 11**
- **Blade** + **Tailwind CSS** + **Chart.js** (via CDN)
- **MySQL** dari Hari 2 (database `latihan_sql`)
- **Cursor** untuk pengembangan dengan AI
- **Laravel Breeze** untuk auth

---

## Setup Sekali di Awal Hari 3

Sebelum Tahap 21, pastikan:

1. **PHP 8.2+** & **Composer** terinstall. Paling mudah: install **Laravel Herd** (gratis, tersedia untuk Mac & Windows):
   - Mac: <https://herd.laravel.com>
   - Windows: <https://herd.laravel.com/windows>

2. **MySQL** dari Hari 2 masih jalan dengan database `latihan_sql`.

3. **View Hari 2** sudah dibuat (`v_assertion_t1_*` sampai `v_assertion_t10_*`). Kalau belum, instruksi pembuatan view ada di `latihan-08-laravel-setup/README.md`.

---

## 10 Tahap Hari 3 (Tahap 21–30)

### 🛡️ Sesi 9 — Security, Ethics & Governance (Materi Only)

Tidak ada latihan teknis. Sesi ini diskusi konsep + studi kasus.

**Materi**: `Sesi-09-Security-Ethics-Governance/materi.md`

**Topik utama**:
- Risiko penggunaan AI coding assistant (data leakage, IP, hallucination, license, prompt injection)
- Etika penggunaan: atribusi, bias, ketergantungan, dampak lingkungan
- Governance framework: policy, training, provisioning, monitoring, review
- Studi kasus: pelajaran dari insiden kebocoran data publik

**Output**: refleksi tertulis tentang policy AI yang akan dibawa pulang ke organisasi peserta.

> 📝 Tidak ada tahap project di sini — fokus diskusi & refleksi.

---

### 🎯 Sesi 10 — Setup Laravel + Dashboard Data Quality

**Materi**: `Sesi-10-Setup-Laravel/materi-laravel-1-setup.md` + `materi-laravel-2-data-quality.md`

#### Tahap 21. Install + Scaffold Laravel
- Install Laravel Herd (jika belum)
- Bikin project Laravel baru: `laravel new dashboard-app`
- Setup `.env`: koneksi ke `latihan_sql`
- Run `php artisan serve` → halaman welcome jalan di `localhost:8000`

#### Tahap 22. Eloquent Model untuk View
- Buat 10 Model untuk view assertion (read-only)
- Buat Model untuk table customers, orders, products, order_items
- Smoke test di `tinker`: `App\Models\AssertionT1::count()`

#### Tahap 23. Halaman Index Dashboard Data Quality
- Route `/data-quality` → DataQualityController@index
- Tampilkan 10 badge: nama assertion + status PASS/FAIL + jumlah pelanggar
- Style dengan Tailwind: hijau untuk PASS, merah untuk FAIL

#### Tahap 24. Drill-down Detail
- Route `/data-quality/{id}` → tampilkan detail pelanggar per assertion
- Tabel sortable berdasarkan severity

#### Tahap 25. Refactor + Polish
- Pindah list assertion ke `config/dataquality.php`
- Tambah summary card di atas: "X / 10 PASS, Y / 10 FAIL"
- Pretty timestamp "last checked"

**Output Tahap 21–25**: Laravel project jalan + Dashboard Data Quality fungsional

**Latihan**: `latihan-08-laravel-setup/` (Tahap 21-22) + `latihan-09-data-quality-dashboard/` (Tahap 23-25)

---

### 🔐 Sesi 12 — Auth + Capstone Presentation

**Materi**: `Sesi-12-Capstone/materi-laravel.md`

#### Tahap 26. Auth dengan Laravel Breeze
- Install Breeze: `composer require laravel/breeze --dev && php artisan breeze:install blade`
- Protect routes `/dashboard/*` dengan middleware `auth`
- Bikin 1 user dummy di seeder
- Tambah info user + tombol logout di nav

#### Tahap 27. Polish + Presentasi
- Tambah validasi minimal di Controller
- Tampilkan error di Blade kalau validasi gagal
- Latih demo 5 menit: tour aplikasi + 1 keputusan teknis yang dipelajari
- Presentasi di kelas

**Output Tahap 26-27**: App lengkap di lokal, presentasi selesai

---

## Tracker Tahap

| Tahap | Sesi | Lensa | Output |
|-------|------|-------|--------|
| — | 9 | Konsep | Materi Security + diskusi (no tahap project) |
| 21 | 10 | Setup | Laravel + welcome page |
| 22 | 10 | Model | Model Eloquent siap |
| 23 | 10 | Dashboard | Badge status PASS/FAIL |
| 24 | 10 | Drill-down | Detail pelanggar per assertion |
| 25 | 10 | Refactor | Config terpusat + summary card |
| 26 | 12 | Auth | Login wajib untuk dashboard |
| 27 | 12 | Capstone | Polish + presentasi 5' |

---

## Kalau Anda Tertinggal

Hari 3 padat (Sesi 10 paling padat karena gabung Setup + Data Quality). Strategi prioritas:

- **Sesi 9**: ikuti diskusi penuh — ini fondasi etika, jangan skip.
- **Sesi 10**: minimum project Laravel jalan + dashboard Data Quality index (badge 1 assertion). Drill-down boleh skip kalau pendek waktu.
- **Sesi 12**: auth prioritas. Polish (error handling, validasi) boleh minimal kalau pendek waktu.

Yang penting: keluar dari Hari 3 dengan **aplikasi Laravel yang jalan di lokal** + **kesadaran etis** + 1 pengalaman ngoding bareng AI Cursor di Laravel.

---

## Setelah Hari 3

Anda akan punya:
- Aplikasi web fungsional yang dipresentasikan ke kolega/atasan
- Pengalaman end-to-end: design data (H2) → bangun app (H3) di lokal
- Skill AI-assisted Laravel development
- Kesadaran tanggung jawab penggunaan AI di organisasi
- Portofolio project nyata untuk CV / LinkedIn

Kombinasikan dengan portfolio Hari 1 dan SQL skill Hari 2 — itu profil developer yang lengkap.

**Lanjutan opsional di rumah**: deploy ke Railway/Hostinger/VPS untuk membuat dashboard bisa diakses online.
