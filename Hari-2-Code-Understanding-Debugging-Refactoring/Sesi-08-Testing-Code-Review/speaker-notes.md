# Speaker Notes — Sesi 8: Testing & Code Review

## Alokasi Waktu (90 menit)

| Menit | Bagian | Catatan |
|-------|--------|---------|
| 0–5   | Recap Sesi 7 | — |
| 5–25  | Konsep 1–4 | Tekankan kualitas > kuantitas test |
| 25–40 | Konsep 5–9 | Review workflow + etika |
| 40–55 | Demo live | PR fiktif refund |
| 55–82 | Lab 07 | — |
| 82–88 | Debrief | — |
| 88–90 | Closing Hari 2 + preview Hari 3 | — |

## Cue Fasilitator

### Pembukaan

Tanya: "Tim Anda punya berapa % coverage? Apa itu jaminan kualitas?" Hampir pasti ada yang 80%+ tapi masih sering production bug. Ini hook untuk "coverage ≠ quality".

### Saat False Positive AI

Tunjukkan contoh nyata: AI komen "potential null dereference" di tempat yang sudah dijaga early return. Diskusikan: jika ini di-comment di PR, author akan kesal.

### Saat Demo PR Fiktif

<!-- STACK-PLACEHOLDER: PR fiktif disiapkan dalam stack mayoritas peserta -->

Default skenario:
- File 1: `routes/refund.ts` — endpoint baru
- File 2: `services/refundService.ts` — business logic refund
- File 3: `tests/refund.test.ts` — 1 happy path test saja

Bug yang sengaja ditanam (untuk AI temukan): (a) tidak cek amount > 0, (b) tidak cek idempotency, (c) tidak handle partial refund. AI akan menemukan (a) dan (b), miss (c).

## Jawaban Kunci

1. Indikator kualitas: mutation testing score, assert specificity, isolation, naming, ratio happy/edge/error, deterministik.
2. Saat false positive masuk ke PR tanpa filter — merusak trust, membuat author defensive, slowing down review.
3. True vs false positive: cek apakah claim AI grounded ke kode aktual (path:line), cek apakah behaviour benar-benar terjadi, jalankan test.
4. Tidak boleh AI: trade-off arsitektur, prioritas bisnis, decision yang menyangkut nilai team / contract.
5. Technical debt actionable: punya owner, estimasi cost, link ke ticket, kategori, severity, mitigation path.

## Common Pitfall

| Pitfall | Koreksi |
|---------|---------|
| AI generate 50 test tapi semua weak | Review per test, hapus yang tidak bermakna |
| Coverage 100% tapi semua snapshot | Tambahkan mutation testing |
| Paste komentar AI mentah ke PR | Filter & rephrase |
| AI review tanpa context business | Jangan delegasikan domain decision |
| Test bergantung waktu real | Inject clock |

## Anekdot

- "Tim mengaktifkan AI auto-review di GitHub, 1 minggu kemudian author mute notifikasi karena 70% komentar false positive."
- "AI generate 30 test untuk function 10 baris — coverage 100%, tapi 1 production bug masih lolos karena tidak ada test untuk concurrent call."

## Closing Hari 2

Sebut: "Hari ini Anda sudah praktek 4 kompetensi inti developer dengan AI: memahami, debug, refactor, test+review. Hari 3 kita masuk ke advanced workflow: integrasi AI ke CI/CD, multi-file change, dan kolaborasi tim."

Tanya 2 peserta: "Satu hal yang akan Anda terapkan besok di kerjaan?"
