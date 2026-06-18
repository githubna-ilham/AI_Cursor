-- ==============================================================
-- Template Assertion Query (dbt-style)
-- ==============================================================
--
-- Konvensi: setiap test adalah query SELECT yang return 0 BARIS
-- saat PASS, dan N BARIS saat FAIL (tiap baris = 1 row yang melanggar).
--
-- Cara baca: kalau hasil > 0 baris, test GAGAL. Investigate baris-baris
-- yang muncul.
--
-- Pakai:
--   select count(*) as failed_rows from (
--     <isi assertion query di sini>
--   ) t;
--   -- failed_rows = 0 → PASS
-- ==============================================================

-- ---------- Template 1: NULL Check ----------
-- Test: kolom X di tabel Y tidak boleh null
-- select id from <tabel> where <kolom> is null;

-- ---------- Template 2: Unique Check ----------
-- Test: kombinasi (a, b) harus unique
-- select a, b, count(*) as dup
-- from <tabel>
-- group by a, b
-- having count(*) > 1;

-- ---------- Template 3: Foreign Key Orphan ----------
-- Test: setiap FK di child harus exist di parent
-- select c.id, c.fk_id
-- from <child> c
-- left join <parent> p on p.id = c.fk_id
-- where p.id is null;

-- ---------- Template 4: Range Check ----------
-- Test: nilai numerik harus dalam rentang
-- select id, val
-- from <tabel>
-- where val < <min> or val > <max>;

-- ---------- Template 5: Enum / Allowed Values ----------
-- Test: kolom status hanya boleh nilai tertentu
-- select id, status
-- from <tabel>
-- where status not in ('a', 'b', 'c');

-- ---------- Template 6: Sum Invariant ----------
-- Test: sum(a) di tabel X harus sama dengan sum(b) di tabel Y
-- with totals as (
--   select (select sum(a) from x) as sum_a,
--          (select sum(b) from y) as sum_b
-- )
-- select sum_a, sum_b from totals where sum_a <> sum_b;

-- ---------- Template 7: Referential Density ----------
-- Test: setiap parent harus punya minimal 1 child
-- select p.id
-- from <parent> p
-- left join <child> c on c.parent_id = p.id
-- where c.id is null;

-- ---------- Template 8: Temporal Consistency ----------
-- Test: kolom_b harus >= kolom_a (mis. delivered_at >= shipped_at)
-- select id, col_a, col_b
-- from <tabel>
-- where col_b < col_a;
