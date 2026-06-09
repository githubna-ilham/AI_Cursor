# Latihan 08 — Setup Laravel + Connect MySQL

> 🗺️ **Tahap 21–22 dari 30** | Sebelumnya: Hari 2 selesai | Setelah ini: Sesi 10 Data Quality Dashboard

**Durasi**: 90 menit
**Tipe**: Hands-on individual
**Output**: Project Laravel `dashboard-app` berjalan di `localhost:8000` + 11 Model siap pakai untuk konsumsi view MySQL.

---

## Konteks

Anda mulai membangun aplikasi Laravel yang akan menampilkan dashboard dari database `latihan_sql` (hasil Hari 2). Sesi 9 fokus ke **fondasi**:
- Setup Laravel dengan benar
- Koneksi ke MySQL existing
- Model Eloquent untuk membaca view & table

Setelah Sesi ini, Anda siap mulai menampilkan data di halaman web (Sesi 10).

---

## Tujuan

Setelah latihan:

1. Memahami struktur project Laravel
2. Konfigurasi `.env` untuk koneksi ke MySQL existing
3. Membuat Eloquent Model untuk table & view
4. Verifikasi koneksi dengan `php artisan tinker`

---

## Prasyarat

- Hari 2 selesai: database `latihan_sql` ada dengan schema + sample data.
- **Familiar dengan 10 assertion query** dari Hari 2 Sesi 8 (`sql-playground/queries/sesi-08-test/01_assertions_example.sql`).
- **PHP 8.2+** & **Composer** terinstall:
  - **Mac**: Laravel Herd dari <https://herd.laravel.com>
  - **Windows**: Laravel Herd dari <https://herd.laravel.com/windows> (atau alternatif XAMPP)
- Cursor aktif.

---

## Langkah

### 0. Bikin View Assertion di MySQL (10')

Sebelum Laravel, kita siapkan **view di MySQL** yang akan dikonsumsi aplikasi nanti. Di Step 0 ini, peserta cukup membuat **1 view contoh** (T1) untuk memahami polanya. Sisa 9 view bisa peserta tambahkan sendiri secara bertahap saat dibutuhkan.

#### Konsep View

**View** = query yang disimpan dengan nama, bisa di-SELECT seperti tabel biasa. Manfaat:
- Pakai berulang kali dengan nama pendek
- Kalau aturan berubah, update di 1 tempat
- Eloquent Laravel bisa baca view seperti tabel

#### Pola CREATE VIEW

```sql
CREATE OR REPLACE VIEW nama_view AS
<query SELECT yang menghasilkan baris pelanggar>;
```

Setelah dibuat:
```sql
SELECT * FROM nama_view;        -- semua pelanggar
SELECT COUNT(*) FROM nama_view; -- jumlah pelanggar (0 = PASS)
```

#### Tugas: Bikin Contoh View T1

Buka DBeaver / MySQL Workbench, pastikan database aktif:

```sql
USE latihan_sql;
```

Tulis view berikut berdasarkan assertion T1 di Hari 2 Sesi 8 (`01_assertions_example.sql`):

```sql
CREATE OR REPLACE VIEW v_assertion_t1_subtotal_mismatch AS
SELECT
  o.id                                                 AS order_id,
  o.subtotal                                           AS header_subtotal,
  COALESCE(SUM(oi.line_total), 0)                      AS detail_sum,
  o.subtotal - COALESCE(SUM(oi.line_total), 0)         AS difference
FROM orders o
LEFT JOIN order_items oi ON oi.order_id = o.id
GROUP BY o.id, o.subtotal
HAVING o.subtotal <> COALESCE(SUM(oi.line_total), 0);
```

Verifikasi:

```sql
SELECT COUNT(*) FROM v_assertion_t1_subtotal_mismatch;
-- Expect: 11 (sengaja FAIL di sample data Hari 2)

SHOW FULL TABLES WHERE TABLE_TYPE = 'VIEW';
-- Expect: 1 baris → v_assertion_t1_subtotal_mismatch
```

✅ Kalau view T1 berhasil dibuat, lanjut ke Step 1.

> 💡 **Sisa 9 view (T2-T10)**: tidak perlu dibuat sekarang. Dashboard di Step 4 akan jalan dengan 1 view (T1 saja) — peserta lihat hasil cepat. Sisa view bisa ditambahkan sendiri di rumah dengan pola yang sama atau bantuan AI Cursor.

---

