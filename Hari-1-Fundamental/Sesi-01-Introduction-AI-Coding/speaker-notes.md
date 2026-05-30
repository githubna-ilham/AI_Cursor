# Speaker Notes — Sesi 1: Introduction to AI-Assisted Coding

**Durasi total**: 90 menit
**Mode**: Plenary + diskusi kelompok

---

## Alokasi Waktu

| Segmen | Durasi | Kegiatan |
|--------|--------|----------|
| Opening & ice breaker | 10' | Sapa, cek pre-test, cerita pembuka |
| Konsep 1.1–1.3 (Why now + Evolusi + AI vs Traditional) | 20' | Slide + tanya-jawab |
| Konsep 1.4–1.5 (Peran AI + Use case per profil) | 10' | Mapping ke pekerjaan peserta |
| Demo Live (format Rupiah) | 10' | Live coding di Cursor |
| Konsep 1.6–1.7 (Mindset + Risiko) | 10' | Refleksi |
| Diskusi kelompok (lihat `diskusi.md`) | 25' | 3 pertanyaan |
| Wrap-up & Q&A | 5' | Sticky note refleksi |

Total: 90 menit (dengan buffer 5').

---

## Cerita Pembuka (pilih salah satu)

**Opsi A — Personal anecdote**:
"Tiga tahun lalu saya butuh 2 hari untuk menulis CRUD admin panel sederhana. Minggu lalu saya bikin yang sama dalam 90 menit, tapi 60 menit-nya saya pakai untuk **membaca dan menolak** kode AI. Hari ini kita akan bahas kenapa 60 menit itu adalah skill baru yang harus kita latih."

**Opsi B — Industry framing**:
"Stack Overflow 2024 Developer Survey: 76% developer pakai atau berencana pakai AI tool. Tapi hanya 43% yang *trust* outputnya. Gap 33% itulah pekerjaan kita di pelatihan ini."

---

## Cue Fasilitator per Segmen

### Segmen "Evolusi Dev"
- Tekankan: bukan "AI menggantikan", tapi "abstraksi unit kerja naik". Analogi: pindah dari assembly → C → Python → ... → spec.
- Hindari overpromise. Jangan bilang "10x productivity"; bilang "berubah jenis pekerjaannya".

### Segmen "AI vs Traditional"
- **Pin** kolom "Akuntabilitas". Ini akan diulang di Hari 2 saat bahas governance.
- Pertanyaan ke peserta: "Siapa yang pernah commit kode Copilot tanpa benar-benar membacanya?" — tunggu tangan, normalisasi, lalu bahas kenapa itu berbahaya.

### Segmen "Use Case per Profil"
- Lihat hasil pre-test → sebut nama peserta dan profilnya. Buat ini personal.
- Minta peserta tambahkan 1 use case yang spesifik ke domain mereka.

### Segmen "Demo Live"
- **Wajib lakukan** menulis manual dulu — peserta perlu lihat "rasa sakit"-nya.
- Saat AI-generate, sengaja jangan terima 100%. Tunjukkan minimal 1 koreksi.
- Highlight: "Lihat, saya menolak 1 baris. Ini bukan kegagalan, ini *adalah* pekerjaan saya sekarang."

### Segmen "Risiko"
- Sebut nama insiden publik (mis. kasus secret leak yang ter-commit ke repo Copilot) — buat real.
- **Pitfall peserta**: cenderung defensive ("saya tidak akan jatuh ke risiko itu"). Konter dengan: "100% developer yang pernah commit secret juga awalnya yakin tidak akan".

---

## Jawaban Kunci untuk Pertanyaan Diskusi

### Pertanyaan 1 (`diskusi.md` Q1): Use case AI di sprint terakhir
Jawaban yang baik menyebut:
- Tugas **boring + well-defined** (boilerplate, test, migration).
- Tugas **eksploratif** (prototype, spike).
- Tugas **translation** (regex, jq, SQL → ORM).

Jawaban yang harus di-challenge:
- "Semua tugas core business logic" → tanya: bagaimana cara verifikasi?

### Pertanyaan 2: Yang TIDAK boleh didelegasikan
Jawaban yang baik:
- Keputusan arsitektur level tinggi.
- Kode yang berhubungan dengan auth, kripto, PII.
- Kode yang tidak bisa direview (tidak ada test, deadline mepet → ini justru *paling berbahaya*).

### Pertanyaan 3: Definisi developer senior
Arahkan ke: senior = orang yang bisa **mendefinisikan spec, mereview hasil, dan menanggung jawab**. Bukan "yang ketik paling cepat".

---

## Common Pitfall Peserta

| Pitfall | Tanda | Counter |
|---------|-------|---------|
| Skeptis ekstrem ("AI bohong terus") | Crossed arms, sarkasme | Setuju dulu (validate), tunjukkan demo terkontrol |
| Hype ekstrem ("Sebentar lagi developer hilang") | Mengutip Devin/AGI | Tunjukkan failure mode konkret |
| Diam karena tidak nyambung | Profil DevOps/Data merasa "ini cuma untuk app dev" | Tarik use case di tabel 1.5 yang sesuai profilnya |
| Bandingkan ke Copilot saja | "Ini sama saja dengan Copilot" | Tunda jawaban → akan jelas di Sesi 2 saat tour Composer |

---

## Material Visual Tambahan

- Siapkan slide 1 grafik **adoption AI tools** (Stack Overflow Survey).
- Siapkan screenshot Cursor Composer (untuk teaser Sesi 2).
- Siapkan 1 contoh "kode salah dari AI yang terlihat benar" — fungsi yang memanggil method yang tidak ada di library — sebagai contoh hallucination.

---

## Transisi ke Sesi 2

Tutup dengan: "Kita sudah sepakat apa, kenapa, dan risikonya. Sekarang kita pegang alatnya — Sesi 2: Cursor IDE."
