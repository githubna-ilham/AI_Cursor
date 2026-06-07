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
| 3 | **Ask** (Chat) | Buka panel (`Cmd/Ctrl + L`) → dropdown mode = `Ask`. Pakai `@` untuk attach context | Tanya jawab tentang codebase, brainstorming, tanpa langsung mengubah file | Jawaban tidak otomatis ter-apply — Anda harus tekan "Apply" atau copy-paste |
| 4 | **Agent** | Panel yang sama → dropdown mode = `Agent` (atau langsung `Cmd/Ctrl + I` untuk buka panel default ke mode Agent) | Tugas multi-file: scaffold, refactor lintas file, bikin fitur dari spec | Bisa bikin/ubah banyak file sekaligus — paling sulit di-review |

> ℹ️ **Catatan versi**: Cursor versi sekarang menyatukan Chat dan Agent ke **satu panel**, dengan dropdown mode (`Ask` / `Agent` / kadang `Edit`) di bagian bawah. Shortcut `Cmd+L` dan `Cmd+I` hanya menentukan mode default saat panel terbuka. Dulu (Cursor <0.40) kedua mode terpisah panel.

**Aturan praktis**: pakai mode yang **paling kecil** yang masih bisa menyelesaikan tugas. Kalau Tab cukup, tidak perlu Ask. Kalau Inline Edit cukup, tidak perlu Agent. Mode lebih agentik = lebih cepat, tapi lebih sulit dikontrol.

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

2.2. Tab akan menyarankan implementasi — biasanya seperti ini:

```js
const section = document.getElementById(id);
section.scrollIntoView({ behavior: 'smooth' });
```

> ⚠️ Perhatikan: saran Tab di atas **belum cek `null`**. Kalau id tidak ditemukan, `section.scrollIntoView(...)` akan melempar `TypeError`. Untuk portfolio ini risikonya rendah (anchor kita kontrol sendiri), tapi catatan ini bagus untuk reviewer-first mindset — terima saran AI, jangan terima asumsi-nya.

2.3. **Baca dulu** saran sebelum terima, lalu:
   - `Tab` untuk accept
   - `Esc` untuk tolak

2.4. Belum perlu memanggil `smoothScrollTo()` sekarang — fungsi ini akan dipakai di **Tahap 9** saat bikin nav sticky.

2.5. Screenshot saran Tab yang muncul → `02-tab.png`.

### 3. Mode Cmd/Ctrl+K — Inline Edit (10')

Lebih kuat dari Tab: Anda highlight kode, lalu beri instruksi natural language untuk modifikasi. Anda akan pakai Cmd+K **tiga kali** di langkah ini:

1. Definisikan **CSS variables** di `:root`.
2. Buat **rule** yang **memakai** variables itu di elemen body/nav/footer.
3. Tambah **dark mode** override.

> 💡 Tahap ini sengaja dipecah supaya peserta sadar: *variables saja tidak cukup* — harus ada rule yang `var(--xxx)` baru warnanya kelihatan di browser.

#### 3a. Definisikan Variables

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

3.4. Tunggu diff muncul. **Baca seluruh diff**, lalu:
   - `Enter` untuk terima
   - `Esc` untuk tolak

> ⚠️ **Cek di browser sekarang**: refresh `index.html`. Halaman **masih putih default** — itu **benar**, bukan bug. Variables hanya mendefinisikan token, belum apply ke elemen. Itulah kenapa kita lanjut ke 3b.

#### 3b. Buat Rule yang Memakai Variables

3.5. Di file yang sama, taruh cursor di bawah blok `:root { ... }`. Tekan `Cmd+K` lagi. Ketik:

```
Tambah rules yang memakai variables di atas:
- body: background --color-bg, color --color-text, font-family --font-base,
  margin 0
- nav: flex row, gap --spacing-md, padding --spacing-md
- nav a: color --color-primary, text-decoration none, font-weight 600
- nav a:hover: opacity 0.8
- main section: min-height 60vh, padding --spacing-lg
- footer: padding --spacing-lg, color --color-muted,
  border-top 1px solid --color-muted
- h1, h2, h3: font-family --font-heading
```

3.6. Refresh `index.html`. Sekarang background dark, text putih, link nav berwarna primary tanpa underline. Ini bukti variables sudah "dipakai".

#### 3c. Tambah Dark Mode Override

3.7. Highlight blok `:root` lagi → `Cmd+K` → ketik:

```
Tambah variant @media (prefers-color-scheme: light) yang override
--color-bg jadi #ffffff dan --color-text jadi #1a1a2e. Variabel lain
biarkan.
```

> ℹ️ Kita sengaja override **light mode** karena baseline kita sudah dark. Kalau baseline Anda light, balik logikanya: pakai `(prefers-color-scheme: dark)`.

3.8. Test: System Settings → ganti appearance, atau DevTools → Rendering → emulate `prefers-color-scheme`. Background harus berubah.

3.9. Screenshot diff salah satu langkah (sebelum accept) → `03-inline-edit.png`.

### 4. Mode Ask — Tanya Codebase (7')

Sekarang ada konten di project. Mode **Ask** untuk **tanya jawab tanpa langsung mengubah file**.

4.1. Buka panel sidebar (`Cmd+L` / `Ctrl+L`).

4.2. Di **dropdown mode** (bagian bawah panel), pilih `Ask`.

4.3. Ketik `@` → pilih `Folder` → arahkan ke folder `portfolio/`.

4.4. Prompt:

```
Jelaskan struktur project ini dalam 5 bullet.
Variabel CSS apa saja yang sudah disiapkan dan untuk apa?
```

4.5. Baca jawaban. Tanya follow-up: *"Kalau saya mau ganti warna primary jadi #2563eb, cukup ubah di mana saja?"*

4.6. Screenshot percakapan → `04-chat.png`.

> 💡 Perhatikan: di mode **Ask**, AI **tidak otomatis** ubah file. Kalau jawabannya mau di-apply, tekan tombol "Apply" di tiap snippet kode atau copy-paste manual. Ini bedanya dengan mode **Agent** di langkah berikutnya.

### 5. Mode Agent — Scaffold Multi-file (10')

Mode paling kuat & paling sulit dikontrol: AI bisa **membuat/mengubah banyak file sekaligus** untuk menyelesaikan tugas yang Anda spec.

5.1. Di panel yang sama, **ganti dropdown mode** dari `Ask` ke `Agent`. (Atau buka panel default Agent dengan `Cmd+I` / `Ctrl+I`.)
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

5.5. Buka `index.html` di browser. Harusnya muncul halaman dengan nav di atas, 4 section kosong (masing-masing setinggi 60vh), footer di bawah, warna mengikuti rules dari langkah 3b.

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
