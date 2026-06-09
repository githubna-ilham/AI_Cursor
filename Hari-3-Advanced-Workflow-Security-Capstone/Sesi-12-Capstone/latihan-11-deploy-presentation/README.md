# Latihan 11 — Auth + Deploy + Capstone Presentation

> 🗺️ **Tahap 29–30 dari 30** | Sebelumnya: Sesi 11 Business Dashboard | Setelah ini: **Selesai Hari 3**

**Durasi**: 90 menit
**Tipe**: Hands-on individual + 5' presentasi
**Output**: Aplikasi ter-deploy di Railway dengan auth + presentasi 5 menit.

---

## Konteks

Aplikasi Anda sudah cantik di localhost. Saatnya:
1. **Tambah auth** — supaya cuma tim internal yang akses
2. **Deploy** — supaya bisa diakses dari mana saja
3. **Presentasi** — tunjukkan hasil ke kelas

---

## Tujuan

Setelah latihan:

1. Install & konfigurasi Laravel Breeze
2. Proteksi route dengan middleware `auth`
3. Deploy aplikasi ke Railway (gratis)
4. Setup environment variables di production
5. Presentasi project 5 menit dengan struktur yang efektif

---

## Prasyarat

- Latihan 09 & 10 selesai (Dashboard Data Quality + Business jalan di localhost).
- Akun GitHub.
- Akun Railway (daftar gratis dengan GitHub).

---

## Langkah

### 1. Install Laravel Breeze (15')

```bash
composer require laravel/breeze --dev
php artisan breeze:install blade
# Saat ditanya Dark mode? → No

npm install
npm run build
php artisan migrate
```

Test:
```bash
php artisan serve
```

Buka `localhost:8000`:
- Klik "Register" → bisa daftar
- Login → redirect ke `/dashboard` (kosong default Breeze)

### 2. Seed User Awal (10')

Edit `database/seeders/DatabaseSeeder.php`:

```php
<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        User::firstOrCreate(
            ['email' => 'admin@multimatics.local'],
            [
                'name' => 'Admin Multimatics',
                'password' => Hash::make('password123'),
            ]
        );
    }
}
```

Jalankan:
```bash
php artisan db:seed
```

Test: login dengan `admin@multimatics.local` / `password123` → sukses.

### 3. Proteksi Route dengan Middleware (15')

Edit `routes/web.php`:

```php
use App\Http\Controllers\DataQualityController;
use App\Http\Controllers\ReportController;

Route::middleware('auth')->group(function () {
    Route::get('/data-quality',         [DataQualityController::class, 'index'])->name('dq.index');
    Route::get('/data-quality/{key}',   [DataQualityController::class, 'show'])->name('dq.show');

    Route::get('/reports/revenue',      [ReportController::class, 'revenue'])->name('reports.revenue');
    Route::get('/reports/customers',    [ReportController::class, 'topCustomers'])->name('reports.customers');
    Route::get('/reports/products',     [ReportController::class, 'topProducts'])->name('reports.products');
});
```

Test:
- Logout → akses `/data-quality` → redirect ke login ✓
- Login lagi → bisa akses dashboard ✓

### 4. Update Nav Menu (10')

Edit `resources/views/layouts/app.blade.php` — tambah info user + logout:

```blade
<nav class="bg-white shadow p-4 mb-6">
    <div class="container mx-auto flex justify-between items-center">
        <div class="flex gap-6 items-center">
            <span class="font-bold text-xl">📊 Multimatics</span>
            <a href="{{ route('dq.index') }}">Data Quality</a>
            <a href="{{ route('reports.revenue') }}">Revenue</a>
            <a href="{{ route('reports.customers') }}">Top Customer</a>
            <a href="{{ route('reports.products') }}">Top Product</a>
        </div>

        <div class="flex items-center gap-4 text-sm">
            <span>👤 {{ Auth::user()->name }}</span>
            <form method="POST" action="{{ route('logout') }}">
                @csrf
                <button type="submit" class="text-red-600 hover:underline">Logout</button>
            </form>
        </div>
    </div>
</nav>
```

