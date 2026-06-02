# Prompting Cheatsheet — Cursor

Cetak / pin di samping monitor. Berlaku untuk Chat dan Composer.

---

## 1. Template Cepat

### Template Universal

```
[Role]    Sebagai <peran>,
[Goal]    saya butuh <hasil> agar <alasan bisnis>.
[Context] Bahan: @file ... @folder ... @docs ...
[Constraint]
  - Pakai <library/style>.
  - Jangan <larangan>.
  - Maks <ukuran/kompleksitas>.
[Acceptance]
  - Lulus test di @file ...
  - Contoh I/O: input=... output=...
```

### Template Refactor

```
Refactor @file <path> agar:
1. <tujuan refactor>
2. Tidak mengubah behavior publik (interface).
3. Tetap lulus test eksisting (@file <test>).
Tampilkan diff per fungsi sebelum saya accept.
```

### Template Bugfix

```
Bug: <gejala satu kalimat>.
Repro: <langkah-langkah / contoh input>.
Expected: <output yang seharusnya>.
Actual: <output sekarang>.
Bahan: @file <file utama> @terminal (log error).
Tugas: (a) jelaskan root cause, (b) usulkan fix minimal, (c) tambahkan test regresi.
```

### Template Test Generation

```
Buat unit test untuk @code <fungsi>.
Framework: <jest / pytest / go test / ...>.
Cakup: happy path, edge case (null/empty/large), error path.
Gaya: AAA (Arrange-Act-Assert), nama test deskriptif Bahasa Indonesia.
Jangan mock yang tidak perlu.
```

### Template Code Review

```
Sebagai senior reviewer, review @git diff.
Berikan komentar dalam format:
[BLOCKER|MAJOR|MINOR|NIT] <file>:<line> — <komentar>
Fokus: correctness, security, readability, performance.
Akhiri dengan ringkasan keputusan: APPROVE / REQUEST CHANGES.
```

### Template Eksplorasi Codebase

```
Saya baru di repo ini. Berdasarkan @folder src/,
jelaskan dalam maksimal 8 bullet:
- Domain / tujuan project
- Arsitektur layer
- Entry point
- 3 file paling kompleks dan mengapa
- Konvensi penting (penamaan, struktur)
Jangan menyentuh / mengubah file.
```

---

## 2. @-Mentions: Kapan Pakai Apa

| Skenario | @-mention |
|----------|-----------|
| Edit 1 file presisi | `@file <path>` |
| Pahami struktur arsitektur | `@folder <root>` |
| Refactor 1 simbol di banyak file | `@code <symbol>` |
| Pakai library/API tertentu dengan benar | `@docs <library>` |
| Cari error message asing | `@web "<error string>"` |
| Review PR / commit | `@git` atau `@commit <hash>` |
| Bahas stack trace | `@terminal` |
| Lanjut diskusi panjang | `@past chat` |

> Untuk yang tidak yakin: mulai dari `@file`. Tambah lapis kalau perlu.

---

## 3. Do / Don't

### Do

- Tulis tujuan dalam 1 kalimat di baris pertama.
- Sebut bahasa/framework eksplisit.
- Sebut acceptance criteria atau test sebagai bukti selesai.
- Tunjukkan contoh input/output kalau ada ambiguitas.
- Pecah task besar jadi prompt kecil.
- Reset chat saat ganti topik.
- Pilih model yang sesuai (Auto untuk umum; model reasoning untuk task algoritmik).

### Don't

- Jangan pakai pronoun ambigu ("ini", "itu", "tadi").
- Jangan ngotot lebih dari 4 iterasi pada prompt yang sama.
- Jangan kirim seluruh repo sebagai konteks (dilution).
- Jangan minta "buatkan project lengkap" dalam 1 prompt.
- Jangan accept Composer tanpa review per-file.
- Jangan paste secret / kredensial sebagai konteks.
- Jangan asumsikan AI tahu library versi terbaru tanpa `@docs`.

---

## 4. Contoh: Buruk vs Baik

### Contoh 1 — Generate API endpoint

**Buruk**
```
buatkan endpoint login
```

**Baik**
```
Sebagai backend engineer Node/Express, buat endpoint POST /auth/login.
Bahan: @file src/auth/user.repo.ts @file src/auth/jwt.util.ts
Input body: { email, password }
Output 200: { token, user: { id, name, email } }
Output 401: { error: "INVALID_CREDENTIALS" }
Pakai zod untuk validasi, bcrypt untuk compare password (sudah ada di repo).
Jangan menambah dependency baru.
Tambahkan unit test di @file src/auth/auth.controller.test.ts dengan minimal 4 case.
```

### Contoh 2 — Refactor

**Buruk**
```
refactor file ini biar lebih bagus
```

**Baik**
```
Refactor @file order.service.ts:
- Pisahkan fungsi calculateTotal menjadi modul terpisah.
- Hilangkan duplikasi loop di applyDiscount.
- Pertahankan public API (signature OrderService.* tidak berubah).
- Tetap lulus @file order.service.test.ts tanpa modifikasi test.
Tampilkan ringkasan perubahan per fungsi sebelum diff.
```

### Contoh 3 — Debug

**Buruk**
```
kenapa error ini?
```

**Baik**
```
Bug: setelah upgrade Node 18 → 20, test e2e gagal di CI dengan pesan:
"ERR_REQUIRE_ESM: require() of ES Module ..." (lihat @terminal)
Konteks: @file package.json @file jest.config.ts
Pertanyaan: (1) apa root cause migrasi ini, (2) opsi fix dengan trade-off-nya,
(3) rekomendasi fix paling minimal yang tidak ubah test code.
```

---

## 5. Tips @-Mentions Lanjutan

- **Stack @-mentions**: gunakan beberapa sekaligus, urutkan dari paling penting.
  Contoh: `@file primary.ts @file related.ts @docs library @web "exact error"`.
- **Symbol-level lebih baik daripada file-level** kalau yang relevan hanya 1 fungsi.
- **Folder-level hanya saat eksplorasi** — terlalu mahal token untuk task spesifik.
- **`@docs` dulu sebelum @web** — docs resmi lebih reliable daripada hasil pencarian.
- **`@past chat`** berguna untuk continuity di sesi panjang; tapi tetap reset saat ganti topik besar.

---

## 6. Quick Self-check Sebelum Submit Prompt

- [ ] Tujuan dalam 1 kalimat?
- [ ] @-mention konteks ada?
- [ ] Constraint kritikal disebut?
- [ ] Acceptance criteria jelas?
- [ ] Bebas pronoun ambigu?
- [ ] Mode tepat (Tab / K / Chat / Composer)?
- [ ] Model sesuai tingkat reasoning?
