# Latihan 01 — Tour Cursor + Scaffold Portfolio

> 🗺️ **Tahap 1–2 dari 10** di [Perjalanan Project Hari 1](../../perjalanan-project.md)
> Sebelumnya: — | Setelah ini: Tahap 3 (Section Hero) di Sesi 3

**Durasi**: 45 menit
**Tipe**: Hands-on individual
**Output**: Repo `portfolio/` lokal berisi `index.html` (skeleton semantic), `assets/styles.css` (variabel CSS dasar), commit pertama, dan 5 screenshot bukti penggunaan 4 mode Cursor.

---

## Konteks BRD

Latihan ini menyelesaikan **FR-01 (parsial)** — fondasi struktur halaman portfolio. Mengacu wireframe **Section 9** di [`/Hari-1-Fundamental-DevNotes/portfolio-brd.md`](../../portfolio-brd.md).

---

## Tujuan

1. Mengalami **4 mode interaksi** Cursor (Tab, Cmd/Ctrl+K, Chat, Agent) pada konteks nyata.
2. Menghasilkan **artefak permanen** yang akan dipakai di Sesi 3 & 4: repo `portfolio/` dengan skeleton HTML semantic + CSS variables siap pakai.

---

## Prasyarat

- Cursor terinstall, login berhasil (lihat `../instalasi-checklist.md`).
- Smoke test poin #8 di checklist lulus.
- Git terinstall + identitas global ter-set.
- Akun GitHub aktif (repo bisa privat).

---

## Output yang Diharapkan

Struktur akhir folder peserta:

```
portfolio/
├── README.md
├── index.html              ← skeleton semantic (header, nav, main dengan placeholder section, footer)
├── assets/
│   ├── styles.css          ← reset minimal + CSS variables (warna, font, spacing)
│   └── app.js              ← kosong / placeholder untuk Tahap berikutnya
└── submissions/<nama>/
    ├── 01-indexed.png
    ├── 02-tab.png
    ├── 03-inline-edit.png
    ├── 04-chat.png
    ├── 05-agent.png
    └── refleksi.md
```

`index.html` harus punya kerangka semantic:

- `<header>` dengan nav (link anchor placeholder: Home / Skills / Projects / Contact)
- `<main>` dengan 4 `<section>` kosong (id: hero, skills, projects, contact)
- `<footer>` dengan copyright & social link placeholder

CSS variables wajib di `:root`:

- `--color-primary`, `--color-bg`, `--color-text`, `--color-muted`
- `--font-base`, `--font-heading`
- `--spacing-sm`, `--spacing-md`, `--spacing-lg`

---

## Langkah

### 1. Setup Repo (5')

1.1. Buat folder: `mkdir portfolio && cd portfolio && git init`.
1.2. Buka di Cursor: **File → Open Folder**.
1.3. Tunggu indexing selesai (< 30 detik untuk repo kosong).
1.4. Screenshot status bar yang menunjukkan project terindex → `submissions/<nama>/01-indexed.png`.

### 2. Mode Agent — Scaffold Multi-file (10')

2.1. Buka panel Agent dengan `Cmd+I` / `Ctrl+I`.
2.2. Prompt:

```
Buat scaffold awal website portfolio personal sebagai web statis HTML/CSS/JS vanilla:
- index.html dengan struktur semantic: <header> berisi <nav> dengan link anchor
  (#hero, #skills, #projects, #contact), <main> dengan 4 <section> KOSONG
  yang masing-masing punya id sesuai anchor di atas, dan <footer> dengan
  copyright + social link placeholder.
- assets/styles.css dengan CSS reset minimal + CSS custom properties (variables)
  di :root untuk warna (--color-primary, --color-bg, --color-text, --color-muted),
  typography (--font-base, --font-heading), dan spacing (--spacing-sm/md/lg).
  Pilih palette yang clean (mis. dark mode atau minimalist light).
- assets/app.js KOSONG dulu (cuma 1 baris komentar "// portfolio script").
- README.md singkat (judul, cara menjalankan: buka index.html di browser).

Mengikuti wireframe portfolio di Section 9 BRD: hero + skills + projects +
contact, single-page scroll-based. Tidak perlu framework, tidak perlu build tool.
```

2.3. **Review tiap file** yang akan dibuat. Reject file yang tidak Anda mengerti — minta penjelasan ulang via Chat.
2.4. Accept perubahan.
2.5. Buka `index.html` di browser. Harusnya muncul halaman dengan nav di atas, 4 section kosong, footer di bawah.
2.6. Screenshot panel Agent + halaman di browser → `05-agent.png`.

### 3. Mode Chat — Tanya Codebase (5')

3.1. Buka Chat (`Cmd+L` / `Ctrl+L`) atau pakai panel kanan yang sama dengan mode "Ask".
3.2. Ketik `@` → pilih `Folder` → arahkan ke folder `portfolio/`.
3.3. Prompt: *"Jelaskan struktur project ini dalam 5 bullet. Variabel CSS apa saja yang sudah disiapkan dan untuk apa?"*
3.4. Baca jawaban. Tanya follow-up: *"Kalau saya mau ganti warna primary jadi #2563eb, cukup ubah di mana saja?"*
3.5. Screenshot percakapan → `04-chat.png`.

