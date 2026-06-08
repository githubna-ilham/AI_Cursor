-- =============================================================================
-- Sample Data: E-Commerce Mini
-- Jalankan SETELAH 00_schema.sql
--
-- Volume: cukup realistis untuk eksplorasi (≈ 200 baris) tapi masih bisa
-- hand-count untuk verifikasi manual saat latihan.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- categories (5 main + 2 sub)
-- -----------------------------------------------------------------------------
insert into categories (id, name, parent_id) values
  (1, 'Electronics', null),
  (2, 'Stationery',  null),
  (3, 'Grocery',     null),
  (4, 'Fashion',     null),
  (5, 'Home',        null),
  (6, 'Audio',       1),     -- sub-kategori Electronics
  (7, 'Peripherals', 1);     -- sub-kategori Electronics

-- -----------------------------------------------------------------------------
-- customers (12 customer di 4 kota dengan 4 tier)
-- -----------------------------------------------------------------------------
insert into customers (id, name, email, city, tier, created_at) values
  (1,  'Andi Pratama',   'andi@x.com',   'Jakarta',   'gold',     '2025-01-15'),
  (2,  'Budi Santoso',   'budi@x.com',   'Bandung',   'silver',   '2025-02-20'),
  (3,  'Citra Dewi',     'citra@x.com',  'Jakarta',   'regular',  '2025-03-10'),
  (4,  'Dewi Lestari',   'dewi@x.com',   'Surabaya',  'platinum', '2024-11-05'),
  (5,  'Eka Wijaya',     'eka@x.com',    'Jakarta',   'regular',  '2025-04-01'),
  (6,  'Fajar Nugroho',  'fajar@x.com',  'Yogyakarta','silver',   '2025-05-12'),
  (7,  'Gita Permata',   'gita@x.com',   'Bandung',   'gold',     '2024-12-20'),
  (8,  'Hadi Kusuma',    'hadi@x.com',   'Surabaya',  'regular',  '2025-06-08'),
  (9,  'Indra Mahesa',   'indra@x.com',  'Jakarta',   'silver',   '2025-07-15'),
  (10, 'Joko Anwar',    'joko@x.com',   'Yogyakarta','regular',  '2025-08-22'),
  (11, 'Kartika Sari',   'kartika@x.com','Bandung',   'platinum', '2024-10-01'),
  (12, 'Lina Marlina',   'lina@x.com',   'Jakarta',   'regular',  '2026-01-05'),
  -- Customer 13 (Mira): baru daftar Juni 2026, belum pernah order →
  -- bahan untuk queries/sesi-06-debug/02_customers_no_orders.sql
  (13, 'Mira Anggraini', 'mira@x.com',   'Jakarta',   'regular',  '2026-06-02');

-- -----------------------------------------------------------------------------
-- products (15 produk lintas kategori)
-- -----------------------------------------------------------------------------
insert into products (id, sku, name, category_id, price, stock, is_active) values
  (1,  'SKU-001', 'Mouse Wireless Logi',  7,   150000,  50,  1),
  (2,  'SKU-002', 'Keyboard Mech RGB',    7,   850000,  20,  1),
  (3,  'SKU-003', 'Notebook A5 100 Page', 2,   35000,   200, 1),
  (4,  'SKU-004', 'Coffee Beans Arabica', 3,   180000,  30,  1),
  (5,  'SKU-005', 'USB-C Cable 1m',       7,   45000,   100, 1),
  (6,  'SKU-006', 'Headphone Bluetooth',  6,   1250000, 15,  1),
  (7,  'SKU-007', 'Speaker Portable',     6,   650000,  25,  1),
  (8,  'SKU-008', 'T-Shirt Cotton XL',    4,   125000,  80,  1),
  (9,  'SKU-009', 'Sneakers Running 42',  4,   850000,  18,  1),
  (10, 'SKU-010', 'Pen Gel Hitam 0.5',    2,   12000,   500, 1),
  (11, 'SKU-011', 'Coffee Maker 1L',      5,   1450000, 8,   1),
  (12, 'SKU-012', 'Bedsheet Queen Size',  5,   320000,  40,  1),
  (13, 'SKU-013', 'Green Tea 100g',       3,   45000,   60,  1),
  (14, 'SKU-014', 'Webcam Full HD',       7,   480000,  0,   1),         -- stock 0, masih aktif
  (15, 'SKU-015', 'Old Modem ADSL',       1,   200000,  5,   0);         -- discontinued

