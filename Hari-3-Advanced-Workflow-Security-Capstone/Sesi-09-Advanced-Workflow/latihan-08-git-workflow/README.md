# Lab 08 — Git Workflow dengan Cursor

**Durasi**: 30 menit
**Format**: Individual, dengan peer review berpasangan di langkah akhir
**Prasyarat**: Cursor terpasang, GitHub account aktif, repo `cursor-orders-api` sudah di-clone.

---

## Tujuan Lab

Anda mampu menjalankan siklus penuh: *implement → commit → PR → review* dengan akselerasi Cursor di setiap tahap, tanpa kehilangan kualitas konvensional.

## Skenario

Anda backend engineer di tim Orders. Product Owner meminta endpoint `POST /api/orders` yang menerima `{ customerId, items[] }`, memvalidasi payload, lalu menyimpan ke database. Branch baru: `feat/MM-142-create-order`.

<!-- STACK-PLACEHOLDER: Default stack lab = Node.js + Express + Postgres. Ganti contoh kode bila kelas memilih Python/FastAPI atau Go. -->

---

## Langkah-Langkah

### Langkah 1 — Setup Branch (3 menit)

```bash
git checkout -b feat/MM-142-create-order
```

Tanya Cursor:
> "Berdasarkan struktur folder repo ini, di mana sebaiknya saya menambahkan route handler dan validator untuk endpoint POST /api/orders?"

Catat jawaban AI, validasi dengan membuka folder sebenarnya.

### Langkah 2 — Implementasi Endpoint (8 menit)

Gunakan Composer untuk men-generate:

- Route handler `routes/orders.js`
- Validator schema (Zod / Joi)
- Service layer yang memanggil repository
- Satu happy path test

Prompt awal yang disarankan:
> "Buat endpoint POST /api/orders mengikuti pola controller-service-repository yang sudah ada di repo. Validasi: customerId string UUID, items minimal 1, tiap item punya productId UUID dan quantity integer > 0. Tulis juga satu integration test dengan supertest."

Tugas Anda: **review, perbaiki, jangan langsung accept**.

### Langkah 3 — Generate Commit Message (3 menit)

1. Stage perubahan: `git add .`
2. Di Cursor Source Control panel, klik tombol *Generate Commit Message* (atau Cmd-K dengan diff context).
3. Prompt tambahan:
   > "Conventional Commits. Type: feat. Scope: orders. Body 2 kalimat menjelaskan kebutuhan bisnis, bukan implementasi teknis. Footer reference: MM-142."
4. Edit hasilnya — wajib minimal 1 perubahan manual.
5. Commit.

### Langkah 4 — Push & PR Description (5 menit)

```bash
git push -u origin feat/MM-142-create-order
```

Buka chat Cursor dengan context `@Branches main..HEAD`:

> "Tulis PR description dengan sections berikut: ## Context, ## Changes, ## How to Test, ## Risks & Rollback. Maksimal 200 kata total. Tandai bila ada perubahan kontrak API."

Salin ke GitHub PR, **edit minimal 1 paragraf** dengan informasi yang hanya Anda tahu (mis. kaitan dengan ticket lain).

### Langkah 5 — Peer Review (11 menit)

Tukar PR dengan rekan sebelah. Di sisi reviewer, jalankan prompt:

> "Saya reviewer PR ini. Ringkas perubahan dalam 5 bullet, identifikasi 3 risiko regresi, dan sarankan 1 test case yang belum ada."

Tulis hasil review (boleh disempurnakan manual) sebagai komentar PR.

---

## Checklist Selesai

- [ ] Branch dibuat dengan naming convention.
- [ ] Endpoint berfungsi (manual test dengan curl/Postman).
- [ ] Commit message Conventional Commits, sudah diedit minimal 1 baris.
- [ ] PR description lengkap dengan 4 section.
- [ ] Memberi review pada PR rekan + menerima review balik.

## Refleksi (tulis 3 kalimat)

1. Bagian mana di mana Cursor paling menghemat waktu Anda?
2. Bagian mana di mana Anda harus paling banyak mengoreksi output AI?
3. Satu hal yang akan Anda bawa ke tim setelah pelatihan ini?

---

## Troubleshooting

| Masalah | Solusi Singkat |
|---------|----------------|
| Cursor tidak melihat diff staged | Pastikan file sudah `git add`, refresh Source Control panel |
| Commit message generic ("update files") | Prompt belum mention scope/type; tambahkan eksplisit |
| PR description menyebut file yang tidak diubah | Konteks `@Branches` salah pakai range; pakai `main..HEAD` |
