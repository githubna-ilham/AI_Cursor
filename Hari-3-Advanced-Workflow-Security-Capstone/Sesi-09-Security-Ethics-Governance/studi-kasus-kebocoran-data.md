# Studi Kasus — Kebocoran Data & Insiden Keamanan terkait AI Coding Assistant

**Tujuan**: Memberi peserta gambaran konkret tentang dampak insiden nyata dan menyusun reflex pencegahan.

**Format diskusi**: 3 kelompok, masing-masing membahas 1 kasus selama 10 menit, kemudian sharing silang 20 menit.

---

## Kasus 1 — Samsung Semiconductor & ChatGPT (April 2023)

### Ringkasan Insiden (berdasarkan laporan media publik)

Dalam rentang ~3 minggu setelah Samsung Semiconductor mengizinkan karyawan menggunakan ChatGPT, dilaporkan terjadi tiga insiden terpisah:

1. Seorang engineer menyalin source code internal terkait pengukuran semiconductor ke ChatGPT untuk debugging.
2. Engineer lain menyalin kode untuk mengoptimasi yield ke ChatGPT.
3. Karyawan menyalin transkrip meeting ke ChatGPT untuk diringkas.

### Dampak

- Potensi paparan kekayaan intelektual ke pihak ketiga (kebijakan retensi OpenAI saat itu mengindikasikan data dapat dipakai untuk training, tergantung pengaturan).
- Samsung kemudian membatasi/melarang penggunaan generative AI publik di lingkungan internal.
- Insiden menjadi referensi global tentang risiko adopsi AI tanpa pelatihan & kontrol.

### Analisis Akar Masalah

- Tidak ada training mandatory sebelum aktivasi tool.
- Tidak ada kebijakan klasifikasi data dengan matriks "apa boleh masuk prompt".
- Tidak ada kanal alternatif (mis. self-hosted) untuk kebutuhan yang sama.

### Pertanyaan Diskusi

1. Jika Anda CISO Samsung, apa 3 kontrol yang akan Anda terapkan **sebelum** mengizinkan tool serupa?
2. Apakah pelarangan total adalah respons proporsional? Apa alternatifnya?
3. Bagaimana memastikan pelajaran ini diadopsi tim Anda tanpa menciptakan budaya takut?

---

## Kasus 2 — Hallucinated Package & Supply Chain (Pola Umum 2023–2024)

### Ringkasan Insiden

Sejumlah riset keamanan (mis. Lasso Security, Socket.dev) mendokumentasikan pola di mana model AI menyarankan nama paket yang tidak ada. Aktor jahat kemudian mempublikasikan paket dengan nama persis itu (typosquatting AI-driven), berisi malware.

Skenario tipikal:

1. Developer bertanya: "Bagaimana cara melakukan X di Python?"
2. AI menyarankan: `pip install <nama-paket-tidak-ada>`.
3. Developer copy-paste, instal.
4. Paket berisi backdoor yang mengirim env vars + SSH key ke C2 server.

### Dampak

- Kompromi mesin developer.
- Potensi lateral movement ke CI/CD bila credential terpapar.
- Supply chain backdoor jika paket masuk dependency proyek.

### Analisis Akar Masalah

- Trust berlebih terhadap saran AI tanpa verifikasi registry.
- Tidak ada policy "verify-before-install" untuk dependency baru.
- Lockfile tidak dipakai konsisten.

### Pertanyaan Diskusi

1. Tool & proses apa yang dapat memvalidasi suggesi paket secara otomatis?
2. Bagaimana membedakan paket sah vs typosquat dalam < 30 detik?
3. Apa peran SBOM dan signed packages dalam mitigasi jangka panjang?

---

## Kasus 3 — Kebocoran via Konteks Repo Open-Source (Skenario Komposit)

### Ringkasan Insiden (skenario edukatif berbasis pola umum)

Sebuah tim fintech mengaktifkan indexing seluruh workspace di Cursor. Workspace tersebut secara tidak sengaja berisi:

- Folder `customer-imports/` dengan file `.csv` PII pelanggan (sisa debugging minggu lalu).
- File `.env.prod` yang tidak masuk `.cursorignore` (hanya `.gitignore`).
- Folder `legacy-vendor/` dengan kode milik vendor yang dilindungi NDA.

Saat developer meminta AI me-refactor query database, konteks yang dikirim memuat sampel data PII karena AI memilih file relevan dari index.

### Dampak

- Pelanggaran PDP / GDPR potensial (PII pelanggan keluar lingkungan kontrol).
- Pelanggaran NDA dengan vendor.
- Potensi sanksi regulator + reputational damage.

### Analisis Akar Masalah

- `.gitignore` ≠ `.cursorignore`. File yang tidak dilacak Git masih bisa dibaca Cursor.
- Tidak ada DLP scan pada workspace developer.
- Tidak ada pembersihan rutin folder `debug/` dan `tmp/`.

### Pertanyaan Diskusi

1. Susun `.cursorignore` minimum untuk tim fintech serupa.
2. Bagaimana Anda mendeteksi PII sebelum file dibaca AI?
3. Apa kontrol organisasi (bukan teknis) yang harus ada?

---

## Checklist Do / Don't Mengirim Kode ke AI

### DO — Aman, Direkomendasikan

- [x] Gunakan **Privacy Mode** / Enterprise mode default untuk semua proyek non-publik.
- [x] Maintain **`.cursorignore`** yang lebih ketat dari `.gitignore`.
- [x] **Anonimkan data** (mis. ganti nama pelanggan → `Customer A`, email → `user@example.com`).
- [x] **Verifikasi setiap dependency** yang disarankan AI di registry resmi sebelum install.
- [x] **Jalankan secret scanner** (gitleaks, trufflehog) pre-commit & pre-push.
- [x] **Edit hasil AI** minimal 1 baris sebelum commit — memastikan keterlibatan manusia.
- [x] **Diskusikan konsep** (algoritma, pola arsitektur) — bukan implementasi proprietary.
- [x] **Laporkan insiden** lewat kanal resmi tanpa rasa takut dipenalti.

### DON'T — Hindari, Berisiko Tinggi

- [ ] Paste **credentials, API key, JWT, password** ke chat AI publik.
- [ ] Paste **PII pelanggan**, rekam medis, data finansial nasabah.
- [ ] Paste **source code lengkap modul rahasia** (billing, scoring, pricing engine).
- [ ] Paste **kode milik klien** tanpa otorisasi kontraktual.
- [ ] Mempercayai **saran install paket** tanpa verifikasi.
- [ ] Menggunakan **akun pribadi** untuk pekerjaan kantor (audit log hilang).
- [ ] Membiarkan **`.env*` & dump database** ada di workspace yang diindeks AI.
- [ ] Mengabaikan **prompt injection** di file open-source yang dipakai sebagai konteks.

---

## Template Laporan Insiden Singkat (1 halaman)

```
Tanggal/Waktu     :
Pelapor           :
Tool yang terlibat:
Data yang terpapar:
Volume & sensitivitas:
Aksi awal yang sudah diambil:
Dukungan yang dibutuhkan:
```

Kirim ke kanal `#sec-incident` (atau channel internal yang setara) dalam **1 jam** sejak diketahui.

---

## Referensi

- Bloomberg / TechCrunch — laporan insiden Samsung & ChatGPT (April 2023).
- Lasso Security — riset "AI Package Hallucination" (2023).
- Socket.dev — laporan supply chain typosquatting.
- ENISA Threat Landscape — Supply Chain Attacks edition.
- Cursor Docs — Privacy Mode & data handling.
