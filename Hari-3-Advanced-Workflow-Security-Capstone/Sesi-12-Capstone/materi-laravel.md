# Sesi 12 (Laravel) — Auth + Deploy + Capstone

Durasi: 90 menit

## Bayangkan Skenario Ini

Dashboard Anda sudah cantik di laptop. Tapi atasan minta: *"Saya mau cek dari HP saat di lapangan, dan tim finance juga butuh akses. Tapi tidak boleh dibuka publik — data internal."*

Anda butuh **2 hal**:
1. **Auth**: hanya user terdaftar yang bisa akses
2. **Deploy**: aplikasi terakses dari internet (bukan cuma localhost)

Sesi 12 melatih kedua hal tersebut + presentasi akhir.

---

## Yang Akan Anda Pelajari

1. Install Laravel Breeze untuk auth instant
2. Proteksi route dengan middleware `auth`
3. Bikin user awal via seeder
4. Deploy ke Railway (gratis untuk hobby tier)
5. Pengaturan environment variables di production
6. Tips presentasi project teknis

---

## 1. Auth dengan Laravel Breeze

**Laravel Breeze** = paket auth instant. Sekali install, langsung dapat:
- Halaman login
- Halaman register
- Halaman forgot password
- Halaman dashboard (kosong, untuk diisi)
- Middleware `auth` siap pakai

### Install

```bash
composer require laravel/breeze --dev

php artisan breeze:install blade
# Saat ditanya: Dark mode? → No (kecuali Anda mau)

npm install && npm run build
```

Migrasi tabel `users`:

```bash
php artisan migrate
```

> ⚠️ Migration akan **bikin tabel `users`** di `latihan_sql`. Tabel sudah punya ada `customers` — `users` adalah tabel terpisah khusus auth.

### Cek Hasil

```bash
php artisan serve
```

Buka `http://localhost:8000`:
- Klik "Login" → form login muncul
- Klik "Register" → bisa daftar user baru
- Setelah login → redirect ke `/dashboard` (kosong, default Breeze)

### Bikin User Awal via Seeder

`database/seeders/DatabaseSeeder.php`:

```php
use App\Models\User;
use Illuminate\Support\Facades\Hash;

public function run(): void
{
    User::create([
        'name' => 'Admin Multimatics',
        'email' => 'admin@multimatics.local',
        'password' => Hash::make('password123'),
    ]);
}
```

Jalankan:
```bash
php artisan db:seed
```

Sekarang bisa login dengan `admin@multimatics.local` / `password123`.

---

## 2. Proteksi Route dengan Middleware

Tanpa proteksi, siapapun yang tahu URL bisa lihat dashboard. Tambah middleware `auth`:

`routes/web.php`:

```php
Route::middleware('auth')->group(function () {
    Route::get('/data-quality',         [DataQualityController::class, 'index'])->name('dq.index');
    Route::get('/data-quality/{key}',   [DataQualityController::class, 'show'])->name('dq.show');

    Route::get('/reports/revenue',      [ReportController::class, 'revenue'])->name('reports.revenue');
    Route::get('/reports/customers',    [ReportController::class, 'topCustomers'])->name('reports.customers');
    Route::get('/reports/products',     [ReportController::class, 'topProducts'])->name('reports.products');
});
```

Sekarang akses `/data-quality` tanpa login → redirect ke `/login`.

### Tambah Logout & Info User di Nav

`resources/views/layouts/app.blade.php`:

```blade
<nav class="bg-white shadow p-4">
    <div class="container mx-auto flex justify-between items-center">
        <div class="flex gap-6">
            <a href="{{ route('dq.index') }}" class="font-semibold">Data Quality</a>
            <a href="{{ route('reports.revenue') }}">Revenue</a>
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

`@csrf` adalah security token Laravel — wajib untuk form POST.

---

## 3. Deploy ke Railway

**Railway** adalah platform deploy gratis untuk hobby (5$/bulan kredit, biasanya cukup untuk dashboard kecil). Support PHP + MySQL out of the box.

### Persiapan: Push ke GitHub

```bash
# Di folder project
git init
git add .
git commit -m "Initial commit: Laravel dashboard"

