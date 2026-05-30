# Prompting Library

Koleksi prompt siap pakai untuk berbagai task developer di Cursor. Salin → modifikasi konteks `<...>` → kirim.

---

## 1. Code Generation

### 1.1 Fitur baru dari user story

```
Konteks: @<file-controller> @<file-service>

Buat endpoint POST /<resource> yang menerima body:
- <field1: type>
- <field2: type>

Requirement:
- Validasi: <aturan>
- Persist via repository pattern yang sudah ada
- Return 201 dengan resource yang dibuat, atau 400 + error detail
- Tambahkan unit test untuk happy path dan 2 edge case

Ikuti pattern dari endpoint POST /<existing-resource> di @<file>.
```

### 1.2 Konversi pseudocode → kode produksi

```
Konversi pseudocode di bawah menjadi <bahasa> sesuai konvensi proyek (@.cursorrules).

Pseudocode:
<paste>

Constraint:
- Tanpa library eksternal di luar yang sudah ada di package.json
- Pakai async/await, bukan callback
- Handle error secara eksplisit
```

### 1.3 Boilerplate berulang

```
Buat <CRUD/form/service> untuk entitas <X> dengan field:
- <field: type, validasi>

Pakai pattern yang identik dengan @<existing-folder>.
Generate: model, repository, service, controller, dan test.
```

## 2. Code Understanding

### 2.1 Jelaskan flow

```
@<file>

Jelaskan apa yang dilakukan fungsi <namaFungsi>. Fokus pada:
1. Input/output
2. Side effect (DB call, HTTP, event)
3. Dependency
4. Edge case yang sudah dihandle dan yang BELUM

Gunakan bahasa Indonesia.
```

### 2.2 Map dependency lintas file

```
@<file-entrypoint> @Codebase

Trace dari fungsi `<X>` ke semua fungsi/module yang dipanggil
hingga 2 level kedalaman. Sajikan sebagai mermaid flowchart.
```

### 2.3 Dokumentasi otomatis

```
@<file>

Generate dokumentasi markdown untuk file ini berisi:
- Ringkasan tujuan file
- Daftar public API (signature + deskripsi singkat)
- Contoh penggunaan minimal
- Dependency eksternal

Format: markdown, Indonesian, maks 200 baris.
```

## 3. Debugging

### 3.1 Analisis stack trace

```
Error berikut muncul saat <skenario>:

```
<paste stack trace>
```

@<file-yang-disebut>

Tugas:
1. Identifikasi root cause (bukan symptom).
2. Sebutkan asumsi yang Anda buat.
3. Usulkan FIX paling minimal yang aman.
4. Sebutkan test yang harus ditambahkan agar regresi tidak terulang.
```

### 3.2 Bug reproduction-driven

```
Saya melihat behavior X tapi mengharapkan Y.
Steps to reproduce:
1. <step>
2. <step>

@<file>

Tanpa menebak, mulai dengan menulis test yang reproduce bug ini,
lalu tunjukkan dimana fix harus diterapkan. Belum perlu menulis fix-nya.
```

### 3.3 "Why is X null/undefined here?"

```
@<file>

Di baris <N>, variabel <x> seharusnya berisi <Y> tetapi sering kosong.
Telusuri semua jalur penugasan <x>. Sebutkan 3 hipotesis paling mungkin
dan cara verifikasi tiap hipotesis dengan log/breakpoint spesifik.
```

## 4. Refactoring

### 4.1 Reduce complexity

```
@<file>

Fungsi <namaFungsi> terlalu panjang dan punya cyclomatic complexity tinggi.

Refactor dengan kriteria:
- Pertahankan public signature
- Extract sub-fungsi private dengan nama bermakna
- Tidak boleh mengubah behavior (proven by test yang sudah ada)
- Jelaskan tiap perubahan dengan 1 kalimat

Jangan terapkan dulu — tunjukkan diff yang Anda usulkan.
```

### 4.2 Modernisasi sintaks

