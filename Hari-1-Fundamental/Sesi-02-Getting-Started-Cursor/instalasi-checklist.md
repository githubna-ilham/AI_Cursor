# Instalasi Checklist — Cursor IDE

Gunakan checklist ini **sebelum** Sesi 2 dimulai bila memungkinkan, atau pandu peserta saat segmen instalasi. Tandai ✓ saat selesai.

---

## 0. Prasyarat Umum

- [ ] Laptop nyala, charger terhubung.
- [ ] Koneksi internet stabil (ping ke `cursor.com` < 200ms ideal).
- [ ] Akses ke email kerja (untuk login).
- [ ] Hak admin / sudo di laptop (untuk install aplikasi).
- [ ] Free disk ≥ 5 GB.
- [ ] RAM ≥ 8 GB (16 GB direkomendasikan).

---

## 1. Download

- [ ] Buka <https://cursor.com>.
- [ ] Klik **Download** → pilih installer sesuai OS.
  - macOS: `.dmg` (Apple Silicon **atau** Intel — pilih sesuai chip).
  - Windows: `.exe` installer (User Setup, **tidak perlu admin**).
  - Linux: `.AppImage` atau `.deb`.

---

## 2. Install per OS

### macOS

- [ ] Buka `.dmg`.
- [ ] Drag `Cursor.app` ke folder `Applications`.
- [ ] Buka via Launchpad / Spotlight.
- [ ] (Jika muncul "unidentified developer") System Settings → Privacy & Security → **Open Anyway**.

### Windows

- [ ] Jalankan installer `.exe`.
- [ ] Tick "Add to PATH" & "Create desktop shortcut".
- [ ] Selesai → buka dari Start Menu.

### Linux (Ubuntu/Debian)

- [ ] `.deb`: `sudo dpkg -i cursor_*.deb` → `sudo apt -f install` jika ada dependency error.
- [ ] `.AppImage`: `chmod +x Cursor-*.AppImage && ./Cursor-*.AppImage`.

---

## 3. First Run & Login

- [ ] Buka Cursor.
- [ ] Pilih theme (dark/light).
- [ ] Import VS Code Settings? **Ya** jika sudah pakai VS Code (extension + keybinding ikut).
- [ ] Login → pakai email kerja → verifikasi via browser.
- [ ] Verifikasi nama akun muncul di kiri-bawah (status bar / activity bar).

---

## 4. Verifikasi Versi & Update

- [ ] Buka **Help → About** (atau Cmd/Ctrl+Shift+P → "About").
- [ ] Catat versi (mis. `Cursor 0.4x.x`).
- [ ] Cek update: **Help → Check for Updates**. Pastikan sudah versi terbaru sebelum pelatihan.

---

## 5. Install Git & Tools Pendukung

### Git (wajib)
- [ ] macOS: `git --version` (akan trigger install Xcode CLT) atau pakai Homebrew `brew install git`.
- [ ] Windows: download dari <https://git-scm.com>.
- [ ] Linux: `sudo apt install git`.
- [ ] Konfigurasi: `git config --global user.name "<nama>"` & `user.email`.

### Stack-specific runtime
<!-- STACK-PLACEHOLDER: isi sesuai hasil pretest -->

- [ ] Node.js LTS + npm/pnpm (untuk peserta FE/Full-Stack/Node BE).
- [ ] Python 3.11+ + pip + venv (untuk peserta Python/Data).
- [ ] Go 1.22+ (untuk peserta Go).
- [ ] JDK 21 + Maven/Gradle (untuk peserta Java).
- [ ] Docker Desktop / colima (untuk peserta DevOps).

---

## 6. Setup Model Preferensi

- [ ] Buka **Cursor Settings** (gear icon → Settings → Models).
- [ ] Aktifkan minimal 2 model: **Auto** + 1 model spesifik (Claude / GPT / Gemini terbaru).
- [ ] Set default = **Auto** (rekomendasi pemula).
- [ ] Verifikasi quota / billing (free tier vs paid).

---

## 7. Privacy & Security

- [ ] Settings → **General → Privacy Mode** → **Enabled** (jika company policy).
- [ ] Buat file `.cursorignore` di root project untuk file sensitif (mirip `.gitignore`). Contoh:

```
.env
.env.*
*.pem
secrets/
```

- [ ] Verifikasi proxy corporate (kalau ada): Settings → HTTP → set proxy.

---

## 8. Smoke Test (5 menit)

- [ ] Buka folder kosong baru.
- [ ] Buat file `hello.<ext>`. <!-- STACK-PLACEHOLDER -->
- [ ] Ketik komentar `// fungsi sapa nama` lalu Enter — Cursor **Tab** harusnya menyarankan fungsi.
- [ ] Highlight fungsi → `Cmd/Ctrl+K` → ketik *"tambahkan input validation"* → terima diff.
- [ ] `Cmd/Ctrl+L` buka Chat → ketik *"jelaskan kode ini"* → cek respons muncul.
- [ ] `Cmd/Ctrl+I` buka Composer → ketik *"buat file README.md sederhana"* → cek file ter-create.

Bila semua ✓ → peserta siap masuk Lab 01.

---

## 9. Troubleshooting Cepat

| Gejala | Solusi |
|--------|--------|
| "Cannot connect to model" | Cek proxy, login ulang, ganti model |
| Indexing stuck | Tutup-buka folder; cek `.cursorignore` terlalu permisif |
| Extension VS Code tidak ada | Install ulang via Extensions panel; cari di OpenVSX |
| Tab tidak muncul | Pastikan auto-save aktif, cek Settings → Features → Cursor Tab |
| Login terus loop | Hapus cache: keluar app → hapus `~/.cursor` (backup dulu) |

---

## 10. Tanda Tangan Peserta

- [ ] Peserta verifikasi semua poin 0–8 ✓.
- [ ] Nama: ____________________
- [ ] Tanggal: ____________________
