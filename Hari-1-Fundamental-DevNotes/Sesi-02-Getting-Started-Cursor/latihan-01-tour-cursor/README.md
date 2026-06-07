# Latihan 01 — Tour Cursor + Scaffold Portfolio

> 🗺️ **Tahap 1–2 dari 10** di [Perjalanan Project Hari 1](../../perjalanan-project.md)
> Sebelumnya: — | Setelah ini: Tahap 3 (Section Hero) di Sesi 3

**Durasi**: 45 menit
**Tipe**: Hands-on individual
**Output**: Repo `portfolio/` lokal berisi `index.html` (skeleton semantic), `assets/styles.css` (variabel CSS dasar), `assets/app.js` (fungsi `smoothScrollTo`), commit pertama, dan 5 screenshot bukti penggunaan 4 mode Cursor.

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

## Empat Mode Cursor — Pengantar Singkat

Sebelum langkah praktik, pahami dulu **kapan masing-masing mode dipakai**. Urutan latihan ini sengaja dari yang paling **sederhana & lokal** ke yang paling **kompleks & agentik**:

| # | Mode | Cara aktifkan | Cocok untuk | Risiko utama |
|---|------|---------------|-------------|--------------|
| 1 | **Tab** | Ketik kode → tombol `Tab` | Autocomplete 1–10 baris berdasarkan konteks file aktif | Saran "kelihatan benar" tapi pakai API yang tidak ada |
| 2 | **Cmd/Ctrl + K** (Inline Edit) | Highlight kode → `Cmd/Ctrl+K` | Modifikasi blok kode yang sudah ada (ubah, tambah, refactor kecil) | Mengubah lebih banyak dari yang Anda kira — wajib baca diff |
| 3 | **Chat** (`Cmd/Ctrl + L`) | Panel kanan, pakai `@` untuk attach context | Tanya jawab tentang codebase, brainstorming, tanpa langsung mengubah file | Jawaban tidak otomatis ter-apply — Anda harus pindah-tempel manual |
| 4 | **Agent** (`Cmd/Ctrl + I`) | Panel kanan, "Composer" / "Agent" mode | Tugas multi-file: scaffold, refactor lintas file, bikin fitur dari spec | Bisa bikin/ubah banyak file sekaligus — paling sulit di-review |

**Aturan praktis**: pakai mode yang **paling kecil** yang masih bisa menyelesaikan tugas. Kalau Tab cukup, tidak perlu Chat. Kalau Inline Edit cukup, tidak perlu Agent. Mode lebih agentik = lebih cepat, tapi lebih sulit dikontrol.

---

## Output yang Diharapkan

Struktur akhir folder peserta:

```
portfolio/
├── README.md
├── index.html              ← skeleton semantic (header, nav, main dengan 4 section, footer)
├── assets/
│   ├── styles.css          ← CSS variables (warna, font, spacing) + dark mode
│   └── app.js              ← fungsi smoothScrollTo (akan dipakai di Tahap 9)
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
1.4. Buat 3 file kosong manual (lewat File Explorer Cursor):

```
portfolio/
├── index.html             (kosong)
└── assets/
    ├── styles.css         (kosong)
    └── app.js             (kosong)
