# Sesi 11 (Laravel) — Dashboard Business Metrics

Durasi: 90 menit

## Bayangkan Skenario Ini

Atasan puas dengan dashboard Data Quality dari Sesi 10. Sekarang dia minta lagi: *"Bagus, sekarang bisa tolong tampilkan juga chart revenue per bulan dan top 10 customer? Saya mau lihat trend tiap pagi sebelum meeting standup."*

Anda buka query Top 10 LTV dari Hari 2 (`01_customer_lifetime_value.sql`) dan query Monthly Revenue (`02_monthly_revenue_per_category.sql`). Tinggal **render ke chart**.

Sesi 11 melatih menambah **chart visualization** ke aplikasi Laravel.

---

## Yang Akan Anda Pelajari

1. Pakai Chart.js (via CDN) untuk render chart interaktif
2. Format data Eloquent → JSON untuk konsumsi Chart.js
3. Implementasi filter date range
4. Layout master dengan navigation menu

---

## 1. Chart.js: Library Chart Paling Populer

**Chart.js** adalah library JavaScript untuk render chart. Cocok untuk workshop karena:

| Kelebihan | Manfaat |
|-----------|---------|
| **Via CDN** | Tidak perlu setup webpack/build |
| **Responsive** | Otomatis adjust ke ukuran browser |
| **8 jenis chart** | Line, bar, pie, doughnut, radar, polar, scatter, bubble |
| **Animasi smooth** | Cantik tanpa effort tambahan |
| **Dokumentasi lengkap** | AI Cursor sangat lihai Chart.js |

Cara include (di Blade layout):

```html
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
```

Selesai. Siap dipakai di mana pun.

---

## 2. Pola Render Chart dari Eloquent

Workflow:

```
Controller                    Blade                    Browser
─────────                     ─────                    ────────
Model::query()         ──►    @json($data)      ──►    Chart.js render
  ↓
collection / array
  ↓
toArray() / pluck()
```

### Contoh: Revenue per Bulan

**Controller**:

```php
public function revenue()
{
    $data = DB::table('orders')
        ->select(
            DB::raw("DATE_FORMAT(created_at, '%Y-%m') as month"),
            DB::raw("SUM(total) as revenue")
        )
        ->whereIn('status', ['paid', 'shipped', 'delivered'])
        ->groupBy('month')
        ->orderBy('month')
        ->get();

    return view('reports.revenue', compact('data'));
}
```

**Blade**:

```blade
@extends('layouts.app')

@section('content')
    <h1 class="text-2xl font-bold mb-4">Revenue Trend</h1>

    <div class="bg-white p-4 rounded-lg shadow">
        <canvas id="revenueChart"></canvas>
    </div>

    <script>
        const labels  = @json($data->pluck('month'));
        const values  = @json($data->pluck('revenue'));

        new Chart(document.getElementById('revenueChart'), {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Revenue (Rp)',
                    data: values,
                    borderColor: '#3b82f6',
                    backgroundColor: 'rgba(59, 130, 246, 0.1)',
                    tension: 0.3
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { display: false }
                }
            }
        });
    </script>
@endsection
```

Buka `/reports/revenue` → line chart muncul. ✓

---

## 3. Konvensi `@json` di Blade

`@json($data)` adalah cara aman convert PHP variable ke JavaScript:

```blade
<script>
    const data = @json($orders);    {-- aman, otomatis escape --}
    console.log(data);
</script>
```

Equivalent dengan:
```blade
<script>
    const data = JSON.parse('{{ json_encode($orders) }}');
</script>
```

Tapi `@json` lebih bersih.

### Pluck untuk Ambil 1 Kolom

```php
$collection->pluck('month');
// → ['2025-09', '2025-10', '2025-11', ...]

$collection->pluck('revenue');
// → [335000, 800000, 600000, ...]
```

`pluck` sangat berguna untuk siapkan data Chart.js (yang butuh array sederhana).

---

## 4. Filter Date Range