-- -----------------------------------------------------------------------------
-- orders (25 order tersebar Sep 2025 - Jun 2026)
-- -----------------------------------------------------------------------------
insert into orders (id, customer_id, status, subtotal, discount, total, created_at) values
  (1,  1,  'delivered', 335000,  0,     335000,  '2025-09-15 10:23:00'),
  (2,  2,  'paid',      850000,  50000, 800000,  '2025-09-20 14:11:00'),
  (3,  3,  'delivered', 630000,  30000, 600000,  '2025-10-05 09:30:00'),
  (4,  4,  'delivered', 1250000, 0,     1250000, '2025-10-12 16:42:00'),
  (5,  5,  'cancelled', 195000,  0,     195000,  '2025-10-18 11:00:00'),
  (6,  1,  'delivered', 480000,  0,     480000,  '2025-11-02 13:25:00'),
  (7,  6,  'delivered', 215000,  15000, 200000,  '2025-11-15 19:50:00'),
  (8,  7,  'paid',      1450000, 100000,1350000, '2025-12-01 08:15:00'),
  (9,  3,  'refunded',  35000,   0,     35000,   '2025-12-10 12:30:00'),
  (10, 4,  'delivered', 1875000, 75000, 1800000, '2025-12-22 17:45:00'),
  (11, 8,  'delivered', 285000,  0,     285000,  '2026-01-10 10:00:00'),
  (12, 1,  'delivered', 1250000, 0,     1250000, '2026-01-25 15:30:00'),
  (13, 9,  'delivered', 770000,  0,     770000,  '2026-02-05 09:45:00'),
  (14, 11, 'delivered', 1900000, 100000,1800000, '2026-02-14 14:20:00'),
  (15, 7,  'delivered', 350000,  20000, 330000,  '2026-02-28 11:35:00'),
  (16, 5,  'delivered', 225000,  0,     225000,  '2026-03-10 16:00:00'),
  (17, 10, 'paid',      45000,   0,     45000,   '2026-03-20 08:50:00'),
  (18, 2,  'shipped',   1700000, 50000, 1650000, '2026-04-02 13:10:00'),
  (19, 4,  'delivered', 540000,  0,     540000,  '2026-04-15 17:25:00'),
  (20, 12, 'delivered', 35000,   0,     35000,   '2026-05-01 10:40:00'),
  (21, 6,  'delivered', 1450000, 50000, 1400000, '2026-05-08 12:15:00'),
  (22, 1,  'paid',      650000,  0,     650000,  '2026-05-20 09:20:00'),
  (23, 8,  'shipped',   320000,  0,     320000,  '2026-06-01 14:55:00'),
  (24, 11, 'delivered', 850000,  50000, 800000,  '2026-06-05 11:30:00'),
  (25, 3,  'pending',   180000,  0,     180000,  '2026-06-08 18:10:00'),
  -- Order 26: customer Andi (1) di Mei 2026 — sengaja dipasangkan dengan
  -- multiple payments & shipments untuk memunculkan JOIN explosion bug
  -- di queries/sesi-06-debug/01_inflated_revenue.sql
  (26, 1,    'paid',      600000,  0,     600000,  '2026-05-25 13:15:00'),
  -- Order 27: GUEST CHECKOUT (customer_id NULL) — order tanpa akun.
  -- Ini bikin "NOT IN (SELECT customer_id FROM orders)" jadi 0 baris karena
  -- subquery mengandung NULL → bahan bug NULL trap di
  -- queries/sesi-06-debug/02_customers_no_orders.sql
  (27, null, 'delivered', 35000,   0,     35000,   '2026-04-10 14:20:00');