# Bikin repo baru di GitHub (via web atau gh CLI)
gh repo create dashboard-app --public --source=. --remote=origin --push
```

### Setup Railway

1. Buka <https://railway.app> → Sign up dengan GitHub
2. Klik **New Project** → **Deploy from GitHub repo**
3. Pilih repo `dashboard-app` → Deploy

Railway otomatis detect Laravel.

### Add MySQL Service

1. Di project Railway, klik **+ New** → **Database** → **MySQL**
2. Railway buat instance MySQL terpisah
3. **Copy connection string** (mis. `mysql://user:pass@host:port/dbname`)

### Import Data dari Local

Karena database production beda dengan local, perlu import schema + data:

```bash
# Export dari local
mysqldump -u root -p latihan_sql > latihan_sql.sql

# Import ke Railway (pakai connection string)
mysql -h HOST -P PORT -u USER -p DATABASE < latihan_sql.sql
```

Atau pakai GUI seperti DBeaver: connect ke Railway MySQL → execute `latihan_sql.sql`.

### Konfigurasi Environment di Railway

Di Project Settings → Variables:

```
APP_NAME=Multimatics Dashboard
APP_ENV=production
APP_DEBUG=false
APP_URL=https://your-app.up.railway.app

DB_CONNECTION=mysql
DB_HOST=<dari Railway>
DB_PORT=<dari Railway>
DB_DATABASE=<dari Railway>
DB_USERNAME=<dari Railway>
DB_PASSWORD=<dari Railway>

APP_KEY=<generate dengan: php artisan key:generate --show>
```

`APP_KEY` wajib di production — generate dari local, copy ke Railway.

### Run Migration di Railway

Setelah deploy, jalankan via Railway shell:
```bash
php artisan migrate --force
php artisan db:seed --force
```

### Test

Buka URL `https://your-app.up.railway.app`. Login dengan user yang di-seed. Lihat dashboard online.

---

## 4. Environment Variables: Security

**Aturan emas**: credential & secret **tidak boleh** di-commit ke git.

| File | Di-commit? | Isi |
|------|-----------|-----|
| `.env` | ❌ TIDAK | DB password, API keys, secret tokens |
| `.env.example` | ✅ YA | Template tanpa nilai sensitif |
| `config/*.php` | ✅ YA | Pakai `env('KEY')`, bukan hardcode |

Cek `.gitignore` — `.env` harus ada di sana (Laravel default sudah mengatur).

```bash
# Cek
cat .gitignore | grep .env
# → .env
```

Kalau tidak ada, **tambahkan sekarang**.

---

## 5. Optimasi Production

Sebelum deploy, jalankan optimasi:

```bash
# Cache config (jadi lebih cepat startup)
php artisan config:cache

# Cache route
php artisan route:cache

# Cache view Blade
php artisan view:cache

# Compile asset
npm run build
```

Saat ada perubahan code, clear cache:
```bash
php artisan optimize:clear
```

Untuk Railway, jalankan ini saat deploy via **Build Command**:
```
composer install --no-dev && php artisan config:cache && npm run build
```

---

## 6. Tips Presentasi Project Teknis

Anda akan presentasi 5 menit di akhir Sesi 12. Berikut struktur efektif:

### Struktur 5 Menit

| Menit | Bagian | Yang Dipresentasikan |
|-------|--------|----------------------|
| 0-1 | **Problem statement** | Masalah apa yang dashboard ini selesaikan |
| 1-3 | **Demo live** | Buka URL → login → tour 3 halaman utama |
| 3-4 | **Highlight teknis** | 1-2 keputusan teknis yang menarik |
| 4-5 | **Pelajaran & next step** | Apa yang Anda pelajari + apa rencana lanjutan |

### Yang Bagus untuk Disebut