`@csrf` adalah security token, **wajib** untuk form POST di Laravel.

### 5. Push ke GitHub (10')

```bash
git add .
git commit -m "feat(auth): add Laravel Breeze + protect routes"

# Bikin repo GitHub
gh repo create dashboard-app --public --source=. --remote=origin --push
```

Buka repo di GitHub, pastikan:
- ❌ `.env` **TIDAK ADA** di repo (cek `.gitignore`)
- ✅ `.env.example` ada
- ✅ `README.md` ada (boleh sederhana untuk sekarang)

### 6. Deploy ke Railway (25')

#### 6.1. Sign Up Railway

1. Buka <https://railway.app>
2. Sign up dengan GitHub
3. Authorize akses ke repo

#### 6.2. Buat Project Baru

1. **+ New Project** → **Deploy from GitHub repo**
2. Pilih repo `dashboard-app`
3. Railway otomatis deteksi Laravel → mulai build

Tunggu build selesai (~3-5 menit). Akan muncul error karena DB belum ada — itu wajar, kita setup di langkah berikut.

#### 6.3. Tambah MySQL Database

1. Di project, klik **+ New** → **Database** → **MySQL**
2. Tunggu provisioning (~1 menit)
3. Klik service MySQL → tab **Connect**
4. **Catat** credentials: host, port, database, username, password

#### 6.4. Import Schema + Data dari Local

Pakai DBeaver / mysql CLI:

```bash
# Export dari local
mysqldump -u root -p latihan_sql > latihan_sql.sql

# Import ke Railway (pakai connection string dari Railway dashboard)
mysql -h HOST -P PORT -u USER -p DATABASE < latihan_sql.sql
```

Atau di DBeaver: connect ke Railway MySQL → klik kanan → **Tools → Restore database** → pilih file `latihan_sql.sql`.

Verifikasi:
```sql
USE railway;  -- atau nama database dari Railway
SHOW TABLES;
-- harus muncul 9 tabel + 10 view
```

#### 6.5. Set Environment Variables

Di Railway project → klik service app → **Variables** → tambahkan:

```
APP_NAME=Multimatics Dashboard
APP_ENV=production
APP_DEBUG=false
APP_URL=https://${{RAILWAY_PUBLIC_DOMAIN}}
APP_KEY=base64:....

DB_CONNECTION=mysql
DB_HOST=${{MySQL.MYSQL_HOST}}
DB_PORT=${{MySQL.MYSQL_PORT}}
DB_DATABASE=${{MySQL.MYSQL_DATABASE}}
DB_USERNAME=${{MySQL.MYSQL_USER}}
DB_PASSWORD=${{MySQL.MYSQL_PASSWORD}}
```

Generate `APP_KEY` dari local:
```bash
php artisan key:generate --show
# Output: base64:XXXXX...
```

Copy ke Railway variable `APP_KEY`.

#### 6.6. Jalankan Migration + Seed di Production

Railway Shell:
```bash
php artisan migrate --force
php artisan db:seed --force
```

#### 6.7. Test Public URL

Buka URL Railway (mis. `https://dashboard-app-production.up.railway.app`):
- Halaman login muncul ✓
- Login dengan `admin@multimatics.local` / `password123` ✓
- Dashboard tampil dengan data ✓

🎉 **Aplikasi Anda sekarang live di internet!**

### 7. Persiapan Presentasi (5')

Siapkan struktur presentasi 5 menit:

| Menit | Bagian | Yang Dipresentasikan |
|-------|--------|----------------------|
| 0-1 | **Problem** | Apa masalah yang dashboard ini selesaikan (1-2 kalimat) |
| 1-3 | **Demo live** | Buka URL → login → tour 3-4 halaman utama |
| 3-4 | **Highlight teknis** | 1-2 keputusan teknis menarik (mis. refactor ke config, pakai Eloquent untuk view) |
| 4-5 | **Pelajaran** | 1 hal paling berharga yang dipelajari dengan AI Cursor |

