# Speaker Notes — Sesi 3: Prompting & Context Management

**Durasi total**: 90 menit
**Mode**: Konsep ringkas → demo intens → lab → review bersama.

---

## Alokasi Waktu

| Segmen | Durasi | Catatan |
|--------|--------|---------|
| Opening + recap Sesi 2 | 5' | Mood check |
| Konsep 1.1–1.4 (prinsip, formula, anatomi, @-mentions) | 15' | Slide + tabel |
| Konsep 1.5–1.8 (budget, 3 pola, iterasi, anti-pattern) | 10' | Banyak contoh |
| Demo Live (prompt jelek → produksi) | 15' | Live di Cursor |
| Lab 02 | 35' | Peserta mengerjakan |
| Review hasil Lab (3 peserta share) | 10' | Pilih 3 contoh: 1 sangat baik, 1 oke, 1 problematik |

---

## Cerita Pembuka

"Tahun 2020 saya menggaji junior developer. Yang membedakan kontribusi mereka bukan IQ, tapi seberapa baik PM saya menulis **ticket**. Tiket jelek → kerjaan jelek. Hari ini, prompt = tiket. Anda PM-nya, AI junior-nya. Skill menulis tiket yang baik balik lagi jadi penting."

---

## Cue Fasilitator per Segmen

### Konsep
- Cepat di poin 1.1–1.3. Jangan tertahan menjelaskan "apa itu LLM". Asumsi peserta sudah tahu dari Sesi 1.
- Berhenti agak lama di **1.4 (@-mentions)** — ini fitur yang paling under-explored peserta baru.
- Demonstrasikan tiap @-mention **di layar live**, bukan hanya di slide.

### Demo Iterasi
- Sengaja munculkan output **buruk** di Iterasi 0. Ini momen "aha" untuk peserta.
- Saat menambah constraint, jelaskan **mengapa setiap constraint dipilih**.
- Tunjukkan **diff antar iterasi** kalau memungkinkan — gunakan tool diff atau side-by-side window.

### Lab 02
- 35 menit terdengar lama, tapi **5 skenario × 7 menit = pas-pasan**.
- Keliling ruang. Tanya peserta: "Apa @-mention yang kamu pakai?" — kalau tidak ada, prompt mereka mungkin terlalu kering.
- **Larangan**: peserta tidak boleh skip skenario. Tulis prompt walau terasa bodoh.

### Review Hasil
- Pilih 3 peserta — variasi: satu yang struktur prompt bagus, satu yang kreatif, satu yang gagal informatif.
- Hindari memuji prompt panjang — yang dipuji adalah prompt **tepat**.

---

## Jawaban Kunci Wrap-up

### Q1 — Prompt yang paling gagal
Probe akar: (a) prompt vague, (b) konteks salah/kurang, (c) model overestimated. Jangan biarkan jawaban "AI-nya bodoh".

### Q2 — @-mention underused
Top guess: `@docs`, `@git`, `@web`. Banyak yang hanya pakai `@file`.

### Q3 — User rules permanen
Contoh standar: bahasa pemrograman, format code style, ban library tertentu, "tanyakan dulu sebelum bikin file baru".

### Q4 — Berbagi prompt
Ide: file `prompts.md` di repo bersama; rotate "prompt of the week" di standup; library prompt di Notion.

### Q5 — Kapan berhenti iterasi
Heuristik 3–4 iterasi. Jika setelah itu belum konvergen → prompt-nya yang salah, atau task-nya **terlalu besar** (pecah).

---

## Common Pitfall Peserta

| Pitfall | Tanda | Counter |
|---------|-------|---------|
| Prompt sangat panjang tapi tanpa @-mention | Wall of text, tetap dapat jawaban generik | Tunjukkan pengaruh @-mention dalam demo |
| Multi-turn tanpa reset | Chat 30 turn, konteks penuh sampah | Ajari reset chat saat ganti topik |
| Constraint berlebihan | Output terlalu kaku / AI menyerah | Pecah jadi 2 prompt |
| Mengasumsikan AI ingat session sebelumnya | "tadi kan saya bilang…" | Sebut eksplisit / pakai rules |
| Lupa pilih model yang sesuai | Pakai model cepat untuk task reasoning berat | Tunjukkan beda kualitas Auto vs model reasoning |

---

## Material Visual Tambahan

- Slide visual **diff antar iterasi** prompt → output.
- Cheat sheet @-mention (cetak/digital).
- Daftar 10 prompt template yang langsung pakai (lihat `prompting-cheatsheet.md`).

---

## Transisi ke Sesi 4

"Kita sudah punya alat (Cursor), cara bertanya (prompting), dan kontrol konteks. Sesi 4 kita pakai semua itu untuk **menghasilkan kode nyata** — fitur CRUD dari user story."
