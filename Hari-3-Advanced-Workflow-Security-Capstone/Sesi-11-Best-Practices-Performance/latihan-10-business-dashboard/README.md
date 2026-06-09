# Latihan 10 — Dashboard Business Metrics

> 🗺️ **Tahap 26–28 dari 30** | Sebelumnya: Sesi 10 Data Quality | Setelah ini: Sesi 12 Auth & Deploy

**Durasi**: 90 menit
**Tipe**: Hands-on individual
**Output**: 3 halaman business dashboard (revenue trend, top customer, top product) + layout master dengan navigation.

---

## Konteks

Setelah Data Quality, Anda diminta tambah halaman **business metrics** yang dipakai harian oleh manajemen. Yang dibutuhkan:

- **Revenue trend** per bulan (line chart)
- **Top 10 customer** dengan total spending (bar chart)
- **Top 5 product per kategori** (tabel)
- **Filter date range** untuk drill-down periode

---

## Tujuan

Setelah latihan:

1. Pakai Chart.js untuk render visualisasi
2. Format data Eloquent ke JSON untuk Chart.js
3. Implementasi filter form GET
4. Bikin layout master dengan navigation menu
5. Pakai helper untuk format currency

---

## Prasyarat

- Latihan 09 selesai: Dashboard Data Quality jalan.
- Database `latihan_sql` masih ada.
- Familiar dengan Blade dari latihan sebelumnya.

---

## Langkah

### 1. Layout Master (15')

Sebelum bikin halaman baru, refactor halaman existing pakai layout master supaya konsisten.

#### 1.1. Bikin `resources/views/layouts/app.blade.php`

Pakai AI Cursor:

```
Bikin layout master Blade dengan struktur:

<html>
<head>
    <title>@yield('title', 'Dashboard') — Multimatics</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="bg-gray-100 min-h-screen">

    <nav class="bg-white shadow p-4 mb-6">
        <div class="container mx-auto flex gap-6 items-center">
            <span class="font-bold text-xl">📊 Multimatics</span>
            <a href="{{ route('dq.index') }}">Data Quality</a>
            <a href="{{ route('reports.revenue') }}">Revenue</a>
            <a href="{{ route('reports.customers') }}">Top Customer</a>
            <a href="{{ route('reports.products') }}">Top Product</a>
        </div>
    </nav>

    <main class="container mx-auto px-4">
        @yield('content')
    </main>

    <footer class="text-center text-sm text-gray-500 mt-12 pb-4">
        Last updated: {{ now()->format('d M Y, H:i') }}
    </footer>
</body>
</html>
```

#### 1.2. Refactor Dashboard Data Quality

Edit `resources/views/data-quality/index.blade.php`:

```blade
@extends('layouts.app')

@section('title', 'Data Quality')

@section('content')
    {{-- ...konten existing tanpa <html>, <head>, <body> ... --}}
@endsection
```

Test: `/data-quality` harus tampil sama, tapi sekarang ada nav menu di atas + footer di bawah.

### 2. Halaman Revenue Trend (30')

#### 2.1. Controller & Route

```bash
php artisan make:controller ReportController
```

`routes/web.php`:
```php
use App\Http\Controllers\ReportController;

Route::get('/reports/revenue',   [ReportController::class, 'revenue'])->name('reports.revenue');
Route::get('/reports/customers', [ReportController::class, 'topCustomers'])->name('reports.customers');
Route::get('/reports/products',  [ReportController::class, 'topProducts'])->name('reports.products');
```

#### 2.2. Method `revenue()`

```
@file app/Http/Controllers/ReportController.php

Bikin method revenue(Request $request) yang:

1. Ambil filter $from = request('from', '2025-01-01') dan
   $to = request('to', date('Y-m-d'))

2. Query DB::table('orders') untuk revenue per bulan:
   - SELECT DATE_FORMAT(created_at, '%Y-%m') as month, SUM(total) as revenue
   - WHERE status IN ('paid', 'shipped', 'delivered')
   - AND created_at BETWEEN $from AND $to
   - GROUP BY month
   - ORDER BY month

3. Return view 'reports.revenue' dengan compact('data', 'from', 'to')

Import Request: use Illuminate\Http\Request;
Import DB: use Illuminate\Support\Facades\DB;
```

