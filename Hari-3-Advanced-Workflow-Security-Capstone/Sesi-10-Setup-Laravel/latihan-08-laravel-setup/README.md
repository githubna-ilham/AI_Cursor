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

### 0. Bikin View Assertion di MySQL (15')

Sebelum Laravel, kita siapkan **10 view** di MySQL yang akan dikonsumsi aplikasi nanti. Aturan: peserta **tulis sendiri 3 view** (T1, T5, T8) untuk merasakan polanya, lalu pakai AI Cursor untuk generate 7 sisa.

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

#### Tugas: Tulis 3 View Sendiri

Buka DBeaver / MySQL Workbench, pastikan database aktif:

```sql
USE latihan_sql;
```

Berdasarkan assertion query di Hari 2 Sesi 8 (`01_assertions_example.sql`), tulis 3 view berikut:

**View 1 — `v_assertion_t1_subtotal_mismatch`**

Wrap assertion T1 (subtotal di header order ≠ sum line_total) jadi view. Polanya:
- `CREATE OR REPLACE VIEW v_assertion_t1_subtotal_mismatch AS`
- Lanjutkan dengan SELECT yang ada di T1, hapus `;` di tengah-tengah

**View 2 — `v_assertion_t5_delivered_no_shipment`**

Wrap assertion T5 (order delivered tanpa shipment) jadi view. Latihan LEFT JOIN + IS NULL.

**View 3 — `v_assertion_t8_negative_stock`**

Wrap assertion T8 (stock negatif) jadi view. Yang paling sederhana — WHERE clause saja.

**Verifikasi**: setelah ketiga view dibuat, test:

```sql
SELECT COUNT(*) FROM v_assertion_t1_subtotal_mismatch;  -- expect 11
SELECT COUNT(*) FROM v_assertion_t5_delivered_no_shipment;  -- expect 0
SELECT COUNT(*) FROM v_assertion_t8_negative_stock;  -- expect 0
```

#### Generate 7 View Sisa dengan AI Cursor

Pakai prompt ini di Cursor Chat:

```
@file sql-playground/queries/sesi-08-test/01_assertions_example.sql

Convert 7 assertion sisa (T2, T3, T4, T6, T7, T9, T10) jadi VIEW
dengan pola:

CREATE OR REPLACE VIEW v_assertion_t{N}_{nama_deskriptif} AS
<query SELECT sesuai assertion>;

Naming convention untuk nama_deskriptif (snake_case):
- T2: total_mismatch
- T3: payment_mismatch
- T4: shipment_temporal
- T6: invalid_rating
- T7: invalid_tier
- T9: invalid_timestamp
- T10: duplicate_review

Berikan 1 blok SQL yang berisi 7 CREATE OR REPLACE VIEW siap di-run.
```

Review output AI sebelum eksekusi:
- Cek nama view sesuai konvensi
- Cek query sama dengan assertion asli
- Cek tidak ada `;` di tengah query (semicolon hanya di akhir tiap statement)

Jalankan SQL di MySQL.

**Final verification**: harus muncul 10 view total.

```sql
SHOW FULL TABLES WHERE TABLE_TYPE = 'VIEW';
-- Expect: 10 baris dengan nama v_assertion_t1 sampai v_assertion_t10
```

✅ Kalau 10 view sudah ada, lanjut ke Step 1.

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

Sebelum belajar Model Eloquent, mari **langsung tampilkan data di browser** dengan cara paling sederhana: `DB::table('nama_view')` di route closure. Nanti kita refactor pakai Model.

#### 4.1. Tambah Route + Inline Logic

Edit `routes/web.php`:

```php
<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\DB;

Route::get('/dashboard', function () {
    $tests = [
        ['key' => 't1',  'name' => 'Subtotal Mismatch',          'view' => 'v_assertion_t1_subtotal_mismatch'],
        ['key' => 't2',  'name' => 'Total Mismatch',             'view' => 'v_assertion_t2_total_mismatch'],
        ['key' => 't3',  'name' => 'Payment Success Mismatch',   'view' => 'v_assertion_t3_payment_mismatch'],
        ['key' => 't4',  'name' => 'Shipment Temporal Order',    'view' => 'v_assertion_t4_shipment_temporal'],
        ['key' => 't5',  'name' => 'Delivered Without Shipment', 'view' => 'v_assertion_t5_delivered_no_shipment'],
        ['key' => 't6',  'name' => 'Invalid Rating Range',       'view' => 'v_assertion_t6_invalid_rating'],
        ['key' => 't7',  'name' => 'Invalid Customer Tier',      'view' => 'v_assertion_t7_invalid_tier'],
        ['key' => 't8',  'name' => 'Negative Product Stock',     'view' => 'v_assertion_t8_negative_stock'],
        ['key' => 't9',  'name' => 'Invalid Timestamp Order',    'view' => 'v_assertion_t9_invalid_timestamp'],
        ['key' => 't10', 'name' => 'Duplicate Review',           'view' => 'v_assertion_t10_duplicate_review'],
    ];

    foreach ($tests as &$test) {
        $test['failed'] = DB::table($test['view'])->count();
    }

    return view('dashboard', compact('tests'));
});
```

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

