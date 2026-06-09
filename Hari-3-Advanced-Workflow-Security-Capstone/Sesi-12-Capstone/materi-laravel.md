# Sesi 12 (Laravel) — Auth + Capstone Presentation

Durasi: 90 menit

## Bayangkan Skenario Ini

Dashboard Anda sudah cantik dan fungsional. Tapi atasan minta: *"Jangan dibuka publik — data internal. Tambah login dulu sebelum dipakai. Nanti besok demo ke tim finance."*

Anda butuh **2 hal**:
1. **Auth**: hanya user terdaftar yang bisa akses
2. **Polish**: pastikan demo besok lancar

Sesi 12 melatih kedua hal tersebut + presentasi capstone akhir pelatihan.

---

## Yang Akan Anda Pelajari

1. Install Laravel Breeze untuk auth instant
2. Proteksi route dengan middleware `auth`
3. Bikin user awal via seeder
4. Polish final aplikasi (error handling, validasi minimal)
5. Tips presentasi project teknis 5 menit

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

> ⚠️ Migration akan **bikin tabel `users`** di `latihan_sql`. Tabel ini terpisah dari `customers` — `users` khusus untuk auth admin/internal.

### 💡 Tips: Ganti Session Driver ke `file` (Opsional)

Laravel 11 default pakai **session driver `database`** — session disimpan di tabel `sessions` di DB. Untuk workshop ini, lebih praktis pakai driver `file`:

```bash
# Edit .env
SESSION_DRIVER=file
```

**Kenapa file driver untuk workshop?**

| Aspek | Database (default) | File |
|-------|---------------------|------|
| Setup tabel `sessions` | Wajib (lewat migration) | Tidak perlu |
| Lokasi simpan | DB | `storage/framework/sessions/` |
| Query DB tiap request | Ya (overhead kecil) | Tidak |
| Cocok untuk | Multi-server, scaling | Single server / dev / workshop |

**Kapan harus pakai database driver?**
- Aplikasi production dengan multi-server / load balancer
- Aplikasi yang butuh session share antar server

**Kapan file aman?**
- Single server (workshop, demo, app kecil) — **kasus kita**
- Lokal development

> ⚠️ **Catatan permission**: pastikan folder `storage/framework/sessions/` writable. Di Mac/Linux: `chmod -R 775 storage/`. Di Windows biasanya OK by default.

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
    User::firstOrCreate(
        ['email' => 'admin@multimatics.local'],
        [
            'name' => 'Admin Multimatics',
            'password' => Hash::make('password123'),
        ]
    );
}
```

Jalankan:
```bash
php artisan db:seed
```

Sekarang bisa login dengan `admin@multimatics.local` / `password123`.

`firstOrCreate` aman dijalankan berulang — kalau email sudah ada, tidak akan duplikasi.

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

`@csrf` adalah security token Laravel — wajib untuk form POST.

---

## 3. Environment Variables: Security

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

## 4. Optimasi Sebelum Demo

Sebelum demo ke kelas, jalankan optimasi supaya aplikasi terasa snappy:

```bash
# Cache config (jadi lebih cepat startup)
php artisan config:cache

# Cache route
php artisan route:cache

# Cache view Blade
php artisan view:cache
```

Saat ada perubahan code setelah cache, clear dulu:
```bash
php artisan optimize:clear
```

Untuk demo workshop, **clear dulu** kalau Anda masih mungkin edit code:
```bash
php artisan optimize:clear
```

Cache cocok untuk **state stabil** (mis. produksi atau demo akhir).

---

## 5. Error Handling Minimal

Saat demo, error 500 di tengah-tengah = jelek. Tambah safeguard di Controller:

```php
public function show($key)
{
    try {
        $tests = config('dataquality.tests');

        if (!isset($tests[$key])) {
            abort(404, 'Assertion tidak ditemukan.');
        }

        $rows = $tests[$key]['model']::limit(50)->get();

        return view('data-quality.show', compact('key', 'rows'));

    } catch (\Exception $e) {
        \Log::error('Gagal load assertion detail: ' . $e->getMessage());
        return view('errors.generic', ['message' => 'Tidak dapat memuat data saat ini. Silakan coba lagi.']);
    }
}
```

Bikin view sederhana untuk error generic:

`resources/views/errors/generic.blade.php`:
```blade
@extends('layouts.app')

@section('content')
    <div class="bg-yellow-100 p-6 rounded-lg">
        <h2 class="font-bold text-lg">⚠️ Maaf, ada gangguan</h2>
        <p class="mt-2">{{ $message }}</p>
        <a href="{{ route('dq.index') }}" class="mt-4 inline-block text-blue-600">← Kembali</a>
    </div>
