# Pendahuluan

Selamat datang di pelatihan **AI Cursor — 3 Hari Fundamental sampai Project End-to-End**. File ini wajib Anda baca lebih dulu sebelum membuka materi Hari 1.

---

## Tentang Materi Ini

Materi **AI Cursor — AI-Powered Coding & Developer Productivity** dirancang untuk mengajarkan cara menggunakan Cursor sebagai pasangan kerja AI di siklus penuh pengembangan perangkat lunak — mulai dari eksplorasi codebase, pemahaman kode, generate fitur, debugging, refactoring, testing, sampai kolaborasi tim lewat Git dan code review. Setelah menyelesaikan semua modul, Anda akan mampu mengintegrasikan AI ke alur kerja harian sebagai developer — mempercepat tugas yang biasanya memakan berjam-jam menjadi hitungan menit, sekaligus membangun dua artefak nyata (website portfolio personal dan aplikasi full-stack DevNotes) yang siap dipakai dan di-deploy.

---

## 1. Pengantar

Pelatihan ini dirancang **berbasis project**. Anda akan membangun **dua artefak nyata** selama 3 hari:

1. **Hari 1**: Website **portfolio personal** Anda sendiri (HTML/CSS/JS vanilla) — siap di-deploy & dipakai apply kerja.
2. **Hari 2–3**: Aplikasi **Laravel + MySQL lokal** — dari query database dengan AI hingga dashboard data yang bisa dipakai.

### Alur 3 Hari

| Hari | Topik utama                                  | Apa yang Anda hasilkan                                                                        |
| ---- | -------------------------------------------- | --------------------------------------------------------------------------------------------- |
| 1    | Fundamental Cursor & AI-Assisted Coding      | **Website portfolio personal** Anda (HTML/CSS/JS) dengan Hero, Skills, Projects, Contact form |
| 2    | Code Understanding, Debugging, Refactoring   | Project Laravel baru: setup Herd, koneksi MySQL, query AI-assisted, eksplorasi & debug data   |
| 3    | Advanced Workflow, Dashboard & Capstone      | Dashboard data berbasis Laravel + MySQL: visualisasi query, refactor, security, presentasi     |

### Studi Kasus

- **Hari 1 — Portfolio Personal**: Hari 1 berfokus pada fundamental Cursor. Anda membangun artefak yang langsung berguna: website portfolio Anda. BRD lengkap di [`Hari-1-Fundamental-DevNotes/portfolio-brd.md`](./Hari-1-Fundamental-DevNotes/portfolio-brd.md).
- **Hari 2 & 3 — Dashboard Laravel**: Aplikasi dashboard data menggunakan Laravel + MySQL lokal via Laravel Herd. AI dipakai untuk menulis, memahami, dan memperbaiki query — hasilnya divisualisasikan sebagai dashboard yang bisa langsung didemonstrasikan.

### Filosofi Pelatihan

- **Project-driven**: setiap latihan menambah artefak nyata ke project Anda, bukan latihan terpisah.
- **Cursor sebagai kolaborator**: AI bukan generator yang Anda terima begitu saja; Anda tetap *reviewer-first*.
- **Belajar dengan tangan**: lebih banyak praktik daripada teori. Materi tipis, latihan tebal.
- **Hasilnya milik Anda**: di akhir pelatihan Anda pulang dengan **portfolio personal** (Hari 1) + **DevNotes full-stack app** (Hari 2-3) di GitHub.

---

## 2. Prasyarat

### Skill yang Diharapkan

Anda **tidak perlu** ahli di semua hal di bawah ini, tapi minimal familiar:

- Salah satu bahasa pemrograman modern (PHP paling membantu, tapi tidak wajib).
- **SQL dasar**: SELECT, WHERE, JOIN, GROUP BY — paham konsep query dan tabel relasional.
- **Git basic**: clone, add, commit, push, branch.
- **Terminal/CLI basic**: navigasi folder, menjalankan perintah.
- **HTML, CSS, JavaScript dasar**: tahu apa itu `<div>`, selektor CSS, event listener.
- **Konsep web**: HTTP request, JSON, query string.

