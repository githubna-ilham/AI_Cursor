# Sesi 5 (SQL) — Code Understanding & Documentation

Durasi: 90 menit
Modul: Hari 2 / Sesi 1 dari 4

> Versi SQL dari `materi.md`. Konsep sama, contoh & latihan disesuaikan untuk SQL query dengan schema `sql-playground/`. Pakai file ini saat workshop SQL.

---

## Learning Outcomes

Setelah sesi ini peserta mampu:

1. Membaca query SQL kompleks (multi-JOIN, CTE, window function, recursive) dengan strategi *outer-in* tanpa kelabakan.
2. Memanfaatkan AI (Cursor Chat mode Ask) untuk **second-opinion** memahami query — bukan menerima penjelasan mentah.
3. Mengekstrak **asumsi bisnis tersembunyi** dari syntax SQL ke dokumentasi bahasa manusia.
4. Menghasilkan dokumentasi minimal yang berguna: docstring query, ER diagram, architecture note.

---

## Konsep Inti

### 1. Kenapa "Membaca" Lebih Penting dari "Menulis"

| Aktivitas | Porsi waktu developer profesional |
|-----------|------------------------------------|
| Menulis kode/query baru | ~20% |
| **Membaca & memahami kode yang sudah ada** | **~80%** |
| Code review, debugging existing, planning | termasuk di 80% |

**Implikasi**: kalau Anda baru join project, mayoritas waktu pertama adalah *reading*, bukan *writing*. Kemampuan membaca cepat & akurat = kemampuan jadi produktif cepat.

AI mengubah ekonomi ini: yang dulu butuh 2 jam baca + tanya senior, sekarang bisa 20 menit baca + tanya AI. Tapi syaratnya: **Anda tahu cara bertanya yang tepat**.

### 2. Strategi Baca Query: Outer-In

Query SQL **dibaca berbeda** dari kode imperatif. Urutan eksekusi vs urutan tulis berbeda:

```sql
SELECT  ...                          -- 6. project kolom
FROM    customers c                  -- 1. tabel awal
JOIN    orders o ON ...              -- 2. join
WHERE   o.status = 'paid'            -- 3. filter row
GROUP BY c.city                      -- 4. agregasi
HAVING  SUM(total) > 1000000         -- 5. filter agregat
ORDER BY total_revenue DESC          -- 7. sort
LIMIT 10;                            -- 8. cap
```

**Cara baca yang efektif** (outer-in):

1. **Mulai dari `SELECT`**: kolom output apa? Itu *intent*-nya.
2. **`FROM` & `JOIN`**: tabel apa yang dilibatkan? Sketch ERD mental.
3. **`WHERE`**: row mana yang di-exclude? Itu *scope*.
4. **`GROUP BY` + `HAVING`**: bagaimana di-agregasi? Itu *granularity*.
5. **`ORDER BY` + `LIMIT`**: bagaimana di-rank? Itu *prioritas*.

Setelah baca 1 menit, Anda harusnya bisa jawab: *"Query ini menjawab pertanyaan bisnis apa?"*

### 3. Pola Query yang Sering Muncul di Project

Mengenali pola = cepat paham:

| Pola | Ciri | Kasus Bisnis Umum |
|------|------|-------------------|
| **Top-N by aggregate** | `GROUP BY` + `ORDER BY agg DESC LIMIT N` | Top customer, top product |
| **Cohort analysis** | CTE: `first_X` cohort + `activity_X` + `period_diff` | Retention, LTV |
| **Funnel / status breakdown** | `COUNT GROUP BY status` + percentage of total | Conversion rate, ops dashboard |
| **Rank per partition** | Window: `RANK() OVER (PARTITION BY ... ORDER BY ...)` | Top product *per kategori* |
| **Hierarchy / tree** | `WITH RECURSIVE` | Category tree, org chart |
| **Inventory / sum invariant** | LEFT JOIN derived + COALESCE | Stok physical vs catatan log |

Saat Anda lihat pola ini → langsung tahu *jenis* query → fokus baca jadi *detail bisnis-nya*.

### 4. Asumsi Tersembunyi: yang AI Sering Lewatkan

Query developer asli sering mengandung **asumsi bisnis** yang tidak tertulis di komentar. Contoh:

```sql
where o.status not in ('cancelled', 'refunded')
```

Asumsinya: *"order yang di-refund tidak hitung sebagai revenue"*. Tapi:
- Apakah `refunded` = full refund atau parsial?
- Apakah `cancelled` sebelum/setelah bayar?
- Apa beda dengan `failed`?

AI bisa jelaskan **apa** yang dilakukan filter, tapi sering tidak tahu **kenapa**. Jawaban "kenapa" perlu Anda gali dari:
- Komentar di kode lain
- Slack/Confluence team
- Tanya owner project langsung