User sering mau lihat data periode tertentu. Pola standar:

### Form Filter

```blade
<form method="GET" class="bg-white p-4 rounded-lg shadow mb-4">
    <div class="flex gap-4 items-end">
        <div>
            <label class="block text-sm">Dari</label>
            <input type="date" name="from" value="{{ request('from', '2025-01-01') }}"
                   class="border rounded px-2 py-1">
        </div>
        <div>
            <label class="block text-sm">Sampai</label>
            <input type="date" name="to" value="{{ request('to', date('Y-m-d')) }}"
                   class="border rounded px-2 py-1">
        </div>
        <button type="submit" class="bg-blue-500 text-white px-4 py-1 rounded">
            Apply
        </button>
    </div>
</form>
```

### Controller Handle

```php
public function revenue(Request $request)
{
    $from = $request->input('from', '2025-01-01');
    $to   = $request->input('to', now()->format('Y-m-d'));

    $data = DB::table('orders')
        ->select(
            DB::raw("DATE_FORMAT(created_at, '%Y-%m') as month"),
            DB::raw("SUM(total) as revenue")
        )
        ->whereIn('status', ['paid', 'shipped', 'delivered'])
        ->whereBetween('created_at', [$from, $to])
        ->groupBy('month')
        ->orderBy('month')
        ->get();

    return view('reports.revenue', compact('data', 'from', 'to'));
}
```

Submit form → URL jadi `/reports/revenue?from=2025-06-01&to=2026-01-31` → Controller filter data → chart re-render.

---

## 5. Bar Chart untuk Top 10 Customer

Pola sama, tinggal ganti chart type:

**Controller**:

```php
public function topCustomers()
{
    $data = DB::table('customers as c')
        ->join('orders as o', 'o.customer_id', '=', 'c.id')
        ->select('c.name', DB::raw('SUM(o.total) as total'))
        ->whereIn('o.status', ['paid', 'shipped', 'delivered'])
        ->groupBy('c.id', 'c.name')
        ->orderByDesc('total')
        ->limit(10)
        ->get();

    return view('reports.customers', compact('data'));
}
```

**Blade** (bagian chart):

```blade
<script>
    const labels = @json($data->pluck('name'));
    const values = @json($data->pluck('total'));

    new Chart(document.getElementById('customerChart'), {
        type: 'bar',                        // ← ganti dari 'line'
        data: {
            labels: labels,
            datasets: [{
                label: 'Total Spending (Rp)',
                data: values,
                backgroundColor: '#10b981'
            }]
        },
        options: {
            indexAxis: 'y',                 // ← horizontal bar
            responsive: true
        }
    });
</script>
```

Horizontal bar lebih cocok untuk nama panjang (tidak overlap di sumbu X).

---

## 6. Layout Master untuk Konsistensi

Setelah punya 3-4 halaman, navigation mulai diperlukan. Bikin layout master:

`resources/views/layouts/app.blade.php`:

```blade
<!DOCTYPE html>
<html>
<head>
    <title>@yield('title', 'Dashboard') — Multimatics</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="bg-gray-100 min-h-screen">

    <nav class="bg-white shadow p-4 mb-4">
        <div class="container mx-auto flex gap-6">
            <a href="{{ route('dq.index') }}" class="font-semibold">Data Quality</a>
            <a href="{{ route('reports.revenue') }}">Revenue</a>
            <a href="{{ route('reports.customers') }}">Top Customer</a>
            <a href="{{ route('reports.products') }}">Top Product</a>
        </div>
    </nav>

    <main class="container mx-auto px-4">
        @yield('content')
    </main>

    <footer class="text-center text-sm text-gray-500 mt-8 pb-4">
        Updated: {{ now()->format('d M Y, H:i') }}
    </footer>

</body>
</html>
```

Tiap halaman tinggal extends:

```blade
@extends('layouts.app')

@section('title', 'Revenue Trend')

@section('content')
    {{-- konten halaman --}}
@endsection
```

