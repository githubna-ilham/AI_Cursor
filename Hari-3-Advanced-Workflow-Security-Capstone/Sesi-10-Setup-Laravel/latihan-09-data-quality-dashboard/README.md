# Latihan 09 — Dashboard Data Quality

> 🗺️ **Tahap 23–25 dari 30** | Sebelumnya: Sesi 9 Setup | Setelah ini: Sesi 11 Business Dashboard

**Durasi**: 90 menit
**Tipe**: Hands-on individual
**Output**: 2 halaman web: `/data-quality` (index dengan badge 10 assertion) + `/data-quality/{key}` (drill-down detail pelanggar).

---

## Konteks

Dashboard ini akan dipakai tim Anda setiap pagi untuk cek apakah ada bug data. Tujuan:

- **Cepat**: 1 halaman, 1 lirik tahu semua status
- **Drill-down**: kalau ada yang FAIL, klik untuk lihat detail
- **Refreshable**: tombol untuk re-run cek

---

## Tujuan

Setelah latihan:

1. Membuat Controller yang query multiple Model
2. Render Blade view dengan loop & conditional
3. Implementasi route dengan parameter dinamis (`{key}`)
4. Refactor data ke konfigurasi terpusat (`config/dataquality.php`)

---

## Prasyarat

- Latihan 08 selesai: Laravel project + 11 Model siap.
- Database `latihan_sql` masih ada.
- Cursor aktif.

---

## Langkah

### 1. Halaman Index Dashboard (30')

#### 1.1. Bikin Controller

```bash
php artisan make:controller DataQualityController
```

Edit `app/Http/Controllers/DataQualityController.php`. Pakai AI Cursor:

```
@file app/Http/Controllers/DataQualityController.php

Bikin method index() yang:
1. Loop 10 assertion (T1-T10)
2. Hitung count() dari masing-masing Model AssertionT1..T10
3. Return view 'data-quality.index' dengan array $tests berisi:
   - key (mis. 't1')
   - name (mis. 'Subtotal Mismatch')
   - failed (jumlah pelanggar)

Daftar nama:
T1 → Subtotal Mismatch
T2 → Total Mismatch
T3 → Payment Success Mismatch
T4 → Shipment Temporal Order
T5 → Delivered Without Shipment
T6 → Invalid Rating Range
T7 → Invalid Customer Tier
T8 → Negative Product Stock
T9 → Invalid Timestamp Order
T10 → Duplicate Review (Customer×Product)
```

#### 1.2. Bikin Route

`routes/web.php`:
```php
use App\Http\Controllers\DataQualityController;

Route::get('/data-quality', [DataQualityController::class, 'index'])->name('dq.index');
```

#### 1.3. Bikin Blade View

```bash
mkdir -p resources/views/data-quality
touch resources/views/data-quality/index.blade.php
```

Edit `resources/views/data-quality/index.blade.php`. Target tampilan: grid 5 kolom × 2 baris dengan 10 badge.

Gunakan Tailwind via CDN:
```blade
<script src="https://cdn.tailwindcss.com"></script>
```

Tiap badge:
- Warna **hijau** kalau `failed == 0` → tampil "✅ PASS"
- Warna **merah** kalau `failed > 0` → tampil "❌ {jumlah} FAIL"

Pakai AI Cursor untuk generate template:

```
Bikin Blade template untuk dashboard index dengan struktur:

<html>
  <head>
    <title>Data Quality Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
  </head>
  <body class="bg-gray-100 p-8">
    <h1>...</h1>

    Grid responsive: 5 kolom desktop, 2 kolom mobile.
    Tiap badge:
    - Background hijau (bg-green-100) kalau PASS, merah (bg-red-100) kalau FAIL
    - Tulisan: key, name, status
    - Hover: shadow lebih kuat (transition)
    - Klik: link ke /data-quality/{key}
  </body>
</html>

Data di-loop dari $tests dengan @foreach.
```

#### 1.4. Test

```bash
php artisan serve
```

Buka <http://localhost:8000/data-quality>. Harusnya muncul:
- T1: ❌ 11 FAIL (merah)
- T2-T10: ✅ PASS (hijau)

### 2. Halaman Drill-Down (30')

#### 2.1. Tambah Route Dinamis

```php
Route::get('/data-quality/{key}', [DataQualityController::class, 'show'])->name('dq.show');
```

#### 2.2. Tambah Method `show()` di Controller

```
Tambah method show($key) di DataQualityController:

1. Map $key (mis. 't1') ke class Model (mis. App\Models\AssertionT1::class)
2. Kalau key tidak valid → abort(404)
3. Query: $rows = $modelClass::limit(50)->get();
4. Return view 'data-quality.show' dengan compact('key', 'rows')

Pakai associative array untuk mapping, lebih bersih dari switch-case.
```

#### 2.3. Bikin View `show.blade.php`

```blade
{{-- resources/views/data-quality/show.blade.php --}}
<!DOCTYPE html>
<html>
<head>
    <title>Detail {{ strtoupper($key) }} — Data Quality</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 p-8">
    <div class="max-w-5xl mx-auto">
        <a href="{{ route('dq.index') }}" class="text-blue-600">← Kembali ke Dashboard</a>

        <h1 class="text-2xl font-bold mt-4">Detail Pelanggar: {{ strtoupper($key) }}</h1>

        @forelse($rows as $row)
            <pre class="bg-white p-4 mt-2 rounded">{{ json_encode($row, JSON_PRETTY_PRINT) }}</pre>
        @empty
            <p class="text-green-600 mt-4">✅ Tidak ada pelanggar. Aman!</p>
        @endforelse
    </div>
</body>
</html>
```

