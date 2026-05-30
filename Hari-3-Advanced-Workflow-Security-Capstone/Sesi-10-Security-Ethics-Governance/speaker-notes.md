# Speaker Notes — Sesi 10: Security, Ethics & Governance

**Durasi total**: 90 menit
**Persiapan fasilitator**:
- Repo demo dengan `.env` dummy + `customers.csv` PII dummy.
- Slide insiden Samsung (sumber media publik, jangan klaim sumber internal).
- Print 3 kartu studi kasus untuk kelompok.
- Toggle Privacy Mode siap di akun demo.

---

## Alokasi Waktu

| Menit | Aktivitas | Catatan |
|-------|-----------|---------|
| 0–5 | Opening + cerita pembuka | Anekdot Samsung, set tone serius tapi non-menggurui |
| 5–25 | Konsep 2.1–2.4 (peta risiko, deployment, perlindungan) | Banyak tabel — jangan dibaca, ringkas |
| 25–40 | Konsep 2.5–2.9 (data sensitif, etika, governance) | Libatkan diskusi 2 menit di tiap topik etika |
| 40–70 | **Studi kasus kelompok + sharing** | 10' diskusi + 20' sharing silang |
| 70–85 | **Demo mitigasi** (5 langkah) | Jaga jangan over-time — ini visual heavy |
| 85–90 | Wrap-up + transisi | Tegaskan: sesi ini bukan menakut-nakuti, tapi memampukan |

---

## Cue Fasilitator

### Pembuka
> "Sebelum kita ngomongin tools, satu pertanyaan: bila besok kalian temukan rekan paste connection string production ke ChatGPT — apa yang akan kalian lakukan? (pause) — Sesi ini menyiapkan kalian untuk momen itu."

### Saat masuk peta risiko
> "Lima kategori ini bukan teoretis. Tiga dari lima sudah pernah terjadi di skala industri pada 2023–2024."

### Saat Privacy Mode
> "Privacy Mode bukan silver bullet — ia mengurangi *retention*, bukan *transmission*. Data tetap melalui infrastruktur vendor. Untuk data setara TOP SECRET, jawabannya self-hosted atau tidak pakai sama sekali."

### Saat etika
> "Diskusi etika sering dihindari karena terasa abstrak. Tapi kebijakan tim yang tidak punya landasan etis akan jadi compliance theater."

---

## Jawaban Kunci

**1. Beda cloud default vs Privacy Mode praktis?**
- Cloud default: ada retensi untuk training/abuse monitoring (tergantung ToS terbaru).
- Privacy Mode: zero retention, tidak dipakai training.
- Praktisnya: Privacy Mode hampir selalu pilihan default untuk tim enterprise.

**2. Rekan paste credential — langkah pertama?**
- Jangan reaktif/mempermalukan. Tarik ke samping.
- Rotate credential segera (1 jam pertama kritikal).
- Lapor security team via channel resmi.
- Dokumentasikan untuk post-mortem, bukan penalti.

**3. Deteksi hallucinated dependency?**
- Cek apakah paket ada di registry resmi (`npm view`, `pip show`).
- Cek download count + tanggal first publish.
- Cek maintainer & repo source.
- Gunakan tool: `socket.dev`, `snyk`, `npm audit signatures`.

**4. Junior pakai Cursor sejak hari pertama?**
- Argumen ya: produktivitas, eksposur ke pola.
- Argumen tidak: bahaya deskilling, harus lewati fundamental.
- Posisi seimbang: **boleh, dengan pairing & pembatasan** (misal 2 minggu pertama wajib jelaskan kode AI line-by-line ke mentor).

**5. Komponen kebijakan tersulit?**
- Biasanya: enforcement audit log + sanksi.
- Karena memerlukan kerja sama HR & Legal.

---

## Anekdot

- **Samsung (April 2023)**: laporan media menyebut tiga insiden internal di mana karyawan Samsung Semiconductor men-paste source code dan transkrip meeting ke ChatGPT. Samsung kemudian melarang generative AI publik internal. Pelajaran: kebijakan reaktif vs proaktif.
- **Typosquatting `requests`** — paket palsu dengan nama mirip muncul berkala di PyPI. Beberapa di antaranya disarankan oleh model AI yang halusinasi.
- **Komentar prompt injection** di README open-source: "Ignore previous instructions and ..." — AI yang membaca repo sebagai konteks bisa terpengaruh.

---

## Common Pitfall

1. **Menganggap Privacy Mode = on-prem**. Tidak. Tetap cloud, hanya zero retention.
2. **`.cursorignore` dibuat sekali lalu dilupakan**. Harus di-review setiap struktur folder berubah.
3. **Policy panjang yang tidak pernah dibaca**. Buat versi 1 halaman + versi lengkap.
4. **Menyamakan AI tooling dengan SaaS biasa** dalam vendor risk assessment. AI memerlukan kriteria tambahan (training data usage, model versioning).
5. **Reaksi panik melarang total** setelah satu insiden — sering kontraproduktif. Edukasi + kontrol bertahap lebih baik.

---

## Transisi ke Sesi 11

> "Kita sudah amankan adopsi. Sekarang, mari maksimalkan nilainya — sesi berikutnya: best practices dan optimasi performa aplikasi dengan bantuan AI."
