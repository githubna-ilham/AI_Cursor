# Speaker Notes — Sesi 7: Refactoring & Code Quality

## Alokasi Waktu (90 menit)

| Menit | Bagian | Catatan |
|-------|--------|---------|
| 0–5   | Recap Sesi 6 | — |
| 5–25  | Konsep 1–4 | Karakterisasi test wajib paham |
| 25–40 | Konsep 5–8 | Workflow + standard + metrik |
| 40–55 | Demo live | Spaghetti controller |
| 55–82 | Lab 06 | — |
| 82–90 | Debrief + wrap-up | — |

## Cue Fasilitator

### Pembukaan

Tanya: "Berapa banyak yang punya file > 500 baris di codebase?" Kemungkinan banyak. Hubungkan ke kebutuhan refactor.

### Saat "Refactor ≠ Rewrite"

Tekankan: rewrite tergiur karena terlihat sat-set di AI, tapi 80% production incident pasca-AI berasal dari rewrite tanpa karakterisasi.

### Saat Characterization Test

Lakukan demo singkat tanpa code editor: "Fungsi `f(x) = ?`. Kita tidak tahu maksudnya. Kita panggil `f(1)=2, f(2)=4, f(0)=0`. Sekarang kita punya test, dan kita bisa refactor isi `f` semau kita."

### Saat Demo Spaghetti Controller

<!-- STACK-PLACEHOLDER: siapkan spaghetti controller dalam stack mayoritas peserta -->

Default: Express handler ~150 baris dengan validasi inline, query SQL inline, dan response formatting bercampur. Tujuan refactor: extract 3 fungsi (validate, fetch, format) tanpa mengubah behaviour.

## Jawaban Kunci

1. Refactor: struktur, behaviour identik. Rewrite: bangun ulang. Refactor saat kode masih hidup & produktif; rewrite saat hutang teknis > nilai bisnis.
2. Tanpa characterization test, refactor = bet. AI bisa mengubah behaviour halus (boundary, error message) tanpa Anda sadar.
3. `.cursorrules` di root + linter di CI + review manusia diff. Plus instruksi style di prompt.
4. Cyclomatic complexity, LOC per fungsi, coverage, maintainability index, regression test pass rate.
5. Risiko: behaviour change halus yang baru muncul di production, lost domain knowledge, false confidence karena test green padahal test belum cukup mencakup.

## Anekdot

- "Tim X minta AI refactor money calculation, AI ganti `BigDecimal` jadi `double` — production lose Rp 12 juta sebelum ketahuan." Pelajaran: type matters, jangan biarkan AI ganti tipe.
- "Test green, tapi error message berubah, integration test client downstream pecah." Pelajaran: behaviour includes error contract.

## Common Pitfall

| Pitfall | Koreksi |
|---------|---------|
| Refactor + fix bug dalam 1 commit | Pisahkan |
| Tidak baca diff sebelum apply | Wajibkan review |
| Lupa jalankan linter | Aktifkan auto-run |
| Generate test setelah refactor | Harusnya sebelum |
| Trust AI 100% untuk extract function | Cek side-effect & closure |

## Transisi ke Sesi 8

"Refactor selesai. Sekarang bagaimana kita memastikan refactor (dan kode lain) bekerja jangka panjang? Testing & code review berbantuan AI."
