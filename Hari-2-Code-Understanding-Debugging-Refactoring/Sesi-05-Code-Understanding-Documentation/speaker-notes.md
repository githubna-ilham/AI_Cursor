# Speaker Notes — Sesi 5: Code Understanding & Documentation

## Alokasi Waktu (90 menit)

| Menit | Bagian | Catatan |
|-------|--------|---------|
| 0–5   | Opening & recap Hari 1 | Tanya 1–2 peserta highlight Hari 1 |
| 5–25  | Konsep inti 1–4 | Jangan terlalu lama di teori |
| 25–40 | Demo live | Pakai repo yang sudah disiapkan H-3 |
| 40–80 | Lab 04 | Bagi pasangan, keliling fasilitasi |
| 80–88 | Debrief lab | 2 pasangan present singkat |
| 88–90 | Wrap-up & preview Sesi 6 | — |

## Cue Fasilitator

### Pembukaan

"Berapa persen waktu kerja Anda dihabiskan membaca kode dibanding menulis?" — biarkan peserta menebak, lalu ungkap angka ~58%. Ini membuka relevansi sesi.

### Saat Konsep "Tiga Lapis"

Tekankan: AI sangat kuat di lapis **struktural**, cukup baik di **behavioral**, dan paling lemah di **evolusional** (karena butuh konteks git history yang tidak selalu tersedia di context window).

### Saat Demo

<!-- STACK-PLACEHOLDER: pilih repo demo sesuai mayoritas stack peserta -->

Rekomendasi default:
- Backend JS: `expressjs/express`
- Backend Python: `pallets/flask`
- Backend Go: `gin-gonic/gin`
- Frontend: `vuejs/core` atau `reduxjs/redux`

Jangan pilih repo > 100k LOC untuk demo — context window akan jadi bottleneck dan demo terlihat lemah.

### Anekdot yang Bisa Dipakai

- Cerita "AI mengarang nama fungsi yang tidak ada": tunjukkan satu output AI lama yang menyebut fungsi `validateOrderV2` padahal hanya ada `validateOrder`. Diskusikan kenapa hallucination terjadi (retrieval miss).
- Cerita "ADR generated 90% bagus, 10% mengarang rationale": tekankan bahwa AI cenderung menulis prosa yang plausible meski tidak ada dasarnya.

## Jawaban Kunci Pertanyaan Refleksi

1. **Paling membantu**: orientasi struktural awal & generate boilerplate dokumentasi. **Paling keliru**: rationale historis, dynamic dispatch, konfigurasi runtime.
2. Tambahkan instruksi eksplisit `cite path:line` + `tandai [UNVERIFIED] jika tidak yakin` + minta format tabel dengan kolom "Source".
3. `@file` untuk pertanyaan lokal; `@folder` untuk pemahaman modul; `@codebase` untuk discovery awal atau pencarian cross-cutting. Untuk monorepo besar, hindari `@codebase` global.
4. Tidak. Minimum: 1 reviewer manusia memvalidasi setiap klaim path/line, mengecek sequence diagram terhadap kode aktual, menghapus rationale yang tidak punya basis.
5. Strategi: minta AI mengidentifikasi entry point DI container dulu, lalu telusuri manual; gunakan runtime debugging untuk konfirmasi resolusi tipe.

## Common Pitfall Peserta

| Pitfall | Cara Mengoreksi |
|---------|-----------------|
| Prompt terlalu umum ("jelaskan codebase ini") | Suruh tambahkan scope + format output |
| Percaya 100% diagram AI | Minta validasi 2 klaim acak |
| Lupa pakai @-context | Tunjukkan perbedaan jawaban dengan/tanpa @codebase |
| Generate ADR tanpa git context | Jelaskan: ADR butuh sumber keputusan |
| Membaca dokumentasi AI seperti membaca buku | Ingatkan: dokumentasi AI = draft, bukan final |

## Transisi ke Sesi 6

"Sekarang Anda bisa memahami codebase. Tapi codebase yang dipahami bukan berarti codebase yang sehat — sering kali bug bersembunyi di flow yang sudah Anda petakan. Sesi 6 kita masuk ke debugging."