- "Saya pakai Eloquent untuk read view SQL tanpa nulis raw query lagi"
- "Saya pisah konfigurasi list assertion ke `config/dataquality.php` supaya nambah test tinggal edit 1 file"
- "Saya pakai Cache untuk query yang complex, refresh tiap 5 menit"
- "Saya proteksi route dengan middleware auth, jadi cuma tim internal yang akses"

### Yang Hindari

- "Saya buat dashboard pakai Laravel" (terlalu generic, tidak insightful)
- Demo 5 menit tanpa narasi (audience bingung)
- Buka code editor selama presentasi (kecuali ada 1 highlight spesifik)
- Membahas teknis terlalu detail (audience non-teknis cape)

---

## 7. Capstone Checklist

Sebelum presentasi, pastikan:

- [ ] Aplikasi terdeploy & URL Railway aktif
- [ ] Login pakai user dummy yang sudah dibuat
- [ ] Dashboard Data Quality: 10 badge tampil dengan T1 FAIL
- [ ] Drill-down 1 assertion bekerja
- [ ] Dashboard Revenue: chart line muncul
- [ ] Top Customer: chart bar muncul
- [ ] Filter date range fungsional
- [ ] Layout konsisten (nav + footer di semua halaman)
- [ ] Logout bekerja
- [ ] Repo GitHub publik dengan README jelas
- [ ] Tidak ada `.env` ter-commit
- [ ] Slide / notes presentasi siap

---

## 8. Anti-Pattern Capstone

| ❌ Hindari | ✅ Lakukan |
|-----------|-----------|
| Demo dari localhost | Demo dari URL production |
| `.env` ter-push ke GitHub | Verifikasi `.gitignore` |
| README kosong di GitHub | README minimal: 1 paragraf + cara setup |
| Hardcode credential di code | Selalu pakai `env('KEY')` |
| Tidak ada error handling | Minimal try-catch untuk query critical |
| Database production = development | Backup sebelum demo |

---

## 9. Setelah Hari 3

Anda akan punya:

1. **Aplikasi web fungsional** ter-deploy
2. **Repo GitHub** dengan README jelas (showcase di CV)
3. **Pengalaman end-to-end**: design data (H2) → bangun app (H3) → deploy
4. **Skill AI-pair-programming** di Laravel

Lanjutan yang bisa Anda kerjakan sendiri di rumah:

- Tambah CRUD: pelanggan bisa di-tambah/edit dari UI
- Export PDF / Excel: dashboard bisa di-download
- Notifikasi email saat assertion FAIL
- Role-based auth: admin vs viewer
- Real-time update dengan Laravel Echo + Pusher

---

## Demo Live (15 menit)

Bareng fasilitator:

1. Install Breeze → ada login page
2. Migrate + seed → ada user admin
3. Pasang middleware `auth` di route grup
4. Tes: logout → akses `/data-quality` → redirect login
5. Push ke GitHub
6. Deploy ke Railway: connect repo + MySQL service + env variables
7. Import schema + data ke MySQL Railway
8. Akses URL public → login → dashboard online ✓

---

## Lanjut ke Latihan

[`latihan-11-deploy-presentation/`](./latihan-11-deploy-presentation/)

---

## Ringkasan 1 Halaman

- **Laravel Breeze** = auth instant (login, register, middleware `auth`).
- **Middleware `auth`** di route → otomatis redirect ke login kalau belum login.
- **Seeder** untuk bikin user awal.
- **`.env` tidak di-commit**. Gunakan `env('KEY')` di code, set value di Railway dashboard.
- **Deploy Railway**: push ke GitHub → connect repo → add MySQL → set env → done.
- **Optimasi production**: `config:cache`, `route:cache`, `view:cache`, `npm run build`.
- **Capstone presentasi 5'**: problem (1') + demo (2') + highlight teknis (1') + pelajaran (1').
- **Aturan emas**: tidak ada credential ter-commit, demo dari production URL.