### 4. Mode Cmd/Ctrl+K — Inline Edit (5')

4.1. Buka `assets/styles.css`. Highlight blok `:root { ... }` (variabel CSS).
4.2. Tekan `Cmd+K` / `Ctrl+K`.
4.3. Ketik: *"Tambah variant dark mode di `@media (prefers-color-scheme: dark)` — override --color-bg dan --color-text saja, sisanya biarkan."*
4.4. Tunggu diff muncul. **Baca** seluruh diff. Terima (Enter) atau tolak (Esc).
4.5. Test: ubah dark mode di System Settings macOS, atau di DevTools → Rendering → Emulate CSS prefers-color-scheme = dark. Refresh browser → warna harus berubah.
4.6. Screenshot diff (sebelum accept) → `03-inline-edit.png`.

### 5. Mode Tab — Autocomplete (5')

5.1. Buka `assets/app.js`, ketik komentar:

```js
// fungsi smoothScrollTo menerima id section (string tanpa #),
// scroll halus ke section tersebut
function smoothScrollTo(id) {
```

5.2. Tekan Enter — Tab akan menyarankan implementasi.
5.3. **Baca dulu**. Terima (Tab), atau edit prefix dulu untuk influence saran.
5.4. (Belum perlu dipanggil sekarang — fungsi ini akan dipakai di Tahap 9 saat bikin nav sticky.)
5.5. Screenshot saran Tab yang muncul → `02-tab.png`.

### 6. Commit & Submit (5')

6.1. `git add . && git commit -m "feat: scaffold portfolio skeleton + CSS variables (Tahap 1-2)"`.
6.2. (Opsional) Buat repo di GitHub dan push.
6.3. Tulis `submissions/<nama>/refleksi.md` (3–5 kalimat):
   - Mode mana paling intuitif?
   - Mode mana paling mengagetkan output-nya?
   - 1 hal yang akan Anda lakukan berbeda kalau mengulang scaffold ini.

---

## Kriteria Selesai (Rubrik)

| Kriteria                                            | Bobot | Cukup                 | Baik                            | Sangat Baik                                            |
| --------------------------------------------------- | ----- | --------------------- | ------------------------------- | ------------------------------------------------------ |
| Halaman tampil dengan 4 section + nav + footer      | 25%   | Tampil tapi rusak     | Tampil rapi sesuai wireframe    | Sesuai wireframe + dark mode toggle lulus              |
| Semua 5 screenshot tersubmit                        | 20%   | 3 file                | 4 file                          | 5 file lengkap                                         |
| Agent dipakai untuk scaffold awal                   | 15%   | Scaffold manual       | Agent dipakai tanpa review      | Agent dipakai + review per-file + reject 1 hal         |
| Tab + Inline Edit menghasilkan kode dipakai         | 15%   | Hanya di-accept       | Di-accept & dipakai             | Di-accept, dipakai, diverifikasi di browser            |
| Chat memakai @-mention dengan benar                 | 10%   | Tanpa @-mention       | @-mention 1×                    | @-mention + follow-up berkualitas                      |
| Commit pertama bermakna (pesan jelas, file relevan) | 10%   | Commit ada            | Commit dengan pesan baik        | Commit + ref Tahap di pesan + repo push ke GitHub      |
| Refleksi tulisan                                    | 5%    | < 3 kalimat           | 3–5 kalimat                     | Refleksi spesifik + insight                            |

Lolos minimum: **70%** total.

---

## Tips

- Jangan tergesa-gesa accept Tab/Agent. Baca dulu — terutama selector CSS dan struktur HTML, mudah di-hallucinate.
- Pakai `Esc` tanpa rasa bersalah. Menolak saran adalah skill.
- Simpan **palette warna pilihan Anda** dengan baik — akan dipakai konsisten di tahap-tahap berikutnya.
- Pakai semantic HTML (`<section>`, `<header>`, `<nav>`, `<footer>`) sejak awal — akan mempermudah accessibility audit di Tahap 10.

---

## Common Issues

| Issue                                  | Solusi                                                              |
| -------------------------------------- | ------------------------------------------------------------------- |
| Agent bikin package.json / build       | Tolak. Tegaskan di prompt: "no build tool, no package.json"         |
| Tab tidak muncul                       | Cek Settings → Features → Cursor Tab; restart Cursor                |
| Chat "no context found"                | Folder belum selesai diindex; tunggu / re-index                     |
| Halaman blank putih di browser         | Buka DevTools console; biasanya path `assets/styles.css` salah      |
| Dark mode tidak switch                 | Cek `@media (prefers-color-scheme: dark)` ada di CSS; cek emulator   |
| Screenshot terpotong                   | Gunakan tool screenshot OS bawaan, full window                      |
