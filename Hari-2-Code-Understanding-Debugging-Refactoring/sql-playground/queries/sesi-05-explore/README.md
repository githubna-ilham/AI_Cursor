# Sesi 5 — Code Understanding (Eksplorasi Query)

Folder ini berisi **8 query SQL** yang ditulis "developer sebelum Anda" — Anda baru join project, dan tugas Anda adalah **memahami** apa yang masing-masing query lakukan, dengan bantuan AI.

---

## Aturan Main

1. **Baca query terlebih dahulu** sebelum tanya AI — coba terka logika selama 1-2 menit.
2. Buka Cursor → mode **Ask** (Chat) → @-mention file query → minta AI:
   - Jelaskan **apa** yang query lakukan (1 paragraf)
   - Jelaskan **kenapa** logikanya begitu (bisnis context)
   - Sebutkan **tabel & kolom** yang diakses
   - Identifikasi **edge case** yang bisa bikin hasil aneh
3. **Run query** di MySQL → bandingkan hasil dengan dugaan Anda.
4. Tulis **docstring** Anda sendiri di file `submissions/<nama>/05_<nomor>_<judul>.md` berisi:
   - Ringkasan dalam bahasa Anda sendiri
   - Asumsi bisnis yang implisit
   - 1 hal yang Anda tidak duga sebelum baca

---

## Daftar Query

| # | File | Skill SQL yang Dipakai | Konteks Bisnis |
|---|------|-------------------------|------------------|
| 01 | `01_customer_lifetime_value.sql` | GROUP BY · HAVING · agregat · DATEDIFF | Marketing — siapa customer paling bernilai |
| 02 | `02_monthly_revenue_per_category.sql` | Multi-JOIN · COALESCE · CASE WHEN · DATE_FORMAT · parent-child | Finance — revenue per kategori induk per bulan |
| 03 | `03_cohort_retention.sql` | CTE · PERIOD_DIFF · subquery scalar · self-join via cohort | Analytics — retensi customer per cohort |
| 04 | `04_inventory_discrepancy.sql` | LEFT JOIN derived · CASE WHEN · COALESCE · status mapping | Warehouse — stok di DB vs catatan pergerakan |
| 05 | `05_top_product_per_category.sql` | Window function (RANK, DENSE_RANK, SUM OVER) · CTE · partition | Procurement — top 3 produk per kategori |
| 06 | `06_tier_upgrade_suggestion.sql` | Subquery derived · CASE WHEN nested · DATE_SUB | CRM — siapa yang harus di-upgrade/downgrade tier |
| 07 | `07_order_funnel.sql` | CTE · CROSS JOIN · NULLIF · custom sort order | Ops — funnel status order 90 hari |
| 08 | `08_category_tree.sql` | **WITH RECURSIVE** · subquery scalar · CONCAT path · REPEAT indent | Admin — pohon kategori dengan revenue per simpul |

Susunan dari **dasar → advanced**: GROUP BY ekspresif → multi-JOIN → CTE → window function → recursive CTE.

---

## Prompt Template untuk AI

Pakai template ini di Cursor Chat (mode **Ask**):

```
@file 01_customer_lifetime_value.sql

Tolong jelaskan query ini dengan format:

1. **TL;DR** (1 kalimat)
2. **Tabel & kolom yang dipakai** (list)
3. **Logika step-by-step** (FROM → WHERE → GROUP BY → HAVING → ORDER → LIMIT)
4. **Asumsi bisnis** (apa yang diasumsikan developer asli, mis. "cancelled & refunded tidak dihitung")
5. **Edge case yang bisa bikin hasil aneh** (mis. customer tanpa order)
6. **Output sample** (3-5 baris)
```

Iterasi prompt kalau jawaban kurang detail (mis. *"Jelaskan kenapa HAVING dipakai bukan WHERE di sini"*).

---

## Setelah Selesai 8 Query

Anda akan punya **dokumentasi internal** untuk seluruh query yang ada di project ini — bahan yang berharga saat onboarding developer baru atau audit pertengahan tahun.

Lanjut ke Sesi 6 (Debugging): folder `queries/sesi-06-debug/`.