-- -----------------------------------------------------------------------------
-- order_items (≈ 60 baris detail item)
-- -----------------------------------------------------------------------------
insert into order_items (order_id, product_id, qty, unit_price) values
  -- order 1: andi
  (1, 1, 1, 150000), (1, 3, 5, 35000), (1, 10, 1, 12000),
  -- order 2: budi
  (2, 2, 1, 850000),
  -- order 3: citra
  (3, 4, 3, 180000), (3, 5, 2, 45000),
  -- order 4: dewi
  (4, 6, 1, 1250000),
  -- order 5: eka (cancelled)
  (5, 3, 5, 35000), (5, 10, 1, 12000), (5, 5, 1, 45000),
  -- order 6: andi
  (6, 14, 1, 480000),
  -- order 7: fajar
  (7, 1, 1, 150000), (7, 13, 1, 45000), (7, 10, 1, 12000), (7, 3, 1, 35000),
  -- order 8: gita
  (8, 11, 1, 1450000),
  -- order 9: citra (refunded)
  (9, 3, 1, 35000),
  -- order 10: dewi
  (10, 2, 1, 850000), (10, 7, 1, 650000), (10, 12, 1, 320000), (10, 5, 1, 45000),
  -- order 11: hadi
  (11, 8, 2, 125000), (11, 10, 1, 12000), (11, 3, 1, 35000),
  -- order 12: andi
  (12, 6, 1, 1250000),
  -- order 13: indra
  (13, 9, 1, 850000),
  -- order 14: kartika (catatan: sengaja subtotal di header TIDAK match sum line_total → bahan debug Sesi 6/8)
  (14, 11, 1, 1450000), (14, 2, 1, 850000),
  -- order 15: gita
  (15, 7, 1, 650000), (15, 13, 1, 45000),
  -- order 16: eka
  (16, 8, 1, 125000), (16, 1, 1, 150000),
  -- order 17: joko
  (17, 5, 1, 45000),
  -- order 18: budi
  (18, 11, 1, 1450000), (18, 12, 1, 320000),
  -- order 19: dewi
  (19, 7, 1, 650000),
  -- order 20: lina
  (20, 3, 1, 35000),
  -- order 21: fajar
  (21, 11, 1, 1450000),
  -- order 22: andi
  (22, 7, 1, 650000),
  -- order 23: hadi
  (23, 12, 1, 320000),
  -- order 24: kartika
  (24, 9, 1, 850000),
  -- order 25: citra (pending)
  (25, 4, 1, 180000),
  -- order 26: andi (mei 2026) - mouse 4 unit = 600k
  (26, 1, 4, 150000),
  -- order 27: guest checkout (customer_id NULL) - 1 notebook
  (27, 3, 1, 35000);

-- -----------------------------------------------------------------------------
-- reviews (15 review)
-- -----------------------------------------------------------------------------
insert into reviews (customer_id, product_id, rating, comment, created_at) values
  (1, 1,  5, 'Mouse-nya enak, klik responsif',           '2025-09-25 10:00:00'),
  (1, 3,  4, 'Kertas oke, agak tipis',                   '2025-09-26 09:00:00'),
  (2, 2,  5, 'Keyboard mantap, switch enak',             '2025-10-01 14:00:00'),
  (3, 4,  3, 'Aromanya kurang kuat',                     '2025-10-15 11:00:00'),
  (3, 5,  4, 'Kabel awet',                               '2025-10-16 12:00:00'),
  (4, 6,  5, 'Suara jernih, batre tahan lama',           '2025-10-20 16:00:00'),
  (7, 11, 5, 'Coffee maker bagus, hasil seduhan top',    '2025-12-05 09:00:00'),
  (4, 2,  4, 'Keyboard solid, RGB cantik',               '2025-12-25 15:00:00'),
  (4, 7,  5, 'Speaker bagus untuk kerja di kafe',        '2025-12-26 10:00:00'),
  (1, 6,  4, 'Headphone empuk, noise cancel oke',        '2026-01-30 13:00:00'),
  (11, 11,5, 'Best coffee maker investment',             '2026-02-20 11:00:00'),
  (6, 11, 4, 'Performance bagus, mahal sedikit',         '2026-05-15 14:00:00'),
  (1, 7,  3, 'Suara mid bagus, bass lemah',              '2026-05-28 16:00:00'),
  (11, 9, 5, 'Sneakers nyaman dipakai lari',             '2026-06-07 09:00:00'),
  (8, 12, 4, 'Bedsheet halus, warna sesuai foto',        '2026-06-08 10:00:00');

