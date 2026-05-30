# Template Presentasi Capstone

**Durasi**: 7 menit presentasi + 2 menit Q&A
**Jumlah slide**: 5–7 (tidak termasuk cover & thank-you)
**Format**: PDF/Keynote/Slides — sediakan backup PDF.

---

## Struktur Slide

### Slide 1 — Cover

- Nama tim & anggota (sebut peran masing-masing).
- Judul project + opsi yang dipilih.
- 1 kalimat tagline ("Pipeline ETL yang idempoten dan auditable dalam 2 jam").

### Slide 2 — Problem

- Konteks bisnis singkat (siapa user, apa kebutuhannya).
- Pain point yang ingin diselesaikan.
- Constraint utama (waktu, stack, data).

**Tips**: jangan generic. Sebut angka atau skenario konkret.

### Slide 3 — Solution

- Diagram arsitektur (mermaid / gambar).
- Komponen utama + tanggung jawabnya.
- Trade-off paling penting yang diputuskan (1–2 kalimat).

### Slide 4 — Demo

- Slide ini sebagai jangkar saat berpindah ke demo live / video.
- Tunjukkan flow end-to-end terpenting (1–2 menit demo).
- Sediakan screenshot fallback jika demo gagal.

### Slide 5 — AI Techniques Used

- Daftar 4–6 prompt kunci yang dipakai (kategori: generate / debug / refactor / test / docs).
- Untuk tiap prompt: **apa yang diminta**, **apa yang dihasilkan**, **bagaimana Anda menyaring/mengoreksi**.
- Bagian mana yang AI **tidak** berkontribusi dan kenapa.

**Format saran**:

| Tahap | Prompt Kunci (ringkas) | Hasil | Tindakan Anda |
|-------|------------------------|-------|---------------|
| Scaffold | "Generate ..." | OK 80% | Edit naming, tambah validasi |
| Debug | "Hipotesis penyebab ..." | 3 hipotesis | Verifikasi #2 benar |
| Test | "Generate edge cases ..." | 8 test | Buang 2 duplikat |
| Docs | "Tulis README ..." | Draft baik | Edit bagian setup |

### Slide 6 — Results & Metrics

- Apa yang berfungsi (functionality checklist).
- Bukti kualitas: test count, coverage, CI status.
- Untuk opsi performance/refactor: angka sebelum vs sesudah.

### Slide 7 — Lessons Learned

- 2 hal yang bekerja baik dengan Cursor.
- 2 hal yang tidak bekerja / harus dikoreksi.
- 1 hal yang akan tim bawa ke pekerjaan sehari-hari.
- 1 hal yang akan tim lakukan berbeda jika punya 1 jam lagi.

### (Opsional) Slide 8 — Thank You + QR

- Link repo (QR code).
- Kontak presenter / lead.
- Pertanyaan?

---

## Tips Presentasi

- **Jaga 7 menit** — latih sekali sebelum maju.
- **Satu presenter utama**, satu pendamping demo. Pergantian < 1.
- **Demo ≠ tour kode**. Jangan scroll IDE; tunjukkan hasil, bukan source.
- **Suara audien**: presentasi setelah Anda mendengarkan Anda — perhatikan saat ada bagian membosankan.
- **Cerita > fitur**. Bingkai sebagai journey, bukan dump kemampuan.

## Aturan Tampilan

- Font min 22pt.
- Maks 6 baris bullet per slide.
- Diagram dibuat jelas dari belakang ruangan.
- Hindari screenshot kode > 8 baris — gunakan kutipan kunci saja.

## Yang Pasti Ditanya Juri / Fasilitator

1. "Mana bagian yang **paling Anda banggakan** dan kenapa?"
2. "Bila ada 1 jam lagi, **prioritas perbaikan apa**?"
3. "Apa **risiko produksi** terbesar dari solusi ini sekarang?"
4. "Bagaimana Anda **memastikan AI tidak meng-introduce regresi**?"
5. "Bagian mana Anda **paling banyak mengoreksi** output AI?"

Siapkan jawaban singkat (≤ 30 detik) untuk masing-masing sebelum maju.