#### 2.3. Blade View

```bash
mkdir -p resources/views/reports
touch resources/views/reports/revenue.blade.php
```

Edit dengan pola:

```blade
@extends('layouts.app')

@section('title', 'Revenue Trend')

@section('content')
    <h1 class="text-2xl font-bold mb-4">Revenue Trend</h1>

    {{-- Form Filter --}}
    <form method="GET" class="bg-white p-4 rounded-lg shadow mb-4 flex gap-4 items-end">
        <div>
            <label class="block text-sm">Dari</label>
            <input type="date" name="from" value="{{ $from }}" class="border rounded px-2 py-1">
        </div>
        <div>
            <label class="block text-sm">Sampai</label>
            <input type="date" name="to" value="{{ $to }}" class="border rounded px-2 py-1">
        </div>
        <button type="submit" class="bg-blue-500 text-white px-4 py-1 rounded">Apply</button>
    </form>

    {{-- Chart --}}
    <div class="bg-white p-6 rounded-lg shadow">
        <canvas id="revenueChart" height="80"></canvas>
    </div>

    <script>
        const labels = @json($data->pluck('month'));
        const values = @json($data->pluck('revenue'));

        new Chart(document.getElementById('revenueChart'), {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Revenue (Rp)',
                    data: values,
                    borderColor: '#3b82f6',
                    backgroundColor: 'rgba(59, 130, 246, 0.1)',
                    tension: 0.3,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                plugins: { legend: { display: false } }
            }
        });
    </script>
@endsection
```

#### 2.4. Test

Buka <http://localhost:8000/reports/revenue>. Harusnya muncul line chart revenue 2025-2026.

Coba filter: ganti tanggal `from` ke `2026-01-01` → chart hanya tampil 6 bulan.

### 3. Halaman Top 10 Customer (20')

#### 3.1. Method Controller

```
Tambah method topCustomers() di ReportController:

Query:
- SELECT customers.name, SUM(orders.total) as total
- FROM customers JOIN orders ON orders.customer_id = customers.id
- WHERE orders.status IN ('paid', 'shipped', 'delivered')
- GROUP BY customers.id, customers.name
- ORDER BY total DESC
- LIMIT 10

Return view 'reports.customers' dengan compact('data').
```

#### 3.2. Blade

`resources/views/reports/customers.blade.php`:

```blade
@extends('layouts.app')

@section('title', 'Top 10 Customer')

@section('content')
    <h1 class="text-2xl font-bold mb-4">Top 10 Customer (Lifetime Value)</h1>

    <div class="bg-white p-6 rounded-lg shadow">
        <canvas id="customerChart" height="100"></canvas>
    </div>

    <script>
        const labels = @json($data->pluck('name'));
        const values = @json($data->pluck('total'));

        new Chart(document.getElementById('customerChart'), {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Total Spending',
                    data: values,
                    backgroundColor: '#10b981'
                }]
            },
            options: {
                indexAxis: 'y',
                responsive: true
            }
        });
    </script>
@endsection
```

Test: buka `/reports/customers` → bar chart horizontal muncul.

### 4. Halaman Top Product (15')

#### 4.1. Method Controller

```
Tambah method topProducts() di ReportController:

Query top 10 product yang paling banyak terjual:
- SELECT products.name, SUM(order_items.qty) as units_sold, SUM(order_items.line_total) as revenue
- FROM products
- JOIN order_items ON order_items.product_id = products.id
- JOIN orders ON orders.id = order_items.order_id
- WHERE orders.status IN ('paid', 'shipped', 'delivered')
- GROUP BY products.id, products.name
- ORDER BY revenue DESC
- LIMIT 10

Return view 'reports.products' dengan compact('data').
```

#### 4.2. Blade — Pakai Tabel, Bukan Chart

Top product cocok pakai tabel karena ada banyak kolom (nama, units, revenue):

