# Sesi 10 (Laravel) — Dashboard Data Quality

Durasi: 90 menit

## Bayangkan Skenario Ini

Pagi senin, atasan datang ke meja Anda: *"Saya dengar dari tim finance, ada beberapa order yang angkanya tidak konsisten. Bisa tolong bikin halaman ringkasan yang setiap pagi kita cek, supaya kalau ada bug data langsung ketahuan?"*

Anda sudah punya 10 assertion dari Hari 2 (T1-T10). Sekarang tinggal **bungkus jadi halaman web** yang bisa di-bookmark dan refresh tiap pagi.

Sesi 10 melatih membangun **Dashboard Data Quality** sederhana tapi powerful.

---

## Yang Akan Anda Pelajari

1. Konsep MVC (Model-View-Controller) di Laravel
2. Bikin Controller yang query Model
3. Bikin Blade template dengan komponen card
4. Setup route + navigation
5. Drill-down: dari ringkasan ke detail

---

## 1. Arsitektur MVC: Konsep Inti Laravel

Setiap halaman Laravel terdiri dari **3 pemain**:

```
                    ┌──────────────┐
   URL request ───► │   Route      │
                    └──────┬───────┘
                           │ teruskan
                           ▼
                    ┌──────────────┐
                    │ Controller   │  ← logic per halaman
                    └──────┬───────┘
                           │ baca data
                           ▼
                    ┌──────────────┐
                    │   Model      │  ← akses database
                    └──────┬───────┘
                           │ hasil
                           ▼
                    ┌──────────────┐
                    │  View (Blade)│  ← tampilan HTML
                    └──────┬───────┘
                           │ render
                           ▼
                       HTML ke browser
```

| Pemain | File | Tanggung Jawab |
|--------|------|----------------|
| **Route** | `routes/web.php` | Petakan URL ke Controller method |
| **Controller** | `app/Http/Controllers/*.php` | Orkestrasi: panggil Model, kirim data ke View |
| **Model** | `app/Models/*.php` | Akses database (Eloquent) |
| **View (Blade)** | `resources/views/**/*.blade.php` | HTML + data injection |

Tiap halaman = 4 file (Route, Controller, Model, View). Terdengar banyak, tapi tiap file kecil & fokus.

---

## 2. Workflow Bikin Halaman Baru (Skenario: Dashboard Index)

Misal target: halaman `/data-quality` yang tampilkan 10 badge assertion.

### Step 1: Bikin Route

`routes/web.php`:
```php
use App\Http\Controllers\DataQualityController;

Route::get('/data-quality', [DataQualityController::class, 'index'])->name('dq.index');
```

Artinya: kalau ada GET request ke `/data-quality`, panggil method `index()` di `DataQualityController`.

### Step 2: Bikin Controller

```bash
php artisan make:controller DataQualityController
```

Edit `app/Http/Controllers/DataQualityController.php`:
```php
<?php

namespace App\Http\Controllers;

use App\Models\AssertionT1;
use App\Models\AssertionT2;
// ... import T3-T10

class DataQualityController extends Controller
{
    public function index()
    {
        $tests = [
            ['key' => 't1', 'name' => 'Subtotal Mismatch', 'failed' => AssertionT1::count()],
            ['key' => 't2', 'name' => 'Total Mismatch',    'failed' => AssertionT2::count()],
            // ... T3-T10
        ];

        return view('data-quality.index', compact('tests'));
    }
}
```

### Step 3: Bikin Blade View

`resources/views/data-quality/index.blade.php`:
```blade
<!DOCTYPE html>
<html>
<head>
    <title>Data Quality Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 p-8">
    <h1 class="text-2xl font-bold mb-4">Data Quality Dashboard</h1>

    <div class="grid grid-cols-5 gap-4">
        @foreach($tests as $test)
            <div class="rounded-lg p-4 {{ $test['failed'] == 0 ? 'bg-green-100' : 'bg-red-100' }}">
                <div class="text-sm font-medium">{{ $test['key'] }}: {{ $test['name'] }}</div>
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
</body>
</html>
```

### Step 4: Test

```bash
php artisan serve
```

Buka <http://localhost:8000/data-quality>. Harusnya muncul 10 badge — 1 merah (T1) dan 9 hijau (T2-T10).

**Selesai.** Dashboard fungsional dalam ~40 baris kode total.

---

## 3. Blade Syntax Singkat

Blade adalah template engine Laravel. Sintaksnya intuitif:

### Echo Data
```blade
{{ $variable }}                {-- escaped (aman dari XSS) --}
{!! $rawHtml !!}               {-- raw, hanya kalau perlu --}
```

### Control Flow
```blade
@if($condition)
    ...
@elseif($other)
    ...
@else
    ...
@endif

@foreach($items as $item)
    {{ $item->name }}
@endforeach

@forelse($items as $item)
    {{ $item->name }}
@empty
    <p>Belum ada data.</p>
@endforelse
```

### Template Inheritance
```blade
{{-- resources/views/layouts/app.blade.php --}}
<html>
<body>
    <nav>...</nav>
    @yield('content')
</body>
</html>

{{-- resources/views/data-quality/index.blade.php --}}
@extends('layouts.app')

@section('content')
    <h1>Dashboard</h1>
@endsection
```

Pakai inheritance supaya layout (nav, footer) tidak duplicate di tiap halaman.

---

## 4. Drill-Down: Detail Pelanggar

Setelah ringkasan badge, peserta sering klik untuk lihat detail. Mari bikin halaman detail per assertion.

### Route

```php
Route::get('/data-quality/{key}', [DataQualityController::class, 'show'])->name('dq.show');
```