#### 2.4. Test

- Klik T1 di dashboard → detail muncul dengan 11 baris JSON
- Klik T8 → "Tidak ada pelanggar"
- Klik "Back" → kembali ke index

### 3. Refactor: Pindah Konfigurasi ke `config/` (20')

Anda mungkin sadar list T1-T10 ditulis di Controller index() dan show(). Itu duplikat — code smell yang dipelajari di Sesi 7.

#### 3.1. Bikin `config/dataquality.php`

```php
<?php

return [
    'tests' => [
        't1'  => ['name' => 'Subtotal Mismatch',           'model' => \App\Models\AssertionT1::class],
        't2'  => ['name' => 'Total Mismatch',              'model' => \App\Models\AssertionT2::class],
        't3'  => ['name' => 'Payment Success Mismatch',    'model' => \App\Models\AssertionT3::class],
        't4'  => ['name' => 'Shipment Temporal Order',     'model' => \App\Models\AssertionT4::class],
        't5'  => ['name' => 'Delivered Without Shipment',  'model' => \App\Models\AssertionT5::class],
        't6'  => ['name' => 'Invalid Rating Range',        'model' => \App\Models\AssertionT6::class],
        't7'  => ['name' => 'Invalid Customer Tier',       'model' => \App\Models\AssertionT7::class],
        't8'  => ['name' => 'Negative Product Stock',      'model' => \App\Models\AssertionT8::class],
        't9'  => ['name' => 'Invalid Timestamp Order',     'model' => \App\Models\AssertionT9::class],
        't10' => ['name' => 'Duplicate Review',            'model' => \App\Models\AssertionT10::class],
    ],
];
```

#### 3.2. Refactor Controller

Sekarang controller jadi 1/3 panjangnya:

```php
public function index()
{
    $tests = collect(config('dataquality.tests'))->map(function ($cfg, $key) {
        return [
            'key'    => $key,
            'name'   => $cfg['name'],
            'failed' => $cfg['model']::count(),
        ];
    });

    return view('data-quality.index', compact('tests'));
}

public function show($key)
{
    $tests = config('dataquality.tests');

    if (!isset($tests[$key])) {
        abort(404);
    }

    $rows = $tests[$key]['model']::limit(50)->get();

    return view('data-quality.show', compact('key', 'rows'));
}
```

#### 3.3. Re-test

Buka semua halaman lagi. **Hasil harus identik** (refactor behavior-preserving — sama dengan prinsip Sesi 7).

Sekarang nambah assertion = edit `config/dataquality.php` saja. Tidak perlu sentuh Controller.

### 4. Polish: Summary Card di Atas (10')

Tambah ringkasan di atas grid:

```blade
@php
    $totalPass = $tests->where('failed', 0)->count();
    $totalFail = $tests->where('failed', '>', 0)->sum('failed');
@endphp

<div class="grid grid-cols-2 gap-4 mb-6">
    <div class="bg-green-500 text-white p-6 rounded-lg">
        <div class="text-sm">PASS</div>
        <div class="text-4xl font-bold">{{ $totalPass }} / {{ $tests->count() }}</div>
    </div>
    <div class="bg-red-500 text-white p-6 rounded-lg">
        <div class="text-sm">TOTAL FAILED ROWS</div>
        <div class="text-4xl font-bold">{{ $totalFail }}</div>
    </div>
</div>
```

Tambah juga timestamp di bawah:

```blade
<div class="text-sm text-gray-500 text-center mt-6">
    Last checked: {{ now()->format('d M Y, H:i:s') }}
</div>
```

### 5. Commit (5')

```bash
git add .
git commit -m "feat(dq): data quality dashboard + drill-down + config refactor"
```

---

## Submit

`submissions/<nama>/`:
- `09_dashboard_index.png` — screenshot halaman `/data-quality` (lengkap dengan summary + 10 badge + timestamp)
- `09_drilldown_t1.png` — screenshot detail T1 (11 baris pelanggar)
- `09_drilldown_t8.png` — screenshot detail T8 ("tidak ada pelanggar")
- `refleksi.md` (≤200 kata):
  - 1 hal yang Anda pelajari tentang Blade
  - 1 hal yang Anda pelajari tentang refactor di Laravel
  - 1 prompt AI Cursor yang membantu (tulis prompt lengkap + komentar)

---

## Tips

- **`compact('a', 'b')`** = shortcut untuk `['a' => $a, 'b' => $b]`. Biasakan pakai.
- **`@php ... @endphp`** untuk kode PHP di Blade. Hindari logic panjang — pindah ke Controller.
- **Pakai route name** (`route('dq.index')`), jangan hardcode URL `/data-quality`. Kalau besok URL berubah, cuma ubah di 1 tempat.
- **AI Cursor bagus untuk Blade**. Generate template lalu adjust styling.

---

## Common Issues

| Issue | Solusi |
|-------|--------|
| Halaman 404 | Cek `routes/web.php` — apakah route sudah didaftar |
| `Class App\Models\AssertionT1 not found` | Latihan 08 belum selesai. Cek Model ada di `app/Models/` |
| Tailwind tidak bekerja | Pastikan `<script src="https://cdn.tailwindcss.com"></script>` ada di `<head>` |
| Hasil count semua 0 | Cek `.env` — koneksi ke `latihan_sql` belum benar |
| `compact()` undefined variable | Tulis variabel sesuai parameter — `compact('tests')` butuh `$tests` |

---

## Next Step

Lanjut ke **Sesi 11 Latihan 10** — tambahkan chart business metrics (revenue trend, top customer).
