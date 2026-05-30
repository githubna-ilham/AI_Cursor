# Speaker Notes — Sesi 09: Advanced Workflow

**Durasi total**: 90 menit
**Persiapan fasilitator**: repo demo `cursor-orders-api` sudah di-clone lokal, akun GitHub dummy untuk demo PR, dua tab Cursor terbuka (satu sebagai "developer", satu sebagai "reviewer").

---

## Alokasi Waktu

| Menit | Aktivitas | Catatan |
|-------|-----------|---------|
| 0–5 | Opening + recap Hari 2 | Tanyakan: "Apa pola Cursor yang paling sering kalian pakai sejak kemarin?" |
| 5–20 | Konsep 2.1–2.3 (Git layers + Conventional Commits) | Slide + whiteboard diagram |
| 20–35 | Konsep 2.4–2.5 (PR review + CI/CD) | Tunjukkan PR contoh real (anonim) |
| 35–45 | Konsep 2.6–2.7 (kolaborasi tim) | Diskusi: minta 2 peserta cerita struktur tim mereka |
| 45–60 | **Demo Live** (5 langkah) | Sediakan branch siap diff |
| 60–85 | **Hands-on Lab** | Pasang timer di layar |
| 85–90 | Wrap-up + Q&A | Pilih 2–3 pertanyaan saja, sisanya diskusi makan siang |

---

## Cue Fasilitator

### Pembuka
> "Hari 1 kita belajar 'apa itu Cursor', Hari 2 'cara pakai harian'. Hari 3 sesi pertama: bagaimana Cursor menyatu dengan workflow tim — Git, review, CI. Bukan tentang fitur baru, tapi tentang *integrasi*."

### Saat masuk Conventional Commits
> "Berapa dari kalian punya konvensi commit yang ditegakkan di repo? (angkat tangan) — Cursor sangat cocok dipakai bila konvensi sudah ada. Bila belum, sesi ini juga jadi peluang menetapkannya."

### Sebelum Demo
> "Saya akan sengaja membuat satu commit message yang buruk dulu, lalu kita perbaiki bareng-bareng — supaya kelihatan kontras *before/after*."

---

## Jawaban Kunci untuk Pertanyaan Wrap-up

**1. Risiko commit message AI tanpa review?**
- Hilangnya konteks *why*. AI sering menulis "what" yang sudah jelas dari diff.
- Bisa mengarang scope/ticket yang salah.
- Mitigasi: selalu edit minimal 1 baris sebelum commit.

**2. PR description manusia vs AI — perlu ditandai?**
- Tidak wajib ditandai eksplisit, tetapi PR author tetap **bertanggung jawab penuh**.
- Bila tim baru mengadopsi, transparansi awal membantu kepercayaan reviewer.

**3. Kapan AI tidak dilibatkan dalam review?**
- PR menyentuh secret management, kriptografi, atau data PII.
- PR security patch yang belum diumumkan (embargo).
- PR yang konteks bisnisnya rahasia (M&A, harga internal).

**4. Sinkronisasi .cursorrules antar anggota?**
- File di repo, review via PR.
- Hindari rules pribadi yang konflik (override di workspace personal saja).
- Jadwalkan review rules tiap kuartal.

**5. Metrik 90 hari?**
- Lead time PR turun X%.
- Cakupan test naik Y%.
- Survei NPS internal developer.
- *Bukan*: jumlah baris kode AI — itu metrik menyesatkan.

---

## Anekdot yang Bisa Dipakai

- Cerita "commit message AI menyebut nama library yang tidak ada di project" — terjadi karena AI mengarang dari pola umum, bukan diff aktual. Pelajaran: selalu baca.
- Cerita tim yang menambahkan `.cursorrules` larangan menyebut nama database production di prompt — pencegahan sederhana yang efektif.

---

## Common Pitfall yang Wajib Disebut

1. **Over-trust pada PR description AI** — reviewer skim deskripsi, ternyata tidak akurat.
2. **Commit AI yang menggabungkan dua perubahan tidak terkait** — minta AI memisahkan via *atomic commit*.
3. **YAML workflow AI yang reference action versi lama** (`@v2` saat sudah `@v4`). Selalu cross-check.
4. **Lupa rotate API key** ketika contoh prompt CI memuat token nyata.
5. **`.cursorrules` membengkak jadi 500 baris** — efektivitas turun. Jaga di bawah 80 baris.

---

## Transisi ke Sesi 10

> "Kita sudah bicara workflow. Tapi semua workflow ini meng-handle kode dan kadang data sensitif. Sesi berikutnya: bagaimana memastikan adopsi Cursor tidak menjadi pintu masuk insiden keamanan."