-- -----------------------------------------------------------------------------
-- payments (1-2 per order, kecuali pending/cancelled)
-- -----------------------------------------------------------------------------
insert into payments (order_id, method, amount, status, paid_at, created_at) values
  (1,  'gopay',    335000,  'success', '2025-09-15 10:25:00', '2025-09-15 10:23:00'),
  (2,  'cc',       800000,  'success', '2025-09-20 14:13:00', '2025-09-20 14:11:00'),
  (3,  'transfer', 600000,  'success', '2025-10-05 09:32:00', '2025-10-05 09:30:00'),
  (4,  'cc',       1250000, 'success', '2025-10-12 16:44:00', '2025-10-12 16:42:00'),
  (5,  'gopay',    195000,  'failed',  null,                  '2025-10-18 11:00:00'),
  (6,  'ovo',      480000,  'success', '2025-11-02 13:27:00', '2025-11-02 13:25:00'),
  (7,  'transfer', 200000,  'success', '2025-11-15 19:52:00', '2025-11-15 19:50:00'),
  (8,  'cc',       1350000, 'success', '2025-12-01 08:17:00', '2025-12-01 08:15:00'),
  (9,  'cc',       35000,   'refunded','2025-12-10 12:32:00', '2025-12-10 12:30:00'),
  (10, 'cc',       1800000, 'success', '2025-12-22 17:47:00', '2025-12-22 17:45:00'),
  (11, 'gopay',    285000,  'success', '2026-01-10 10:02:00', '2026-01-10 10:00:00'),
  (12, 'cc',       1250000, 'success', '2026-01-25 15:32:00', '2026-01-25 15:30:00'),
  (13, 'transfer', 770000,  'success', '2026-02-05 09:47:00', '2026-02-05 09:45:00'),
  (14, 'cc',       1800000, 'success', '2026-02-14 14:22:00', '2026-02-14 14:20:00'),
  (15, 'ovo',      330000,  'success', '2026-02-28 11:37:00', '2026-02-28 11:35:00'),
  (16, 'gopay',    225000,  'success', '2026-03-10 16:02:00', '2026-03-10 16:00:00'),
  (17, 'cod',      45000,   'pending', null,                  '2026-03-20 08:50:00'),
  (18, 'cc',       1650000, 'success', '2026-04-02 13:12:00', '2026-04-02 13:10:00'),
  (19, 'transfer', 540000,  'success', '2026-04-15 17:27:00', '2026-04-15 17:25:00'),
  (20, 'gopay',    35000,   'success', '2026-05-01 10:42:00', '2026-05-01 10:40:00'),
  (21, 'cc',       1400000, 'success', '2026-05-08 12:17:00', '2026-05-08 12:15:00'),
  (22, 'ovo',      650000,  'success', '2026-05-20 09:22:00', '2026-05-20 09:20:00'),
  (23, 'cc',       320000,  'success', '2026-06-01 14:57:00', '2026-06-01 14:55:00'),
  (24, 'cc',       800000,  'success', '2026-06-05 11:32:00', '2026-06-05 11:30:00'),
  -- order 25 pending → belum ada payment
  -- Order 22 & 26: sengaja multi-payment + multi-shipment untuk bahan debug
  -- queries/sesi-06-debug/01_inflated_revenue.sql (JOIN explosion)
  (22, 'cc',       650000,  'failed',  null,                  '2026-05-20 09:19:00'),
  (26, 'gopay',    600000,  'failed',  null,                  '2026-05-25 13:14:00'),
  (26, 'gopay',    600000,  'failed',  null,                  '2026-05-25 13:14:30'),
  (26, 'cc',       600000,  'success', '2026-05-25 13:18:00', '2026-05-25 13:15:00'),
  -- Order 27: guest checkout (cod)
  (27, 'cod',      35000,   'success', '2026-04-12 11:00:00', '2026-04-10 14:20:00');

