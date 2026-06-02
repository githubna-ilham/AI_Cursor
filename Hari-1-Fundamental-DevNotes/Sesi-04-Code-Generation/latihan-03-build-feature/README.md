# Latihan 03 — Build Feature: Form New Note + localStorage CRUD

**Durasi**: 60 menit
**Tipe**: Hands-on individual (boleh diskusi tetangga)
**Sesi**: Sesi 4 — Code Generation Fundamentals
**Output**: `new.html` (form editor) + persistensi `localStorage` + tombol Edit/Hapus di home & detail, dengan minimal 4 mode interaksi Cursor terpakai dan 4 commit kecil bermakna.

---

## Konteks BRD

Latihan ini menyelesaikan **FR-04** (create catatan) + **FR-06** lokal (edit/delete) versi Hari 1 — semua persistensi di `localStorage`, belum ada BE.

Mengacu mockup **Section 11.5** (editor) dan **11.4** (dashboard list) di [`/project-brd.md`](../../../project-brd.md).

> Catatan: di Hari 2, persistensi akan dipindah ke Supabase. Kode `localStorage` di Hari 1 sengaja dibuat **tipis & terisolasi** supaya mudah diganti — peserta akan praktik refactor di Sesi 7.

---

## Tujuan

Peserta membangun fitur CRUD lokal end-to-end menggunakan Cursor, dengan praktik commit kecil, review diff, dan verifikasi manual di browser.

---

## User Story

> **Sebagai** developer, **saya ingin** menulis, mengubah, dan menghapus catatan saya di DevNotes dengan persistensi di browser, **agar** saya bisa drafting tanpa kehilangan data saat refresh halaman.

### Acceptance Criteria

- [ ] Halaman `new.html` (FR-04): form dengan input `title` (≥1, ≤120 char), textarea `body_md` (≤5000 char), radio `is_public`.
- [ ] Tombol "Simpan" → push ke array `notes` di `localStorage` (key: `devnotes:notes`), redirect ke `notes/[id].html?id=<slug>`.
- [ ] Halaman home (`index.html`) menggabungkan MOCK_NOTES + notes dari localStorage, urut terbaru di atas.
- [ ] Halaman detail (`notes/[id].html`) tampilkan tombol "Edit" & "Hapus" **hanya** kalau note berasal dari localStorage (anggap user adalah owner).
- [ ] Tombol "Edit" → buka `new.html?id=<slug>` dengan form ter-prefill.
- [ ] Tombol "Hapus" → konfirmasi sebelum delete, refresh ke home setelah delete.
- [ ] Validasi: title wajib (non-empty), karakter limit ditegakkan dengan disable tombol simpan kalau invalid.
- [ ] Tidak ada error di DevTools console pada flow happy path.

---

## Prasyarat

- Lulus Latihan 01 & 02 (repo `devnotes/` punya home + detail).
- Git config siap untuk commit.
- Browser dengan DevTools (Chrome/Firefox/Edge).

---

## Stack & Starter

- Stack: HTML + CSS + JavaScript vanilla (tidak ada framework, tidak ada build tool).
- Starter: repo `devnotes/` Anda sendiri dari Sesi 2 & 3.
- Exemplar `@-mention`: `assets/app.js` (mock data + render) dan `notes/[id].html` (URL param handling).

---

## Langkah

### 0. Persiapan (3')

0.1. Buat branch baru: `git checkout -b feat/new-note`.
0.2. Pastikan home + detail masih jalan: buka `index.html`, klik 1 kartu → detail muncul.
0.3. Buka DevTools → Application → Local Storage. Pastikan key `devnotes:notes` belum ada (atau kosongkan).

### 1. Storage Layer (8') — Mode Cmd/Ctrl+K

1.1. Buka `assets/app.js`. Di bagian atas (setelah `MOCK_NOTES`), highlight area kosong dan tekan `Cmd+K` / `Ctrl+K`.
1.2. Prompt:

