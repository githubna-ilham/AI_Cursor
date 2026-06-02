# Lab 07 — Testing & AI-Assisted Code Review

## Tujuan

Peserta menulis unit test berkualitas untuk fungsi existing, lalu melakukan code review berbantuan AI pada pull request fiktif dan menghasilkan komentar yang konstruktif & terverifikasi.

## Durasi

35 menit (30 menit kerja + 5 menit debrief)

## Prasyarat

- Cursor aktif.
- Test runner stack peserta siap.
- Telah memahami konsep Sesi 8 (test pyramid, AAA, false positive AI).

## Bagian 1 — Test Generation (15 menit)

### Fungsi Target

<!-- STACK-PLACEHOLDER: ganti dengan fungsi pricing/discount dari domain peserta -->

File: `src/services/pricing.ext` (PLACEHOLDER)

```
function calculateTotal(items, customerTier, couponCode) {
    if (!items || items.length === 0) throw new Error("empty cart")
    let subtotal = 0
    for (const item of items) {
        if (item.qty <= 0) throw new Error("invalid qty")
        subtotal = subtotal + item.price * item.qty
    }
    let discount = 0
    if (customerTier === "gold") discount = 0.10
    else if (customerTier === "silver") discount = 0.05
    if (couponCode === "WELCOME10") discount = discount + 0.10
    if (discount > 0.25) discount = 0.25
    const afterDiscount = subtotal * (1 - discount)
    const tax = afterDiscount * 0.11
    return Math.round((afterDiscount + tax) * 100) / 100
}
```

### Langkah

1. **Prompt AAA** ke AI: minta generate 8 test (2 happy, 3 edge, 2 error, 1 property). Pakai pola naming `should_X_when_Y`.
2. **Review** tiap test:
   - Assert spesifik? (tolak `toBeDefined`)
   - Independen?
   - Cover behaviour, bukan implementasi?
3. **Jalankan** semua test. Wajib green.
4. **Counter-example prompt**: "Beri 3 input yang Anda yakin akan break fungsi ini." Tambahkan sebagai test, jalankan. Jika green tapi seharusnya red, fungsi punya bug — catat.
5. **Coverage cek**. Target ≥ 90% branch coverage.

### Deliverable Bagian 1

- `tests/pricing.test.ext` (min. 10 test)
- `coverage-report.md` (screenshot atau ringkasan)
- `test-quality-notes.md` (1 paragraf: mana test yang paling bernilai, mana yang AI generate tapi Anda buang)

## Bagian 2 — AI-Assisted Code Review pada PR Fiktif (15 menit)

### PR Fiktif

<!-- STACK-PLACEHOLDER: PR fiktif disiapkan dalam stack mayoritas peserta. Default di bawah dalam pseudocode JS/TS. -->

PR Title: "Add refund endpoint"
Branch: `feature/refund`
Changes:

```
+ src/routes/refund.ext      (+25 baris)
+ src/services/refund.ext    (+40 baris)
+ tests/refund.test.ext      (+15 baris, hanya 1 happy path)
```

Cuplikan kode (PLACEHOLDER):

```
// src/services/refund.ext
function refund(orderId, amount, reason) {
    const order = db.queryOne("SELECT * FROM orders WHERE id = " + orderId)
    if (!order) throw new Error("not found")
    const refundId = db.insert("refunds", {
        order_id: orderId, amount: amount, reason: reason, created_at: new Date()
    })
    db.update("orders", {id: orderId}, {status: "refunded"})
    return {id: refundId, amount: amount}
}
```

Bug yang sengaja ada (jangan beri tahu peserta):

- SQL injection.
- Tidak cek `amount > 0` & `amount <= order.total`.
- Tidak idempotent (bisa refund ganda).
- Tidak ada transaksi DB.
- Tidak handle partial refund.
- Test hanya happy path, missing edge.

### Langkah

1. **AI scan** dengan checklist Sesi 8 sebagai prompt. Simpan output.
2. **Klasifikasi temuan**: True Positive / False Positive / Needs Verification. Tabel.
3. **Verifikasi** 3 temuan paling kritis dengan membaca kode (cite path:line).
4. **Generate missing tests** untuk 2 temuan kritis (mis. idempotency, validasi amount).
5. **Tulis 3 komentar review** dalam tone konstruktif. Format:
   ```
   path/to/file.ext:line — [severity] <pertanyaan/saran>
   ```

### Deliverable Bagian 2

- `review-findings.md` (tabel klasifikasi)
- `review-comments.md` (3 komentar siap-tempel)
- `tests/refund.additional.test.ext` (test untuk 2 temuan kritis)

## Kriteria Selesai / Rubrik

| Kriteria | Bobot |
|----------|-------|
| Test pricing min. 10, branch coverage ≥ 90% | 25% |
| Assert spesifik, naming jelas | 15% |
| Klasifikasi temuan AI dengan justifikasi | 20% |
| Min. 3 true positive verified dengan path:line | 20% |
| Komentar PR konstruktif (bukan akusatif, ada saran) | 20% |

## Debrief (5 menit)

2 pair share: 1 false positive yang menarik + 1 komentar review terbaik.

## Wrap-up Hari 2

Setelah debrief, instruktur menutup Hari 2: rangkuman 4 sesi, preview Hari 3 (advanced workflow & integrasi).