### 1. Install Laravel Herd (10' — kalau belum)

Lihat materi Sesi 9 untuk panduan install Laravel Herd di **Mac** atau **Windows**. Lewati kalau sudah punya PHP + Composer + Laravel CLI.

Verifikasi (terminal apapun — Terminal di Mac, PowerShell/CMD di Windows):

```bash
php --version       # ≥ 8.2
composer --version  # ≥ 2.x
laravel --version   # ≥ 5.x
```

### 2. Buat Project Laravel (10')

#### macOS

```bash
cd ~/Projek/mm_cursor      # atau folder kerja Anda
laravel new dashboard-app
cd dashboard-app
```

#### Windows (PowerShell)

```powershell
# Pindah ke folder kerja, mis. C:\Projects
cd C:\Users\$env:USERNAME\Projects

# Bikin folder kalau belum ada
mkdir Projects -Force; cd Projects

# Buat project
laravel new dashboard-app
cd dashboard-app
```

#### Pilihan Saat Ditanya (Mac & Windows)

```
- Starter Kit?      → None
- Tests?            → No
- Database?         → MySQL
- Run migration?    → No
```

Test (sama di Mac & Windows):
```bash
php artisan serve
```

Buka <http://localhost:8000> → halaman welcome Laravel muncul.

> 💡 **Cursor shortcut**: di Mac pakai `Cmd+...`, di Windows pakai `Ctrl+...`. Jadi `Cmd+L` (Mac) = `Ctrl+L` (Windows) untuk buka Chat panel.

### 3. Konfigurasi `.env` (5')

Edit `.env`:

```
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=latihan_sql
DB_USERNAME=root
DB_PASSWORD=password_mysql_anda
```

Test koneksi:
```bash
php artisan tinker
```

Di prompt:
```php
DB::table('customers')->count();
// → harus output 13
```

Kalau output 13, koneksi sukses ✅. Keluar dengan `exit`.

### 4. Bikin Halaman Dashboard Sederhana (20')

Sekarang bangun dashboard pertama dengan pola **MVC Laravel**. Urutan pembuatannya: **Route → Blade view → Controller**.

Bayangkan alurnya seperti restoran:
- **Route** = daftar menu (URL mana yang tersedia + diteruskan ke mana)
- **Blade view** = template piring & dekorasi (HTML yang dilihat customer)
- **Controller** = koki (orkestrasi: ambil data, kirim ke piring)

#### 4.1. Bikin Route

Edit `routes/web.php`. Tambah route `/dashboard` yang point ke method `index` di `DataQualityController` (Controller-nya akan kita bikin di 4.3):

```php
<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\DataQualityController;

Route::get('/dashboard', [DataQualityController::class, 'index'])->name('dashboard');
```

Kalau Anda buka <http://localhost:8000/dashboard> sekarang → akan error karena Controller belum ada. Itu **expected** — kita akan bikin di langkah berikut.

#### 4.2. Bikin Blade View

Buat file baru `resources/views/dashboard.blade.php`:

```blade
<!DOCTYPE html>
<html>
<head>
    <title>Data Quality Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 p-8">
    <div class="max-w-6xl mx-auto">
        <h1 class="text-3xl font-bold mb-6">📊 Data Quality Dashboard</h1>

        <div class="grid grid-cols-2 md:grid-cols-5 gap-4">
            @foreach($tests as $test)
                <div class="rounded-lg p-4 shadow {{ $test['failed'] == 0 ? 'bg-green-100' : 'bg-red-100' }}">
                    <div class="text-xs font-medium uppercase text-gray-600">
                        {{ $test['key'] }}
                    </div>
                    <div class="text-sm mt-1">
                        {{ $test['name'] }}
                    </div>
                    <div class="text-2xl font-bold mt-2">
                        @if($test['failed'] == 0)
                            ✅ PASS
                        @else
                            ❌ {{ $test['failed'] }} FAIL
                        @endif
                    </div>
                </div>
            @endforeach
        </div>

        <div class="text-sm text-gray-500 mt-6 text-center">
            Last checked: {{ now()->format('d M Y, H:i:s') }}
        </div>
    </div>
</body>
</html>
```

Penjelasan singkat sintaks Blade:
- `{{ $test['key'] }}` — echo nilai variabel (auto-escape XSS-safe)
- `@foreach($tests as $test) ... @endforeach` — loop
- `@if(...) ... @else ... @endif` — conditional
- Variabel `$tests` belum tahu dari mana — itu akan dikirim Controller di 4.3

