# Latihan 04 — Eksplorasi Codebase: 8 Query SQL

> 🗺️ **Tahap 11–12 dari 20** di [Perjalanan Project Hari 2](../../perjalanan-project.md)
> Sebelumnya: Hari 1 selesai (portfolio + SQL prompting drill) | Setelah ini: Sesi 6 Debugging

**Durasi**: 90 menit
**Tipe**: Hands-on individual
**Output**: 4–8 file `submissions/<nama>/05_NN_<judul>.md` berisi docstring + diagram + asumsi bisnis hasil eksplorasi.

---

## Konteks

Anda baru "join project" e-commerce. Di repo (`sql-playground/queries/sesi-05-explore/`) ada 8 query SQL yang ditulis developer sebelum Anda — **tanpa komentar, tanpa dokumentasi**.

Tugas Anda: **pahami semuanya** dengan bantuan AI, dan **tulis dokumentasi** yang akan dibaca developer baru berikutnya.

Mensimulasikan kondisi nyata: 80% waktu developer dihabiskan **memahami kode orang lain**, bukan menulis kode baru.

---

## Tujuan

Setelah latihan, peserta mampu:

1. **Membaca query SQL kompleks** (multi-JOIN, CTE, window function, recursive) dengan bantuan AI tanpa terlena disuapi.
2. Menggunakan **@-mention file** di Cursor Chat untuk attach query sebagai context.
3. **Memvalidasi penjelasan AI** dengan run query investigatif sendiri (bukan terima mentah).
4. **Menulis docstring & ER diagram** untuk knowledge transfer.

---

## Prasyarat

- MySQL Server + GUI client (DBeaver / MySQL Workbench / Cursor Database Client) terinstall.
- Cursor aktif, mode Ask (Chat) familiar (dari Hari 1).

---

## Langkah

### 1. Setup (10')

1.1. Buka file `sql-playground/00_schema.sql` di GUI client, lalu eksekusi seluruh isinya untuk membuat database dan semua tabel.

> Kalau schema sudah pernah dibuat sebelumnya, file ini akan DROP dan recreate semua tabel — data lama akan terhapus.

1.2. Buka file `sql-playground/01_sample_data.sql`, lalu eksekusi untuk mengisi data sample ke semua tabel.

1.3. Verifikasi data sudah masuk:

```sql
USE latihan_sql;
SHOW TABLES;
-- expect 9 tabel

SELECT 'customers' AS t, COUNT(*) FROM customers
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'orders', COUNT(*) FROM orders;
```

1.4. Buka folder `sql-playground/queries/sesi-05-explore/` di Cursor.

1.5. Buat folder submission: `mkdir -p submissions/<nama>/`.

### 2. Eksplorasi 8 Query (60')

Untuk **minimal 4 query** (idealnya semua 8), lakukan loop berikut:

#### 2a. Baca dulu (2 menit per query)

Buka file query, **baca pelan-pelan**, coba terka apa yang query lakukan. Jangan tanya AI dulu.

#### 2b. Tanya AI dengan format terstruktur (3 menit)

Di Cursor Chat (mode **Ask**):

```
@file 01_customer_lifetime_value.sql

Tolong jelaskan query ini dengan format:

1. **TL;DR** (1 kalimat)
2. **Tabel & kolom yang dipakai** (list)
3. **Logika step-by-step** (FROM → WHERE → GROUP BY → HAVING → ORDER → LIMIT)
4. **Asumsi bisnis** (apa yang diasumsikan developer asli)
5. **Edge case yang bisa bikin hasil aneh**
6. **Output sample** (3-5 baris dummy)
```

#### 2c. Verifikasi (3 menit)

Run query di MySQL. Bandingkan hasil dengan klaim AI di point 6. **Kalau tidak match** → AI hallucinate, tanya ulang dengan paste hasil real.

#### 2d. Tulis docstring sendiri (2 menit)

Di file `submissions/<nama>/05_01_customer_lifetime_value.md`:

```markdown
# Query 01 — Customer Lifetime Value

**TL;DR (versi saya)**: ...

**Asumsi bisnis yang implisit**:
- ...

**1 hal yang saya tidak duga sebelum baca**: ...

**Edge case yang perlu di-handle ke depan**:
- ...
```

Ulangi 2a–2d untuk minimal 4 query.

### 3. Generate ER Diagram (10')

```
@file ../../sql-playground/00_schema.sql

Generate ER diagram dalam Mermaid syntax untuk schema ini. Tampilkan:
- Semua 9 tabel dengan kolom utama
- Relasi 1:N dengan label
- Foreign key dengan notasi crow's foot

Format Mermaid `erDiagram`, langsung paste-able ke markdown.
```

Simpan ke `submissions/<nama>/05_er_diagram.md`.

### 4. Architecture Note (10')

Berdasarkan 4 query yang sudah dipahami + ER diagram, tulis `submissions/<nama>/05_arsitektur.md` (max 300 kata):

- **Domain bisnis apa**: e-commerce, scope: ?
- **Entitas utama**: core vs supporting
- **Pola query yang sering muncul**
- **1 hal yang developer berikutnya perlu tahu duluan**

---

## Submit

Folder `submissions/<nama>/` minimal berisi:

- 4–8 file `05_NN_<judul>.md` (docstring per query)
- `05_er_diagram.md` (Mermaid)
- `05_arsitektur.md` (note 300 kata)
- `refleksi.md` (≤150 kata):
  - Query mana paling sulit dipahami? Kenapa?
  - 1 hallucination AI yang Anda temukan & cara menemukannya
  - 1 template prompt yang akan Anda simpan

---

## Tips

- **Baca sebelum tanya** — prompt jadi lebih tajam setelah Anda punya hipotesis.
- **@-mention file**, jangan paste manual.
- **Run setiap klaim AI** di MySQL.
- **Pakai EXPLAIN** sebelum tanya kenapa query lambat — sering jawab sendiri.

---

## Common Issues

| Issue | Solusi |
|-------|--------|
| `Unknown column 'X'` saat run query | Schema belum di-apply ulang, run `00_schema.sql` lagi |
| AI bilang tabel `category` (singular) | Refresh @file mention; AI cache outdated. Schema kita pakai `categories` |
| Recursive CTE error di MySQL | Pastikan MySQL ≥ 8.0; MariaDB ≥ 10.2 |
| Hasil agregat berbeda dari klaim AI | Itu **expected** — sample data sengaja ada subtle mismatch. Tulis di docstring. |
