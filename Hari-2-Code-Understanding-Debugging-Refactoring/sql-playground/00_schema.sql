-- =============================================================================
-- Schema: E-Commerce Mini (Extended) — Hari 2
-- DBMS target: MySQL 8.0+ (kompatibel MySQL 9.x & MariaDB 10.5+)
-- =============================================================================
--
-- File ini SELF-CONTAINED — bisa di-run ulang tanpa peduli state sebelumnya
-- (mis. peserta sempat bikin tabel di Hari 1 dengan struktur berbeda).
--
-- Tahap eksekusi:
--   1. CREATE DATABASE (kalau belum ada) + USE
--   2. Disable FK checks → DROP semua tabel
--   3. Re-enable FK checks
--   4. CREATE TABLE × 9 dari nol (TANPA "IF NOT EXISTS" → memastikan
--      struktur baru benar-benar terpasang)
--
-- Setelah file ini sukses, lanjut: jalankan 01_sample_data.sql
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. Database
-- -----------------------------------------------------------------------------
create database if not exists latihan_sql
  character set utf8mb4
  collate utf8mb4_unicode_ci;

use latihan_sql;

-- -----------------------------------------------------------------------------
-- 2. Bersihkan tabel lama (urutan apa pun aman karena FK checks off)
-- -----------------------------------------------------------------------------
set foreign_key_checks = 0;

drop table if exists inventory_log;
drop table if exists shipments;
drop table if exists payments;
drop table if exists reviews;
drop table if exists order_items;
drop table if exists orders;
drop table if exists products;
drop table if exists categories;
drop table if exists customers;

set foreign_key_checks = 1;

-- =============================================================================
-- 3. Tabel-tabel (urutan: induk dulu sebelum anak yang punya FK)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- categories — kategori produk (mendukung sub-kategori via parent_id)
-- -----------------------------------------------------------------------------
create table categories (
  id int auto_increment primary key,
  name varchar(60) not null unique,
  parent_id int null,
  created_at timestamp not null default current_timestamp,
  constraint fk_categories_parent foreign key (parent_id) references categories(id)
) engine = innodb default charset = utf8mb4;

create index idx_categories_parent on categories(parent_id);

-- -----------------------------------------------------------------------------
-- customers — pembeli
-- -----------------------------------------------------------------------------
create table customers (
  id int auto_increment primary key,
  name varchar(100) not null,
  email varchar(120) not null unique,
  city varchar(60) null,
  tier varchar(20) not null default 'regular',           -- regular|silver|gold|platinum
  created_at timestamp not null default current_timestamp
) engine = innodb default charset = utf8mb4;

create index idx_customers_city on customers(city);
create index idx_customers_tier on customers(tier);

-- -----------------------------------------------------------------------------
-- products — barang dijual
-- -----------------------------------------------------------------------------
create table products (
  id int auto_increment primary key,
  sku varchar(20) not null unique,
  name varchar(120) not null,
  category_id int null,
  price decimal(12, 2) not null,
  stock int not null default 0,
  is_active tinyint(1) not null default 1,
  created_at timestamp not null default current_timestamp,
  constraint fk_products_category foreign key (category_id) references categories(id)
) engine = innodb default charset = utf8mb4;

create index idx_products_category on products(category_id);
create index idx_products_active on products(is_active);

-- -----------------------------------------------------------------------------
-- orders — header pesanan
-- -----------------------------------------------------------------------------
create table orders (
  id int auto_increment primary key,
  customer_id int not null,
  status varchar(20) not null default 'pending',         -- pending|paid|shipped|delivered|cancelled|refunded
  subtotal decimal(12, 2) not null default 0,            -- denormalized (sum order_items)
  discount decimal(12, 2) not null default 0,
  total decimal(12, 2) not null default 0,               -- subtotal - discount
  created_at timestamp not null default current_timestamp,
  updated_at timestamp not null default current_timestamp on update current_timestamp,
  constraint fk_orders_customer foreign key (customer_id) references customers(id)
) engine = innodb default charset = utf8mb4;

create index idx_orders_customer on orders(customer_id);
create index idx_orders_status on orders(status);
create index idx_orders_created on orders(created_at);

