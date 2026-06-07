# Latihan 03 — Build Feature: Contact Form + Polish Portfolio

> 🗺️ **Tahap 7–10 dari 10** di [Perjalanan Project Hari 1](../../perjalanan-project.md)
> Sebelumnya: Tahap 3–6 (3 section terisi + modal interaktif) di Sesi 3 | Setelah ini: Akhir Hari 1 — portfolio siap di-deploy & dipakai

**Durasi**: 75 menit
**Tipe**: Hands-on individual (boleh diskusi tetangga)
**Output**: Section Contact dengan form + validasi + submit ke `localStorage`, navigation sticky responsive, polish & Lighthouse audit. Minimal 4 mode interaksi Cursor terpakai dan 4 commit kecil bermakna.

---

## Konteks BRD

Latihan ini menyelesaikan **FR-02, FR-04, FR-05, FR-06, FR-07** + **NFR-02 accessibility**. Portfolio Anda akan siap di-share di akhir tahap.

Mengacu wireframe **Section 9** (form Contact, toast sukses) dan model data **Section 6** (schema `message`) di [`/Hari-1-Fundamental-DevNotes/portfolio-brd.md`](../../portfolio-brd.md).

---

## Tujuan

Peserta menyelesaikan portfolio personal end-to-end dengan praktik commit kecil, review diff, dan verifikasi manual di browser. Di akhir, portfolio bisa dibuka di laptop sendiri, di-share via GitHub Pages / Vercel / Netlify (opsional), dan layak ditampilkan di CV / LinkedIn.

---

## User Story

> **Sebagai** pengunjung portfolio, **saya ingin** mengirim pesan langsung dari website tanpa harus pindah ke email, **agar** saya bisa menghubungi pemilik portfolio dengan cepat.

> **Sebagai** pemilik portfolio (Anda), **saya ingin** website tampil rapi di mobile maupun desktop dan lulus standar accessibility, **agar** portfolio saya kredibel dipakai apply kerja.

### Acceptance Criteria

- [ ] **Tahap 7**: Form Contact (`<form id="contact-form">`) dengan field nama, email, pesan. Validasi inline aktif sebelum submit (nama ≥ 2 char, email format valid, pesan ≥ 10 char). Error muncul di bawah field terkait.
- [ ] **Tahap 8**: Submit form → handler JS simpan ke `localStorage` (key: `portfolio:messages`) dengan schema `{ id, name, email, message, receivedAt }`. Tampil toast "Pesan terkirim, terima kasih!" auto-hide 3 detik. Form reset.
- [ ] **Tahap 9**: Nav sticky di top saat scroll. Active section ter-highlight. Mobile (≤ 768px): nav berubah jadi hamburger menu dengan animasi buka-tutup.
- [ ] **Tahap 10**: Run Lighthouse di Chrome DevTools. Skor minimum: Performance ≥ 85, Accessibility ≥ 90, Best Practices ≥ 90. Fix masalah yang muncul.
- [ ] Tidak ada error di DevTools console pada flow happy path.

---

## Prasyarat

- Lulus Latihan 01 & 02: portfolio sudah punya skeleton + 3 section terisi (Hero, Skills, Projects) + modal `<dialog>` untuk project detail. Section Contact masih kosong — itulah entry point Tahap 7.
- File yang akan dimodifikasi di latihan ini sudah ada: `index.html`, `assets/styles.css`, `assets/app.js`, `assets/data.js` (dari latihan-02 Tahap 5).
- Git config siap untuk commit.
- Browser dengan DevTools (Chrome direkomendasikan untuk Lighthouse).

---

## Stack & Starter

- Stack: HTML + CSS + JavaScript vanilla (tidak ada framework, tidak ada build tool).
- Starter: repo `portfolio/` Anda sendiri dari Sesi 2 & 3.
- Exemplar `@-mention`: `assets/app.js` (untuk style consistency), `index.html` (untuk struktur).

---

## Langkah

### 0. Persiapan (3')