### Yang Akan Anda Pelajari Sambil Jalan

Hal-hal ini boleh **belum** Anda kuasai — pelatihan akan memandu:

- Laravel (MVC, routing, Eloquent, Blade) — diperkenalkan Hari 2 & 3.
- MySQL lokal via Laravel Herd — setup di Hari 2.
- Query analytics & agregasi SQL untuk dashboard — dipraktikkan Hari 2–3.
- Visualisasi data sederhana di Blade/dashboard — Hari 3.

### Perangkat & Akun

| Kategori     | Yang dibutuhkan                                                                          |
| ------------ | ---------------------------------------------------------------------------------------- |
| Laptop       | RAM minimum 8 GB (16 GB direkomendasikan), disk kosong ≥ 10 GB, internet stabil         |
| OS           | macOS, Windows 10/11, atau Linux modern                                                  |
| Akun GitHub  | Aktif, sudah login dari laptop Anda (bisa lewat browser atau GitHub CLI)                 |
| Akun email   | Aktif (untuk login Cursor)                                                               |
| Browser      | Chrome / Edge / Firefox versi terbaru (untuk DevTools & preview dashboard)               |
| Laravel Herd | Diinstall sebelum Hari 2 — sudah termasuk PHP, MySQL, Nginx lokal (gratis)              |

---

## 3. Persiapan Sebelum Hari 1

Lakukan checklist di bawah ini **sebelum** hari pertama dimulai. Estimasi total: 30–60 menit (lebih lama kalau koneksi pelan saat download Cursor).

### 3.1 Install Cursor

1. Buka <https://cursor.com/download>.
2. Download installer sesuai OS Anda.
3. Install seperti aplikasi biasa.
4. Buka Cursor → login dengan email Anda (akan muncul kode verifikasi via email).
5. Detail lengkap & troubleshooting: [`Hari-1-Fundamental-DevNotes/Sesi-02-Getting-Started-Cursor/instalasi-checklist.md`](./Hari-1-Fundamental-DevNotes/Sesi-02-Getting-Started-Cursor/instalasi-checklist.md).

### 3.2 Pahami Plan & Quota Cursor

Cursor membatasi pemakaian model premium per bulan. Untuk pelatihan 3 hari intensif:

- **Free tier** biasanya **habis di pertengahan Hari 1**. Tidak direkomendasikan.
- **Pro Trial 14 hari** gratis — daftar maksimal H-14 sebelum hari pertama supaya trial masih aktif selama pelatihan.
- **Pro berbayar ($20/bulan)** — paling aman kalau Anda berencana lanjut pakai Cursor pasca-pelatihan.

Detail lengkap setiap plan di section "Plan & Quota Awareness" di [`instalasi-checklist.md`](./Hari-1-Fundamental-DevNotes/Sesi-02-Getting-Started-Cursor/instalasi-checklist.md) dan halaman resmi <https://cursor.com/pricing>.

### 3.3 Verifikasi Git

Buka terminal, jalankan:

```bash
git --version              # harus ≥ 2.30
git config --global user.name "Nama Anda"
git config --global user.email "email@anda.com"
git config --global init.defaultBranch main
```

### 3.4 Install Laravel Herd

Laravel Herd adalah environment lokal all-in-one untuk PHP — sudah termasuk PHP, MySQL, Nginx, dan Laravel installer tanpa konfigurasi manual.

1. Buka <https://herd.laravel.com> → download installer sesuai OS Anda.
2. Install dan buka Herd.
3. Verifikasi PHP & MySQL aktif:

```bash
php --version       # harus ≥ 8.2
mysql --version     # harus ada
herd --version      # verifikasi Herd CLI aktif
```

4. Pastikan MySQL service running di Herd dashboard (ikon hijau).