Latih sekali sebelum tampil. Pastikan URL siap, login ready.

---

## Submit

`submissions/<nama>/`:
- `11_railway_url.md` — URL public + credentials login dummy
- `11_homepage.png` — screenshot login page production
- `11_dashboard.png` — screenshot dashboard production (setelah login)
- `11_github_repo.md` — link GitHub repo
- `refleksi.md` (≤300 kata):
  - 1 challenge terbesar selama 3 hari ini & cara mengatasinya
  - 1 hal yang akan Anda lakukan berbeda kalau mulai ulang
  - 3 next step yang akan Anda kerjakan di rumah untuk extend aplikasi ini

---

## Checklist Pre-Presentasi

Sebelum tampil:

- [ ] URL Railway aktif (test dari incognito browser)
- [ ] Login berhasil dengan user dummy
- [ ] Dashboard Data Quality tampil dengan T1 FAIL
- [ ] Drill-down 1 assertion bekerja
- [ ] Dashboard Revenue chart muncul
- [ ] Top Customer chart muncul
- [ ] Top Product tabel muncul
- [ ] Filter date range fungsional
- [ ] Logout bekerja
- [ ] Tidak ada error di console browser
- [ ] Repo GitHub publik dengan README
- [ ] `.env` **tidak** ter-commit (cek di repo)
- [ ] Note presentasi siap

---

## Tips Presentasi

| ✅ Lakukan | ❌ Hindari |
|-----------|-----------|
| Mulai dengan "problem yang dipecahkan" | Mulai dengan "saya pakai Laravel..." |
| Demo dari production URL | Demo dari localhost |
| Tunjuk 1-2 highlight teknis spesifik | Bahas semua technical detail |
| Latih sekali sebelum tampil | Improvise tanpa persiapan |
| Backup credentials di notes | Pasrah mengingat di tempat |
| Sebut nama orang yang membantu | Klaim semua sendirian |

---

## Common Issues

| Issue | Solusi |
|-------|--------|
| Railway build error "composer not found" | Cek `composer.json` valid — `composer validate` di local |
| 500 error di production | Cek Railway logs — biasanya `APP_KEY` belum diset |
| `Connection refused` ke MySQL Railway | Set env DB_* sesuai variable Railway MySQL service |
| Migration error "Foreign key" | Import schema lengkap dulu sebelum jalankan migration Breeze |
| Dashboard tampil tapi kosong | Data belum di-import — re-run `mysql < latihan_sql.sql` |
| Login berhasil tapi redirect ke 404 | Cek `php artisan optimize:clear` lalu deploy ulang |

---

## Selamat! 🎉

Anda telah menyelesaikan 3 hari pelatihan AI Cursor + Hari 3 menghasilkan **aplikasi web fungsional yang ter-deploy**.

Portofolio Anda sekarang:
- Day 1: Portfolio personal HTML/CSS/JS
- Day 2: SQL skills (Code Understanding, Debugging, Refactoring, Testing)
- Day 3: Full-stack Laravel app dengan auth + deploy

Ketiganya bisa di-mention di CV dan LinkedIn.

**Apa selanjutnya?** Lihat seksi "Setelah Hari 3" di [`materi-laravel.md`](../materi-laravel.md) Sesi 12 untuk ide pengembangan lanjutan.

---

## Lanjut Setelah Workshop

Saran skill yang bisa di-eksplor lebih lanjut:
- **Laravel Filament** (admin panel auto-generate)
- **Inertia + React/Vue** (SPA experience)
- **Laravel Vapor** (deploy serverless AWS)
- **Pest** (testing framework yang lebih modern dari PHPUnit)
- **Livewire 3** (reactive components tanpa JS framework)
