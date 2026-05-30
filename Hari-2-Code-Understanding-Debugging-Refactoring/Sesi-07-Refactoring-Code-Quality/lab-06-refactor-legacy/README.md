# Lab 06 — Refactor Legacy Controller

## Tujuan

Peserta merefactor "spaghetti controller" legacy menjadi struktur yang testable & readable, dengan behaviour-preserving guarantee melalui characterization test.

## Durasi

30 menit (25 menit kerja + 5 menit debrief)

## Prasyarat

- Cursor aktif, `.cursorrules` siap (lihat speaker notes Sesi 7).
- Test runner stack peserta siap.
- Telah mengikuti Sesi 7.

## Kode Awal

<!-- STACK-PLACEHOLDER: ganti dengan controller legacy dalam stack peserta. Pseudocode di bawah adalah template. -->

File: `src/controllers/orderController.ext` (PLACEHOLDER, ~120 baris)

```
function createOrder(req, res) {
    // 1. Validasi inline (20 baris if-else)
    if (!req.body.customer_id) return res.status(400).send("missing")
    if (typeof req.body.customer_id !== "number") return res.status(400).send("bad")
    if (!req.body.items || req.body.items.length === 0) return res.status(400).send("empty")
    for (let i = 0; i < req.body.items.length; i++) {
        if (!req.body.items[i].sku) return res.status(400).send("no sku")
        if (req.body.items[i].qty <= 0) return res.status(400).send("bad qty")
    }

    // 2. Query DB inline (30 baris raw SQL string)
    const customer = db.queryOne("SELECT * FROM customers WHERE id = " + req.body.customer_id)
    if (!customer) return res.status(404).send("no customer")
    let total = 0
    const products = []
    for (let i = 0; i < req.body.items.length; i++) {
        const p = db.queryOne("SELECT * FROM products WHERE sku = '" + req.body.items[i].sku + "'")
        if (!p) return res.status(404).send("no product " + req.body.items[i].sku)
        if (p.stock < req.body.items[i].qty) return res.status(409).send("out of stock")
        total = total + p.price * req.body.items[i].qty
        products.push({p, qty: req.body.items[i].qty})
    }

    // 3. Business logic inline (diskon, tax, dll, 40 baris)
    if (customer.tier === "gold") total = total * 0.9
    else if (customer.tier === "silver") total = total * 0.95
    const tax = total * 0.11
    const grand = total + tax

    // 4. Persistence inline (15 baris)
    const orderId = db.insert("orders", {customer_id: customer.id, total: grand})
    for (const p of products) {
        db.insert("order_items", {order_id: orderId, sku: p.p.sku, qty: p.qty})
        db.update("products", {sku: p.p.sku}, {stock: p.p.stock - p.qty})
    }

    // 5. Response formatting inline (10 baris)
    return res.status(201).json({
        id: orderId, customer: customer.name, total: grand, tax: tax, items: products.length
    })
}
```

Smell yang sengaja ada: SQL injection, long method, mixed concerns, magic numbers, no transaction, no validation library, inline business rules.

## Langkah

1. **Identify smells** (3 menit). Prompt AI: "Daftar code smell, urutkan dari paling berdampak ke maintainability/security. Tabel: smell | dampak | severity."
2. **Characterization test** (5 menit). Prompt AI untuk generate 6 test cases (happy + edge + error). Jalankan against kode awal. Wajib semua green sebelum lanjut.
3. **Extract validator** (4 menit). Pisahkan validasi ke `validators/orderValidator.ext`. Commit.
4. **Extract repository** (4 menit). Pisahkan akses DB ke `repositories/orderRepository.ext`. Pakai parameterized query (sekalian fix SQL injection — TAPI catat di changelog, ini behaviour change keamanan, bukan refactor murni). Commit terpisah.
5. **Extract pricing service** (4 menit). Pisahkan business rule (diskon, tax) ke `services/pricingService.ext`. Constants untuk magic number. Commit.
6. **Verify** (3 menit). Jalankan semua characterization test. Hitung complexity sebelum vs sesudah.
7. **Optional** (jika waktu cukup): bungkus persistence dalam transaction.

## Deliverable

Folder `output-lab-06/`:

- `before/` — kode awal
- `after/` — kode hasil refactor (terstruktur per modul)
- `tests/characterization.test.ext`
- `metrics.md` — complexity sebelum/sesudah, LOC per fungsi
- `changelog.md` — daftar commit + alasan, tandai mana yang murni refactor & mana yang behaviour change (SQL injection fix)

## Kriteria Selesai / Rubrik

| Kriteria | Bobot |
|----------|-------|
| Characterization test ditulis duluan & green | 25% |
| Min. 3 ekstraksi (validator, repo, pricing) | 25% |
| Tiap langkah = 1 commit | 15% |
| Test tetap green setelah seluruh refactor | 20% |
| Metrics terukur (complexity turun) | 15% |

## Catatan

- Jangan ganti library / framework di lab ini.
- SQL injection fix WAJIB dilakukan tapi dicatat sebagai behaviour change (keamanan), bukan refactor netral.
- Jika test red di tengah, **revert**, jangan lanjutkan.

## Debrief (5 menit)

1 pair share metric improvement; 1 pair share gotcha (mis. AI lupa update import).