-- -----------------------------------------------------------------------------
-- shipments (untuk order yang sudah paid+)
-- -----------------------------------------------------------------------------
insert into shipments (order_id, courier, tracking_no, status, shipped_at, delivered_at, created_at) values
  (1,  'jne',     'JNE001AA', 'delivered', '2025-09-16 09:00:00', '2025-09-18 14:30:00', '2025-09-16 08:00:00'),
  (2,  'jnt',     'JNT002BB', 'in_transit',  '2025-09-21 10:00:00', null,                  '2025-09-21 09:00:00'),
  (3,  'sicepat', 'SCP003CC', 'delivered', '2025-10-06 11:00:00', '2025-10-08 16:00:00', '2025-10-06 10:00:00'),
  (4,  'jne',     'JNE004DD', 'delivered', '2025-10-13 09:30:00', '2025-10-15 13:15:00', '2025-10-13 08:30:00'),
  (6,  'gosend',  'GSD006FF', 'delivered', '2025-11-03 12:00:00', '2025-11-03 14:45:00', '2025-11-03 11:00:00'),
  (7,  'jnt',     'JNT007GG', 'delivered', '2025-11-16 10:00:00', '2025-11-18 11:30:00', '2025-11-16 09:00:00'),
  (8,  'jne',     'JNE008HH', 'delivered', '2025-12-02 11:00:00', '2025-12-04 15:00:00', '2025-12-02 10:00:00'),
  (10, 'jne',     'JNE010II', 'delivered', '2025-12-23 09:00:00', '2025-12-26 14:00:00', '2025-12-23 08:00:00'),
  (11, 'jnt',     'JNT011JJ', 'delivered', '2026-01-11 10:00:00', '2026-01-13 12:00:00', '2026-01-11 09:00:00'),
  (12, 'jne',     'JNE012KK', 'delivered', '2026-01-26 09:30:00', '2026-01-28 15:30:00', '2026-01-26 08:30:00'),
  (13, 'sicepat', 'SCP013LL', 'delivered', '2026-02-06 10:00:00', '2026-02-08 14:00:00', '2026-02-06 09:00:00'),
  (14, 'jne',     'JNE014MM', 'delivered', '2026-02-15 11:00:00', '2026-02-17 16:00:00', '2026-02-15 10:00:00'),
  (15, 'gosend',  'GSD015NN', 'delivered', '2026-03-01 09:00:00', '2026-03-01 12:30:00', '2026-03-01 08:00:00'),
  (16, 'jnt',     'JNT016OO', 'delivered', '2026-03-11 10:00:00', '2026-03-13 11:00:00', '2026-03-11 09:00:00'),
  (18, 'jne',     'JNE018PP', 'in_transit',  '2026-04-03 09:30:00', null,                  '2026-04-03 08:30:00'),
  (19, 'sicepat', 'SCP019QQ', 'delivered', '2026-04-16 10:00:00', '2026-04-18 13:00:00', '2026-04-16 09:00:00'),
  (20, 'grabexpress','GEX020RR','delivered','2026-05-02 11:00:00', '2026-05-02 13:30:00', '2026-05-02 10:00:00'),
  (21, 'jne',     'JNE021SS', 'delivered', '2026-05-09 09:00:00', '2026-05-11 14:30:00', '2026-05-09 08:00:00'),
  (22, 'gosend',  'GSD022TT', 'delivered', '2026-05-21 10:00:00', '2026-05-21 13:00:00', '2026-05-21 09:00:00'),
  (23, 'jnt',     'JNT023UU', 'picked_up',  '2026-06-02 11:00:00', null,                  '2026-06-02 10:00:00'),
  (24, 'jne',     'JNE024VV', 'delivered', '2026-06-06 09:30:00', '2026-06-08 13:00:00', '2026-06-06 08:30:00'),
  -- Order 26: multi-shipment (1 dikirim → returned, 1 redelivered) → JOIN explosion
  (26, 'jne',     'JNE026WW', 'returned',  '2026-05-26 09:00:00', null,                  '2026-05-26 08:00:00'),
  (26, 'gosend',  'GSD026XX', 'delivered', '2026-05-28 10:00:00', '2026-05-28 14:00:00', '2026-05-28 09:00:00'),
  -- Order 27: guest checkout — 1 shipment delivered
  (27, 'jnt',     'JNT027YY', 'delivered', '2026-04-11 09:00:00', '2026-04-13 11:30:00', '2026-04-11 08:00:00');

-- -----------------------------------------------------------------------------
-- inventory_log (audit pergerakan stok, sengaja sparse untuk eksplorasi)
-- -----------------------------------------------------------------------------
insert into inventory_log (product_id, movement_type, qty_change, reason, ref_order_id, created_at) values
  (1, 'in',         100, 'initial stock',          null, '2025-09-01 09:00:00'),
  (3, 'in',         300, 'initial stock',          null, '2025-09-01 09:00:00'),
  (4, 'in',         50,  'initial stock',          null, '2025-09-01 09:00:00'),
  (1, 'out',        -1,  'order #1',               1,    '2025-09-15 10:23:00'),
  (3, 'out',        -5,  'order #1',               1,    '2025-09-15 10:23:00'),
  (4, 'out',        -3,  'order #3',               3,    '2025-10-05 09:30:00'),
  (6, 'in',         20,  'restock from vendor',    null, '2025-10-20 14:00:00'),
  (6, 'out',        -1,  'order #4',               4,    '2025-10-12 16:42:00'),
  (3, 'in',         100, 'restock',                null, '2025-11-01 10:00:00'),
  (3, 'adjustment', -10, 'damaged inventory',      null, '2025-12-15 13:00:00'),
  (9, 'return',     1,   'order #9 refund',        9,    '2025-12-11 09:00:00');
  -- catatan: log sengaja TIDAK lengkap (banyak order tidak ada catatan stok) —
  -- ini realistic & jadi bahan diskusi Sesi 5/6 (kenapa stok mismatch?)

-- =============================================================================
-- Selesai. Verifikasi cepat:
--   select 'customers' as t, count(*) as n from customers
--   union all select 'products', count(*) from products
--   union all select 'orders', count(*) from orders
--   union all select 'order_items', count(*) from order_items
--   union all select 'reviews', count(*) from reviews
--   union all select 'payments', count(*) from payments
--   union all select 'shipments', count(*) from shipments
--   union all select 'inventory_log', count(*) from inventory_log;
-- =============================================================================