```
@<file>

File ini pakai pattern lama: <callback / var / class-based component / dll>.
Modernisasi ke <async-await / const-let / functional component / dll>
tanpa mengubah behavior. Pertahankan test pass.
```

### 4.3 Extract module

```
@<folder>

Folder ini punya tanggung jawab campuran. Usulkan pemecahan menjadi
modul-modul fokus. Sajikan:
- Daftar modul baru + tanggung jawabnya
- File mana pindah kemana
- Interface antar modul
- Urutan migrasi (smallest-first)

Belum perlu mengeksekusi.
```

## 5. Testing

### 5.1 Unit test dari nol

```
@<file>

Tulis unit test untuk fungsi <X> menggunakan <framework: vitest/jest/pytest/...>.

Coverage minimum:
- Happy path
- 2 edge case (empty input, batas atas)
- 1 error path
- Mock dependency: <list>

Ikuti gaya test yang ada di @<existing-test-file>.
```

### 5.2 Property-based test ideas

```
@<file>

Untuk fungsi <X>, usulkan 5 property invariant yang harus selalu benar
tanpa peduli input. Contoh: "output array selalu sorted",
"hasil idempotent terhadap pemanggilan kedua", dst.
```

## 6. Code Review

### 6.1 Self-review sebelum PR

```
@Git diff (uncommitted)

Review perubahan saya seakan-akan Anda reviewer senior. Cek:
1. Bug potensial (null, off-by-one, race, leak)
2. Inconsistency dengan pattern sekitar
3. Edge case yang luput dari test
4. Naming dan readability

Tandai severity: blocker / suggestion / nit.
```

### 6.2 PR description generator

```
@Git diff main..HEAD

Buat deskripsi PR berisi:
- **Summary** (2-3 kalimat)
- **Why** (motivasi)
- **What changed** (bullet ringkas per file kunci)
- **How to test** (manual steps + automated)
- **Risks**

Bahasa Indonesia, profesional, tanpa hype.
```

## 7. Documentation & Communication

### 7.1 ADR (Architecture Decision Record)

```
Tulis ADR untuk keputusan berikut: <ringkas keputusan>.

Format:
- Context
- Decision
- Consequences (positive, negative, neutral)
- Alternatives considered (3, dengan alasan ditolak)
```

### 7.2 README repo

```
@<folder-root>

Generate README.md proyek berisi:
- Judul + 1 paragraf deskripsi
- Prerequisites (versi runtime, OS)
- Install (numbered steps)
- Run / Build / Test commands
- Struktur folder (mermaid)
- Contributing checklist

Verifikasi semua command terhadap file `package.json`/`Makefile` aktual.
```

## 8. DevOps & Automation

### 8.1 Dockerfile dari aplikasi

```
@<entrypoint> @<package.json | go.mod | requirements.txt>

Buat Dockerfile multi-stage yang:
- Stage build: <runtime build>
- Stage runtime: image distroless / alpine
- Tidak memuat secret
- Jalankan sebagai non-root user
- Expose port <N>

Sertakan .dockerignore yang sesuai.
```

### 8.2 GitHub Actions CI

```
@<package.json | go.mod | pyproject.toml>

Buat workflow GitHub Actions: 
- Trigger: pull_request ke main
- Job: lint, test, build
- Cache dependency
- Matrix: <bila perlu>

Gunakan action versi terbaru yang stabil. Jelaskan setiap step singkat.
```

---

## Tips Umum Prompting

- **Selalu beri konteks** dengan `@file` / `@folder` — jangan andalkan model menebak.
- **Pisahkan tujuan dan constraint** — tujuan di awal, constraint sebagai bullet list.
- **Minta plan dulu, baru eksekusi** untuk perubahan kompleks.
- **Tolak hasil yang menebak** — jika AI menyebut library/fungsi yang tidak ada di kode Anda, hentikan, koreksi konteks.
- **Hindari "perbaiki ini"** tanpa konteks. Beri error message + file + perilaku yang diharapkan.
- **Iterasi pendek** lebih akurat daripada prompt jumbo.