0.1. Buat branch baru: `git checkout -b feat/contact-and-polish`.

0.2. Pastikan portfolio masih jalan: buka `index.html`, scroll dari Hero ke Projects.

0.3. Buka DevTools → Application → Local Storage. Pastikan key `portfolio:messages` belum ada (atau kosongkan).

### Tahap 7. Contact Form + Validasi (15') — Mode Agent

7.1. Buka panel Agent (`Cmd+I` / `Ctrl+I`).
7.2. Prompt:

```
Isi <section id="contact"> di index.html dengan form Contact:
- 3 field: name (input text), email (input email), message (textarea 5 baris)
- Tiap field punya <label> dan attribute required/minlength/maxlength
- Tombol submit "Kirim Pesan"
- Validasi inline JavaScript (di assets/app.js):
  - name: minimal 2 karakter
  - email: regex format valid
  - message: minimal 10 karakter
- Error message muncul di bawah tiap field saat blur kalau invalid
- Tombol submit disabled sampai semua field valid

Constraints:
- Pakai CSS variables yang sudah ada untuk warna error (--color-error, tambahkan kalau belum ada)
- Tidak pakai library validation
- @file index.html dan @file assets/app.js sebagai context

Jangan submit handler dulu — itu Tahap 8.
```

7.3. Review per-file. Test manual di browser: isi form invalid → error muncul, isi valid → tombol enabled.

7.4. **Commit**: `feat: add contact form with inline validation (Tahap 7)`.

### Tahap 8. Submit ke localStorage + Toast (15') — Mode Cmd/Ctrl+K

8.1. Buka `assets/app.js`, cari area dekat fungsi validasi form.

8.2. Highlight area, tekan `Cmd+K`:

```
Tambah submit handler untuk #contact-form:
- preventDefault, kumpulkan { name, email, message } dari form
- Generate id: `msg-${Date.now()}`, set receivedAt: new Date().toISOString()
- Baca array existing dari localStorage key 'portfolio:messages' (default [])
- Push message baru, save kembali ke localStorage (JSON.stringify)
- Tampilkan toast: buat <div> sementara dengan class .toast, isi "Pesan terkirim, terima kasih!",
  append ke body, auto-remove setelah 3 detik dengan transisi fade-out
- Reset form setelah sukses

Constraint: pakai try/catch untuk JSON operations, error → console.error + toast error.
```

8.3. Test: submit form valid → cek DevTools → Local Storage → `portfolio:messages` muncul.

8.4. Buat CSS untuk `.toast` di styles.css (fixed bottom-right, padding, shadow, transisi). Bisa pakai Cmd+K juga.

8.5. **Commit**: `feat: submit contact form to localStorage with toast (Tahap 8)`.

### Tahap 9. Nav Sticky + Responsive (15') — Mode Agent

9.1. Buka panel Agent.

9.2. Prompt:

```
Tambah perilaku navigation di portfolio:
1. <header> dengan nav jadi position: sticky, top: 0, dengan backdrop-filter blur ringan
2. Saat scroll, link nav yang sesuai dengan section yang sedang terlihat ditandai
   .active (highlight underline atau warna). Gunakan IntersectionObserver, jangan
   scroll event listener.
3. Klik link nav → smooth scroll ke section (gunakan smoothScrollTo dari Tahap 2
   kalau sudah ada; kalau belum, pakai scrollIntoView({ behavior: 'smooth' })).
4. Mobile (max-width 768px): nav berubah jadi hamburger:
   - Tombol hamburger icon di kanan
   - Klik → drawer slide dari kanan dengan link vertikal
   - Klik link → drawer close + scroll ke section
   - Klik backdrop atau Esc → drawer close

@file index.html, @file assets/styles.css, @file assets/app.js sebagai context.
List dulu file yang akan diubah sebelum apply.
```

9.3. Test di DevTools responsive mode: desktop OK, lalu ganti ke iPhone 14 — hamburger muncul, drawer jalan.

