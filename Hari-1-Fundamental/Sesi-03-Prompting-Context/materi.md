# Sesi 3 — Prompting & Context Management

**Durasi**: 90 menit
**Format**: Konsep (25') + Demo prompting (15') + Lab 02 (35') + Review hasil (15')

---

## Learning Outcomes

Setelah sesi ini peserta mampu:

1. **Menjelaskan** mengapa kualitas output AI di Cursor adalah **fungsi dari prompt + konteks + rules**, bukan hanya prompt.
2. **Menerapkan** 3 pola prompting (role-based, context-based, constraint-based) pada minimal 5 contoh skenario kerja.
3. **Menggunakan** @-mentions (`@file`, `@folder`, `@code`, `@docs`, `@web`, `@git`) untuk mengontrol konteks secara presisi.
4. **Mengelola** *context budget* dengan strategi pruning, scoping, dan reusable snippets.
5. **Mengevaluasi** prompt sendiri menggunakan checklist kualitas dan iterasi *prompt → diff → prompt'*.

---

## 1. Konsep Inti

### 1.1 Prinsip Dasar: Prompt = Brief untuk Junior Developer

Anggap AI sebagai junior developer yang **sangat cepat, sangat patuh, sangat lupa**. Brief yang Anda berikan harus berisi:

- **Apa** (tujuan / hasil yang diinginkan).
- **Untuk siapa** (konteks pengguna / sistem).
- **Dengan apa** (file/library/data yang harus dipakai).
- **Batasan** (style, performa, security, library yang dilarang).
- **Bagaimana tahu selesai** (kriteria, test, contoh I/O).

Prompt yang sukses **menjawab kelima dimensi** ini, eksplisit atau implisit.

### 1.2 Formula Prompt: 3 Lapis

```mermaid
flowchart TD
    P[Prompt akhir] --> R[Role / Persona]
    P --> C[Context]
    P --> X[Constraint]
    R --> Re[Reasoning style]
    C --> F[@file @folder @docs @web]
    X --> A[Acceptance criteria]
```

| Lapis | Tujuan | Contoh |
|-------|--------|--------|
| **Role-based** | Set perspektif & gaya jawaban | "Sebagai senior backend engineer..." |
| **Context-based** | Beri bahan/fakta | "Berdasarkan @file user.service.ts dan @docs OpenAPI..." |
| **Constraint-based** | Jepit ruang solusi | "Tanpa library baru. Pakai pola repository. Maks 80 baris." |

Prompt produksi yang baik **mengkombinasikan ketiganya**.

### 1.3 Anatomi Prompt yang Baik

Template umum:

```
[Role]
Saya butuh bantuan sebagai <peran AI>.

[Goal]
Tujuan: <hasil yang diinginkan, 1 kalimat>.

[Context]
Bahan: @file …, @folder …, @docs …
Asumsi: <list asumsi>.

[Constraints]
- <constraint 1>
- <constraint 2>

[Acceptance]
Selesai jika: <kriteria terukur>.
Contoh I/O (opsional): …
```

### 1.4 @-Mentions: Mengontrol Konteks

| Mention | Apa yang dikirim | Kapan dipakai |
|---------|------------------|---------------|
| `@file <path>` | Isi file (atau chunk relevan) | Edit/refer spesifik 1 file |
| `@folder <path>` | Ringkasan file di folder | Arsitektur, eksplorasi |
| `@code <symbol>` | Definisi simbol (fungsi/class) | Refactor lintas file |
| `@docs <library>` | Dokumentasi resmi (yang sudah diindex Cursor) | Pakai API library terbaru |
| `@web <query>` | Hasil pencarian web | Info terkini, error msg unik |
| `@git` / `@commit` | Diff / commit history | Review, summarize PR |
| `@terminal` | Output terminal terakhir | Debug error, log |
| `@past chat` | Riwayat chat sebelumnya | Continuity multi-turn |

> Detail dan ketersediaan menyesuaikan versi Cursor. Lihat dokumentasi resmi.

### 1.5 Context Budget

Setiap model punya **token window** terbatas (puluhan ribu hingga jutaan). Aturan praktis:

- **Lebih banyak konteks ≠ lebih baik**. Bahan tidak relevan justru menurunkan kualitas (dilution).
- Pilih **chunk paling relevan**, bukan seluruh folder.
- Untuk repo besar, andalkan `@code <symbol>` ketimbang `@folder`.
- Hapus konteks lama di chat panjang (reset chat saat topik berubah).

```mermaid
flowchart LR
    Q[Question] --> S{Scope?}
    S -- "1 file" --> F[@file]
    S -- "1 fungsi lintas file" --> C[@code symbol]
    S -- "arsitektur" --> Fo[@folder ringkas]
    S -- "API external" --> D[@docs]
    S -- "info terbaru" --> W[@web]
```

### 1.6 Tiga Pola Prompting (Detail)

#### a. Role-based
> "Sebagai security reviewer, evaluasi `@file auth.controller.ts`. Sebutkan kerentanan OWASP Top 10 yang relevan dan beri rekomendasi fix."

Kapan dipakai: ingin gaya jawaban/standar profesi tertentu.