---

## 7. Performance: N+1 Query

Saat halaman makin complex, ada bahaya **N+1 query**:

```php
// ❌ N+1: tiap loop = 1 query terpisah
$orders = Order::all();
foreach ($orders as $order) {
    echo $order->customer->name;   // ← query baru tiap loop!
}

// ✅ Eager loading: 2 query total
$orders = Order::with('customer')->get();
foreach ($orders as $order) {
    echo $order->customer->name;   // ← sudah di-load
}
```

`with('customer')` adalah **eager loading**: 1 query untuk orders + 1 query untuk semua customer terkait, lalu Laravel "pasangkan" otomatis.

Pakai eager loading saat di Blade ada `$model->relasi->kolom`.

---

## 8. Caching untuk Query Berat

Kalau query memakan 5 detik dan halaman di-load tiap menit, **cache** sangat membantu:

```php
use Illuminate\Support\Facades\Cache;

public function revenue()
{
    $data = Cache::remember('revenue_trend', 300, function () {
        return DB::table('orders')
            ->select(/* query berat */)
            ->get();
    });

    return view('reports.revenue', compact('data'));
}
```

`Cache::remember('key', 300, callback)` artinya:
- Cek apakah cache `revenue_trend` ada
- Kalau ada & belum 300 detik (5 menit), pakai cache
- Kalau tidak ada / expired, jalankan callback & simpan ke cache

Trade-off:
- ✅ Halaman jauh lebih cepat
- ❌ Data bisa stale sampai 5 menit

Cocok untuk dashboard yang data-nya tidak time-critical.

---

## 9. Anti-Pattern Visualization

| ❌ Hindari | ✅ Lakukan |
|-----------|-----------|
| Pie chart dengan > 5 slice | Bar chart kalau > 5 kategori |
| Line chart untuk data kategorial | Bar chart untuk kategorial |
| Sumbu Y tidak mulai dari 0 (bar chart) | Sumbu Y mulai dari 0 untuk fair comparison |
| Banyak warna pelangi tanpa makna | Warna sesuai status atau gradient |
| Chart tanpa title atau axis label | Selalu kasih label yang jelas |
| Data raw tanpa format (mis. 1500000) | Format ke Rp 1.500.000 |

---

## 10. Helper Format Currency

Bikin helper kecil untuk format rupiah:

`app/helpers.php`:
```php
<?php

if (!function_exists('rupiah')) {
    function rupiah($value): string
    {
        return 'Rp ' . number_format($value, 0, ',', '.');
    }
}
```

Register di `composer.json`:
```json
"autoload": {
    "files": [
        "app/helpers.php"
    ]
}
```

Run `composer dump-autoload`. Sekarang di Blade:

```blade
<p>Total Revenue: {{ rupiah($total) }}</p>
{{-- → Total Revenue: Rp 25.350.000 --}}
```

---

## Demo Live (15 menit)

Bareng fasilitator:

1. Bikin route `/reports/revenue`
2. Bikin `ReportController@revenue` dengan query DB
3. Bikin Blade dengan Chart.js line chart
4. Tambah filter date range (form GET)
5. Bikin halaman `/reports/customers` (bar chart)
6. Bikin layout master + nav menu

---

## Lanjut ke Latihan

[`latihan-10-business-dashboard/`](./latihan-10-business-dashboard/)

---

## Ringkasan 1 Halaman

- **Chart.js** via CDN — 8 jenis chart, responsive, mudah pakai.
- **Pola data**: Controller query → `@json($data)` di Blade → Chart.js render.
- **`pluck()`** untuk ambil 1 kolom dari collection.
- **Filter** dengan form GET → request param → Controller filter.
- **Layout master** (`@extends`/`@yield`) untuk konsistensi navigation.
- **N+1 query**: eager loading dengan `with('relasi')`.
- **Cache** untuk query berat — trade-off cepat vs data stale.
- **Helper rupiah()** untuk format currency Indonesia.
