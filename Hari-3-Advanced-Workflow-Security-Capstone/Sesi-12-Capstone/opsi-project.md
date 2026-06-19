# Opsi Project Capstone

Lima opsi project yang dirancang dapat diselesaikan dalam ~2 jam eksekusi oleh tim 3–4 orang. Pilih satu yang paling sesuai dengan komposisi tim.

---

## Opsi 1 — REST API + Auth (Backend / Full-Stack)

### Deskripsi Singkat
Bangun REST API untuk aplikasi **"Task Tracker Tim"** dengan autentikasi JWT, otorisasi role-based (admin / member), dan CRUD task.

### Requirement
- Endpoint:
  - `POST /auth/register`, `POST /auth/login`
  - `GET/POST/PATCH/DELETE /tasks`
  - `GET /me`
- Hashing password (bcrypt/argon2).
- Validasi input (Zod / Joi / Pydantic).
- Minimal 5 unit test + 2 integration test.
- README + cara menjalankan + contoh request.
- CI workflow: lint + test.

### Tip Cursor
- Gunakan Composer untuk scaffold controller-service-repo sekaligus.
- Minta AI menulis test edge case otorisasi (member coba akses task admin).
- Minta AI me-review handler auth Anda dari kacamata OWASP Top 10.

<!-- STACK-PLACEHOLDER: Default Node.js + Express + Postgres. Bisa diganti FastAPI/Python atau Go + Chi sesuai pilihan tim. -->

### Risiko Umum
- Lupa rate-limit endpoint login.
- JWT secret hardcoded.
- Tidak memvalidasi refresh token reuse.

---

## Opsi 2 — Dashboard CRUD (Frontend / Full-Stack)

### Deskripsi Singkat
Bangun dashboard **"Inventory Mini"** yang menampilkan list produk, detail, form tambah/edit, dengan filter & pencarian.

### Requirement
- Tampilan: list (table/grid), detail, form add/edit, delete confirmation.
- State management (Context/Zustand/Redux secukupnya).
- Form validation + error state.
- Empty state, loading state, error state.
- Minimal 3 component test.
- README + screenshot.

### Tip Cursor
- Minta AI scaffold komponen dengan TypeScript types lebih dulu, baru implementasi.
- Minta AI generate skeleton loading & empty state — biasanya terlupa manual.
- Gunakan AI untuk audit aksesibilitas (semantic HTML, label form).

<!-- STACK-PLACEHOLDER: Default React + Vite + Tailwind. Bisa Next.js, Vue, atau Svelte. -->

### Risiko Umum
- State server tidak sinkron setelah mutasi.
- Komponen monolitik 400 baris.
- Tidak ada handling error network.

---

## Opsi 3 — Data Pipeline ETL (Data Engineer)

### Deskripsi Singkat
Bangun pipeline ETL yang membaca file CSV `transactions.csv` (disediakan, dummy), membersihkan, agregasi harian, lalu menulis ke database / parquet.

### Requirement
- Validasi schema input.
- Penanganan baris rusak (logged, tidak crash).
- Agregasi: total transaksi, average value, top 5 kategori per hari.
- Output: tabel `daily_summary` atau file parquet.
- Logging terstruktur.
- Minimal 3 test data quality.
- README + diagram alur.

### Tip Cursor
- Minta AI bantu desain schema staging vs final.
- Tanya AI strategi handle duplicates & late-arriving data.
- Gunakan AI untuk profile data: "Berikan 5 pertanyaan EDA untuk dataset ini."

<!-- STACK-PLACEHOLDER: Default Python + pandas + DuckDB. Bisa PySpark, Polars, atau dbt + Postgres. -->

### Risiko Umum
- Memori meledak pada CSV besar (gunakan chunking).
- Tidak idempoten — re-run menggandakan data.
- Timezone tidak konsisten.

---

## Opsi 4 — Script Automasi DevOps (DevOps / SRE)

### Deskripsi Singkat
Bangun script CLI **"repo-doctor"** yang men-scan sebuah repo dan menghasilkan laporan kesehatan: dependency outdated, secret leak, branch stale, license risk.

### Requirement
- Command CLI: `repo-doctor scan <path> --report report.md`.
- Cek minimal 4 dimensi (di atas).
- Output: Markdown report + exit code (0 sehat, 1 ada warning, 2 ada blocker).
- Konfigurasi via `repo-doctor.yml`.
- Minimal 3 test fungsi inti.
- README + contoh report.

### Tip Cursor
- Minta AI scaffold struktur CLI + subcommand.
- Gunakan AI untuk merancang format report yang scannable manusia.
- Tanya AI: "Apa false positive umum di secret scanner dan bagaimana mengurangi?"

<!-- STACK-PLACEHOLDER: Default Python + Click atau Node + Commander. Bisa Go + Cobra. -->

### Risiko Umum
- False positive terlalu banyak → diabaikan.
- Tidak ada cara whitelist temuan yang dikonfirmasi aman.
- Eksekusi lambat pada repo besar — pertimbangkan paralelisasi.

---

## Opsi 5 — Refactor Monolith Module (Senior / Mixed)

### Deskripsi Singkat
Diberikan modul "legacy" (~500–800 baris, disediakan fasilitator) yang punya bau kode klasik: God function, magic numbers, no tests, mixed concerns. Tugas: refactor agar testable, modular, dengan minimal 70% test coverage di bagian yang disentuh.

### Requirement
- Identifikasi minimal 4 code smell + dokumentasikan.
- Refactor incremental dengan minimal 5 commit bermakna.
- Test pass sebelum & sesudah setiap commit refactor.
- Coverage report (≥70% pada modul target).
- ADR singkat: "Mengapa refactor dengan arah ini?"

### Tip Cursor
- Wajib: tulis **characterization tests** dulu sebelum refactor (Cursor bantu generate).
- Pakai AI untuk identifikasi smell, lalu rangking sendiri.
- Minta AI menjelaskan setiap fungsi dengan satu kalimat — bila tidak bisa, fungsi itu kandidat dipecah.

<!-- STACK-PLACEHOLDER: Modul legacy tersedia dalam dua versi: Node (`legacy-billing.js`) dan Python (`legacy_billing.py`). -->

### Risiko Umum
- Refactor terlalu besar dalam satu commit — sulit di-review/rollback.
- Mengubah perilaku tanpa sadar (regresi).
- Mengejar "indah" tanpa target objektif.

---

## Matriks Kecocokan Tim

| Komposisi Tim Dominan | Opsi Disarankan |
|------------------------|-----------------|
| Backend-heavy | 1, 4, 5 |
| Frontend-heavy | 2 |
| Data-heavy | 3 |
| Mixed senior | 4, 5 |
| Mixed junior | 1, 2 |

---

## Dataset & Asset yang Disediakan Fasilitator

- `transactions.csv` (10k baris, dummy) — untuk Opsi 3.
- `legacy-billing.js` & `legacy_billing.py` — untuk Opsi 5.
- `sample-repo/` dengan beberapa "masalah" tertanam — untuk Opsi 4.
- Postman collection contoh — untuk Opsi 1.
- Figma mockup sederhana — untuk Opsi 2.
