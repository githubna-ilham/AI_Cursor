# Latihan 02 — Prompting Drill: SQL Query

> 🗺️ Bagian dari [Sesi 3 — Prompting & Context](../materi.md)
> Sebelumnya: Latihan 01 (Tour Cursor) di Sesi 2 | Setelah ini: Latihan 03 (Build Feature) di Sesi 4

**Durasi**: 60 menit (4 tahap × ~13 menit + review)
**Tipe**: Hands-on individual
**Output**: 4 file `tahap-N.md` berisi prompt + query SQL hasil + verifikasi + refleksi.

---

## Konteks

Sesi 3 mengajarkan **3 pola prompting** (Role-based, Context-based, Constraint-based) plus pola **iterasi**. Latihan ini melatih keempatnya dengan domain yang **familiar untuk semua peserta — SQL query**.

Kenapa SQL?
- Dipakai di hampir semua project (backend, data, analytics).
- Hasilnya **mudah diverifikasi**: query → run → cek hasil.
- AI sering "kelihatan benar" tapi salah subtle (join salah, group by hilang, dialect ngacau) — bagus untuk latih *reviewer-first mindset*.
- Tidak butuh setup project besar; cukup playground online.

---

## Tujuan

Setelah latihan, peserta mampu:

1. Memberikan **schema** sebagai konteks AI lewat @-mention atau paste langsung.
2. Memilih **pola prompting** (Role / Context / Constraint) sesuai jenis pertanyaan SQL.
3. **Iterasi** prompt saat AI memberi query yang salah dialect / mismatch schema.
4. Memverifikasi output AI dengan menjalankan query di playground & membaca hasil.

---

## Prasyarat

- Lulus Latihan 01 (Cursor aktif, 4 mode dipahami).
- Akses ke **SQL playground** salah satu:
  - <https://www.db-fiddle.com> (rekomendasi — pilih PostgreSQL 16)
  - Supabase project Anda (kalau sudah punya dari pelatihan ini)
  - DBeaver / pgAdmin lokal
- Tidak perlu hafal SQL — AI yang menulis, Anda yang me-review.

---

## Skenario: Schema E-Commerce Mini

Anda diberi schema 4 tabel berikut. **Wajib paste schema ini ke playground SQL Anda sebelum mulai**, supaya bisa run query yang AI generate.

```sql
-- ==== SCHEMA ====
create table customers (
  id serial primary key,
  name varchar(100) not null,
  email varchar(120) unique not null,
  city varchar(60),
  created_at timestamptz default now()
);

create table products (
  id serial primary key,
  sku varchar(20) unique not null,
  name varchar(120) not null,
  category varchar(60),
  price numeric(12,2) not null,
  stock int default 0
);

create table orders (
  id serial primary key,
  customer_id int references customers(id),
  status varchar(20) default 'pending',  -- pending|paid|shipped|cancelled
  created_at timestamptz default now()
);

create table order_items (
  id serial primary key,
  order_id int references orders(id),
  product_id int references products(id),
  qty int not null,
  unit_price numeric(12,2) not null
);

-- ==== SAMPLE DATA ====
insert into customers (name, email, city) values
  ('Andi',  'andi@x.com',  'Jakarta'),
  ('Budi',  'budi@x.com',  'Bandung'),
  ('Citra', 'citra@x.com', 'Jakarta'),
  ('Dewi',  'dewi@x.com',  'Surabaya'),
  ('Eka',   'eka@x.com',   'Jakarta');

insert into products (sku, name, category, price, stock) values
  ('SKU-001', 'Mouse Wireless',   'Electronics', 150000, 50),
  ('SKU-002', 'Keyboard Mech',    'Electronics', 850000, 20),
  ('SKU-003', 'Notebook A5',      'Stationery',  35000,  200),
  ('SKU-004', 'Coffee Beans 1kg', 'Grocery',     180000, 30),
  ('SKU-005', 'USB Cable',        'Electronics', 45000,  100);

insert into orders (customer_id, status, created_at) values
  (1, 'paid',     '2026-04-15'),
  (1, 'shipped',  '2026-05-02'),
  (2, 'paid',     '2026-05-10'),
  (3, 'paid',     '2026-05-12'),
  (3, 'cancelled','2026-05-13'),
  (4, 'shipped',  '2026-06-01'),
  (5, 'pending',  '2026-06-05');

insert into order_items (order_id, product_id, qty, unit_price) values
  (1, 1, 2, 150000), (1, 3, 5, 35000),
  (2, 2, 1, 850000),
  (3, 4, 3, 180000), (3, 5, 2, 45000),
  (4, 1, 1, 150000), (4, 2, 1, 850000),
  (6, 3, 10, 35000),
  (7, 4, 1, 180000);
```

---

## Aturan Main