```
Buat modul storage tipis untuk DevNotes:
- Konstanta STORAGE_KEY = 'devnotes:notes'
- getUserNotes(): Note[] — baca dari localStorage, return [] jika kosong
- saveUserNote(note: Note): Note — push (atau replace jika id sama), return note
- deleteUserNote(id: string): boolean — hapus by id, return true jika ada
- generateSlug(title: string): string — slug url-safe dari title + 4 digit random
- getAllNotes(): Note[] — gabung MOCK_NOTES + getUserNotes(), urut createdAt desc

Type Note: { id, title, body_md, author, createdAt, is_public, _source: 'mock'|'user' }
Semua user notes set _source: 'user'. MOCK_NOTES set _source: 'mock' (tambahkan saat baca).

Tidak ada library eksternal. Pakai try/catch untuk JSON.parse. Export via window.DevNotesStorage.
```

1.3. Review diff, accept.
1.4. Test di DevTools console: `DevNotesStorage.saveUserNote({title:'test', body_md:'hi', author:'me', createdAt: new Date().toISOString(), is_public: true, id: DevNotesStorage.generateSlug('test')})`.
1.5. Verifikasi key `devnotes:notes` muncul di Local Storage. Hapus dulu setelah verifikasi.
1.6. **Commit**: `feat: add localStorage storage layer for notes`.

### 2. Form New Note Page (12') — Mode Composer

2.1. Buka Composer (`Cmd+I` / `Ctrl+I`).
2.2. Prompt:

```
Buat halaman new.html sebagai form editor catatan DevNotes.
Layout mengikuti mockup 11.5 BRD:
- Header dengan tombol "← Batal" (link ke index.html) dan tombol "Simpan" di kanan
- Input title (required, maxlength 120)
- Textarea body_md (maxlength 5000), tinggi 12 baris
- Preview pane di sebelah kanan textarea yang render markdown live (pakai marked via CDN)
- Radio is_public: "🔒 Privat" (default) dan "🌐 Publik"

JS:
- On submit: validasi title non-empty, buat object Note pakai DevNotesStorage.generateSlug
  untuk id, set author='me' (hardcoded Hari 1), createdAt=now, _source='user'.
- Panggil DevNotesStorage.saveUserNote, lalu redirect ke notes/[id].html?id=<slug>.
- Disable tombol Simpan kalau title kosong (gunakan event input).

Jangan ubah file lain. Pakai @file assets/app.js untuk konsistensi style.
```

2.3. Review per-file. Pastikan **tidak ada** package.json baru atau file aneh.
2.4. Accept.
2.5. Test manual: buka `new.html` di browser, isi form, simpan, verifikasi redirect & data di localStorage.
2.6. **Commit**: `feat: add new note editor page (FR-04)`.

### 3. Update Home untuk Gabung User Notes (5') — Mode Cmd/Ctrl+K

3.1. Buka `assets/app.js`, cari fungsi `renderNotes()`.
3.2. Highlight fungsi, `Cmd+K` / `Ctrl+K`:

```
Ubah renderNotes() agar:
- Ambil data dari DevNotesStorage.getAllNotes() (bukan langsung MOCK_NOTES)
- Tambah indikator visual kecil "(draft)" di kartu yang _source='user' dan is_public=false
- Tidak ubah signature fungsi atau struktur HTML lain
```

3.3. Verifikasi: buka home, draft yang baru disimpan harus muncul di paling atas dengan label "(draft)".
3.4. **Commit**: `feat: merge user notes into home feed`.

### 4. Edit & Delete di Detail (12') — Mode Chat + Composer

4.1. Buka Chat (`Cmd+L` / `Ctrl+L`). Tambahkan context: `@file notes/[id].html` + `@file assets/app.js`.
4.2. Prompt:

```
Saya butuh menambah tombol Edit dan Hapus di halaman detail (notes/[id].html),
hanya muncul kalau note._source === 'user'.

- Tombol Edit: link ke new.html?id=<slug>
- Tombol Hapus: confirm() dulu, lalu DevNotesStorage.deleteUserNote, lalu redirect ke index.html

Tunjukkan diff yang dibutuhkan, jangan langsung apply. Saya mau review dulu.
```

4.3. Baca diff yang diusulkan di Chat. Kalau bagus, lanjut ke Composer untuk apply, atau apply manual sebagian dengan `Cmd+K`.
4.4. Sekarang, untuk **prefill form edit**, buka `new.html` dan tambahkan logic via `Cmd+K`:

```
Kalau ada query string ?id=<slug> dan note ditemukan di DevNotesStorage.getUserNotes(),
prefill form dengan field tersebut, ubah judul halaman jadi "Edit Catatan",
dan saat submit lakukan replace (bukan create baru — DevNotesStorage.saveUserNote
sudah handle ini selama id sama).
```