> ℹ️ Laravel Herd gratis untuk tier dasar. MySQL sudah berjalan di port 3306 lokal — tidak perlu setup password awal untuk development.

### 3.5 Siapkan Folder Kerja

Buat folder kosong di laptop Anda untuk project:

```bash
mkdir ~/cursor-workshop
cd ~/cursor-workshop
```

Di Hari 1 Sesi 2 Anda akan `git init` folder `portfolio/` di sini. Di Hari 2 Anda akan membuat project Laravel baru di folder yang sama.

### 3.6 Akses Repo Pelatihan

Repo ini ([github.com/githubna-ilham/AI_Cursor](https://github.com/githubna-ilham/AI_Cursor)) berisi semua materi + brief latihan. Anda boleh:

- **Browse online** di GitHub langsung, atau
- **Clone** ke laptop supaya bisa dibaca offline:

  ```bash
  git clone https://github.com/githubna-ilham/AI_Cursor.git
  ```

Anda **tidak** perlu menulis kode di repo ini — kode aplikasi (portfolio Hari 1, project Laravel Hari 2-3) ada di folder kerja Anda sendiri (langkah 3.5).

### 3.7 Baca BRD

- **Portfolio (Hari 1)** — [`Hari-1-Fundamental-DevNotes/portfolio-brd.md`](./Hari-1-Fundamental-DevNotes/portfolio-brd.md). Baca **Section 3 (Scope), Section 6 (Model Data), Section 9 (Wireframe)** sebelum Sesi 2. Total ~10 menit.

### 3.7 Persiapan Mental

Tiga sikap yang akan membantu Anda menyerap pelatihan ini:

1. **Tolak saran AI dengan berani.** `Esc` adalah skill. Saran yang salah lebih merugikan daripada tidak ada saran.
2. **Commit kecil, sering.** Setiap latihan diakhiri dengan commit bermakna. Mudah revert kalau salah arah.
3. **Tulis catatan Anda sendiri.** Output AI mudah dilupakan kalau Anda tidak ringkas dengan kata-kata sendiri.

---

## 4. Cara Membaca Repo Ini

Urutan rekomendasi pembacaan:

1. `pendahuluan.md` ← Anda sedang di sini.
2. [`project-brd.md`](./project-brd.md) — studi kasus & spek lengkap.
3. [`Hari-1-Fundamental-DevNotes/README.md`](./Hari-1-Fundamental-DevNotes/README.md) — overview Hari 1.
4. Materi & latihan per sesi (`Sesi-XX-*/materi.md` lalu `latihan-XX-*/README.md`).
5. Hari 2, lalu Hari 3 dengan pola yang sama.

Setiap sesi punya dua file utama:

- **`materi.md`** — konsep & teori. Baca **sebelum** latihan.
- **`latihan-XX-*/README.md`** — instruksi hands-on. Kerjakan **setelah** baca materi.

Sumber daya tambahan tersedia di folder [`resources/`](./resources/) (cheatsheet prompting, template `.cursorrules` per stack, checklist security).

---

## 5. Kalau Anda Tertinggal

Pelatihan ini cukup padat. Kalau Anda merasa tertinggal di tengah jalan:

- **Selama latihan**: angkat tangan, tanyakan ke fasilitator. Tetangga seringkali juga bisa membantu.
- **Selesai sesi tapi belum tuntas**: lanjutkan di break / malam hari. Latihan dirancang bisa di-resume kapan saja.
- **Hari berikutnya**: kalau output Hari sebelumnya tidak selesai, fokus pada satu fitur kunci agar bisa lanjut. Boleh diskusi dengan fasilitator pilihan trade-off.

Yang penting: **tidak ada nilai akhir**. Tujuan Anda adalah keluar dari pelatihan dengan dua artefak yang berjalan (portfolio personal + aplikasi DevNotes) + skill baru yang nyata. Bukan medali sempurna di setiap latihan.

---

Selamat belajar. Sampai jumpa di Sesi 1.
