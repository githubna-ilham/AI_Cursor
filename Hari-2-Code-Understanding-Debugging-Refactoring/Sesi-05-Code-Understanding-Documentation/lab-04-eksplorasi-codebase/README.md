# Lab 04 — Eksplorasi Codebase dengan AI

## Tujuan

Peserta mampu memetakan arsitektur dan flow utama sebuah repository asing menggunakan Cursor AI dalam waktu terbatas, lalu memproduksi dokumentasi teknis yang siap di-review.

## Durasi

40 menit (35 menit kerja + 5 menit debrief)

## Prasyarat

- Cursor terinstall, login aktif, codebase indexing menyala.
- Git terinstall.
- Akses internet untuk clone repo.
- Sudah mengikuti Sesi 5.

## Repository Target

<!-- STACK-PLACEHOLDER: fasilitator memilih 1 repo per stack peserta -->

Default repo (pilih salah satu sesuai stack):

| Stack | Repo Rekomendasi | Ukuran |
|-------|------------------|--------|
| Backend Node.js | `expressjs/express` | ~15k LOC |
| Backend Python | `pallets/flask` | ~25k LOC |
| Backend Go | `gin-gonic/gin` | ~20k LOC |
| Frontend | `reduxjs/redux` | ~10k LOC |
| Data Engineer | `dbt-labs/dbt-core` | sedang |
| DevOps | `kubernetes-sigs/kind` | sedang |

## Langkah

1. **Clone & buka** repo target di Cursor. Tunggu indexing selesai (lihat status bar).
2. **Orientasi struktural** (5 menit). Prompt:
   ```
   @folder <root-source> Buat tabel berisi: subfolder | tanggung jawab | file kunci.
   Sertakan path untuk file kunci.
   ```
   Simpan output di `peta-modul.md`.
3. **Identifikasi entry point** (3 menit). Prompt:
   ```
   @codebase Apa entry point eksekusi utama project ini?
   Sertakan path:line.
   ```
4. **Map flow utama** (10 menit). Pilih satu flow representatif (misal: HTTP request lifecycle, atau task execution). Prompt:
   ```
   @codebase Petakan flow <nama flow> dari entry point hingga output akhir.
   - Numbered list fungsi yang dipanggil + path:line
   - Identifikasi side-effect (I/O, network, state mutation)
   - Mermaid sequence diagram di akhir
   Tandai [UNVERIFIED] untuk klaim yang tidak yakin.
   ```
   Simpan sebagai `flow-utama.md`.
5. **Verifikasi** (5 menit). Pilih 3 klaim AI secara acak (terutama yang punya path:line), buka file aktual, konfirmasi atau koreksi. Catat di `verifikasi.md`.
6. **Generate README submodul** (7 menit). Pilih satu submodul kecil. Prompt:
   ```
   @folder <submodul> Tulis README.md berisi: tujuan submodul, public API,
   contoh penggunaan, dependency, batas tanggung jawab.
   Cite path:line untuk setiap public API.
   ```
   Simpan di `submodul-readme-draft.md`.
7. **Catat 3 pertanyaan terbuka** (5 menit) yang AI tidak bisa jawab meyakinkan. Simpan di `pertanyaan-terbuka.md`.

## Deliverable

Di akhir lab, pasangan punya 5 file di folder `output-lab-04/`:

- `peta-modul.md`
- `flow-utama.md`
- `verifikasi.md`
- `submodul-readme-draft.md`
- `pertanyaan-terbuka.md`

## Kriteria Selesai / Rubrik

| Kriteria | Bobot | Indikator Selesai |
|----------|-------|-------------------|
| Peta modul lengkap | 20% | Minimal 80% subfolder tercakup, file kunci punya path |
| Flow utama terverifikasi | 30% | Min. 5 langkah flow, semua punya path:line, 3 langkah sudah dicek manual |
| Sequence diagram valid | 15% | Diagram mermaid render benar, urutan match dengan kode |
| README submodul akurat | 20% | Public API listed semua, contoh berjalan, no fictional function |
| Pertanyaan terbuka tajam | 15% | 3 pertanyaan menyangkut hal non-trivial (bukan "apa nama variabel ini") |

## Tips

- Jangan habiskan waktu di repo besar (> 50k LOC) — pilih repo sedang.
- Jika AI mengarang, perpendek scope (`@folder` lebih kecil).
- Selalu buka file untuk verifikasi minimal 30% klaim.

## Debrief (5 menit)

Dua pasangan mempresentasikan: 1 temuan menarik + 1 kegagalan AI yang menarik.
