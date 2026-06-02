# Latihan 01 — Tour Cursor + Scaffold DevNotes (Home Statis)

**Durasi**: 45 menit
**Tipe**: Hands-on individual
**Sesi**: Sesi 2 — Getting Started with Cursor
**Output**: Repo `devnotes/` lokal berisi `index.html` (halaman home dengan mock data), commit pertama, dan 5 screenshot bukti penggunaan 4 mode Cursor.

---

## Konteks BRD

Latihan ini menyelesaikan **FR-01** (halaman home menampilkan daftar catatan publik) dengan data dummy hardcoded. Mengacu mockup **Section 11.1** di [`/project-brd.md`](../../../project-brd.md).

---

## Tujuan

1. Mengalami **4 mode interaksi** Cursor (Tab, Cmd/Ctrl+K, Chat, Composer) pada konteks nyata.
2. Menghasilkan **artefak permanen** yang akan dipakai di Sesi 3 & 4: repo `devnotes/` dengan halaman home statis.

---

## Prasyarat

- Cursor terinstall, login berhasil (lihat `../instalasi-checklist.md`).
- Smoke test poin #8 di checklist lulus.
- Git terinstall + identitas global ter-set (`git config --global user.name/.email`).
- Akun GitHub aktif (repo bisa privat).

---

## Output yang Diharapkan

Struktur akhir folder peserta:

```
devnotes/
├── README.md
├── index.html              ← halaman home (feed publik dummy)
├── assets/
│   ├── styles.css
│   └── app.js              ← berisi MOCK_NOTES array
└── submissions/<nama>/
    ├── 01-indexed.png
    ├── 02-tab.png
    ├── 03-inline-edit.png
    ├── 04-chat.png
    ├── 05-composer.png
    └── refleksi.md
```

`index.html` harus menampilkan minimal 3 kartu catatan dummy dengan layout sesuai mockup 11.1 BRD (judul, author, waktu, ringkasan).

---

## Langkah

### 1. Setup Repo (5')

1.1. Buat folder: `mkdir devnotes && cd devnotes && git init`.
1.2. Buka di Cursor: **File → Open Folder**.
1.3. Tunggu indexing selesai (lihat status bar — biasanya < 30 detik untuk repo kosong).
1.4. Screenshot status bar yang menunjukkan project terindex → simpan sebagai `submissions/<nama>/01-indexed.png`.

### 2. Mode Composer — Scaffold Multi-file (10')

2.1. Buka Composer dengan `Cmd+I` / `Ctrl+I`.
2.2. Prompt:

```
Buat scaffold awal aplikasi DevNotes berupa web statis HTML/CSS/JS vanilla:
- index.html dengan struktur semantic (header, main, footer)
- assets/styles.css dengan CSS reset minimal + style untuk card list
- assets/app.js berisi array MOCK_NOTES (3 item: title, author, createdAt, excerpt)
  dan fungsi renderNotes() yang inject ke <main id="feed">
- README.md singkat (judul, cara menjalankan: buka index.html di browser)

Mengikuti mockup home page DevNotes: header bertuliskan "DevNotes" dengan
tombol Login dan +New, list kartu catatan ditampilkan vertikal.
Tidak perlu framework, tidak perlu build tool.
```

2.3. **Review tiap file** yang akan dibuat. Reject file yang tidak Anda mengerti, minta penjelasan ulang via Chat.
2.4. Accept perubahan.
2.5. Buka `index.html` di browser (double-click atau `open index.html`).
2.6. Screenshot panel Composer + halaman di browser → `05-composer.png`.

### 3. Mode Chat — Tanya Codebase (5')

3.1. Buka Chat dengan `Cmd+L` / `Ctrl+L`.
3.2. Ketik `@` → pilih `Folder` → arahkan ke folder `devnotes/`.
3.3. Prompt: *"Jelaskan struktur project ini dalam 5 bullet. Mana file yang paling penting untuk diubah kalau saya mau ganti data dummy menjadi data dari API?"*
3.4. Baca jawaban. Tanya follow-up: *"Tunjukkan baris kode tepat yang harus diganti dan apa yang harus ditulis."*
3.5. Screenshot percakapan → `04-chat.png`.

### 4. Mode Cmd/Ctrl+K — Inline Edit (5')

