# Checklist Security & Etika Penggunaan AI Cursor

Acuan praktis untuk developer dan tim IT saat memakai AI code assistant di lingkungan enterprise/regulated.

---

## Sebelum Memakai AI di Kode Produksi

- [ ] Saya tahu **kebijakan AI** yang berlaku di organisasi (atau menanyakannya bila belum).
- [ ] **Privacy Mode** Cursor sudah ON untuk repo enterprise.
- [ ] Saya **tidak mengirim secret** (API key, password, token) ke chat AI.
- [ ] Saya **tidak meng-paste data pelanggan / PII** ke prompt.
- [ ] Saya tahu repo mana yang **boleh** diindeks AI dan mana yang **tidak boleh**.
- [ ] Workspace pelatihan/eksperimen **terpisah** dari workspace proyek nyata.

## Saat Menulis Prompt

- [ ] Konteks yang saya tarik (`@file`, `@folder`) **hanya yang relevan**, bukan seluruh repo.
- [ ] Saya **tidak meminta AI mengakses file di luar proyek aktif** secara sembarangan.
- [ ] Bila membahas error dari production log, saya **redact** informasi sensitif (user ID, IP, payload).
- [ ] Saya **tidak menyertakan database dump / connection string lengkap** sebagai konteks.

## Saat Menerima Output AI

- [ ] Saya **membaca dan memahami** seluruh kode yang AI usulkan sebelum apply.
- [ ] Saya **tidak menerapkan patch besar** tanpa diff review.
- [ ] Saya **memverifikasi nama library, fungsi, dan API** yang AI sebut benar-benar ada (anti-hallucination).
- [ ] Saya **menjalankan test** setelah perubahan AI-assisted.
- [ ] Saya **linter pass** sebelum commit.
- [ ] Untuk security-sensitive code (auth, crypto, input validation), saya **review ekstra ketat** dan/atau pair-review manusia.

## Saat Commit & PR

- [ ] **Tidak menyembunyikan** bahwa AI dipakai (transparency) — sesuai kebijakan organisasi.
- [ ] PR description menyebutkan **scope perubahan**, bukan "AI generated, please review".
- [ ] Tidak `--no-verify` untuk skip pre-commit/pre-push hook hanya karena AI yakin kodenya benar.

---

## Klasifikasi Data — Boleh Dikirim ke AI?

| Tipe Data                        | AI Publik (cloud) | AI Privat / On-Prem | Catatan                            |
| -------------------------------- | ----------------- | ------------------- | ---------------------------------- |
| Algoritma generik / open-source  | ✅ Ya             | ✅ Ya               | Risiko rendah                      |
| Kode internal non-sensitif       | ⚠️ Hati-hati      | ✅ Ya               | Cek kebijakan IP organisasi        |
| Konfigurasi infra (anonim)       | ⚠️ Hati-hati      | ✅ Ya               | Pastikan tidak ada host/IP nyata   |
| Secret (API key, token, password)| ❌ Tidak          | ❌ Tidak            | Selalu gunakan secret manager      |
| Data pelanggan / PII             | ❌ Tidak          | ⚠️ Sesuai kebijakan | Tunduk regulasi (GDPR, UU PDP)     |
| Source code produk inti / IP     | ❌ Tidak          | ✅ Ya (terkontrol)  | Cek lisensi & klausul kontrak      |
| Production logs mentah           | ❌ Tidak          | ⚠️ Sanitize dulu    | Redact PII & secret                |
| Skema DB lengkap dengan data     | ❌ Tidak          | ⚠️ Hati-hati        | Pisahkan schema dari data          |

---

## Red Flag — Berhenti & Eskalasi

Hentikan penggunaan AI dan eskalasi ke tech lead / security officer bila:

- AI menyarankan kode yang mengirim data ke endpoint asing tanpa konteks jelas.
- AI tiba-tiba "tahu" detail spesifik tentang proyek yang Anda **tidak pernah** bagikan ke AI.
- Anda diminta menempelkan kredensial untuk "membantu AI memahami".
- Vendor AI mengalami insiden keamanan publik.

---

## Etika

- **Atribusi**: Bila AI ikut menulis kode signifikan, sebut di PR/commit description sesuai kebijakan (beberapa organisasi mewajibkan, beberapa melarang co-author AI di commit).
- **Akuntabilitas**: Anda tetap bertanggung jawab penuh atas kode yang Anda commit, terlepas siapa yang menuliskannya.
- **Hak cipta**: Bila AI menghasilkan kode yang mirip dengan lisensi tertentu (mis. GPL), waspadai kontaminasi lisensi proyek Anda.
- **Tidak mengganggu pembelajaran junior**: Junior tetap perlu memahami fundamental — jangan biarkan AI menjadi pengganti pemahaman, terutama untuk mereka yang masih membangun mental model.

---

## Referensi Internal

- Kebijakan AI organisasi: _<isi link internal>_
- Kontak security officer: _<isi>_
- Saluran lapor insiden: _<isi>_