Tugas Anda di Sesi 5: **tulis "kenapa" ini** di docstring supaya orang berikutnya tidak perlu gali lagi.

### 5. Tools untuk Pahami Query

| Tool | Fungsi | Kapan Pakai |
|------|--------|-------------|
| **`DESCRIBE table`** | Lihat schema tabel cepat | Awal eksplorasi |
| **`SHOW CREATE TABLE`** | DDL lengkap + index + FK | Verifikasi schema |
| **`EXPLAIN`** | Lihat execution plan | Pahami JOIN order, index usage |
| **`EXPLAIN ANALYZE`** | + waktu eksekusi nyata | Kalau query slow |
| **DBeaver "ER Diagram"** | Generate diagram dari schema | Visualize relasi |
| **DBeaver "SQL Format"** | Auto-format query messy | Sebelum baca query 200 baris |

Pakai tools **sebelum** tanya AI — sering jawab sendiri.

### 6. Pakai AI sebagai Reader (Bukan Writer)

Prompt template yang efektif untuk *understanding*:

```
@file <nama-query>.sql

Tolong jelaskan query ini dengan format:
1. TL;DR (1 kalimat — "query ini menjawab pertanyaan apa")
2. Tabel & kolom yang dipakai (list)
3. Logika step-by-step (FROM → WHERE → GROUP BY → HAVING → ORDER → LIMIT)
4. Asumsi bisnis (apa yang diasumsikan developer asli)
5. Edge case yang bisa bikin hasil aneh
6. Output sample (3-5 baris)
```

**Format terstruktur** memaksa AI jawab lengkap, tidak skip. Tanpa format, AI sering hanya kasih "summary" yang dangkal.

### 7. Iterasi Pemahaman

Jangan terima jawaban pertama mentah-mentah. Pola iterasi:

```
AI: <jawab format 6 poin>

Anda: "Di point 4, kamu bilang 'cancelled tidak hitung'. Tapi kenapa
       refunded juga tidak hitung? Bukankah refunded artinya sudah
       bayar tapi dikembalikan? Apakah ini bug atau policy bisnis?"

AI: <jelaskan dengan dua kemungkinan, minta klarifikasi dari domain expert>
```

Iterasi ini **menghasilkan pertanyaan untuk owner project** — itu seringkali lebih berharga dari jawaban AI sendiri.

### 8. Output Wajib: Dokumentasi

Akhir Sesi 5, Anda harus produksi 3 jenis dokumentasi:

| Jenis | Audiens | Format |
|-------|---------|--------|
| **Docstring per query** | Developer berikutnya yang buka file | Komentar di atas query (Markdown atau SQL comment) |
| **ER Diagram** | Developer baru join project | Mermaid `erDiagram` |
| **Architecture Note** | Tech lead, fasilitator review | Markdown 300 kata |

Dokumentasi yang baik = developer berikutnya menghemat 2 jam yang Anda habiskan hari ini.

### 9. Anti-pattern Reading

| ❌ Salah | ✅ Benar |
|----------|---------|
| "Jelaskan query ini" (vague) | Format 6 poin terstruktur |
| Terima jawaban AI tanpa baca query | Baca dulu 2 menit, baru tanya |
| Jawaban AI dipaste ke docstring as-is | Tulis ulang dengan kata-kata sendiri |
| Lupa run query untuk verifikasi | Run + bandingkan sample output |
| Skip ER diagram karena "sudah paham" | ER diagram = handover artifact |

---

## Demo Live (15 menit)

Skenario: query baru ditemukan di repo, tidak ada komentar.

Buka `sql-playground/queries/sesi-05-explore/03_cohort_retention.sql` di Cursor.

Langkah:

1. **Baca 2 menit**: identifikasi CTE, sketch mental.
2. **Prompt format 6 poin** ke Cursor Chat.
3. **Verifikasi**: run query → bandingkan klaim AI.
4. **Iterasi**: tanya "kenapa PERIOD_DIFF dipakai bukan TIMESTAMPDIFF?".
5. **Docstring**: tulis ringkasan 4-baris untuk file ini.

---

## Hands-on Latihan

Lihat [`latihan-04-eksplorasi-codebase/`](./latihan-04-eksplorasi-codebase/).

---

## Wrap-up & Q&A

1. Pola reading "outer-in" — kapan tidak berlaku?
2. Apa beda menjelaskan query untuk **junior** vs untuk **product manager**?
3. Kalau AI memberi jawaban yang Anda yakin salah, apa langkah pertama?

---

## Bacaan Lanjutan

- *SQL Antipatterns* — Bill Karwin (chapter 1-3)
- MySQL EXPLAIN documentation: <https://dev.mysql.com/doc/refman/8.0/en/explain.html>
- *Use the Index, Luke!* — <https://use-the-index-luke.com/>
