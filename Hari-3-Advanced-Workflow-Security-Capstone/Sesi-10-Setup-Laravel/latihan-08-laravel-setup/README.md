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
- **10 view assertion** sudah dibuat di MySQL (lihat `Setup` di bawah kalau belum).
- **PHP 8.2+** & **Composer** terinstall:
  - **Mac**: Laravel Herd dari <https://herd.laravel.com>
  - **Windows**: Laravel Herd dari <https://herd.laravel.com/windows> (atau alternatif XAMPP)
- Cursor aktif.

---

## Langkah

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

### 4. Bikin Model untuk Table (15')

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

### 5. Bikin Model untuk View (25')

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

### 6. Halaman Tes Sederhana (15')

Untuk verifikasi semuanya jalan, bikin halaman test sederhana yang tampilkan jumlah customer:

`routes/web.php`:
```php
use App\Models\Customer;

Route::get('/test', function () {
    $count = Customer::count();
    return "<h1>Total Customer: {$count}</h1>";
});
```

Buka <http://localhost:8000/test> → muncul "Total Customer: 13".

### 7. Commit Sebelum Sesi 10 (10')

```bash
git init
git add .
git commit -m "feat(setup): Laravel project setup + Eloquent Models for table & view"
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
  - `welcome.png` — halaman welcome Laravel di browser
  - `tinker_t1.png` — output `AssertionT1::count()` di tinker
- `refleksi.md` (≤150 kata):
  - 1 hal yang mengejutkan saat pakai Eloquent dibanding raw SQL
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
