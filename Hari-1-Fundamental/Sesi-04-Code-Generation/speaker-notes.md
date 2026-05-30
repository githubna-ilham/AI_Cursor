# Speaker Notes — Sesi 4: Code Generation Fundamentals

**Durasi total**: 90 menit
**Mode**: Demo end-to-end + lab terpanjang di hari 1.

---

## Alokasi Waktu

| Segmen | Durasi | Catatan |
|--------|--------|---------|
| Opening + recap Sesi 3 | 5' | Tarik benang merah |
| Konsep 1.1–1.4 (spectrum, story→prompt, fungsi/class/module, pseudocode) | 12' | Banyak contoh konkret |
| Konsep 1.5–1.8 (style, validasi, anti-pattern, loop) | 8' | Cepat |
| Demo Live (CRUD end-to-end) | 15' | Demo ringkas |
| Lab 03 | 45' | Peserta mengerjakan |
| Wrap-up + 2 demo peserta + retrospektif | 5' | Pilih 2 peserta share |

Total: 90 menit.

---

## Cerita Pembuka

"Sampai Sesi 3, kita masih belajar 'aturan main'. Sesi 4 kita main pertandingan sungguhan. Anda akan keluar ruangan ini dengan **kode yang berjalan** — bukan kode dari tutorial, kode yang Anda spec sendiri, generate sendiri, debug sendiri."

---

## Cue Fasilitator per Segmen

### Konsep
- Berlama-lama di **1.1 Spectrum** dan **1.2 Story→Prompt**. Ini insight paling berharga.
- Tunjukkan **1.4 (pseudocode)** di slide dengan contoh yang benar-benar Anda terjemahkan live.
- Anti-pattern (1.7) dibacakan dengan nada serius — peserta cenderung anggap remeh.

### Demo Live
- **Pilih stack yang dipakai mayoritas peserta** (sesuai pretest).
- Sengaja munculkan 1 kegagalan test → tunjukkan loop fix.
- Jangan tergoda demo "agentic full auto"; tujuan demo adalah **mengilustrasikan loop sehat**.

### Lab 03 (paling penting)
- 45 menit terdengar banyak, **akan kurang**.
- Brief peserta sebelum mulai: prioritas adalah **commit kecil + test jalan**, bukan fitur lengkap.
- Keliling ruang, intervensi cepat ketika melihat:
  - Composer dipakai untuk "generate semuanya sekaligus".
  - Test diskip "nanti saja".
  - Diff diterima tanpa dibaca.
- Siapkan **template starter** di sample repo agar peserta tidak habis waktu setup.

### Retrospektif
- Pilih 2 peserta: 1 yang berhasil sampai test hijau, 1 yang stuck. Yang stuck **paling berharga** untuk dibahas.
- Pertanyaan probe: "Di titik mana kamu mulai merasa kehilangan kendali?"

---

## Jawaban Kunci Wrap-up

### Q1 — Mudah vs sulit
Pattern: boilerplate (mudah), business logic spesifik (sulit), integrasi cross-module (paling sulit).

### Q2 — Rasio waktu
Heuristik sehat: 30% prompt, 40% review, 30% manual + test. Kalau prompt >50% → terlalu lama; kalau review <30% → bahaya.

### Q3 — Hallucination konkret
Probe: nama method yang tidak ada, asumsi schema salah, library version mismatch.

### Q4 — Commit yang ditolak
Pattern: commit besar tanpa test, perubahan irrelevant, pesan commit generik, dependency baru tanpa diskusi.

### Q5 — Besok pagi
Catat semua — jadi *bridge* ke Hari 2 (workflow tim).

---

## Common Pitfall Peserta

| Pitfall | Tanda | Counter |
|---------|-------|---------|
| Composer big-bang | "saya minta Composer bikin semuanya" | Tunjukkan diff yang tidak masuk akal → ajak pecah task |
| Skip test | "nanti deh testnya, fokus fitur dulu" | Aturan lab: tidak ada test = tidak lolos |
| Tidak baca diff | Klik accept setiap saran | Minta jelaskan 3 baris yang dia accept terakhir |
| Stack-pattern lupa diberi tahu AI | Output style asing | Tunjukkan kekuatan @file exemplar |
| Commit raksasa di akhir | 1 commit jam terakhir | Aturan lab: minimal 4 commit |

---

## Material Visual Tambahan

- Slide loop kerja (mermaid 1.8) dicetak besar di dinding.
- Template user story untuk Lab 03 (siap pakai).
- Checklist validasi (1.6) di kartu kecil bagikan ke peserta.

---

## Penutup Hari 1

"Hari 1 selesai. Anda punya: Cursor terinstall, pemahaman prompting, fitur yang jalan. Hari 2 kita angkat ke level tim: rules, workflow review, kolaborasi. Bawa fitur yang Anda bangun hari ini — kita akan tambahkan tim-aware governance di atasnya."

Recap 1 menit:
- Sesi 1: mindset shift, akuntabilitas tetap di developer.
- Sesi 2: 4 mode interaksi Cursor.
- Sesi 3: prompt = role + context + constraint + acceptance.
- Sesi 4: feature = banyak commit kecil yang reviewable & testable.

Briefing Hari 2: "Bawa repo hasil hari ini. Kita akan tambahkan rules, code review AI-assisted, dan workflow Git yang cocok untuk tim."
