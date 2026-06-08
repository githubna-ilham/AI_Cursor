# Sesi 5 (SQL) — Memahami Query Orang Lain

Durasi: 90 menit

## Bayangkan Skenario Ini

Anda hari pertama masuk kerja di tim data. Atasan kasih akses ke folder berisi **8 file SQL**. Tidak ada komentar, tidak ada dokumentasi. Tugas Anda: pahami query-nya, supaya minggu depan bisa bantu modifikasi.

Tanpa AI: 1-2 jam per query, tanya rekan kerja, baca pelan-pelan, sering bingung.
Dengan AI sebagai partner: bisa 15-20 menit per query — kalau Anda tahu cara bertanya yang benar.

Itulah inti Sesi 5.

---

## Yang Akan Anda Pelajari

1. Cara baca query SQL panjang dengan urutan yang masuk akal
2. Cara minta AI jelaskan query tanpa dapat jawaban dangkal
3. Cara menulis catatan supaya developer berikutnya tidak perlu bingung lagi

---

## 1. Kenapa Membaca Lebih Penting dari Menulis

Rata-rata developer profesional:
- **20% waktu** menulis kode baru
- **80% waktu** membaca, memahami, dan memodifikasi kode yang sudah ada

Artinya: kalau Anda baru join tim, **kemampuan utama** Anda bukan ngetik query baru. Tapi **memahami** query lama dan ngomong dengan rekan kerja tentang itu.

**Analogi**: bayangkan Anda pindah ke kota baru. Skill paling penting bukan bikin jalan baru — tapi tahu cara baca peta + tanya orang lokal.

---

## 2. Cara Baca Query Panjang: Mulai dari Mana?

Query SQL dibaca **berbeda** dari kode biasa. Bukan dari atas ke bawah.

Coba lihat query ini:

```sql
SELECT  c.name, SUM(o.total) AS revenue
FROM    customers c
JOIN    orders o ON o.customer_id = c.id
WHERE   o.status = 'paid'
GROUP BY c.name
ORDER BY revenue DESC
LIMIT 10;
```

**Cara baca yang lebih cepat — "outer-in"**:

| Step | Lihat bagian | Pertanyaan yang dijawab |
|------|--------------|--------------------------|
| 1 | `SELECT` | "Yang saya mau lihat di hasil itu apa?" → nama customer + revenue |
| 2 | `FROM` + `JOIN` | "Data dari tabel mana saja?" → customers + orders |
| 3 | `WHERE` | "Yang dipilih cuma yang seperti apa?" → status paid |
| 4 | `GROUP BY` | "Di-grup per apa?" → per nama customer |
| 5 | `ORDER BY` + `LIMIT` | "Diurut bagaimana, dibatasi berapa?" → revenue terbesar, ambil 10 |

Setelah 5 step di atas (1-2 menit), Anda sudah bisa **terka apa pertanyaan bisnis** yang query ini jawab: *"Siapa 10 customer paling besar revenue-nya yang sudah bayar?"*

Kalau **belum bisa terka** setelah 2 menit, baru tanya AI.

---

## 3. Pola yang Sering Anda Temui

Setelah baca beberapa query, Anda akan sadar: query SQL itu cuma beberapa "pola umum" yang diulang-ulang. Mengenali pola = baca cepat.

5 pola paling sering:

### Pola 1 — Top-N (Yang Paling)
> "Siapa **top 10** customer paling besar belanjanya?"

Ciri: `GROUP BY` + `ORDER BY ... DESC` + `LIMIT N`

### Pola 2 — Per Kelompok (Group-by Sederhana)
> "**Berapa total revenue** tiap kota?"

Ciri: `GROUP BY <kategori>` + `SUM/COUNT`

### Pola 3 — Funnel (Berapa Banyak Tiap Tahap)
> "Dari semua order, **berapa persen** yang akhirnya delivered?"

Ciri: `COUNT` per status + persentase

### Pola 4 — Pencarian Bug Data
> "Adakah produk dengan **stok beda** antara catatan vs realita?"

Ciri: `LEFT JOIN` + bandingkan 2 angka

### Pola 5 — Pohon Kategori (Bertingkat)
> "Tampilkan **semua sub-kategori** Electronics."

Ciri: `WITH RECURSIVE` (jangan panik, ini cuma "ulangi sambil naik")

Saat Anda lihat query baru, tanya: *"Ini pola yang mana?"* Setengah pertanyaan langsung terjawab.

---

## 4. Asumsi Tersembunyi: Yang AI Tidak Bisa Bantu

Coba lihat baris ini:

```sql
WHERE status NOT IN ('cancelled', 'refunded')
```

AI bisa jelaskan **apa** yang dilakukan: "filter ini buang order yang dibatalkan atau di-refund".