4.5. Test flow lengkap: create → home → klik draft → detail muncul tombol Edit/Hapus → klik Edit → form ter-prefill → ubah → simpan → redirect ke detail dengan data baru.
4.6. Test delete: buat 1 note dummy, hapus, verifikasi hilang dari home & localStorage.
4.7. **Commit**: `feat: add edit and delete from detail page`.

### 5. Verifikasi & Polish (5')

5.1. Test happy path full: home → +New → isi → simpan → home → klik draft → detail → edit → simpan → hapus → home.
5.2. Buka DevTools console, harus **kosong dari error** sepanjang flow.
5.3. Lighthouse cepat (Chrome DevTools → Lighthouse) untuk halaman home, target accessibility ≥ 90 (NFR-05). Catat skor.
5.4. Kalau ada polish kecil (label form, kontras), commit terpisah: `chore: a11y polish`.

### 6. Refleksi (5')

Tulis di `submissions/<nama>/latihan-03-refleksi.md`:

- Rasio waktu prompt : review : manual coding.
- 1 hallucination/bug yang Anda temukan & cara menemukannya.
- 1 hal yang akan dilakukan berbeda kalau diulang.
- Skor Lighthouse accessibility yang Anda dapat.
- 1 bagian kode yang menurut Anda **paling rapuh** dan akan Anda audit ulang di Sesi 5 (Hari 2).

---

## Kriteria Selesai (Rubrik)

| Kriteria                                                       | Bobot | Cukup       | Baik           | Sangat Baik                                |
| -------------------------------------------------------------- | ----- | ----------- | -------------- | ------------------------------------------ |
| Semua acceptance criteria functional terpenuhi                 | 30%   | Create only | Create + edit  | Full CRUD + validasi + a11y                |
| Persistensi localStorage stabil (no data loss saat refresh)    | 15%   | Sebagian    | Stabil         | Stabil + handle JSON.parse error           |
| Commit kecil reviewable                                        | 15%   | 1 commit    | 2–3 commit     | ≥4 commit bermakna dengan ref FR           |
| 4 mode interaksi Cursor terpakai                               | 15%   | 1–2         | 3              | 4 (Tab + K + Chat + Composer)              |
| DevTools console bersih dari error                             | 10%   | ≥3 error    | 1–2 error      | 0 error                                    |
| Refleksi tulisan + skor Lighthouse                             | 15%   | < 3 poin    | 3 poin         | + insight spesifik + skor ≥ 90             |

Lolos: ≥ **70%**.

---

## Tips

- **Mulai kecil**: storage layer → form → integrasi. Jangan langsung Composer-all.
- **Test sesering mungkin di browser**. Reload setelah tiap commit kecil.
- **Pakai exemplar**: `@file assets/app.js` adalah teman terbaik Anda untuk style consistency.
- **Iterasi prompt** kalau diff aneh — jangan tambal manual kecuali kecil.
- **Anggap diri Anda owner data sendiri** — di Hari 2, "owner" akan ditegakkan via Supabase RLS.

---

## Common Issues

| Issue                                          | Solusi                                                                          |
| ---------------------------------------------- | ------------------------------------------------------------------------------- |
| Form submit reload halaman tanpa simpan        | Tambahkan `e.preventDefault()` di handler submit                                |
| localStorage data hilang setelah refresh       | Cek JSON.stringify saat save & JSON.parse saat load; lihat try/catch            |
| Draft muncul dua kali di home                  | Duplikasi MOCK_NOTES vs user notes — pastikan getAllNotes dedupe by id          |
| Markdown preview menampilkan HTML mentah       | `previewEl.innerHTML = marked.parse(value)`, bukan `textContent`                |
| Composer ngubah file di luar scope             | Reset Composer, sebut file tepat + tambahkan "jangan ubah file lain"            |
| Dependency npm muncul (package.json)           | Tolak. Restate: "no build tool, vanilla JS only, marked via CDN"                |
| Kehabisan waktu                                | Drop fitur **edit prefill** lebih dulu (paling tidak kritikal), fokus create + delete |

---

## Demo Peserta (5' di akhir sesi)

2 peserta dipilih share:

- Tunjukkan `git log --oneline` (bukti commit kecil).
- Demo create → edit → delete live.
- Refleksi 1 kalimat tentang hallucination yang ditemukan.