#### 4.3. Bikin Controller

Generate Controller dengan artisan:

```bash
php artisan make:controller DataQualityController
```

Ini akan membuat file `app/Http/Controllers/DataQualityController.php`. Edit jadi:

```php
<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\DB;

class DataQualityController extends Controller
{
    public function index()
    {
        $tests = [
            [
                'key'  => 't1',
                'name' => 'Subtotal Mismatch',
                'view' => 'v_assertion_t1_subtotal_mismatch',
            ],
            // 💡 Tambah view T2-T10 di sini setelah peserta bikin
            // view-nya di MySQL dengan pola CREATE OR REPLACE VIEW.
        ];

        foreach ($tests as &$test) {
            $test['failed'] = DB::table($test['view'])->count();
        }

        return view('dashboard', compact('tests'));
    }
}
```

Penjelasan:
- `namespace App\Http\Controllers` — supaya bisa di-autoload Laravel
- `use Illuminate\Support\Facades\DB` — import DB query builder
- Method `index()` — dijalankan saat user buka `/dashboard` (sesuai Route di 4.1)
- `DB::table('nama_view')->count()` — query langsung ke view, hasil jumlah baris
- `return view('dashboard', compact('tests'))` — render `dashboard.blade.php` + kirim variabel `$tests`

#### 4.4. Jalankan & Lihat Hasil

```bash
php artisan serve
```

Buka <http://localhost:8000/dashboard>. Harusnya muncul:
- 1 kartu badge **T1**: berwarna **merah** dengan "❌ 11 FAIL"
- Footer dengan timestamp last checked

🎉 **Dashboard pertama jalan dengan struktur MVC lengkap.**

Saat peserta nanti tambah view T2-T10 di MySQL, cukup tambahkan baris baru di array `$tests` di Controller → badge baru otomatis muncul di dashboard.

#### Alur yang Baru Saja Anda Bangun

```
Browser GET /dashboard
   ↓
routes/web.php cocokkan ke DataQualityController@index
   ↓
DataQualityController::index() jalankan
   ↓
DB::table(...)->count() query ke MySQL
   ↓
return view('dashboard', $tests) render Blade
   ↓
HTML dikirim balik ke browser
```

Ini **persis alur MVC** di diagram materi Sesi 10.

#### 4.4. Catatan tentang Pendekatan Ini

`DB::table('nama_view')` adalah **query builder** Laravel — abstraksi langsung di atas SQL. Cocok untuk:
- Prototype cepat
- Query ad-hoc
- Akses view sederhana

Tapi ada kekurangan:
- Tidak ada type hint / autocomplete di IDE
- Sulit reuse logic (mis. format khusus, scope query)
- Tidak ada relasi otomatis

Untuk aplikasi yang akan bertumbuh, kita perlu **Model Eloquent** — itu yang akan kita refactor di Step 5–6.

### 5. Refactor — Bikin Model untuk Table (15')

```bash
php artisan make:model Customer
php artisan make:model Product
php artisan make:model Order
php artisan make:model OrderItem
```

Edit `app/Models/Customer.php` (default sudah cukup):
```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Customer extends Model
{
    // Default: table 'customers', primary key 'id', timestamps ada
}
```

Test:
```bash
php artisan tinker
```

```php
App\Models\Customer::count();        // → 13
App\Models\Customer::first()->name;  // → "Andi Pratama"
```

Ulangi untuk `Product`, `Order`, `OrderItem`.

### 6. Bikin Model untuk View (10')

View tidak punya `created_at`/`updated_at`, perlu set `$timestamps = false`.

Buat `app/Models/AssertionT1.php`:
```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class AssertionT1 extends Model
{
    protected $table = 'v_assertion_t1_subtotal_mismatch';
    public $timestamps = false;
}
```

Test di tinker:
```bash
php artisan tinker
```

```php
App\Models\AssertionT1::count();    // → 11 (sengaja FAIL)
```

> 💡 **Sisa Model AssertionT2-T10**: tidak perlu dibuat sekarang. Tambah secara bertahap saat peserta sudah bikin view yang sesuai di MySQL. Pola sama: 1 file per Model, ganti nama class + `$table`. Bisa pakai AI Cursor: *"Bikin Model AssertionT2 yang map ke view v_assertion_t2_total_mismatch dengan pola sama seperti @file app/Models/AssertionT1.php"*.