9.4. **Commit**: `feat: add sticky nav + mobile hamburger (Tahap 9)`.

### Tahap 10. Polish + Lighthouse Audit (15') — Mode Chat + Cmd+K

10.1. Buka Chrome DevTools → tab **Lighthouse** → pilih kategori Performance + Accessibility + Best Practices → Generate report (desktop).

10.2. Catat skor awal.

10.3. Untuk tiap kategori dengan skor < target:
   - Buka Chat, paste daftar isu yang muncul.
   - Tanya: *"Bantu saya fix 3 isu accessibility prioritas teratas berikut: [paste]"*.
   - Apply fix lewat Cmd+K per file (alt text, label, kontras, focus visible, dll).

10.4. (Opsional) Tambah dark mode toggle: tombol di nav yang toggle class `.dark` di `<body>`, simpan preferensi di localStorage `portfolio:theme`.

10.5. Run Lighthouse ulang. Pastikan target tercapai.

10.6. **Commit**: `chore: polish + lighthouse fixes (Tahap 10)` dan kalau ada dark mode: `feat: dark mode toggle`.

### 11. Refleksi (5')

Tulis di `submissions/<nama>/latihan-03-refleksi.md`:

- Rasio waktu prompt : review : manual coding.
- 1 hallucination/bug yang Anda temukan & cara menemukannya.
- 1 hal yang akan dilakukan berbeda kalau diulang.
- Skor Lighthouse final yang Anda dapat.
- 1 bagian portfolio yang paling Anda banggakan.

---

## Tips

- **Mulai kecil**: form → validasi → submit → toast. Jangan kerjakan semua sekaligus.
- **Test sesering mungkin di browser**. Reload setelah tiap commit kecil.
- **Pakai DevTools responsive mode** sejak Tahap 9 — jangan tunggu Tahap 10 baru cek mobile.
- **Iterasi prompt** kalau diff aneh — jangan tambal manual kecuali kecil.
- **Lighthouse desktop ≠ mobile**. Latihan ini target desktop dulu; mobile lighthouse boleh menyusul.

---

## (Opsional) Deploy ke GitHub Pages

Kalau waktu masih ada di akhir:

```bash
# 1. Push ke GitHub
git remote add origin https://github.com/<username>/portfolio.git
git push -u origin main

# 2. GitHub: Settings → Pages → Source = main branch / root → Save
# 3. Tunggu ~1 menit, akses di https://<username>.github.io/portfolio/
```

Atau via Netlify / Vercel (gratis, drag-drop folder).

---

## Common Issues

| Issue                                          | Solusi                                                                          |
| ---------------------------------------------- | ------------------------------------------------------------------------------- |
| Form submit reload halaman tanpa simpan        | Tambahkan `e.preventDefault()` di handler submit                                |
| localStorage data hilang setelah refresh       | Cek JSON.stringify saat save & JSON.parse saat load; lihat try/catch            |
| Toast tidak hilang                             | Cek `setTimeout` di handler; pastikan element ter-remove                        |
| Hamburger menu tidak buka di mobile            | Cek media query CSS; cek event listener; cek z-index drawer                    |
| Lighthouse A11y < 90                           | Periksa: alt text image, label form, kontras (cek di Lighthouse details), focus indicator visible |
| Lighthouse Performance < 85                    | Image terlalu besar — compress dengan TinyPNG; preload font; minify CSS         |
| Agent ngubah file di luar scope                | Reset Agent, sebut file tepat + "jangan ubah file lain"                         |
| Dependency npm muncul (package.json)           | Tolak. Restate: "no build tool, vanilla JS only"                                |

---

## Demo Peserta (5' di akhir sesi)

2 peserta dipilih share:

- Tunjukkan `git log --oneline` (bukti commit kecil).
- Demo portfolio live: scroll dari Hero ke Contact → submit form → toast → cek localStorage.
- Tunjukkan Lighthouse score.
- 1 kalimat refleksi tentang prompt yang paling powerful.