-- -----------------------------------------------------------------------------
-- order_items — detail item per order
-- -----------------------------------------------------------------------------
create table order_items (
  id int auto_increment primary key,
  order_id int not null,
  product_id int not null,
  qty int not null check (qty > 0),
  unit_price decimal(12, 2) not null,                    -- snapshot harga saat order
  line_total decimal(14, 2) generated always as (qty * unit_price) stored,
  constraint fk_oi_order foreign key (order_id) references orders(id) on delete cascade,
  constraint fk_oi_product foreign key (product_id) references products(id)
) engine = innodb default charset = utf8mb4;

create index idx_oi_order on order_items(order_id);
create index idx_oi_product on order_items(product_id);

-- -----------------------------------------------------------------------------
-- reviews — review customer untuk produk (1 review per pasangan)
-- -----------------------------------------------------------------------------
create table reviews (
  id int auto_increment primary key,
  customer_id int not null,
  product_id int not null,
  rating tinyint not null check (rating between 1 and 5),
  comment text null,
  created_at timestamp not null default current_timestamp,
  constraint fk_reviews_customer foreign key (customer_id) references customers(id),
  constraint fk_reviews_product foreign key (product_id) references products(id),
  constraint uk_reviews_customer_product unique (customer_id, product_id)
) engine = innodb default charset = utf8mb4;

create index idx_reviews_product on reviews(product_id);
create index idx_reviews_rating on reviews(rating);

-- -----------------------------------------------------------------------------
-- payments — record pembayaran per order
-- -----------------------------------------------------------------------------
create table payments (
  id int auto_increment primary key,
  order_id int not null,
  method varchar(30) not null,                           -- cc|debit|gopay|ovo|transfer|cod
  amount decimal(12, 2) not null,
  status varchar(20) not null default 'pending',         -- pending|success|failed|refunded
  paid_at timestamp null,
  created_at timestamp not null default current_timestamp,
  constraint fk_payments_order foreign key (order_id) references orders(id)
) engine = innodb default charset = utf8mb4;

create index idx_payments_order on payments(order_id);
create index idx_payments_status on payments(status);
create index idx_payments_paid_at on payments(paid_at);

-- -----------------------------------------------------------------------------
-- shipments — pengiriman per order
-- -----------------------------------------------------------------------------
create table shipments (
  id int auto_increment primary key,
  order_id int not null,
  courier varchar(30) not null,                          -- jne|jnt|sicepat|gosend|grabexpress
  tracking_no varchar(60) null,
  status varchar(20) not null default 'pending',         -- pending|picked_up|in_transit|delivered|returned
  shipped_at timestamp null,
  delivered_at timestamp null,
  created_at timestamp not null default current_timestamp,
  constraint fk_shipments_order foreign key (order_id) references orders(id)
) engine = innodb default charset = utf8mb4;

create index idx_shipments_order on shipments(order_id);
create index idx_shipments_status on shipments(status);
create index idx_shipments_courier on shipments(courier);

-- -----------------------------------------------------------------------------
-- inventory_log — audit pergerakan stok (untuk seeded bug Sesi 6 & 8)
-- -----------------------------------------------------------------------------
create table inventory_log (
  id int auto_increment primary key,
  product_id int not null,
  movement_type varchar(20) not null,                    -- in|out|adjustment|return
  qty_change int not null,                               -- + untuk in, - untuk out
  reason varchar(120) null,
  ref_order_id int null,
  created_at timestamp not null default current_timestamp,
  constraint fk_invlog_product foreign key (product_id) references products(id),
  constraint fk_invlog_order foreign key (ref_order_id) references orders(id)
) engine = innodb default charset = utf8mb4;

create index idx_invlog_product on inventory_log(product_id);
create index idx_invlog_created on inventory_log(created_at);

-- =============================================================================
-- Verifikasi cepat (run terpisah setelah file ini sukses):
--
--   show tables;
--   -- harus muncul 9 tabel: categories, customers, products, orders,
--   --                       order_items, reviews, payments, shipments,
--   --                       inventory_log
--
-- Selanjutnya: jalankan 01_sample_data.sql
-- =============================================================================