- Untuk tiap tahap, peserta **wajib**:
  1. Tulis prompt di file `submissions/<nama>/tahap-N.md` **sebelum** dijalankan ke Cursor.
  2. Jalankan di Cursor (Chat/Ask mode disarankan — lebih cepat untuk SQL).
  3. Salin query yang AI generate ke file submission.
  4. **Run query** di playground SQL, screenshot atau salin hasil row-nya.
  5. Tulis refleksi singkat: apakah hasil sesuai harapan? Kalau tidak, iterasi prompt.
- Boleh iterasi maks 3 kali per tahap (sebut versi `prompt-v1`, `prompt-v2`, dst).
- Setiap tahap melatih **pola prompting berbeda** — sengaja diatur supaya peserta merasakan kapan tiap pola dipakai.

---

## Tahap

### Tahap 3 — Role-based Prompting (15')

**Skenario**: Tim sales minta laporan harian "berapa total revenue dari order dengan status `paid` atau `shipped` bulan ini, per kota customer."

**Pola yang dilatih**: **Role-based** — beri AI "topi" peran tertentu sehingga gaya outputnya sesuai standar profesi.

**Contoh prompt** (silakan tiru, lalu sesuaikan):

```
Sebagai data analyst SQL berpengalaman di e-commerce, tulis query
PostgreSQL untuk:

Pertanyaan: total revenue (sum dari qty * unit_price) dari order
dengan status 'paid' atau 'shipped' di bulan Mei 2026, di-group by
kota customer, urut revenue terbesar dulu.

Schema (paste sekali, AI ingat untuk pertanyaan berikut):
[paste schema 4 tabel dari atas]

Output yang diharapkan:
- 1 query SELECT yang bisa langsung dijalankan
- Beri komentar SQL singkat untuk join dan agregasi
- Sebutkan asumsi (kalau ada) sebelum query
```

**Yang harus diverifikasi**:
- Apakah AI memakai `INNER JOIN` 4 tabel dengan benar (customers ← orders ← order_items → products)?
- Apakah filter `status IN ('paid','shipped')` ada?
- Apakah `date_trunc` atau range tanggal sesuai Mei 2026?
- Apakah `GROUP BY city` benar dan tidak hilang field?

**Acceptance**: query bisa di-paste ke playground tanpa edit, hasilkan baris dengan kolom `city, total_revenue`, dan datanya **konsisten dengan hand-count Anda** (Jakarta paling tinggi karena Andi & Citra di sana).

### Tahap 4 — Context-based Prompting (15')

**Skenario**: Ada laporan dari user "produk SKU-005 (USB Cable) ada di order, tapi tidak masuk ringkasan penjualan bulan ini." Anda perlu cek apakah ada bug data atau bug query.

**Pola yang dilatih**: **Context-based** — jawaban sangat bergantung pada artefak (schema + sample data). Beri AI **konteks lengkap** supaya analisanya akurat.

**Contoh prompt**:

```
Berdasarkan schema dan sample data berikut, jawab pertanyaan diagnostik:

[paste schema + sample data dari skenario di atas]

Pertanyaan investigasi:
1. Berapa kali produk SKU-005 muncul di order_items?
2. Untuk tiap kemunculan, apa status order-nya?
3. Apakah ada baris order_items yang order-nya berstatus 'pending'
   atau 'cancelled'?
4. Berikan query yang mengisolasi 3 jawaban di atas.

Output: 3 query terpisah dengan label A/B/C, plus penjelasan 1
kalimat untuk tiap query.
```

**Yang harus diverifikasi**:
- AI seharusnya temukan: SKU-005 ada di order id=3 (status `paid` ✅) dan order id=... cek lagi.
- Hand-check sendiri pakai data sample: berapa kali SKU-005 muncul? (jawab: 1× di order 3).
- Kalau AI bilang "tidak ada masalah", apakah konsisten dengan hand-check?

**Acceptance**: 3 query berjalan, dan kesimpulan AI sesuai dengan data nyata di playground.

### Tahap 5 — Constraint-based Prompting (15')

**Skenario**: Manajemen minta "list 3 customer dengan total belanja terbesar, beserta jumlah order mereka, **tapi jangan pakai subquery** (ada policy review code: subquery sulit di-tune)."

**Pola yang dilatih**: **Constraint-based** — ruang solusi terlalu lebar (subquery, CTE, window function semua bisa), persempit dengan constraint eksplisit.

**Contoh prompt**:

```
Tulis query PostgreSQL dengan SEMUA constraint berikut:

Tujuan: top 3 customer dengan total spending terbesar all-time,
hanya hitung order dengan status 'paid' atau 'shipped'.

Output kolom: customer_name, total_orders, total_spending (urut desc).

Constraint TEKNIS:
1. TIDAK BOLEH pakai subquery (no SELECT ... FROM (SELECT ...))
2. TIDAK BOLEH pakai WITH/CTE
3. WAJIB pakai single SELECT dengan JOIN + GROUP BY
4. Hasil dibatasi 3 baris (pakai LIMIT)
5. Total spending hitung dari qty * unit_price di order_items

Schema: [paste]

Kalau constraint #1 dan #2 tidak bisa dipenuhi, jelaskan kenapa
sebelum tulis query alternatif.
```

