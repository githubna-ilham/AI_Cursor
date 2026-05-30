# Speaker Notes — Sesi 2: Getting Started with Cursor

**Durasi total**: 90 menit
**Mode**: Demo-heavy + hands-on lab.

---

## Alokasi Waktu

| Segmen | Durasi | Catatan |
|--------|--------|---------|
| Opening + recap Sesi 1 | 5' | Jembatan: "kita sudah sepakat why, sekarang how" |
| Konsep 1.1–1.4 (Apa Cursor, kapabilitas, arsitektur, model) | 20' | Slide + tabel |
| Instalasi & verifikasi (dipandu) | 20' | Walk peserta step-by-step, tunggu yang tertinggal |
| Tour UI (live demo) | 20' | Demo 6 langkah di materi.md |
| Lab 01 | 20' | Peserta mandiri, fasilitator keliling |
| Wrap-up & Q&A | 5' | |

---

## Cerita Pembuka

"VS Code dengan Copilot itu seperti mobil bensin dengan turbocharger — cepat, tapi mesinnya tetap didesain untuk bensin. Cursor itu mobil yang dari awal didesain untuk hybrid. Sama-sama bisa pakai jalan tol yang sama (extension), tapi *cara berkendaranya* beda."

---

## Cue Fasilitator per Segmen

### Instalasi (paling rawan)
- **Pitfall paling umum**: peserta corporate laptop dengan policy proxy. Siapkan workaround:
  - `HTTPS_PROXY` env var.
  - Offline installer kalau memungkinkan.
- **Pitfall #2**: Windows defender mem-flag installer. Tunjukkan cara izinkan.
- **Pitfall #3**: peserta lupa email kantor — sediakan plan B login dengan email pribadi (akan refactor di hari 2).
- **Aturan emas**: jangan lanjut ke Tour UI sebelum **minimal 90% peserta** sudah login.

### Tour UI (paling padat)
- Demonstrasikan **shortcut, ucapkan shortcut-nya keras-keras** ("Command K... Command L..."). Otot memori penting.
- Sengaja buat 1 *failure* kecil — mis. Tab menyarankan sesuatu yang salah → tolak dengan Esc → jelaskan "Tab bukan oracle, ini probabilistic".
- Saat demo Composer: **batasi 1 task kecil**. Jangan demo agent yang jalan 5 menit — peserta akan terdistraksi.

### Pertanyaan menjebak yang sering muncul
- *"Apakah kode saya dikirim ke OpenAI/Anthropic?"* → Jawab jujur: ya, kecuali privacy mode aktif. Jelaskan apa yang disimpan vs tidak.
- *"Apakah Cursor membaca semua file di disk saya?"* → Tidak, hanya project yang dibuka & yang di-allow indexing.
- *"Bisa offline?"* → Tidak untuk model utama. Bisa pakai local model (Ollama) lewat custom endpoint dengan keterbatasan kualitas.
- *"Berapa biaya?"* → Arahkan ke pricing page; tekankan free tier cukup untuk pelatihan.

---

## Jawaban Kunci Wrap-up

### Q1 — Mode interaksi favorit
Jawaban yang baik mencerminkan pemahaman *niche*:
- Tab → micro edits.
- K → terlokalisasi presisi.
- Chat → eksplorasi & belajar codebase.
- Composer → task multi-file.

Jawaban yang harus di-challenge: "semuanya pakai Composer" → tunjukkan biaya kognitif & risiko *over-reach*.

### Q2 — Privacy
Jawaban yang baik: **Privacy Mode + `.cursorignore` + review policy organisasi**.

### Q3 — Extension wajib
Probe: linter, formatter, debugger stack peserta, GitLens, Docker. Pastikan peserta sudah migrate.

### Q4 — Model default
Tidak ada jawaban tunggal benar. Tekankan **kriteria**: latency, kualitas reasoning, panjang konteks, biaya.

### Q5 — Friction
Catat semua → ini *backlog* untuk fasilitator perbaiki sebelum Hari 2.

---

## Common Pitfall Peserta

| Pitfall | Tanda | Counter |
|---------|-------|---------|
| Tidak indexing project | Status bar "indexing 0%" terus | Re-open folder, cek `.cursorignore` |
| Pakai email salah → kena rate limit free | "limit reached" di Chat | Switch akun atau pakai trial |
| Spam Tab tanpa baca | Code "berkembang" tanpa pemahaman | Latih hard rule: baca 2 detik sebelum Tab |
| Composer di repo besar tanpa scope | Agent kebingungan, edit acak | Selalu scope dengan @-mentions atau buka file relevan saja |
| Lupa save → Tab tidak berfungsi optimal | Saran tidak nyambung | Aktifkan auto-save |

---

## Material Visual Tambahan

- Slide screenshot **UI Cursor** dengan label 5 area utama.
- Cheat sheet shortcut (cetak, 1 halaman) — bagikan fisik bila memungkinkan.
- Sample repo demo: repo Node sederhana atau yang sesuai stack mayoritas peserta.

---

## Transisi ke Sesi 3

Tutup dengan: "Sekarang tools-nya ada di tangan Anda. Tapi tools tidak berarti tanpa cara bertanya. Sesi 3: prompting & context — di sinilah AI berhenti jadi 'mainan' dan jadi *partner*."
