# Sesi 6 (SQL) — Cari Bug di Query

Durasi: 90 menit

## Bayangkan Skenario Ini

Senin pagi, QA team kirim chat: *"Laporan revenue customer bulan Mei salah. Andi muncul 4,5 juta, padahal dari catatan manual cuma 1,25 juta. Tolong cek."*

Anda buka query yang dipakai laporan itu. Query-nya 30 baris, gabungan 4 tabel. Mau langsung minta AI fix? Tunggu dulu — itu **anti-pattern utama** yang akan kita pelajari hari ini.

---

## Yang Akan Anda Pelajari

1. Bedakan **gejala** (symptom) vs **penyebab** (root cause)
2. Kenali **5 jebakan SQL** yang paling sering memicu bug
3. Urutan kerja debug yang anti panik
4. Cara minta AI **diagnose dulu**, bukan langsung fix

---

## 1. Bug = Penyakit. Symptom ≠ Penyebab

**Analogi**: Anda sakit kepala. Itu **symptom** (gejala). Penyebabnya bisa macam-macam:
- Kurang tidur
- Dehidrasi
- Stres
- Tekanan darah tinggi
- Tumor (jarang, tapi mungkin)

Beda penyebab → beda obat. Memberi obat tanpa diagnosa = berbahaya.

Sama dengan bug SQL. Satu gejala bisa banyak penyebab:

| Gejala | Penyebab Mungkin |
|--------|------------------|
| "Total revenue 4,5jt padahal harusnya 1,25jt" | Join explosion, duplicate data, salah filter tanggal |
| "Customer baru tidak muncul di daftar" | NULL trap, JOIN type salah, filter ketat |
| "Query timeout" | Tidak pakai index, full scan tabel besar |

**Aturan**: cari penyebab dulu. Jangan langsung tambal.

---

## 2. Lima Jebakan SQL Paling Sering

Lima kasus berikut adalah penyebab bug yang paling sering muncul. Hafalkan polanya, supaya saat ketemu lagi Anda langsung mengenali.

### Jebakan 1: NULL Membuat `NOT IN` Berperilaku Tidak Wajar

```sql
-- Tujuan: cari customer yang belum pernah order
SELECT * FROM customers
WHERE id NOT IN (SELECT customer_id FROM orders);
-- Hasil: 0 baris (selalu!) padahal jelas ada customer baru
```

**Kenapa salah**: kalau salah satu `customer_id` di orders ada yang NULL, `NOT IN (1, 2, NULL)` jadi "tidak ada yang lulus filter". Aneh tapi nyata.

**Fix**:
```sql
WHERE NOT EXISTS (
  SELECT 1 FROM orders WHERE customer_id = customers.id
)
```

### Jebakan 2: `BETWEEN '...' AND '2026-01-31'` Buang Jam Sore

```sql
-- Tujuan: order bulan Januari
WHERE created_at BETWEEN '2026-01-01' AND '2026-01-31'
-- Hasil: order tanggal 31 Jan jam 15:30 TIDAK muncul!
```

**Kenapa salah**: `'2026-01-31'` di-anggap `'2026-01-31 00:00:00'`. Apa pun yang lewat jam 00:00 hari itu, tidak masuk.

**Fix**:
```sql
WHERE created_at >= '2026-01-01'
  AND created_at <  '2026-02-01'   -- pakai awal bulan berikutnya
```

### Jebakan 3: `AND` vs `OR` — Mana Duluan?

```sql
-- Tujuan: status paid ATAU shipped, DAN total > 1jt
WHERE status = 'paid' OR status = 'shipped' AND total > 1000000
-- Hasil: ikut muncul order paid kecil-kecil!
```

**Kenapa salah**: SQL eksekusi `AND` dulu. Jadinya: *"paid (semua) OR (shipped DAN total > 1jt)"*. Bukan yang Anda mau.

**Fix**: kasih kurung.
```sql
WHERE (status = 'paid' OR status = 'shipped')
  AND total > 1000000
```

### Jebakan 4: JOIN "Meledak" Membuat Angka Berlipat Ganda

```sql
-- Tujuan: total revenue per customer
SELECT c.id, SUM(o.total)
FROM customers c
LEFT JOIN orders o    ON o.customer_id = c.id
LEFT JOIN payments p  ON p.order_id    = o.id   -- 1 order bisa banyak payment
LEFT JOIN shipments s ON s.order_id    = o.id   -- 1 order bisa banyak shipment
GROUP BY c.id;
-- Hasil: angka 2x lipat untuk customer dengan order yang punya 2 payment
```

**Kenapa salah**: 1 order yang punya 2 payment + 1 shipment → JOIN menggandakan baris jadi 2 → `SUM(total)` ikut terhitung 2 kali.

**Fix**: jangan JOIN tabel yang tidak Anda butuhkan kolomnya.
```sql
SELECT c.id, SUM(o.total)
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.id
GROUP BY c.id;
```

### Jebakan 5: `GROUP BY` Lupa Sebut Kolom

```sql
SELECT customer_id, name, SUM(total)
FROM orders o JOIN customers c ON ...
GROUP BY customer_id;   -- `name` tidak ada di GROUP BY
```

**Kenapa salah**: MySQL versi longgar bolehkan ini, tapi `name` yang muncul = **acak** dari salah satu baris. Hari ini "Andi", besok bisa beda.

**Fix**: sebutkan semua kolom non-aggregate di GROUP BY.
```sql
GROUP BY customer_id, c.name
```

---