#### 4.3. Jalankan & Lihat Hasil

```bash
php artisan serve
```

Buka <http://localhost:8000/dashboard>. Harusnya muncul:
- 10 kartu badge dalam grid 5 kolom
- T1 berwarna **merah** dengan "❌ 11 FAIL"
- T2–T10 berwarna **hijau** dengan "✅ PASS"

🎉 **Dashboard pertama jalan tanpa login, tanpa Model.**

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

### 6. Bikin Model untuk View (20')

View tidak punya `created_at`/`updated_at`, perlu set `$timestamps = false`.

`app/Models/AssertionT1.php`:
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

**Tugas Anda**: Bikin Model `AssertionT2` sampai `AssertionT10` dengan pola yang sama. Cukup:
- Ganti nama class (T2, T3, ...)
- Ganti `protected $table` ke nama view yang sesuai

Pakai AI Cursor untuk efisiensi:

```
@file app/Models/AssertionT1.php

Bikin 9 Model serupa (AssertionT2 sampai AssertionT10) yang map ke view berikut:

T2 → v_assertion_t2_total_mismatch
T3 → v_assertion_t3_payment_mismatch
T4 → v_assertion_t4_shipment_temporal
T5 → v_assertion_t5_delivered_no_shipment
T6 → v_assertion_t6_invalid_rating
T7 → v_assertion_t7_invalid_tier
T8 → v_assertion_t8_negative_stock
T9 → v_assertion_t9_invalid_timestamp
T10 → v_assertion_t10_duplicate_review

Pola sama dengan T1: protected $table + public $timestamps = false.

Berikan 9 file lengkap untuk paste.
```

Test semua:
```bash
php artisan tinker
```

```php
App\Models\AssertionT1::count();    // → 11 (sengaja FAIL)
App\Models\AssertionT2::count();    // → 0
App\Models\AssertionT8::count();    // → 0
// ... dst sampai T10
```

Pastikan semua angka sesuai expectation (T1 = 11, T2-T10 = 0).

### 7. Refactor Dashboard Pakai Model (10')

Sekarang ganti `DB::table()` di route closure dengan Model Eloquent yang baru saja dibuat.

Edit `routes/web.php`, ganti seluruh isinya:

```php
<?php

use Illuminate\Support\Facades\Route;
use App\Models\AssertionT1;
use App\Models\AssertionT2;
use App\Models\AssertionT3;
use App\Models\AssertionT4;
use App\Models\AssertionT5;
use App\Models\AssertionT6;
use App\Models\AssertionT7;
use App\Models\AssertionT8;
use App\Models\AssertionT9;
use App\Models\AssertionT10;

Route::get('/dashboard', function () {
    $tests = [
        ['key' => 't1',  'name' => 'Subtotal Mismatch',          'failed' => AssertionT1::count()],
        ['key' => 't2',  'name' => 'Total Mismatch',             'failed' => AssertionT2::count()],
        ['key' => 't3',  'name' => 'Payment Success Mismatch',   'failed' => AssertionT3::count()],
        ['key' => 't4',  'name' => 'Shipment Temporal Order',    'failed' => AssertionT4::count()],
        ['key' => 't5',  'name' => 'Delivered Without Shipment', 'failed' => AssertionT5::count()],
        ['key' => 't6',  'name' => 'Invalid Rating Range',       'failed' => AssertionT6::count()],
        ['key' => 't7',  'name' => 'Invalid Customer Tier',      'failed' => AssertionT7::count()],
        ['key' => 't8',  'name' => 'Negative Product Stock',     'failed' => AssertionT8::count()],
        ['key' => 't9',  'name' => 'Invalid Timestamp Order',    'failed' => AssertionT9::count()],
        ['key' => 't10', 'name' => 'Duplicate Review',           'failed' => AssertionT10::count()],
    ];

    return view('dashboard', compact('tests'));
});
```

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