Tapi AI tidak tahu **kenapa**:
- Kenapa `refunded` juga di-buang? Bukannya `refunded` artinya sudah pernah bayar?
- Apakah `cancelled` bisa berarti "user cancel" atau "system cancel"?
- Mungkin developer asli mengasumsikan revenue = **uang yang benar-benar masuk** (bukan transaksi yang batal-bayar).

**Tugas Anda**: gali "kenapa" ini dengan tanya rekan kerja (atau Slack/Notion), lalu **tulis di catatan**. Supaya developer berikutnya tidak perlu bingung lagi.

> 💡 **Aturan emas**: AI hebat menjelaskan *apa*. *Kenapa* harus dari manusia yang tahu konteks bisnis.

---

## 5. Cara Tanya AI yang Bener

Ada 2 cara tanya AI. Coba bedakan kualitasnya:

**Tanya cara A (vague)**:
> "Jelaskan query ini"

Hasil AI: 1-2 paragraf umum, sering miss detail penting.

**Tanya cara B (format terstruktur)** — pakai ini:

```
@file 01_customer_lifetime_value.sql

Tolong jelaskan query ini dengan format:

1. **TL;DR** — 1 kalimat: query ini menjawab pertanyaan apa
2. **Tabel & kolom yang dipakai** — list singkat
3. **Logika step-by-step** — FROM, WHERE, GROUP BY, ORDER, dst.
4. **Asumsi bisnis** — apa yang diasumsikan, mis. "cancelled tidak hitung"
5. **Edge case** — kondisi yang bikin hasil aneh
6. **Output sample** — 3-5 baris contoh
```

Hasil AI cara B: jauh lebih lengkap, tidak skip bagian penting.

Aturan: **selalu kasih format**. Tanpa format, AI bingung mau detail seberapa.

---

## 6. Verifikasi: Jangan Percaya, Jalankan

AI sering ngarang (istilah teknis: "hallucination"). Khususnya saat bilang "outputnya begini".

**Wajib**: setelah AI jelaskan, **jalankan query-nya** di MySQL/DBeaver Anda. Bandingkan:

- Jumlah baris yang AI klaim vs yang muncul
- 3 baris pertama match atau tidak
- Sum angka utama (mis. total revenue) — match atau tidak

Kalau **tidak match** → AI salah. Tanya ulang dengan paste hasil real:

> "Kamu bilang outputnya 50 baris dengan total 12 juta. Saya run, dapat 47 baris dengan total 11.5 juta. Coba periksa lagi logika WHERE-nya."

---

## 7. Output Wajib: 3 Jenis Dokumentasi

Akhir Sesi 5, Anda akan punya 3 hal:

| Jenis | Apa Isinya | Untuk Siapa |
|-------|------------|-------------|
| **Docstring per query** | 4-5 baris penjelasan di atas query | Developer yang buka file ini besok |
| **ER Diagram** | Gambar tabel + relasinya | Developer baru join project |
| **Architecture Note** | 1 halaman: "project ini tentang apa, polanya gimana" | Tech lead, calon developer baru |

Dokumentasi yang baik = developer berikutnya **menghemat 2 jam** yang Anda habiskan hari ini.

---

## 8. Jangan Lakukan Ini

| ❌ Salah | ✅ Benar |
|---------|---------|
| Langsung tanya AI tanpa baca dulu | Baca 2 menit, baru tanya |
| "Jelaskan query ini" (vague) | Pakai format 6-poin |
| Terima jawaban AI mentah | Verifikasi dengan jalankan query |
| Copy-paste jawaban AI ke docstring | Tulis ulang dengan kata-kata Anda sendiri |
| Skip ER diagram karena "sudah paham" | Tetap bikin — orang lain belum paham |

---

## Demo Live (15 menit)

Buka `sql-playground/queries/sesi-05-explore/03_cohort_retention.sql`. Bareng fasilitator:

1. Baca 2 menit
2. Tanya AI pakai format 6-poin
3. Jalankan query, bandingkan
4. Tulis docstring 4 baris

---

## Lanjut ke Latihan

[`latihan-04-eksplorasi-codebase/`](./latihan-04-eksplorasi-codebase/)

---

## Ringkasan 1 Halaman

- Developer profesional **80% waktu baca**, 20% nulis. Kuasai baca dulu.
- Query dibaca **outer-in**: SELECT → FROM/JOIN → WHERE → GROUP → ORDER.
- Kenali 5 pola umum (Top-N, group-by, funnel, bug data, pohon).
- AI bagus jelasin **apa**, bukan **kenapa**. Gali kenapa dari rekan kerja.
- Tanya AI selalu pakai **format terstruktur** (6 poin).
- Verifikasi dengan **jalankan query** — AI sering ngarang.
- Output Sesi 5: docstring per query + ER diagram + architecture note.
