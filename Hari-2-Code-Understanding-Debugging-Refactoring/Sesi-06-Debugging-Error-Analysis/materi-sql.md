# Sesi 6 (SQL) — Debugging: Menemukan dan Memperbaiki Bug pada Query

Durasi: 90 menit

## Konteks Sesi

Senin pagi, tim QA mengirim pesan: *"Laporan revenue customer bulan Mei salah. Andi muncul 4,5 juta, padahal dari catatan manual hanya 1,25 juta. Tolong dicek."*

Anda membuka query yang digunakan untuk laporan tersebut. Query-nya 30 baris, menggabungkan 4 tabel. Langsung meminta AI untuk memperbaikinya? Belum saatnya — itulah **anti-pattern utama** yang akan dibahas dalam sesi ini.

---

## Yang Akan Anda Pelajari

1. Membedakan **gejala** (symptom) dari **penyebab** (root cause)
2. Mengenali **5 jebakan SQL** yang paling sering memicu bug
3. Urutan kerja debugging yang terstruktur
4. Cara meminta AI untuk **mendiagnosis terlebih dahulu**, bukan langsung memperbaiki

---

## 1. Bug = Penyakit. Symptom ≠ Penyebab

**Analogi**: Anda mengalami sakit kepala. Itu adalah **symptom** (gejala). Penyebabnya bisa bermacam-macam:
- Kurang tidur
- Dehidrasi
- Stres
- Tekanan darah tinggi

Penyebab yang berbeda membutuhkan penanganan yang berbeda pula. Memberikan obat tanpa diagnosis adalah tindakan yang berisiko.

Hal yang sama berlaku pada bug SQL. Satu gejala dapat memiliki banyak penyebab:

| Gejala | Kemungkinan Penyebab |
|--------|----------------------|
| "Total revenue 4,5jt padahal seharusnya 1,25jt" | JOIN explosion, data duplikat, filter tanggal salah |
| "Customer baru tidak muncul di daftar" | NULL trap, tipe JOIN salah, filter terlalu ketat |
| "Query timeout" | Tidak menggunakan index, full scan tabel besar |

**Aturan**: temukan penyebabnya terlebih dahulu. Jangan langsung memperbaiki.

---

## 2. Lima Jebakan SQL yang Paling Sering Muncul

Lima kasus berikut adalah penyebab bug yang paling sering ditemui. Kenali polanya agar dapat langsung diidentifikasi saat muncul kembali.

### Jebakan 1: NULL Membuat `NOT IN` Berperilaku Tidak Wajar

```sql
-- Tujuan: cari customer yang belum pernah order
SELECT * FROM customers
WHERE id NOT IN (SELECT customer_id FROM orders);
-- Hasil: 0 baris (selalu!) padahal jelas ada customer baru
```

**Penyebab**: apabila salah satu `customer_id` di orders bernilai NULL, kondisi `NOT IN (1, 2, NULL)` tidak akan meloloskan satu baris pun.

**Solusi**:
```sql
WHERE NOT EXISTS (
  SELECT 1 FROM orders WHERE customer_id = customers.id
)
```

### Jebakan 2: `BETWEEN '...' AND '2026-01-31'` Membuang Data Jam Sore

```sql
-- Tujuan: order bulan Januari
WHERE created_at BETWEEN '2026-01-01' AND '2026-01-31'
-- Hasil: order tanggal 31 Jan jam 15:30 TIDAK muncul!
```

**Penyebab**: `'2026-01-31'` diinterpretasikan sebagai `'2026-01-31 00:00:00'`. Semua data setelah pukul 00:00 pada hari tersebut tidak akan masuk.

**Solusi**:
```sql
WHERE created_at >= '2026-01-01'
  AND created_at <  '2026-02-01'   -- gunakan awal bulan berikutnya
```

### Jebakan 3: `AND` vs `OR` — Prioritas Eksekusi

```sql
-- Tujuan: status paid ATAU shipped, DAN total > 1jt
WHERE status = 'paid' OR status = 'shipped' AND total > 1000000
-- Hasil: order berstatus paid dengan nilai kecil ikut muncul!
```

**Penyebab**: SQL mengeksekusi `AND` terlebih dahulu. Kondisi yang terbaca adalah: *"paid (semua) OR (shipped DAN total > 1jt)"* — bukan yang dimaksudkan.