**Yang harus diverifikasi**:
- AI patuh constraint? Cek manual: ada `SELECT ... FROM (SELECT` atau `WITH ... AS`? Kalau iya, tolak.
- Iterasi: kalau AI melanggar, prompt ulang: *"Kamu masih pakai subquery di baris X. Tulis ulang dengan murni JOIN."*
- Apakah `LIMIT 3` ada? Apakah `ORDER BY total_spending DESC` benar?

**Acceptance**: query lulus 5 constraint + return tepat 3 baris.

### Tahap 6 — Iterasi & Counter-Example (15')

**Skenario**: Anda dapat query dari Tahap 5, tapi merasa **lambat** untuk data 1 juta baris. Anda ingin AI:
1. Jelaskan kenapa lambat
2. Beri 5 cara mempercepat
3. Implementasi versi tercepat dengan asumsi data 1 juta baris

**Pola yang dilatih**: **Iterasi & Counter-Example** — prompt awal jarang sempurna. Latih siklus *Prompt → Baca → Feedback spesifik*.

**Contoh prompt awal**:

```
Berikut query saya:
[paste query Tahap 5]

Skenario produksi:
- tabel orders: 1 juta baris
- tabel order_items: 5 juta baris
- tabel customers: 100 ribu baris

Jelaskan:
1. Bottleneck query ini di production (estimate, no need EXPLAIN actual)
2. 5 cara mempercepat — urutkan dari dampak tertinggi ke terendah
3. Implementasi 1 cara teratas (tulis query baru)
```

**Iterasi #2 (kalau jawaban kurang spesifik)** — ini bagian latihannya:

```
Jawaban kamu kurang spesifik di poin 2 — "tambah index" terlalu generik.
Untuk tiap cara mempercepat:
- Sebutkan index spesifik (kolom mana, B-tree vs hash)
- Estimasi peningkatan kasar (mis. 2x lebih cepat)
- Sebutkan trade-off (mis. write jadi lebih lambat)

Lalu untuk query baru di poin 3, jelaskan kenapa pilih pendekatan itu
dibanding 4 cara lainnya.
```

**Counter-example prompt** (opsional, level ekstra):

```
Beri saya 3 query yang JUSTRU LAMBAT untuk skenario ini, dengan
penjelasan kenapa lambat. Tujuan: saya mau tahu anti-pattern apa
yang harus saya hindari saat tulis query agregasi.
```

**Acceptance**: Anda paham 5 cara optimasi + bisa jelaskan kenapa pilih satu, plus bisa identifikasi anti-pattern.

---

## Submit

Folder `submissions/<nama>/` berisi:

- `tahap-3.md` — prompt + query + screenshot/result + refleksi singkat
- `tahap-4.md` — sda
- `tahap-5.md` — sda
- `tahap-6.md` — sda (boleh ada prompt-v1, v2, v3 untuk iterasi)
- `refleksi.md` (≤200 kata) menjawab:
  1. Pola prompting mana yang paling cocok untuk pertanyaan SQL?
  2. Bug/hallucination AI yang paling membingungkan dan cara Anda menemukannya
  3. 1 template prompt yang akan Anda simpan untuk pakai esok hari

---

## Tips

- **Paste schema sekali di awal Chat**. Setelah itu AI di Chat ingat untuk pertanyaan berikut di session yang sama.
- **Sebutkan dialect** (PostgreSQL / MySQL / SQLite) di prompt — sintaks beda (mis. `LIMIT` vs `TOP`, `date_trunc` vs `DATE_FORMAT`).
- **Jangan percaya, run di playground**. AI sering bikin query yang lolos parse tapi hasilnya salah.
- **Hand-count untuk data kecil**. Sample data kita kecil — verifikasi manual lebih cepat daripada debug query.
- **Iterasi dengan feedback spesifik**, bukan "ini salah". Sebutkan baris mana yang melanggar constraint mana.

---

## Common Issues

| Issue | Solusi |
|-------|--------|
| AI pakai MySQL syntax padahal kita PostgreSQL | Sebut dialect di prompt awal: "PostgreSQL 16" |
| Query hasil 0 baris padahal harusnya ada | Cek `WHERE` filter — sering AI salah range tanggal atau timezone |
| AI bilang "subquery tidak bisa dihindari" di Tahap 5 | Tantang: "tulis dengan JOIN saja, izinkan WHERE complex. Subquery selalu bisa di-flatten." |
| Hasil di playground beda dengan klaim AI | AI hallucinate jumlah baris. **Selalu run sendiri**. |
| Schema lupa di-paste, AI nebak struktur tabel | Mulai ulang Chat dengan paste schema lengkap |
| AI nambah tabel yang tidak ada di schema | Beri constraint: "hanya pakai 4 tabel yang saya kasih, jangan asumsikan tabel `inventory` atau lainnya" |
