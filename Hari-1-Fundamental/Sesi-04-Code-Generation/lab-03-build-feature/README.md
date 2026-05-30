# Lab 03 — Build a Small Feature (CRUD)

**Durasi**: 45 menit
**Tipe**: Hands-on individual (boleh diskusi tetangga)
**Sesi**: Sesi 4 — Code Generation Fundamentals

---

## Tujuan

Peserta membangun 1 fitur **CRUD sederhana** end-to-end menggunakan Cursor, dengan praktik commit kecil, review diff, dan test minimal hijau.

---

## User Story

> **Sebagai** user, **saya ingin** menambah, melihat daftar, mengubah, dan menghapus *Note* (title, body, createdAt, updatedAt) **agar** saya bisa mencatat ide harian.

### Acceptance Criteria

- [ ] Bisa create Note dengan title (≥1, ≤120 char) dan body (≤5000 char).
- [ ] Bisa list semua Note milik user, urut terbaru di atas.
- [ ] Bisa update title/body Note.
- [ ] Bisa delete Note (soft delete OK).
- [ ] Validasi: title wajib; body opsional.
- [ ] Error response konsisten (format JSON/HTTP standar yang sudah dipakai di repo).
- [ ] Minimal 1 test per operasi (create/list/update/delete) **hijau** lokal.

---

## Prasyarat

- Lulus Lab 01 & Lab 02.
- Sample repo terbuka. <!-- STACK-PLACEHOLDER: sebutkan starter repo / branch -->
- Git config siap untuk commit.

---

## Stack & Starter

<!-- STACK-PLACEHOLDER:
Pilih sesuai hasil pretest. Contoh:
- Node + Express + Prisma + Jest
- Python + FastAPI + SQLAlchemy + Pytest
- Go + Gin + GORM + testing
- Java + Spring Boot + JPA + JUnit
- Next.js + Prisma + Vitest (full-stack)
- DevOps: Terraform module CRUD untuk resource ringan (S3 bucket policy, dll.)
- Data Engineer: dbt model + test untuk staging table "notes"
-->

Starter berisi:
- Struktur folder mengikuti konvensi stack.
- Contoh entity lain (mis. `User`) sebagai **exemplar** untuk @-mention.
- Setup test runner sudah jalan (1 dummy test hijau).

### Contoh Skeleton (PLACEHOLDER — diisi sesuai stack)

```text
<!-- STACK-PLACEHOLDER: tree project starter -->
src/
  entities/
    user.<ext>
  repositories/
    user.repo.<ext>
  services/
    user.service.<ext>
  controllers/   # atau routes/ atau handlers/
    user.controller.<ext>
  __tests__/
    user.service.test.<ext>
```

```text
<!-- STACK-PLACEHOLDER: contoh kode entity exemplar (bisa di-mirror untuk Note) -->
```

---

## Langkah

### 0. Persiapan (3')
0.1. Buat branch baru: `git checkout -b feat/notes`.
0.2. Buka file exemplar (`user.*`) — Anda akan rujuk via @file.
0.3. Pastikan test starter hijau: <!-- STACK-PLACEHOLDER: command run test -->.

### 1. Schema / Entity (5')
1.1. Buat file `entities/note.<ext>` (kosong). Pakai **Cmd/Ctrl+K**.
1.2. Prompt: rujuk `@file entities/user.<ext>` sebagai style, definisikan field & validasi sesuai acceptance.
1.3. Review diff, accept, **commit**: `feat(notes): add Note entity`.

### 2. Repository (5')
2.1. Buat file `repositories/note.repo.<ext>`. Pakai **Cmd/Ctrl+K**.
2.2. Prompt: rujuk `@file repositories/user.repo.<ext>`, buat CRUD method.
2.3. Review, accept, **commit**: `feat(notes): add Note repository`.

### 3. Service + Test (12')
3.1. Buka **Chat** (Cmd/Ctrl+L).
3.2. Prompt: minta service + unit test di file terpisah, sebut acceptance criteria.
3.3. Eksekusi, **baca per-file**, accept perubahan.
3.4. Jalankan test → ada yang merah? iterasi prompt: tunjukkan output, minta fix minimal.
3.5. **Commit**: `feat(notes): add Note service and tests`.

### 4. Controller / Endpoint (10')
4.1. Pakai **Composer** (Cmd/Ctrl+I) untuk menambah controller + wire ke router/entry point.
4.2. Scope eksplisit: file controller, file route, **tidak** menyentuh service lagi.
4.3. Review tiap file, accept selektif.
4.4. Jalankan app lokal, test manual minimal 1 endpoint (curl/Postman / UI tab).
4.5. **Commit**: `feat(notes): expose CRUD endpoints`.

### 5. Verifikasi & Polish (5')
5.1. Jalankan **semua test** → semua hijau.
5.2. Jalankan **linter/formatter**.
5.3. Tulis 1 commit terakhir kalau ada polish: `chore(notes): lint + fix`.

### 6. Refleksi (5')
Tulis di `submissions/<nama>/lab-03-refleksi.md`:
- Rasio waktu prompt : review : manual.
- 1 hallucination/bug yang Anda temukan & cara menemukannya.
- 1 hal yang akan dilakukan berbeda kalau diulang.

---

## Kriteria Selesai (Rubrik)

| Kriteria | Bobot | Cukup | Baik | Sangat Baik |
|----------|-------|-------|------|-------------|
| Semua acceptance criteria functional terpenuhi | 30% | 2 op | 3 op | 4 op (full CRUD) |
| Test hijau | 20% | 1 test | 2–3 test | 4 test (per op) |
| Commit kecil reviewable | 15% | 1 commit besar | 2–3 commit | ≥4 commit bermakna |
| 4 mode interaksi terpakai | 15% | 1–2 | 3 | 4 (Tab + K + Chat + Composer) |
| Konsistensi style dengan repo | 10% | Off-style | Mostly | Sesuai 100% |
| Refleksi tulisan | 10% | < 3 poin | 3 poin | + insight spesifik |

Lolos: ≥ 70%.

---

## Tips

- **Mulai kecil**: entity → repo dulu, jangan langsung Composer-all.
- **Pakai exemplar**: `@file user.*` adalah teman terbaik Anda.
- **Commit walau bagian kecil selesai** — gampang revert kalau salah arah.
- **Iterasi prompt** kalau diff aneh — jangan tambal manual kecuali kecil.
- **Test dulu sebelum lanjut**. Jangan tumpuk fitur di atas test yang merah.

---

## Common Issues

| Issue | Solusi |
|-------|--------|
| Composer ngubah file di luar scope | Reset Composer, sebut file tepat di prompt |
| Test gagal karena fixture | Tunjukkan error ke Chat dengan `@terminal` |
| Style tidak konsisten | Pasang `@file <exemplar>` di prompt ulang |
| Dependency baru muncul | Tolak; minta solusi tanpa dependency |
| Kehabisan waktu | Drop fitur **update** lebih dulu (paling tidak kritikal), kejar test |

---

## Demo Peserta (5' di sesi)

2 peserta dipilih share:
- Apa user story (singkat).
- Tunjukkan `git log` (bukti commit kecil).
- Run test live.
- Refleksi 1 kalimat.