#### b. Context-based
> "Berdasarkan `@file user.entity.ts` dan `@file order.entity.ts`, buat query untuk mendapatkan top 10 user dengan total order tertinggi bulan ini. Pakai ORM yang sudah dipakai di repo."

Kapan dipakai: jawaban sangat bergantung pada artefak proyek.

#### c. Constraint-based
> "Refactor fungsi ini agar memenuhi semua syarat: (1) tidak boleh memakai library eksternal baru, (2) tidak boleh menambah file baru, (3) cyclomatic complexity ≤ 8, (4) tetap lulus test eksisting di `@file user.test.ts`."

Kapan dipakai: ruang solusi terlalu lebar; Anda ingin AI fokus.

### 1.7 Iterasi Prompt: *Prompt → Diff → Prompt'*

Prompt pertama jarang sempurna. Loop:

1. **Submit prompt** awal.
2. **Baca diff/jawaban**. Catat *deviasi* dari yang Anda inginkan.
3. **Beri umpan balik** spesifik (bukan "ini salah, coba lagi"). Contoh: *"Bagian transactional belum dibungkus, dan nama variabel masih camelCase padahal repo ini pakai snake_case."*
4. **Ulangi** maks 3–4 kali. Jika belum konvergen, *reset* dengan prompt baru yang lebih spesifik.

### 1.8 Anti-pattern Prompting

| Anti-pattern | Contoh | Fix |
|--------------|--------|-----|
| Terlalu vague | "buatkan login" | "buat endpoint POST /login pakai JWT, validasi pakai zod, tulis test" |
| Multi-tujuan | "buat login, register, reset password, lupa password" | Pecah jadi 4 prompt |
| Tanpa konteks | "kenapa kode ini lambat?" | "kenapa `@file query.ts` lambat saat input >10rb baris?" |
| Argumentatif | "kamu salah, harusnya begini" | "Saya melihat X di output; expected Y; tolong jelaskan asumsi yang dipakai" |
| Over-spec | 30-baris constraint untuk task 10-baris | Pakai 3 constraint paling kritikal |

### 1.9 Reusable Prompt: Snippets & Rules

- **Snippets pribadi**: simpan template prompt di file `prompts.md` di luar repo.
- **Project rules** (`.cursor/rules/*.mdc`): instruksi otomatis yang ter-load. Dipelajari Hari 2.
- **User rules** (Settings → Rules): preferensi gaya lintas project (mis. "selalu pakai TypeScript strict").

### 1.10 Checklist Kualitas Prompt

Sebelum tekan Enter, cek:

- [ ] Ada **tujuan jelas** dalam 1 kalimat?
- [ ] Sudah pasang **@-mention** konteks relevan?
- [ ] Sudah sebutkan **constraint** non-negotiable?
- [ ] Sudah sebutkan **acceptance criteria**?
- [ ] Tidak ada **ambiguitas pronoun** ("ini", "itu", "tadi")?
- [ ] Sudah pilih **mode yang tepat** (Tab / K / Chat / Composer)?

---

## 2. Demo Live

**Skenario**: "Dari prompt jelek ke prompt produksi dalam 4 iterasi."

1. **Iterasi 0 (vague)**: di Chat ketik *"buatkan fungsi cache"*. Tunjukkan jawaban generik.
2. **Iterasi 1 (+role)**: *"Sebagai senior backend, buatkan fungsi cache untuk service ini."* Sedikit lebih baik.
3. **Iterasi 2 (+context)**: tambah `@file user.service.ts @folder src/lib/`. AI mulai pakai pola repo.
4. **Iterasi 3 (+constraint)**: tambah *"Pakai Map in-memory, TTL 5 menit, threadsafe, tanpa library baru, lulus test di @file cache.test.ts."*
5. **Bandingkan side-by-side** kualitas output Iterasi 0 vs 3.

Pesan kunci: **prompt yang baik adalah investasi, bukan biaya**.

---

## 3. Hands-on Latihan

**Latihan 02 — Prompting Drill** (35 menit).
Lokasi: `./latihan-02-prompting-drill/README.md`.

Briefing: peserta diberi 5 skenario, harus menulis prompt produksi dan mengeksekusinya di Cursor, lalu menilai sendiri dengan rubrik.

---

## 4. Wrap-up & Q&A

Pertanyaan refleksi:

1. Prompt mana di Lab 02 yang paling **gagal** dan apa akar masalahnya — prompt, konteks, atau model?
2. @-mention mana yang **paling Anda underuse** sebelum hari ini?
3. Constraint apa yang akan Anda **pasang permanen** sebagai user rules?
4. Bagaimana Anda akan menyimpan & berbagi prompt template di tim?
5. Kapan Anda akan **berhenti** mengiterasi dan memilih menulis manual?

---

## 5. Bacaan Lanjutan

- Cursor — *Chat & Composer*: <https://cursor.com/docs/chat>
- Cursor — *@-symbols / context*: <https://cursor.com/docs/context/@-symbols>
- Cursor — *Rules*: <https://cursor.com/docs/context/rules>
- Anthropic — *Prompt engineering guide*: <https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/overview>
- OpenAI — *Prompt engineering best practices*.
- Lilian Weng — *Prompt Engineering* (blog post).
- Buku: *Software Engineering at Google*, bab "Knowledge Sharing" — relevan untuk reusable prompt di tim.
