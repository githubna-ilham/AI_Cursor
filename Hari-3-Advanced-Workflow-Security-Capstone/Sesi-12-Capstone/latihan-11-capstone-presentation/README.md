# Latihan 11 — Auth + Capstone Presentation

> 🗺️ **Tahap 29–30 dari 30** | Sebelumnya: Sesi 11 Business Dashboard | Setelah ini: **Selesai Hari 3**

**Durasi**: 90 menit
**Tipe**: Hands-on individual + 5' presentasi
**Output**: Aplikasi Laravel lengkap dengan auth, jalan di lokal, siap dipresentasikan.

---

## Konteks

Aplikasi Anda sudah fungsional. Saatnya:
1. **Tambah auth** — supaya cuma tim internal yang akses
2. **Polish** — error handling, validasi minimal supaya demo lancar
3. **Presentasi** — tunjukkan hasil ke kelas dalam 5 menit

---

## Tujuan

Setelah latihan:

1. Install & konfigurasi Laravel Breeze
2. Proteksi route dengan middleware `auth`
3. Menambah safeguard error handling
4. Presentasi project 5 menit dengan struktur yang efektif

---

## Prasyarat

- Latihan 09 & 10 selesai (Dashboard Data Quality + Business jalan di localhost).
- Database `latihan_sql` masih ada.

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

`@csrf` adalah security token Laravel — **wajib** untuk form POST.

### 5. Tambah Error Handling (10')

Edit `ReportController` — tambah validasi date range:

```php
public function revenue(Request $request)
{
    $request->validate([
        'from' => 'nullable|date',
        'to'   => 'nullable|date|after_or_equal:from',
    ]);

    $from = $request->input('from', '2025-01-01');
    $to   = $request->input('to', now()->format('Y-m-d'));

    // ... query existing
}
```

Edit Blade form revenue — tampilkan error:

```blade
@if($errors->any())
    <div class="bg-red-100 border border-red-300 p-3 rounded mb-4">
        @foreach($errors->all() as $error)
            <p>{{ $error }}</p>
        @endforeach
    </div>
@endif
```

Test: isi `to` lebih kecil dari `from` → error muncul.

### 6. Bikin Repo GitHub (Optional, 10')

Boleh skip kalau tidak punya akun GitHub.

```bash
git add .
git commit -m "feat: complete Laravel dashboard with auth"

# Bikin repo GitHub
gh repo create dashboard-app --public --source=. --remote=origin --push
```

⚠️ **Pastikan `.env` TIDAK ter-commit**. Cek `.gitignore`:
```bash
cat .gitignore | grep "^\.env$"
# harus muncul: .env
```

### 7. Persiapan Presentasi (10')

Siapkan struktur presentasi 5 menit:

| Menit | Bagian | Yang Dipresentasikan |
|-------|--------|----------------------|
| 0-1 | **Problem** | Apa masalah yang dashboard ini selesaikan (1-2 kalimat) |
| 1-3 | **Demo live** | `php artisan serve` → login → tour 3-4 halaman utama |
| 3-4 | **Highlight teknis** | 1-2 keputusan teknis menarik (mis. refactor ke config, pakai Eloquent untuk view) |
| 4-5 | **Pelajaran** | 1 hal paling berharga yang dipelajari dengan AI Cursor |

**Latih sekali sebelum tampil.** Pastikan:
- Server jalan
- Login ready (user dummy siap)
- Note presentasi terbuka di sebelah browser

### 8. Presentasi (5')

Tampil. Audience: peserta lain + fasilitator. Format informal, tanya jawab di akhir.

---

## Submit

`submissions/<nama>/`:
- `11_login.png` — screenshot halaman login
- `11_dashboard.png` — screenshot dashboard setelah login (dengan info user di nav)
- `11_error_demo.png` — screenshot validasi error muncul saat isi date salah
- `refleksi.md` (≤300 kata):
  - 1 challenge terbesar selama 3 hari ini & cara mengatasinya
  - 1 hal yang akan Anda lakukan berbeda kalau mulai ulang
  - 3 next step yang akan Anda kerjakan di rumah untuk extend aplikasi ini

---

## Checklist Pre-Presentasi

Sebelum tampil:

- [ ] `php artisan serve` jalan di `localhost:8000`
- [ ] Login berhasil dengan user dummy
- [ ] Dashboard Data Quality tampil dengan T1 FAIL
- [ ] Drill-down 1 assertion bekerja
- [ ] Dashboard Revenue chart muncul
- [ ] Top Customer chart muncul
- [ ] Top Product tabel muncul
- [ ] Filter date range fungsional
- [ ] Validasi error berfungsi (test kirim `to` < `from`)
- [ ] Logout bekerja
- [ ] Tidak ada error 500 di happy path
- [ ] Note presentasi siap

---

## Tips Presentasi

| ✅ Lakukan | ❌ Hindari |
|-----------|-----------|
| Mulai dengan "problem yang dipecahkan" | Mulai dengan "saya pakai Laravel..." |
| Demo nyata dari aplikasi | Bahas teori panjang tanpa demo |
| Tunjuk 1-2 highlight teknis spesifik | Bahas semua technical detail |
| Latih sekali sebelum tampil | Improvise tanpa persiapan |
| Sebut bantuan AI Cursor dengan spesifik | Klaim "AI yang bikin semuanya" |
| Jujur tentang kesulitan & solusi | Pura-pura semua mudah |

---

## Common Issues

| Issue | Solusi |
|-------|--------|
| Breeze migration error "table users exists" | `php artisan migrate:fresh --seed` (⚠️ hapus semua data, hanya untuk dev) |
| Login berhasil tapi redirect ke 404 | Cek `php artisan optimize:clear` lalu coba lagi |
| Form CSRF error 419 | Pastikan ada `@csrf` di setiap `<form method="POST">` |
| `Class App\Models\User not found` | Re-install Breeze: `composer require laravel/breeze --dev` |
| Server lambat saat demo | Clear cache: `php artisan optimize:clear` |
| Style Breeze conflict dengan Tailwind kustom | Cek `resources/css/app.css` — comment yang tidak perlu |

---

## Selamat! 🎉

Anda telah menyelesaikan 3 hari pelatihan AI Cursor + Hari 3 menghasilkan **aplikasi web fungsional**.

Portofolio Anda sekarang:
- **Day 1**: Portfolio personal HTML/CSS/JS
- **Day 2**: SQL skills (Code Understanding, Debugging, Refactoring, Testing)
- **Day 3**: Full-stack Laravel app dengan auth

Ketiganya bisa di-mention di CV dan LinkedIn.

---

## Lanjut Setelah Workshop (Optional)

Saran skill yang bisa di-eksplor lebih lanjut:

**Deploy production**:
- **Railway** (gratis tier) — push GitHub → otomatis deploy
- **Hostinger / Niagahoster** — shared hosting Indonesia, support Laravel
- **VPS** (DigitalOcean, AWS Lightsail) — full control

**Feature lanjutan**:
- **Laravel Filament** (admin panel auto-generate)
- **CRUD UI** — pelanggan bisa di-tambah/edit dari aplikasi
- **Export PDF / Excel** — dashboard bisa di-download
- **Notifikasi email** saat assertion FAIL
- **Role-based auth** (admin vs viewer)
- **Real-time** dengan Laravel Echo + Pusher

**Testing**:
- **Pest** atau **PHPUnit** — unit test Controller + Model
- **Dusk** — browser test end-to-end
