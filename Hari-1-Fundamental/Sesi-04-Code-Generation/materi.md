# Sesi 4 — Code Generation Fundamentals

**Durasi**: 90 menit
**Format**: Konsep (20') + Demo end-to-end (15') + Lab 03 (45') + Demo & retrospektif (10')

---

## Learning Outcomes

Setelah sesi ini peserta mampu:

1. **Menerjemahkan** user story / requirement menjadi prompt produksi untuk Cursor secara terstruktur.
2. **Menghasilkan** fungsi, class, dan modul yang konsisten dengan style codebase eksisting.
3. **Mengkonversi** pseudocode menjadi implementasi runnable dalam bahasa target.
4. **Membangun** 1 fitur CRUD sederhana end-to-end (data → service → endpoint/UI → test) menggunakan kombinasi Tab / Cmd-K / Chat / Composer.
5. **Memvalidasi** kualitas kode hasil generate dengan checklist (correctness, security, style, test coverage).

---

## 1. Konsep Inti

### 1.1 Spectrum Code Generation

```mermaid
flowchart LR
    A[Snippet<br/>1 baris/blok] --> B[Function<br/>1 unit logika]
    B --> C[Module<br/>kumpulan unit]
    C --> D[Feature<br/>vertical slice]
    D --> E[Service<br/>boundary]
    style A fill:#dff
    style E fill:#fdd
```

| Level | Risiko | Mode Cursor Optimal | Review effort |
|-------|--------|---------------------|---------------|
| Snippet | Rendah | Tab | Detik |
| Function | Rendah-sedang | Cmd/Ctrl+K | Menit |
| Module | Sedang | Chat / K | 10+ menit |
| Feature | Tinggi | Composer | 30+ menit |
| Service | Sangat tinggi | Composer (bertahap) + manual arch | Jam |

Aturan: **semakin tinggi level, semakin penting spesifikasi & review**.

### 1.2 Dari User Story ke Prompt

User story klasik:

> Sebagai *user*, saya ingin *mendaftar dengan email & password* sehingga *saya bisa login kemudian*.
>
> **Acceptance**:
> - Email valid (format + belum terdaftar).
> - Password ≥ 8 karakter, ada angka.
> - Sukses → return 201 + user.id.
> - Gagal validasi → 400 + pesan.

Strategi penerjemahan:

1. **Pecah ke task teknis** (route, controller, service, repository, schema, test).
2. **Petakan ke file** yang sudah ada di repo (pakai konvensi).
3. **Susun prompt per task**, atau 1 prompt Composer untuk fitur kecil dengan scope tegas.

### 1.3 Menulis Fungsi / Class / Module

#### Fungsi (≤30 baris)
- Gunakan **Cmd/Ctrl+K** di file target.
- Sebut signature, behavior, edge case, error mode.
- Selalu generate test pada langkah berikutnya — jangan tunggu nanti.

#### Class
- Sebut **single responsibility** secara eksplisit.
- Sebut dependency yang di-inject (DI).
- Sebut pola yang dipakai di repo (mis. repository pattern).

Contoh prompt (pseudo, agnostik stack):
```
Buat class UserService dengan:
- Dependency: UserRepository, PasswordHasher, Logger
- Method: register(input), findById(id)
- register: validasi input, cek email unique, hash password, simpan, return user (tanpa password)
- Lempar DomainError untuk pelanggaran rule
- Konsisten dengan style class lain di @folder src/services/
```

#### Module / Folder
- Gunakan **Composer** dengan scope file/folder eksplisit.
- Wajib **list file yang akan dibuat** sebelum accept.
- Wajib **review per-file**, bukan accept-all.

### 1.4 Pseudocode → Kode

Pseudocode adalah jembatan antara desain dan implementasi yang sangat cocok untuk AI. Format yang baik:

```
INPUT: list of order (id, amount, status)
OUTPUT: total amount of orders with status="PAID" in last 30 days

ALGORITHM:
1. now = currentDate()
2. cutoff = now - 30 days
3. filter orders where status="PAID" AND createdAt >= cutoff
4. sum amount
5. return rounded to 2 decimals
```

Lalu prompt:
```
Implementasi pseudocode berikut dalam <bahasa> sesuai style @folder src/.
Tambahkan unit test 4 case (happy, empty, all unpaid, tanggal batas).
[paste pseudocode]
```

### 1.5 Konsistensi dengan Codebase

AI **tidak otomatis** mengikuti style repo Anda. Pastikan dengan:

- `@folder` referensi ke folder dengan style yang ingin di-mirror.
- `@file` ke file *exemplar* — contoh "begini cara kami menulis service".
- Project rules (`.cursor/rules/*.mdc`) yang menjelaskan konvensi (akan dipakai Hari 2).
- Selalu **jalankan linter/formatter** setelah generate.

### 1.6 Validasi Kualitas Output

Checklist minimal sebelum commit:

| Aspek | Cek |
|-------|-----|
| Correctness | Lulus test (eksisting + baru) |
| Style | Lulus linter/formatter |
| Security | Tidak ada SQL injection / XSS / kebocoran secret |
| Performance | Tidak ada N+1 query, loop boros |
| Readability | Nama variabel/fungsi jelas, komentar seperlunya |
| Boundary | Edge case (null, empty, very large) terhandle |
| Dependency | Tidak menambah library tanpa perlu |

### 1.7 Anti-pattern Code Generation

- **Accept-all Composer** tanpa baca diff.
- **Build feature di-1-prompt** padahal estimasi 1 hari kerja.
- **Skip test** karena "AI sudah pasti benar".
- **Asumsi style** tanpa exemplar.
- **Tidak menjalankan code** setelah generate (kompilasi/lint/test).
- **Commit dengan pesan default AI** tanpa review.

### 1.8 Loop Kerja Rekomendasi (Build Feature)

```mermaid
flowchart TD
    S[User story] --> P[Pecah ke task]
    P --> X[Tulis prompt task-1]
    X --> G[Generate]
    G --> R[Review diff]
    R -->|OK| T[Test lokal]
    R -->|tidak OK| X
    T -->|hijau| C[Commit kecil]
    T -->|merah| X
    C --> N{Task berikut?}
    N -->|ya| X
    N -->|tidak| D[Done]
```

Karakter loop: **commit kecil, sering, dengan test**. Hindari mega-commit "feature X done".

---

## 2. Demo Live

**Skenario**: "User story → fitur CRUD `Note` end-to-end."

User story:
> Sebagai user, saya ingin **menambah, melihat daftar, mengubah, dan menghapus catatan** (title, body, createdAt) agar saya bisa mencatat ide harian.

Demo step:

1. **Pecah task** di whiteboard: schema/migration, repository, service, controller/UI, test.
2. **Bikin schema** dengan Cmd/Ctrl+K di file model. <!-- STACK-PLACEHOLDER -->
3. **Generate repository** dengan Chat + exemplar `@file` repository lain.
4. **Generate service** dengan Composer, scope ke folder service saja.
5. **Generate controller/route** dengan Cmd/Ctrl+K, sebutkan acceptance criteria.
6. **Generate test** dengan Chat — pisahkan happy path & error path.
7. **Jalankan test** di terminal; tunjukkan minimal 1 kegagalan & cara fix.

Pesan kunci: **6 langkah kecil, masing-masing reviewable, masing-masing testable**.

---

## 3. Hands-on Lab

**Lab 03 — Build a Small Feature** (45 menit).
Lokasi: `./lab-03-build-feature/README.md`.

Briefing:
- Peserta diberi user story (sesuaikan stack peserta) — fitur CRUD ringan.
- Wajib pakai semua 4 mode interaksi minimal sekali.
- Wajib commit kecil minimal 4 commit.
- Output: fitur jalan + test minimal hijau + refleksi.

---

## 4. Wrap-up & Q&A

Pertanyaan refleksi:

1. Bagian fitur mana yang paling **mudah** di-generate? Paling **sulit**? Mengapa?
2. Berapa **rasio waktu** menulis prompt : membaca diff : menulis manual? Apakah seperti ekspektasi awal?
3. Bug atau hallucination apa yang sempat Anda temukan? Bagaimana mendeteksinya?
4. Commit mana yang akan Anda **tolak** kalau jadi reviewer di tim?
5. Apa 1 hal yang akan Anda **lakukan berbeda** besok pagi di pekerjaan sebenarnya?

---

## 5. Bacaan Lanjutan

- Cursor — *Composer / Agent*: <https://cursor.com/docs/agent>
- Cursor — *Code completion*: <https://cursor.com/docs/tab>
- Martin Fowler — *Refactoring*, edisi 2.
- Kent Beck — *Test-Driven Development by Example*.
- *Working Effectively with Legacy Code* (Feathers) — relevan untuk generate test pada kode lama.
- Anthropic — *Patterns for building agentic systems*.
- Addy Osmani — *Why developers should care about prompt engineering*.
