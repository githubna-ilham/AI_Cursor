# Lab 01 — Tour Cursor

**Durasi**: 20 menit
**Tipe**: Hands-on individual
**Sesi**: Sesi 2 — Getting Started with Cursor

---

## Tujuan

Peserta mengalami **4 mode interaksi** Cursor (Tab, Cmd/Ctrl+K, Chat, Composer) pada satu codebase nyata dan menghasilkan bukti tangkapan layar untuk masing-masing mode.

---

## Prasyarat

- Cursor terinstall, login berhasil (lihat `../instalasi-checklist.md`).
- Smoke test poin #8 di checklist lulus.
- Git terinstall.
- Sample repo sudah di-clone. <!-- STACK-PLACEHOLDER: URL repo demo sesuai stack -->

---

## Bahan

- Sample repo (disediakan fasilitator).
- Folder `submissions/<nama>/` untuk hasil screenshot.

---

## Langkah

### 1. Buka Sample Repo
1.1. `git clone <URL>` → buka di Cursor: **File → Open Folder**.
1.2. Tunggu indexing selesai (lihat status bar — biasanya 30–90 detik untuk repo kecil).
1.3. Screenshot status bar yang menunjukkan project terindex → simpan sebagai `01-indexed.png`.

### 2. Mode Tab — Autocomplete Cerdas
2.1. Buka 1 file source di repo. <!-- STACK-PLACEHOLDER: contoh path -->
2.2. Tambahkan **komentar singkat** di akhir file mendeskripsikan fungsi baru yang ingin dibuat, contoh:
   ```
   // fungsi menghitung total harga termasuk pajak 11%
   ```
2.3. Tekan Enter — Tab akan menyarankan implementasi.
2.4. Terima (Tab) **atau** edit dulu, lalu screenshot saran yang muncul → `02-tab.png`.

### 3. Mode Cmd/Ctrl+K — Inline Edit
3.1. Highlight 1 fungsi eksisting.
3.2. Tekan `Cmd+K` (mac) / `Ctrl+K` (win/linux).
3.3. Ketik instruksi: *"Tambahkan dokumentasi singkat dan handle input null/undefined."*
3.4. Tunggu diff muncul (hijau = tambah, merah = hapus).
3.5. **Baca** seluruh diff. Terima (Enter) atau tolak (Esc).
3.6. Screenshot diff (sebelum dan sesudah accept) → `03-inline-edit.png`.

### 4. Mode Chat — Q&A Codebase
4.1. Buka Chat dengan `Cmd+L` / `Ctrl+L`.
4.2. Ketik `@` → pilih `Folder` → arahkan ke folder utama codebase (mis. `src/`).
4.3. Prompt: *"Jelaskan tujuan utama folder ini dalam 5 bullet. Sebutkan file kunci."*
4.4. Baca jawaban. Tanya follow-up: *"File mana yang paling kompleks dan mengapa?"*
4.5. Screenshot percakapan → `04-chat.png`.

### 5. Mode Composer — Multi-file Task
5.1. Buka Composer dengan `Cmd+I` / `Ctrl+I`.
5.2. Prompt: *"Buat file `CONTRIBUTING.md` ringkas (maks 30 baris) berisi cara setup dev environment, cara menjalankan test, dan konvensi commit. Gunakan informasi yang sudah ada di README dan package manifest."*
5.3. Tunggu Composer membaca file → propose perubahan.
5.4. **Review tiap file** yang akan ditambah/ubah.
5.5. Accept perubahan.
5.6. Screenshot panel Composer + file baru → `05-composer.png`.

### 6. Submit
6.1. Salin 5 screenshot ke folder `submissions/<nama-anda>/`.
6.2. Tulis file `submissions/<nama-anda>/refleksi.md` (3–5 kalimat): mode mana paling intuitif? mode mana paling mengagetkan?

---

## Kriteria Selesai (Rubrik)

| Kriteria | Bobot | Cukup | Baik | Sangat Baik |
|----------|-------|-------|------|-------------|
| Semua 5 screenshot tersubmit | 30% | 3 file | 4 file | 5 file lengkap |
| Tab dimanfaatkan dengan benar | 15% | Saran diterima tanpa baca | Saran dibaca | Saran dimodifikasi sebelum diterima |
| Inline Edit menghasilkan diff bermakna | 15% | Diff trivial | Diff sesuai instruksi | Diff sesuai + peserta menolak bagian salah |
| Chat memakai @-mention dengan benar | 15% | Tanpa @-mention | @-mention 1× | @-mention + follow-up berkualitas |
| Composer menghasilkan file baru sesuai brief | 15% | File ada tapi off-brief | File sesuai | File sesuai + review per-hunk |
| Refleksi tulisan | 10% | < 3 kalimat | 3–5 kalimat | Refleksi spesifik + insight |

Lolos minimum: **70%** total.

---

## Tips

- Jangan tergesa-gesa accept Tab. Baca dulu.
- Pakai `Esc` tanpa rasa bersalah — menolak saran adalah skill.
- Jika Composer tampak "ngawur", scope ulang dengan menyebut file/folder spesifik via @-mention.
- Simpan ide prompt baik di catatan pribadi — akan dipakai di Sesi 3.

---

## Common Issues

| Issue | Solusi |
|-------|--------|
| Tab tidak muncul | Cek Settings → Features → Cursor Tab; restart Cursor |
| Chat "no context found" | Folder belum selesai diindex; tunggu / re-index |
| Composer error rate limit | Switch model atau tunggu beberapa detik |
| Screenshot terpotong | Gunakan tool screenshot OS bawaan, full window |