@endsection
```

Pengguna lihat pesan ramah, log dicatat untuk debugging Anda.

---

## 6. Validasi Input Minimal

Untuk form filter date range, validasi supaya tidak error:

```php
public function revenue(Request $request)
{
    $validated = $request->validate([
        'from' => 'nullable|date',
        'to'   => 'nullable|date|after_or_equal:from',
    ]);

    $from = $validated['from'] ?? '2025-01-01';
    $to   = $validated['to']   ?? now()->format('Y-m-d');

    // ... query
}
```

Kalau user kirim tanggal tidak valid (mis. `to` < `from`), Laravel auto-redirect kembali dengan pesan error.

Tampilkan error di Blade:
```blade
@if($errors->any())
    <div class="bg-red-100 p-3 rounded mb-4">
        @foreach($errors->all() as $error)
            <p>{{ $error }}</p>
        @endforeach
    </div>
@endif
```

---

## 7. Tips Presentasi Project Teknis

Anda akan presentasi 5 menit di akhir Sesi 12. Berikut struktur efektif:

### Struktur 5 Menit

| Menit | Bagian | Yang Dipresentasikan |
|-------|--------|----------------------|
| 0-1 | **Problem statement** | Masalah apa yang dashboard ini selesaikan |
| 1-3 | **Demo live** | Buka aplikasi → login → tour 3 halaman utama |
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

## 8. Capstone Checklist

Sebelum presentasi, pastikan:

- [ ] `php artisan serve` jalan di `localhost:8000`
- [ ] Login pakai user dummy yang sudah dibuat
- [ ] Dashboard Data Quality: 10 badge tampil dengan T1 FAIL
- [ ] Drill-down 1 assertion bekerja
- [ ] Dashboard Revenue: chart line muncul
- [ ] Top Customer: chart bar muncul
- [ ] Top Product: tabel muncul
- [ ] Filter date range fungsional
- [ ] Layout konsisten (nav + footer di semua halaman)
- [ ] Logout bekerja
- [ ] Tidak ada error 500 saat demo
- [ ] Note presentasi siap

---

## 9. Anti-Pattern Capstone

| ❌ Hindari | ✅ Lakukan |
|-----------|-----------|
| `.env` ter-commit ke GitHub | Verifikasi `.gitignore` |
| Hardcode credential di code | Selalu pakai `env('KEY')` |
| Tidak ada error handling | Minimal try-catch untuk query critical |
| Demo tanpa rehearsal | Latih sekali sebelum tampil |
| Slide tanpa demo nyata | Demo > slide kalau ada aplikasi |
| Klaim "AI yang bikin semuanya" | Jujur — sebut bagian mana AI bantu, bagian mana Anda yang putuskan |

---

## 10. Setelah Hari 3

Anda akan punya:

1. **Aplikasi web fungsional** jalan di lokal
2. **Repo GitHub** dengan README jelas (showcase di CV)
3. **Pengalaman end-to-end**: design data (H2) → bangun app (H3)
4. **Skill AI-pair-programming** di Laravel

Lanjutan yang bisa Anda kerjakan sendiri di rumah:

- **Deploy ke production** (Railway, Hostinger, atau VPS)
- Tambah **CRUD**: pelanggan bisa di-tambah/edit dari UI
- **Export PDF / Excel**: dashboard bisa di-download
- **Notifikasi email** saat assertion FAIL
- **Role-based auth**: admin vs viewer
- **Real-time update** dengan Laravel Echo + Pusher
- **Pakai Filament**: admin panel auto-generate dari Model

---

## Demo Live (15 menit)

Bareng fasilitator:

1. Install Breeze → ada login page
2. Migrate + seed → ada user admin
3. Pasang middleware `auth` di route grup
4. Tes: logout → akses `/data-quality` → redirect login
5. Edit layout: tambah info user + logout di nav
6. Tambah validasi date range di Controller revenue
7. Latih presentasi 5 menit

---

## Lanjut ke Latihan

[`latihan-11-capstone-presentation/`](./latihan-11-capstone-presentation/)

---

## Ringkasan 1 Halaman

- **Laravel Breeze** = auth instant (login, register, middleware `auth`).
- **Middleware `auth`** di route → otomatis redirect ke login kalau belum login.
- **Seeder** untuk bikin user awal (`firstOrCreate` aman jalan berulang).
- **`.env` tidak di-commit**. Gunakan `env('KEY')` di code, set value di `.env` lokal.
- **Optimasi**: `config:cache`, `route:cache`, `view:cache` untuk demo stabil.
- **Error handling**: try-catch + view error generic supaya demo tidak crash.
- **Validasi**: `$request->validate([...])` untuk input form.
- **Capstone presentasi 5'**: problem (1') + demo (2') + highlight teknis (1') + pelajaran (1').
- **Aturan emas**: tidak ada credential ter-commit, demo dari aplikasi lokal yang sudah dites.
