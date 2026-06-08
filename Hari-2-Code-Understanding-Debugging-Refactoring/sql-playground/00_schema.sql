-- =============================================================================
-- Schema: E-Commerce Mini (Extended)
-- Untuk pelatihan AI Cursor Hari 2 — Code Understanding, Debug, Refactor, Test
-- DBMS target: MySQL 8.0+ (kompatibel MySQL 9.x & MariaDB 10.5+)
-- =============================================================================
--
-- Lanjutan dari schema 4-tabel Hari 1 (Sesi 3 latihan-02), diperluas jadi 9
-- tabel supaya cukup material untuk eksplorasi 4 sesi:
--
--   Hari 1: customers, products, orders, order_items                  [4 tabel]
--   Hari 2: + categories, reviews, payments, shipments, inventory_log [9 tabel]
--
-- Drop semua dulu (urutan reverse FK) — aman untuk re-run.
-- =============================================================================

drop table if exists inventory_log;
drop table if exists shipments;
drop table if exists payments;
drop table if exists reviews;
drop table if exists order_items;
drop table if exists orders;
drop table if exists products;
drop table if exists categories;
drop table if exists customers;

-- -----------------------------------------------------------------------------
-- categories — kategori produk (Electronics, Stationery, Grocery, dst)
-- -----------------------------------------------------------------------------
create table categories (
  id int auto_increment primary key,
  name varchar(60) not null unique,
  parent_id int null,                                -- self-ref untuk sub-kategori
  created_at timestamp default current_timestamp,
  constraint fk_categories_parent foreign key (parent_id) references categories(id)
);

create index idx_categories_parent on categories(parent_id);

-- -----------------------------------------------------------------------------
-- customers — pembeli
-- -----------------------------------------------------------------------------
create table customers (
  id int auto_increment primary key,
  name varchar(100) not null,
  email varchar(120) unique not null,
  city varchar(60),
  tier varchar(20) default 'regular',                -- regular|silver|gold|platinum
  created_at timestamp default current_timestamp
);

create index idx_customers_city on customers(city);
create index idx_customers_tier on customers(tier);

-- -----------------------------------------------------------------------------
-- products — barang dijual
-- -----------------------------------------------------------------------------
create table products (
  id int auto_increment primary key,
  sku varchar(20) unique not null,
  name varchar(120) not null,
  category_id int,                                   -- replace varchar 'category' Hari 1
  price decimal(12,2) not null,
  stock int default 0,
  is_active tinyint(1) default 1,
  created_at timestamp default current_timestamp,
  constraint fk_products_category foreign key (category_id) references categories(id)
);

create index idx_products_category on products(category_id);
create index idx_products_active on products(is_active);

-- -----------------------------------------------------------------------------
-- orders — header pesanan
-- -----------------------------------------------------------------------------
create table orders (
  id int auto_increment primary key,
  customer_id int not null,
  status varchar(20) default 'pending',              -- pending|paid|shipped|delivered|cancelled|refunded
  subtotal decimal(12,2) default 0,                  -- denormalized untuk performance (sum order_items)
  discount decimal(12,2) default 0,
  total decimal(12,2) default 0,                     -- subtotal - discount
  created_at timestamp default current_timestamp,
  updated_at timestamp default current_timestamp on update current_timestamp,
  constraint fk_orders_customer foreign key (customer_id) references customers(id)
);

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
  unit_price decimal(12,2) not null,                 -- snapshot harga saat order
  line_total decimal(12,2) generated always as (qty * unit_price) stored,
  constraint fk_oi_order foreign key (order_id) references orders(id) on delete cascade,
  constraint fk_oi_product foreign key (product_id) references products(id)
);

create index idx_oi_order on order_items(order_id);
create index idx_oi_product on order_items(product_id);

-- -----------------------------------------------------------------------------
-- reviews — review customer untuk produk
-- -----------------------------------------------------------------------------
create table reviews (
  id int auto_increment primary key,
  customer_id int not null,
  product_id int not null,
  rating tinyint not null check (rating between 1 and 5),
  comment text,
  created_at timestamp default current_timestamp,
  constraint fk_reviews_customer foreign key (customer_id) references customers(id),
  constraint fk_reviews_product foreign key (product_id) references products(id),
  unique key uk_reviews_customer_product (customer_id, product_id)
);

create index idx_reviews_product on reviews(product_id);
create index idx_reviews_rating on reviews(rating);

-- -----------------------------------------------------------------------------
-- payments — record pembayaran per order
-- -----------------------------------------------------------------------------
create table payments (
  id int auto_increment primary key,
  order_id int not null,
  method varchar(30) not null,                       -- cc|debit|gopay|ovo|transfer|cod
  amount decimal(12,2) not null,
  status varchar(20) default 'pending',              -- pending|success|failed|refunded
  paid_at timestamp null,
  created_at timestamp default current_timestamp,
  constraint fk_payments_order foreign key (order_id) references orders(id)
);

create index idx_payments_order on payments(order_id);
create index idx_payments_status on payments(status);
create index idx_payments_paid_at on payments(paid_at);

-- -----------------------------------------------------------------------------
-- shipments — pengiriman per order
-- -----------------------------------------------------------------------------
create table shipments (
  id int auto_increment primary key,
  order_id int not null,
  courier varchar(30) not null,                      -- jne|jnt|sicepat|gosend|grabexpress
  tracking_no varchar(60),
  status varchar(20) default 'pending',              -- pending|picked_up|in_transit|delivered|returned
  shipped_at timestamp null,
  delivered_at timestamp null,
  created_at timestamp default current_timestamp,
  constraint fk_shipments_order foreign key (order_id) references orders(id)
);

create index idx_shipments_order on shipments(order_id);
create index idx_shipments_status on shipments(status);
create index idx_shipments_courier on shipments(courier);

-- -----------------------------------------------------------------------------
-- inventory_log — audit pergerakan stok (untuk seeded bug Sesi 6)
-- -----------------------------------------------------------------------------
create table inventory_log (
  id int auto_increment primary key,
  product_id int not null,
  movement_type varchar(20) not null,                -- in|out|adjustment|return
  qty_change int not null,                           -- positif untuk in, negatif untuk out
  reason varchar(120),
  ref_order_id int null,
  created_at timestamp default current_timestamp,
  constraint fk_invlog_product foreign key (product_id) references products(id),
  constraint fk_invlog_order foreign key (ref_order_id) references orders(id)
);

create index idx_invlog_product on inventory_log(product_id);
create index idx_invlog_created on inventory_log(created_at);

-- =============================================================================
-- Selesai. Lanjut: jalankan 01_sample_data.sql
-- =============================================================================