```

1.5. Screenshot status bar yang menunjukkan project terindex → `submissions/<nama>/01-indexed.png`.

> 💡 File sengaja dibuat kosong dulu supaya Anda **merasakan** apa yang masing-masing mode tambahkan ke file.

### 2. Mode Tab — Autocomplete (5')

Mode paling sederhana: AI melihat konteks file aktif dan menyarankan beberapa baris berikut. Tidak perlu dialog, tidak perlu prompt.

2.1. Buka `assets/app.js`. Ketik komentar di bawah, lalu tekan Enter:

```js
// fungsi smoothScrollTo menerima id section (string tanpa #),
// scroll halus ke section tersebut
function smoothScrollTo(id) {
```

2.2. Tab akan menyarankan implementasi (biasanya pakai `document.getElementById` + `scrollIntoView({ behavior: 'smooth' })`).
2.3. **Baca dulu** saran sebelum terima. Tekan `Tab` untuk accept, atau `Esc` untuk tolak.
2.4. (Fungsi ini akan dipanggil di Tahap 9 saat bikin nav sticky — belum perlu dipanggil sekarang.)
2.5. Screenshot saran Tab yang muncul → `02-tab.png`.

### 3. Mode Cmd/Ctrl+K — Inline Edit (8')

Lebih kuat dari Tab: Anda highlight kode, lalu beri instruksi natural language untuk modifikasi.

3.1. Buka `assets/styles.css`. Tulis manual blok kosong:

```css
:root {
}
```

3.2. Highlight blok `:root { ... }`.
3.3. Tekan `Cmd+K` / `Ctrl+K`. Ketik:

```
Isi dengan CSS variables: warna (--color-primary, --color-bg,
--color-text, --color-muted), font (--font-base, --font-heading),
dan spacing (--spacing-sm/md/lg). Pilih palette clean dark mode.
```

3.4. Tunggu diff muncul. **Baca seluruh diff**. Terima (Enter) atau tolak (Esc).
3.5. Lanjut: highlight `:root` lagi, `Cmd+K`, ketik: *"Tambah variant dark mode di `@media (prefers-color-scheme: dark)` — override `--color-bg` dan `--color-text` saja."*
3.6. Screenshot diff (sebelum accept) → `03-inline-edit.png`.

### 4. Mode Chat — Tanya Codebase (7')

Sekarang ada konten di project. Mode Chat untuk **tanya jawab tanpa langsung mengubah file**.

4.1. Buka Chat (`Cmd+L` / `Ctrl+L`).
4.2. Ketik `@` → pilih `Folder` → arahkan ke folder `portfolio/`.
4.3. Prompt:

```
Jelaskan struktur project ini dalam 5 bullet.
Variabel CSS apa saja yang sudah disiapkan dan untuk apa?
```

4.4. Baca jawaban. Tanya follow-up: *"Kalau saya mau ganti warna primary jadi #2563eb, cukup ubah di mana saja?"*
4.5. Screenshot percakapan → `04-chat.png`.

> 💡 Perhatikan: Chat **tidak otomatis** ubah file. Kalau jawabannya mau di-apply, Anda yang copy-paste atau pakai tombol "Apply".

### 5. Mode Agent — Scaffold Multi-file (10')

Mode paling kuat & paling sulit dikontrol: AI bisa **membuat/mengubah banyak file sekaligus** untuk menyelesaikan tugas yang Anda spec.

5.1. Buka panel Agent dengan `Cmd+I` / `Ctrl+I`.
5.2. Prompt (ringkas, fokus 1 tugas):

```
Isi index.html dengan struktur semantic single-page portfolio:
- <header> berisi <nav> dengan 4 link anchor (#hero, #skills, #projects, #contact)
- <main> dengan 4 <section> kosong (id: hero, skills, projects, contact)
- <footer> dengan copyright + social link placeholder

Link ke assets/styles.css dan assets/app.js yang sudah ada.
Tidak perlu framework. Tidak perlu inline CSS/JS.
```

5.3. **Review tiap perubahan** yang akan dibuat. Reject hal yang tidak Anda mengerti — minta penjelasan ulang via Chat.
5.4. Accept perubahan.
5.5. Buka `index.html` di browser. Harusnya muncul halaman dengan nav di atas, 4 section kosong, footer di bawah, warna sesuai variables dari langkah 3.
5.6. Test dark mode: System Settings macOS atau DevTools → Rendering → `prefers-color-scheme: dark`. Warna harus berubah.
5.7. Screenshot panel Agent + halaman di browser → `05-agent.png`.

### 6. Commit & Submit (5')

6.1. `git add . && git commit -m "feat: scaffold portfolio skeleton + CSS variables (Tahap 1-2)"`.
6.2. (Opsional) Buat repo di GitHub dan push.
6.3. Tulis `submissions/<nama>/refleksi.md` (3–5 kalimat):
   - Mode mana paling intuitif?
   - Mode mana paling mengagetkan output-nya?
   - 1 hal yang akan Anda lakukan berbeda kalau mengulang scaffold ini.

---

## Tips

- **Mulai dari mode terkecil.** Kalau Tab cukup, jangan langsung Agent. Latihan ini sengaja diatur dari sederhana ke kompleks supaya intuisi "kapan pakai apa" terbentuk.
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