**Solusi**: tambahkan tanda kurung.
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
LEFT JOIN payments p  ON p.order_id    = o.id   -- 1 order bisa punya banyak payment
LEFT JOIN shipments s ON s.order_id    = o.id   -- 1 order bisa punya banyak shipment
GROUP BY c.id;
-- Hasil: angka berlipat ganda untuk customer dengan order yang memiliki 2 payment
```

**Penyebab**: 1 order dengan 2 payment + 1 shipment → JOIN menggandakan baris menjadi 2 → `SUM(total)` terhitung dua kali.

**Solusi**: jangan JOIN tabel yang kolomnya tidak dibutuhkan.
```sql
SELECT c.id, SUM(o.total)
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.id
GROUP BY c.id;
```

### Jebakan 5: `GROUP BY` Tidak Menyebut Semua Kolom

```sql
SELECT customer_id, name, SUM(total)
FROM orders o JOIN customers c ON ...
GROUP BY customer_id;   -- kolom `name` tidak ada di GROUP BY
```

**Penyebab**: MySQL versi longgar memperbolehkan ini, tetapi kolom `name` yang muncul bersifat **tidak deterministik** — bisa berbeda setiap kali query dijalankan.

**Solusi**: cantumkan semua kolom non-aggregate di GROUP BY.
```sql
GROUP BY customer_id, c.name
```

---

## 3. Urutan Kerja Debugging (5 Langkah Terstruktur)

```
1. REPRODUCE  → jalankan query, lihat hasil aktual
2. ISOLATE    → sederhanakan query (hapus JOIN/filter satu per satu)
3. HYPOTHESIS → rumuskan dugaan penyebab (tulis 1 kalimat)
4. FIX MINI   → ubah hanya baris yang bermasalah
5. VERIFY     → jalankan ulang, bandingkan hasilnya
```

**Penting**: jangan melewati langkah. Banyak developer langsung ke langkah 4 (fix) tanpa menyusun hipotesis. Akibatnya: perbaikan berhasil tetapi tidak dipahami **mengapa berhasil** — bug yang sama berpotensi muncul kembali.

---

## 4. Cara Meminta AI: Diagnosis Dulu, Perbaikan Kemudian

**Anti-pattern utama**:
> "Fix query ini" → AI melakukan rewrite total, Anda tidak memahami akar masalahnya.

**Pola yang tepat — Langkah 1: diagnosis**:
```
Query berikut hasilnya salah. Gejala: total customer Andi muncul
4,5jt, padahal pengecekan manual menunjukkan hanya 1,25jt.

Query:
<paste>

Tolong lakukan hal berikut:
1. Tentukan kemungkinan penyebab (1-2 kalimat)
2. Berikan query SELECT singkat untuk membuktikan dugaan tersebut
3. JANGAN berikan perbaikan dulu

Saya ingin memahami MENGAPA terjadi, bukan sekadar hasilnya.
```

Lihat jawaban AI, **jalankan query pembuktiannya** secara mandiri. Apabila hipotesis terbukti, baru minta perbaikan.

**Pola yang tepat — Langkah 2: perbaikan**:
```
Hipotesis Anda benar (sudah saya verifikasi). Sekarang:
1. Berikan query perbaikan — ubah sesedikit mungkin
2. Tambahkan komentar 1 baris di atas bagian yang diubah: -- FIX: <apa & mengapa>
3. Sertakan query SELECT untuk membandingkan hasil sebelum & sesudah
```

---

## 5. Risiko dan Prioritas: Tidak Semua Bug Harus Diperbaiki Sekarang

| Tingkat Risiko | Contoh | Prioritas |
|----------------|--------|-----------|
| 🔴 Hasil salah di laporan ke customer/audit | Invoice dengan angka keliru | **Segera** |
| 🟡 Hasil salah di dashboard internal | Manajer melihat angka tidak wajar | Hari ini |
| 🟢 Query lambat tetapi hasilnya benar | Waktu muat halaman 3 detik | Sprint ini |
| 🔵 Edge case yang jarang terjadi | Bug saat customer memiliki email NULL | Backlog |

AI juga dapat membantu **menilai risiko**: *"Skenario apa yang dapat memicu bug ini di production?"*

---

## 6. Anti-Pattern yang Perlu Dihindari

| ❌ Tidak Disarankan | ✅ Praktik yang Tepat |
|---------------------|----------------------|
| Langsung meminta AI "fix query ini" | Minta diagnosis terlebih dahulu |
| Menerapkan perbaikan tanpa verifikasi | Selalu jalankan dan bandingkan output |
| Menulis ulang query secara total | Perbaikan minimal — ubah hanya baris yang bermasalah |
| Hanya menguji happy path | Uji edge case (NULL, 0 baris, banyak baris) |
| Tidak menyimpan query asli | Backup file atau gunakan `git diff` |
| Tidak mengecek EXPLAIN saat query lambat | Cek terlebih dahulu, sering dapat menjawab sendiri |

---

## Demo Live (15 menit)

Buka `sql-playground/queries/sesi-06-debug/01_inflated_revenue.sql`. Ikuti langkah bersama fasilitator:

1. Reproduce: jalankan query, perhatikan angka yang tidak wajar
2. Isolate: hapus satu JOIN per percobaan, temukan yang menyebabkan duplikasi baris
3. Hipotesis ke AI: "kemungkinan JOIN payments menyebabkan data terduplikasi?"
4. Verify: `SELECT order_id, COUNT(*) FROM payments GROUP BY order_id HAVING COUNT(*) > 1;`
5. Fix minimal: hapus JOIN payments yang tidak diperlukan
6. Verify: angka kembali sesuai ekspektasi

---

## Lanjut ke Latihan

[`latihan-05-debugging-studi-kasus/`](./latihan-05-debugging-studi-kasus/)

---

## Ringkasan

- **Symptom ≠ Penyebab**. Lakukan diagnosis terlebih dahulu, baru perbaiki.
- **5 jebakan**: NULL + `NOT IN`, BETWEEN datetime, prioritas AND/OR, JOIN explosion, GROUP BY ambigu.
- **5 langkah debugging**: Reproduce → Isolate → Hypothesis → Fix minimal → Verify.
- **Minta AI mendiagnosis terlebih dahulu**. Pendekatan "fix langsung" sering membuat bug muncul kembali.
- **EXPLAIN** seperti rontgen query — gunakan sebelum bertanya mengapa query lambat.
- **Tidak semua bug harus diperbaiki sekarang**. Gunakan penilaian risiko untuk menentukan prioritas.