### 7. Refactor Controller Pakai Model (10')

Sekarang ganti `DB::table()` di Controller dengan Model Eloquent yang baru saja dibuat di Step 6.

Edit `app/Http/Controllers/DataQualityController.php`:

```php
<?php

namespace App\Http\Controllers;

use App\Models\AssertionT1;

class DataQualityController extends Controller
{
    public function index()
    {
        $tests = [
            [
                'key'    => 't1',
                'name'   => 'Subtotal Mismatch',
                'failed' => AssertionT1::count(),
            ],
            // 💡 Tambah AssertionT2-T10 di sini setelah peserta bikin
            // Model-nya. Pola sama seperti baris di atas.
        ];

        return view('dashboard', compact('tests'));
    }
}
```

Yang berubah dari Step 4.3:
- Hapus `use Illuminate\Support\Facades\DB`
- Tambah `use App\Models\AssertionT1`
- Hapus loop `foreach` + `DB::table(...)->count()`
- Langsung embed `AssertionT1::count()` di array

Refresh browser <http://localhost:8000/dashboard>. **Hasil harus identik** dengan Step 4 — ini adalah refactoring (behavior-preserving).

**Yang berubah:**
- `DB::table('v_assertion_t1_subtotal_mismatch')` → `AssertionT1::class`
- Loop manual `foreach` untuk count → langsung di array
- Logic lebih dekat ke domain (assertion sebagai konsep), bukan ke implementasi (nama tabel)

**Yang sama:**
- URL `/dashboard`
- Tampilan badge 10 assertion
- Angka yang muncul (T1=11, lainnya=0)

🎯 **Ini momen "aha" Eloquent**: Model = abstraksi yang menyembunyikan detail tabel/view dari logic aplikasi.

### 8. Commit Sebelum Sesi Berikutnya (10')

```bash
git init
git add .
git commit -m "feat(setup): Laravel project + 10 view + dashboard + Eloquent Models"
```

Push ke GitHub (opsional, untuk backup):
```bash
gh repo create dashboard-app --public --source=. --remote=origin --push
```

---

## Submit

`submissions/<nama>/`:
- `laravel_setup.md` (≤300 kata):
  - Versi PHP & Laravel yang Anda pakai
  - Cara Anda install (Herd / Homebrew / lain)
  - 1 masalah saat setup + cara Anda atasi
- Screenshot:
  - `phpversion.png` — output `php --version`
  - `dashboard_step4.png` — dashboard versi raw DB::table (Step 4)
  - `dashboard_step7.png` — dashboard versi Eloquent Model (Step 7) — visual sama, beda di belakang
- `refleksi.md` (≤200 kata):
  - 1 hal yang mengejutkan saat pakai Eloquent dibanding raw `DB::table()`
  - Apa beda hasil di browser antara Step 4 dan Step 7? (clue: tidak ada bedanya — kenapa kita tetap refactor?)
  - 1 prompt AI Cursor yang sangat membantu di sesi ini

---

## Tips

- **Jangan migrate**. Schema sudah ada dari Hari 2 — kalau jalankan `php artisan migrate`, Laravel akan bikin tabel baru yang tidak perlu.
- **`php artisan tinker` adalah teman terbaik**. Pakai untuk test cepat tiap selesai bikin Model.
- **Nama Model singular**, nama tabel plural. Convention Laravel — kalau langgar, harus set `protected $table` manual.
- **Selalu set `$timestamps = false` untuk view**. Kalau lupa, query akan error karena Eloquent cari kolom `updated_at`.

---

## Common Issues

| Issue | Solusi |
|-------|--------|
| `SQLSTATE[HY000] [2002] Connection refused` | MySQL tidak jalan — cek dengan `mysql -u root -p` di terminal |
| `SQLSTATE[HY000] [1045] Access denied` | Password di `.env` salah |
| `Class 'App\Models\Customer' not found` | Salah namespace — pastikan `namespace App\Models;` di awal file |
| `Table 'latihan_sql.v_assertion_t1...' doesn't exist` | View belum dibuat — kembali ke section Setup di atas |
| `Column not found: 1054 Unknown column 'updated_at'` | Lupa set `public $timestamps = false` di Model View |
| Tinker tidak buka | Cek version PHP (`php -v` harus 8.2+) |

---

## Next Step

Lanjut ke **Sesi 10 Latihan 09** — bikin halaman dashboard yang konsumsi 10 Model assertion.