### Controller

```php
public function show($key)
{
    $model_map = [
        't1' => AssertionT1::class,
        't2' => AssertionT2::class,
        // ... T3-T10
    ];

    if (!isset($model_map[$key])) {
        abort(404);
    }

    $modelClass = $model_map[$key];
    $rows = $modelClass::limit(50)->get();

    return view('data-quality.show', compact('key', 'rows'));
}
```

### View

```blade
@extends('layouts.app')

@section('content')
    <h1>Detail Pelanggar: {{ strtoupper($key) }}</h1>

    @forelse($rows as $row)
        <pre>{{ json_encode($row, JSON_PRETTY_PRINT) }}</pre>
    @empty
        <p class="text-green-600">✅ Tidak ada pelanggar. Aman!</p>
    @endforelse

    <a href="{{ route('dq.index') }}" class="mt-4 inline-block bg-gray-200 px-4 py-2 rounded">
        ← Kembali ke Dashboard
    </a>
@endsection
```

Setelah ini, klik badge T1 di index → masuk ke detail dengan 11 pelanggar.

---

## 5. Refactor Awal: Konstanta untuk Daftar Test

Setelah halaman jalan, pasti Anda lihat masalah: **list T1-T10 ditulis di banyak tempat**. Itu code smell — sama dengan yang dibahas di Sesi 7 (magic numbers, duplicate logic).

Solusi: bikin **konfigurasi terpusat**.

`config/dataquality.php`:
```php
<?php
return [
    'tests' => [
        't1' => ['name' => 'Subtotal Mismatch',  'model' => \App\Models\AssertionT1::class],
        't2' => ['name' => 'Total Mismatch',     'model' => \App\Models\AssertionT2::class],
        // ... T3-T10
    ],
];
```

Controller jadi:
```php
public function index()
{
    $tests = collect(config('dataquality.tests'))->map(function ($cfg, $key) {
        return [
            'key' => $key,
            'name' => $cfg['name'],
            'failed' => $cfg['model']::count(),
        ];
    });

    return view('data-quality.index', compact('tests'));
}
```

Sekarang nambah assertion = edit `config/dataquality.php` saja. Tidak perlu sentuh Controller atau View.

---

## 6. Pola UX yang Baik untuk Dashboard

### Hierarki Informasi

```
┌──────────────────────────────────────────┐
│  SUMMARY (top)                           │  ← yang paling perlu dilihat
│  ┌─────────┐ ┌─────────┐                 │     dalam 3 detik
│  │ 9 PASS  │ │ 1 FAIL  │                 │
│  └─────────┘ └─────────┘                 │
├──────────────────────────────────────────┤
│  PER-ASSERTION CARDS                     │  ← detail per test
│  [T1] [T2] [T3] [T4] [T5]                │
│  [T6] [T7] [T8] [T9] [T10]               │
├──────────────────────────────────────────┤
│  CLICK CARD → DETAIL PAGE                │  ← drill-down on demand
└──────────────────────────────────────────┘
```

Aturan: yang paling penting di atas, detail di bawah/halaman lain.

### Warna untuk Status

| Status | Warna | Tailwind |
|--------|-------|----------|
| PASS | Hijau | `bg-green-100`, `text-green-800` |
| WARN | Kuning | `bg-yellow-100`, `text-yellow-800` |
| FAIL | Merah | `bg-red-100`, `text-red-800` |
| INFO | Biru | `bg-blue-100`, `text-blue-800` |

Pakai sesuai konteks. Jangan semua merah berlebihan (jadi distracting).

### Timestamp "Last Checked"

User perlu tahu **data sebaru apa**. Tambah footer:

```blade
<div class="text-sm text-gray-500 mt-4">
    Last checked: {{ now()->format('d M Y, H:i') }}
</div>
```

Karena data quality cek selalu real-time (query view), timestamp = waktu request.

---

## 7. Anti-Pattern Dashboard

| ❌ Hindari | ✅ Lakukan |
|-----------|-----------|
| 50 metrics di 1 halaman | 5-10 metric paling penting saja |
| Warna pelangi tanpa konsistensi | 3-4 warna semantik (pass/warn/fail/info) |
| Data tanpa context (just angka) | Tambah satuan, perbandingan periode |
| Refresh manual tanpa info | Tampilkan "last checked" timestamp |
| Drill-down dalam modal kecil | Halaman terpisah dengan URL — bisa di-bookmark |
| Logic complex di Blade | Pindah ke Controller |

---

## Demo Live (15 menit)

Bareng fasilitator:

1. Bikin route `/data-quality`
2. Bikin `DataQualityController` dengan method `index()`
3. Bikin Blade template dengan 10 badge
4. Buka browser → lihat hasil
5. Refactor: pindah list T1-T10 ke `config/dataquality.php`
6. Bikin route + halaman drill-down `/data-quality/{key}`

---

## Lanjut ke Latihan

[`latihan-09-data-quality-dashboard/`](./latihan-09-data-quality-dashboard/)

---

## Ringkasan 1 Halaman

- **MVC pattern**: Route → Controller → Model → View → HTML.
- **Tiap halaman = 4 file**: route, controller, model, blade. Masing-masing kecil & fokus.
- **Blade syntax**: `{{ }}` untuk echo, `@if/@foreach` untuk control flow, `@extends`/`@yield` untuk layout.
- **Drill-down pattern**: index summary → klik → detail page (URL terpisah).
- **Refactor magic strings ke config**: list test di `config/dataquality.php`, bukan hardcoded di Controller.
- **UX dashboard**: hierarki informasi, warna semantik, timestamp last checked.