```blade
@extends('layouts.app')

@section('title', 'Top Product')

@section('content')
    <h1 class="text-2xl font-bold mb-4">Top 10 Product Terlaris</h1>

    <div class="bg-white rounded-lg shadow overflow-hidden">
        <table class="w-full">
            <thead class="bg-gray-100">
                <tr>
                    <th class="text-left p-3">#</th>
                    <th class="text-left p-3">Product Name</th>
                    <th class="text-right p-3">Units Sold</th>
                    <th class="text-right p-3">Revenue</th>
                </tr>
            </thead>
            <tbody>
                @foreach($data as $idx => $row)
                    <tr class="border-t">
                        <td class="p-3">{{ $idx + 1 }}</td>
                        <td class="p-3">{{ $row->name }}</td>
                        <td class="p-3 text-right">{{ number_format($row->units_sold) }}</td>
                        <td class="p-3 text-right font-semibold">{{ rupiah($row->revenue) }}</td>
                    </tr>
                @endforeach
            </tbody>
        </table>
    </div>
@endsection
```

⚠️ Helper `rupiah()` belum ada — buat di langkah 5.

### 5. Helper Format Rupiah (10')

#### 5.1. Bikin Helper

`app/helpers.php`:

```php
<?php

if (!function_exists('rupiah')) {
    function rupiah($value): string
    {
        return 'Rp ' . number_format($value ?? 0, 0, ',', '.');
    }
}
```

#### 5.2. Register di Composer

Edit `composer.json`, tambah di section `autoload`:

```json
"autoload": {
    "psr-4": {
        "App\\": "app/"
    },
    "files": [
        "app/helpers.php"
    ]
},
```

#### 5.3. Re-generate Autoload

```bash
composer dump-autoload
```

Test di Blade revenue chart juga:

```blade
{{-- di datasets Chart.js --}}
options: {
    plugins: {
        tooltip: {
            callbacks: {
                label: (ctx) => 'Rp ' + ctx.parsed.y.toLocaleString('id-ID')
            }
        }
    }
}
```

### 6. Commit (5')

```bash
git add .
git commit -m "feat(reports): business dashboard with revenue, customer, product charts"
```

---

## Submit

`submissions/<nama>/`:
- `10_revenue_chart.png` — screenshot `/reports/revenue` dengan chart full + filter
- `10_top_customer.png` — screenshot `/reports/customers` dengan bar chart
- `10_top_product.png` — screenshot `/reports/products` dengan tabel
- `10_filter_demo.png` — screenshot setelah apply filter date range (chart berubah)
- `refleksi.md` (≤200 kata):
  - 1 keputusan kapan pakai chart vs tabel
  - 1 hal yang dipelajari tentang `@json` di Blade
  - 1 prompt AI Cursor untuk Chart.js yang paling membantu

---

## Tips

- **Chart.js docs**: <https://www.chartjs.org/docs/latest/> — banyak contoh siap copy
- **Format angka**: `toLocaleString('id-ID')` di JS, `number_format()` di PHP
- **Color palette**: pakai `#3b82f6` (blue), `#10b981` (green), `#f59e0b` (yellow), `#ef4444` (red), `#8b5cf6` (purple)
- **Responsive chart**: set `height` di `<canvas>` atau biarkan auto
- **Avoid pie chart** kalau > 5 slice — pakai bar chart

---

## Common Issues

| Issue | Solusi |
|-------|--------|
| Chart tidak muncul | Cek console browser — biasanya error `@json` syntax |
| Chart muncul tapi kosong | `$data->pluck()` mungkin return array kosong — cek query |
| `Class function 'rupiah' not found` | Lupa `composer dump-autoload` setelah edit helpers |
| Filter date tidak bekerja | Cek attribute `name` di `<input>` harus `from` & `to` |
| Tooltip Chart.js format default ('123456') | Pakai `tooltip.callbacks.label` untuk custom format |

---

## Next Step

Lanjut ke **Sesi 12 Latihan 11** — auth dengan Laravel Breeze + polish + presentasi.
