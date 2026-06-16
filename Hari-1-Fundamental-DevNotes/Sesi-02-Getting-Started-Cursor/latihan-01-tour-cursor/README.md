# Latihan 01 — Build Portfolio Website dengan Cursor

**Durasi**: ± 3–4 jam efektif
**Output**: Website portfolio personal satu halaman (HTML/CSS/JS vanilla) yang bisa langsung dibuka di browser.

---

## Struktur File Akhir

```
portfolio/
├── index.html
├── assets/
│   ├── styles.css
│   ├── app.js
│   └── profile.jpg
```

---

## Tahap 1 — Setup Folder & Buka di Cursor (10')

Buat folder project dan buka di Cursor:

```bash
mkdir portfolio && cd portfolio
git init
```

Buka Cursor → **File → Open Folder** → pilih folder `portfolio/`.

Buat tiga file kosong via File Explorer Cursor (klik kanan → New File):

```
index.html
assets/styles.css
assets/app.js
```

---

## Tahap 2 — Generate Struktur HTML (15')

Buka `index.html`. Ketik `<!DOCTYPE html>` lalu tekan `Tab` — Cursor akan menyarankan boilerplate HTML5. Terima sarannya.

Tambahkan link stylesheet dan script sebelum `</body>`:

```html
<link rel="stylesheet" href="assets/styles.css">
<script src="assets/app.js"></script>
```

Buka panel Agent (`Cmd+I` / `Ctrl+I`). Prompt:

```
Lengkapi index.html dengan struktur portfolio satu halaman:
- <header> dengan <nav> berisi link: Home, About, Skills, Projects, Contact
- <section id="hero"> dengan foto profil, nama, tagline, dan 2 tombol CTA
- <section id="about"> dengan bio singkat 2-3 paragraf
- <section id="skills"> dengan grid skill (minimal 6 item)
- <section id="projects"> dengan 3 kartu project (judul, deskripsi, tags, link)
- <section id="contact"> dengan form sederhana (nama, email, pesan, tombol kirim)
- <footer> dengan copyright dan link GitHub/LinkedIn

Stack: HTML5 vanilla. Tidak ada framework, tidak ada npm.
Jangan ubah <link> dan <script> yang sudah ada.
```

Review setiap perubahan sebelum accept. Buka `index.html` di browser — semua section harus tampil.

---

## Tahap 3 — Styling dengan CSS (30')

Buka `assets/styles.css`. Buka panel Agent → prompt:

```
Buatkan styling untuk portfolio di assets/styles.css:
- CSS variables di :root: warna (primary, background, text, muted), font, spacing
- Palette: dark modern (background gelap, accent biru atau ungu)
- body: background, color, font-family, margin 0
- nav: sticky di atas, flex row, link tanpa underline berwarna primary
- Tiap section: min-height 80vh, padding atas-bawah yang nyaman
- Hero: flex row (foto kiri, teks kanan), foto bulat 180px
- Skills: grid auto-fill, tiap item punya background subtle dan border-radius
- Projects: grid 3 kolom, kartu dengan shadow ringan dan hover effect
- Contact form: field full-width, tombol submit berwarna primary
- footer: text-align center, warna muted
- Responsive mobile (max-width 768px): layout jadi satu kolom, nav jadi vertikal
```

Refresh browser — halaman harus sudah berwarna dan tersusun rapi.

---

## Tahap 4 — Personalisasi (30')

Isi data Anda sendiri langsung di `index.html`:

1. **Foto profil** — ganti `src` di `<img>` dengan `assets/profile.jpg` (salin foto Anda ke folder assets), atau pakai placeholder:
   ```html
   <img src="https://i.pravatar.cc/180" alt="Foto profil">
   ```

2. **Nama & tagline** — ganti teks di `<h1>` dan paragraf headline.

3. **Bio** — isi section About dengan cerita singkat Anda (pengalaman, minat, tujuan).

4. **Skills** — sesuaikan daftar skill dengan yang Anda kuasai.

5. **Projects** — isi 3 project nyata (atau project latihan yang pernah Anda kerjakan): judul, deskripsi 1–2 kalimat, dan link repo GitHub.

6. **Kontak** — update link GitHub dan LinkedIn di footer.

Kalau ada bagian HTML yang ingin diubah tampilan atau teksnya, highlight lalu `Cmd+K` / `Ctrl+K` dan ketik instruksi langsung.

---

## Tahap 5 — Smooth Scroll & Interaksi Ringan (20')

Buka `assets/app.js`. Gunakan `Cmd+K` / `Ctrl+K` untuk generate:

```
Tambahkan ke app.js:
1. Smooth scroll saat klik link nav (gunakan scrollIntoView atau scroll-behavior)
2. Highlight link nav yang aktif saat halaman di-scroll (IntersectionObserver)
3. Pada form contact: saat submit, tampilkan alert sederhana "Pesan terkirim!" dan reset form
   (tidak perlu backend — cukup simulasi)
```

Test: klik link nav → halaman scroll halus ke section yang sesuai.

---

## Tahap 6 — Cek Final & Push ke GitHub (15')

Buka `index.html` di browser dan cek:

- [ ] Semua section tampil dengan benar
- [ ] Foto profil muncul
- [ ] Nav link scroll ke section yang tepat
- [ ] Form bisa di-submit dan muncul pesan konfirmasi
- [ ] Tampilan rapi di layar kecil (DevTools → Toggle device toolbar)

Commit dan push:

```bash
git add .
git commit -m "feat: portfolio website selesai"
git remote add origin https://github.com/<username>/portfolio.git
git push -u origin main
```

---

## Tips

- **Baca diff sebelum accept.** Agent bisa mengubah lebih dari yang Anda minta.
- **Pakai `Esc` kalau tidak suka saran AI.** Lalu tulis ulang prompt yang lebih spesifik.
- **Data Anda sendiri > placeholder.** Portfolio ini lebih berguna kalau diisi data nyata.
- **Kalau ada bagian yang tidak sesuai selera**, highlight di editor → `Cmd+K` → instruksikan perubahannya.

---

## Common Issues

| Issue | Solusi |
|---|---|
| Halaman blank putih | DevTools console → biasanya path `assets/styles.css` salah |
| Agent bikin file baru yang tidak diminta | Tolak perubahan itu, tambahkan "jangan buat file baru" di prompt |
| Tab tidak muncul | Settings → Features → Cursor Tab → pastikan aktif |
| Foto tidak muncul | Pastikan file `profile.jpg` ada di folder `assets/` dan nama file cocok persis |
| Form submit reload halaman | Tambahkan `e.preventDefault()` di event listener submit |