## 3. Urutan Kerja Debug (5 Langkah Anti-Panik)

```
1. REPRODUCE  → jalankan query, lihat hasil aktual
2. ISOLATE    → kecilkan query (hapus JOIN/filter satu-satu)
3. HYPOTHESIS → tebak penyebab (tulis 1 kalimat)
4. FIX MINI   → ubah baris yang salah saja
5. VERIFY     → run lagi, bandingkan hasil
```

**Penting**: jangan loncat langkah. Banyak orang loncat ke langkah 4 (fix), tanpa hypothesis. Hasilnya: fix berhasil tapi tidak tahu **kenapa berhasil**. Bug akan muncul lagi.

---

## 4. Cara Minta AI: Diagnose Dulu, Fix Kemudian

**Anti-pattern utama**:
> "Fix query ini" → AI rewrite total, Anda tidak belajar apa-apa.

**Pola benar — Step 1: diagnose**:
```
Query berikut hasilnya salah. Gejala: total customer Andi muncul
4,5jt, padahal cek manual cuma 1,25jt.

Query:
<paste>

Tugas kamu:
1. Tebak penyebab (1-2 kalimat)
2. Bantu saya bukti: query SELECT pendek untuk membuktikan dugaan
3. JANGAN beri fix dulu

Saya mau paham KENAPA, bukan cuma hasilnya.
```

Lihat jawaban AI, **jalankan query buktinya** sendiri. Kalau hipotesis terbukti, baru minta fix.

**Pola benar — Step 2: fix**:
```
Hipotesis kamu benar (saya sudah verify). Sekarang:
1. Berikan query fix — ubah seminimal mungkin
2. Komentar 1 baris di atas yang diubah: -- FIX: <apa & kenapa>
3. Query SELECT untuk bandingkan hasil sebelum & sesudah
```

---

## 5. Pakai EXPLAIN Kalau Query Lambat

`EXPLAIN` itu seperti **rontgen** untuk query — kasih tahu Anda *bagaimana* MySQL bakal jalanin query.

```sql
EXPLAIN
SELECT name, SUM(total)
FROM customers c JOIN orders o ON o.customer_id = c.id
WHERE o.created_at >= '2026-01-01'
GROUP BY name;
```

Yang dilihat di output:

| Kolom | Yang bagus | Yang buruk |
|-------|-----------|-----------|
| `type` | `ref`, `eq_ref` | `ALL` (full scan) |
| `rows` | Sesuai estimasi | Jutaan padahal expect ratusan |
| `Extra` | (kosong) | "Using temporary", "Using filesort" |
| `key` | Nama index | NULL (tidak pakai index) |

Sering `EXPLAIN` jawab pertanyaan tanpa AI: *"Aha, query tidak pakai index karena saya pakai `date()` di WHERE."*

---

## 6. Risiko & Urgency: Tidak Semua Bug Harus Fix Sekarang

Tradeoff:

| Tingkat Risiko | Contoh | Urgency |
|----------------|--------|---------|
| 🔴 Hasil salah di laporan ke customer/audit | Invoice salah angka | **Sekarang** |
| 🟡 Hasil salah di dashboard internal | Manager lihat angka aneh | Hari ini |
| 🟢 Query lambat tapi hasilnya benar | Page load 3 detik | Sprint ini |
| 🔵 Edge case yang jarang muncul | Bug saat customer dengan email NULL | Backlog |

Tanya AI juga bisa untuk **assess risiko**: *"Skenario apa yang bisa trigger bug ini di production?"*

---

## 7. Jangan Lakukan Ini

| ❌ Salah | ✅ Benar |
|---------|---------|
| Langsung minta AI "fix query ini" | Minta diagnose dulu |
| Apply fix tanpa verify | Selalu run + bandingkan output |
| Rewrite total query | Patch minimal — ubah baris yang salah saja |
| Cuma test happy path | Test edge case (NULL, 0 row, banyak baris) |
| Lupa simpan query asli | Backup file atau `git diff` |
| Lupa cek EXPLAIN saat lambat | Cek dulu, sering jawab sendiri |

---

## Demo Live (15 menit)

Buka `sql-playground/queries/sesi-06-debug/01_inflated_revenue.sql`. Bersama fasilitator:

1. Reproduce: jalankan, lihat angka aneh
2. Isolate: hapus 1 JOIN per percobaan, cari mana yang menyebabkan ledakan baris
3. Hypothesis ke AI: "kemungkinan JOIN payments duplikat?"
4. Verify: `SELECT order_id, COUNT(*) FROM payments GROUP BY order_id HAVING COUNT(*) > 1;`
5. Fix mini: hapus JOIN payments
6. Verify: angka kembali normal

---

## Lanjut ke Latihan

[`latihan-05-debugging-studi-kasus/`](./latihan-05-debugging-studi-kasus/)

---

## Ringkasan 1 Halaman

- **Symptom ≠ Penyebab**. Diagnose dulu, baru fix.
- **5 jebakan**: NULL+`NOT IN`, BETWEEN datetime, AND/OR precedence, JOIN explosion, GROUP BY ambiguity.
- **5 langkah debug**: Reproduce → Isolate → Hypothesis → Fix mini → Verify.
- **Minta AI diagnose dulu**. Jangan "fix query ini". Pendekatan itu sering menyebabkan bug muncul kembali.
- **EXPLAIN** seperti rontgen query — cek dulu sebelum tanya kenapa lambat.
- **Tidak semua bug harus fix sekarang**. Pakai risk matrix.
