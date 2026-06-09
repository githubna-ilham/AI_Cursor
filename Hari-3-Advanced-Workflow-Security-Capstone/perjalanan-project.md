# Perjalanan Hari 3 — Build Dashboard Laravel

Hari 3 dirancang sebagai **satu perjalanan linear** membangun aplikasi web Laravel yang menampilkan dashboard dari database `latihan_sql` (hasil Hari 2). Tiap tahap menambah satu kemampuan baru ke aplikasi yang sama.

**Output akhir**: aplikasi Laravel yang ter-deploy, bisa diakses publik, siap dipresentasikan.

---

## Filosofi

Hari 1 = bangun UI tanpa data (portfolio static)
Hari 2 = kelola data tanpa UI (SQL playground)
Hari 3 = **gabung keduanya** (Laravel app yang baca data)

Ini representasi realistis kerja developer profesional: 70% kasus adalah wrapping logic SQL ke UI yang ramah user.

---

## Stack & Tools

- **PHP 8.2+** + **Laravel 11**
- **Blade** + **Tailwind CSS** + **Chart.js** (via CDN)
- **MySQL** dari Hari 2 (database `latihan_sql`)
- **Cursor** untuk pengembangan dengan AI
- **Laravel Breeze** untuk auth
- **Railway / shared hosting** untuk deploy

---

## Setup Sekali di Awal Hari 3

Sebelum Tahap 21, pastikan:

1. **PHP 8.2+** & **Composer** terinstall (paling mudah: install Laravel Herd dari https://herd.laravel.com — gratis).
2. **MySQL** dari Hari 2 masih jalan dengan database `latihan_sql`.
3. **View Hari 2** sudah dibuat (`v_assertion_t1_*` sampai `v_assertion_t10_*`). Kalau belum, jalankan SQL berikut di MySQL:

```sql
USE latihan_sql;

-- 10 view untuk assertion
CREATE OR REPLACE VIEW v_assertion_t1_subtotal_mismatch AS
SELECT o.id AS order_id, o.subtotal AS header_subtotal,
       COALESCE(SUM(oi.line_total), 0) AS detail_sum,
       o.subtotal - COALESCE(SUM(oi.line_total), 0) AS difference
FROM orders o LEFT JOIN order_items oi ON oi.order_id = o.id
GROUP BY o.id, o.subtotal
HAVING o.subtotal <> COALESCE(SUM(oi.line_total), 0);

-- (8 view T2-T10 mirip pola di atas — lihat materi Sesi 9)
```

4. Akun **Railway** atau **GitHub** untuk deploy nanti.

Kalau setup lulus, Anda siap mulai Tahap 21.

---

## 10 Tahap Hari 3 (Tahap 21–30)

### 🎯 Sesi 9 — Setup + Foundation

**Latihan 08** · `Hari-3-.../Sesi-09-.../latihan-08-laravel-setup/`

#### Tahap 21. Install + Scaffold Laravel
- Install Laravel Herd (jika belum)
- Bikin project Laravel baru: `laravel new dashboard-app`
- Setup `.env`: koneksi ke `latihan_sql`
- Run `php artisan serve` → halaman welcome jalan di `localhost:8000`

#### Tahap 22. Eloquent Model untuk View
- Buat 10 Model untuk view assertion (read-only)
- Buat 1 Model untuk view reporting (mis. monthly revenue)
- Smoke test di `tinker`: `App\Models\AssertionT1::count()`

**Output Tahap 21-22**: Laravel project jalan, koneksi MySQL OK, 11 Model siap dipakai

---

### 🚨 Sesi 10 — Dashboard Data Quality

**Latihan 09** · `Hari-3-.../Sesi-10-.../latihan-09-data-quality-dashboard/`

#### Tahap 23. Halaman Index Dashboard
- Route `/data-quality` → DataQualityController@index
- Tampilkan 10 badge: nama assertion + status PASS/FAIL + jumlah pelanggar
- Style dengan Tailwind: hijau untuk PASS, merah untuk FAIL

#### Tahap 24. Drill-down Detail
- Route `/data-quality/{id}` → tampilkan detail pelanggar per assertion
- Tabel sortable berdasarkan severity
- Link "Back" ke index

#### Tahap 25. Auto-Refresh & Polish
- Tambah tombol "Refresh" yang jalankan ulang assertion
- Tambah summary card di atas: "X / 10 PASS, Y / 10 FAIL"
- Pretty timestamp "last checked"

**Output Tahap 23-25**: Dashboard Data Quality fungsional dengan drill-down

---

### 📊 Sesi 11 — Dashboard Business Metrics

**Latihan 10** · `Hari-3-.../Sesi-11-.../latihan-10-business-dashboard/`

#### Tahap 26. Chart Revenue Trend
- Route `/reports/revenue` → tampilkan line chart revenue per bulan
- Pakai Chart.js (CDN) + data dari view reporting
- Filter date range (date picker)

#### Tahap 27. Top Customer LTV + Top Product
- Halaman terpisah atau gabung dengan revenue
- Bar chart top 10 customer berdasarkan total spending
- Tabel top 5 product per kategori
- Filter berdasarkan tier customer

#### Tahap 28. Layout & Navigation
- Buat layout master Blade dengan nav menu
- Sidebar: Data Quality | Reports | (kosong nanti untuk Admin)
- Konsistensi warna, font, spacing dengan Tailwind

**Output Tahap 26-28**: Dashboard business + layout konsisten

---

### 🔐 Sesi 12 — Auth + Capstone Presentation

**Latihan 11** · `Hari-3-.../Sesi-12-.../latihan-11-capstone-presentation/`

#### Tahap 29. Auth dengan Laravel Breeze
- Install Breeze: `composer require laravel/breeze --dev && php artisan breeze:install blade`
- Protect routes `/data-quality/*` dan `/reports/*` dengan middleware `auth`
- Bikin 1 user dummy di seeder
- Tambah info user + tombol logout di nav

#### Tahap 30. Polish + Presentasi
- Tambah validasi date range di Controller (`$request->validate`)
- Tampilkan error di Blade kalau validasi gagal
- Latih demo 5 menit: tour aplikasi + 1 keputusan teknis yang dipelajari
- Presentasi di kelas

**Output Tahap 29-30**: App lengkap di lokal, presentasi selesai

---

## Tracker Tahap

| Tahap | Sesi | Lensa | Output |
|-------|------|-------|--------|
| 21 | 9 | Setup | Laravel + welcome page |
| 22 | 9 | Model | 11 Model Eloquent siap |
| 23 | 10 | Dashboard | 10 badge status PASS/FAIL |
| 24 | 10 | Drill-down | Detail pelanggar per assertion |
| 25 | 10 | Polish | Refresh button + summary |
| 26 | 11 | Chart | Revenue trend + filter |
| 27 | 11 | Chart | Top customer + product |
| 28 | 11 | UX | Layout + nav menu |
| 29 | 12 | Auth | Login wajib untuk dashboard |
| 30 | 12 | Capstone | Polish + presentasi 5' |

---

## Kalau Anda Tertinggal

Hari 3 padat. Strategi prioritas:

- **Sesi 9**: minimum project Laravel jalan, koneksi MySQL OK, 1 Model siap.
- **Sesi 10**: minimum dashboard index dengan badge PASS/FAIL. Drill-down boleh skip kalau pendek waktu.
- **Sesi 11**: minimum 1 chart (revenue trend). Top customer & product boleh dilanjut di rumah.
- **Sesi 12**: auth prioritas. Polish (error handling, validasi) boleh minimal kalau pendek waktu.

Yang penting: keluar dari Hari 3 dengan **aplikasi Laravel yang jalan di lokal** + 1 pengalaman ngoding bareng AI Cursor di Laravel.

---

## Setelah Hari 3

Anda akan punya:
- Aplikasi web fungsional yang dipresentasikan ke kolega/atasan
- Pengalaman end-to-end: SQL design → app dev (di lokal)
- Skill AI-assisted Laravel development
- Portofolio project nyata untuk CV / LinkedIn

Kombinasikan dengan portfolio Hari 1 dan SQL skill Hari 2 — itu profil developer yang lengkap.

**Lanjutan opsional di rumah**: deploy ke Railway/Hostinger/VPS untuk membuat dashboard bisa diakses online.