4.1. Buka `assets/app.js`, highlight fungsi `renderNotes()`.
4.2. Tekan `Cmd+K` / `Ctrl+K`.
4.3. Ketik: *"Tambahkan empty state: jika MOCK_NOTES kosong, tampilkan pesan 'Belum ada catatan publik' di tengah halaman. Pakai HTML inline, tidak perlu CSS baru."*
4.4. Tunggu diff muncul. **Baca** seluruh diff. Terima (Enter) atau tolak (Esc).
4.5. Test: ubah `MOCK_NOTES = []` sementara, refresh browser — pesan empty state harus muncul. Kembalikan data setelah verifikasi.
4.6. Screenshot diff (sebelum accept) → `03-inline-edit.png`.

### 5. Mode Tab — Autocomplete (5')

5.1. Buka `assets/app.js`, di akhir file tambahkan komentar:

```js
// fungsi formatRelativeTime menerima ISO date string,
// mengembalikan "2 jam lalu" / "kemarin" / "3 hari lalu"
function formatRelativeTime(iso) {
```

5.2. Tekan Enter — Tab akan menyarankan implementasi.
5.3. **Baca dulu**. Terima (Tab), atau edit prefix dulu untuk influence saran.
5.4. Pakai fungsi ini di `renderNotes()` (replace tampilan `createdAt` dengan `formatRelativeTime(note.createdAt)`).
5.5. Verifikasi di browser.
5.6. Screenshot saran Tab yang muncul → `02-tab.png`.

### 6. Commit & Submit (5')

6.1. `git add . && git commit -m "feat: scaffold DevNotes home page (FR-01)"`.
6.2. (Opsional) Buat repo di GitHub dan push.
6.3. Tulis `submissions/<nama>/refleksi.md` (3–5 kalimat):
   - Mode mana paling intuitif?
   - Mode mana paling mengagetkan output-nya?
   - 1 hal yang akan Anda lakukan berbeda kalau mengulang scaffold ini.

---

## Kriteria Selesai (Rubrik)

| Kriteria                                            | Bobot | Cukup                 | Baik                            | Sangat Baik                                            |
| --------------------------------------------------- | ----- | --------------------- | ------------------------------- | ------------------------------------------------------ |
| Halaman home tampil di browser dengan 3+ kartu      | 25%   | Tampil tapi rusak     | Tampil rapi sesuai mockup       | Sesuai mockup + empty state lulus                      |
| Semua 5 screenshot tersubmit                        | 20%   | 3 file                | 4 file                          | 5 file lengkap                                         |
| Composer dipakai untuk scaffold awal                | 15%   | Scaffold manual       | Composer dipakai tanpa review   | Composer dipakai + review per-file + reject 1 hal      |
| Tab + Inline Edit menghasilkan kode dipakai         | 15%   | Hanya di-accept       | Di-accept & dipakai             | Di-accept, dipakai, diverifikasi di browser            |
| Chat memakai @-mention dengan benar                 | 10%   | Tanpa @-mention       | @-mention 1×                    | @-mention + follow-up berkualitas                      |
| Commit pertama bermakna (pesan jelas, file relevan) | 10%   | Commit ada            | Commit dengan pesan baik        | Commit + ref FR di pesan + repo push ke GitHub         |
| Refleksi tulisan                                    | 5%    | < 3 kalimat           | 3–5 kalimat                     | Refleksi spesifik + insight                            |

Lolos minimum: **70%** total.

---

## Tips

- Jangan tergesa-gesa accept Tab/Composer. Baca dulu — terutama selector CSS dan struktur HTML, mudah di-hallucinate.
- Pakai `Esc` tanpa rasa bersalah. Menolak saran adalah skill.
- Simpan `MOCK_NOTES` Anda dengan baik — akan **dipakai lagi** di Sesi 3 (drill prompting halaman detail) dan Sesi 4 (form new note).
- Pakai semantic HTML (`<article>`, `<header>`, `<time>`) sejak awal — akan mempermudah accessibility audit di Hari 3.

---

## Common Issues

| Issue                                  | Solusi                                                              |
| -------------------------------------- | ------------------------------------------------------------------- |
| Composer membuat package.json / build  | Tolak. Tegaskan di prompt: "no build tool, no package.json"         |
| Tab tidak muncul                       | Cek Settings → Features → Cursor Tab; restart Cursor                |
| Chat "no context found"                | Folder belum selesai diindex; tunggu / re-index                     |
| Halaman blank putih di browser         | Buka DevTools console; biasanya path `assets/styles.css` salah      |
| Screenshot terpotong                   | Gunakan tool screenshot OS bawaan, full window                      |
