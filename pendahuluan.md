# Pendahuluan

Selamat datang di pelatihan **AI Cursor — 3 Hari Fundamental sampai Project End-to-End**. File ini wajib Anda baca lebih dulu sebelum membuka materi Hari 1.

---

## 1. Pengantar

Pelatihan ini dirancang sebagai **satu perjalanan project**. Selama 3 hari Anda akan membangun satu aplikasi nyata bernama **DevNotes** — catatan pembelajaran teknis untuk developer — sambil mempelajari fundamental sampai praktik lanjutan menggunakan Cursor.

### Alur 3 Hari

| Hari | Topik utama                                  | Apa yang Anda hasilkan                                                              |
| ---- | -------------------------------------------- | ----------------------------------------------------------------------------------- |
| 1    | Fundamental Cursor & AI-Assisted Coding      | Web statis DevNotes (HTML/CSS/JS) dengan feed, detail, form, persistensi `localStorage` |
| 2    | Code Understanding, Debugging, Refactoring   | Migrasi ke Next.js + Supabase + Vercel; BE punya API, auth, RLS                     |
| 3    | Advanced Workflow, Security, Capstone        | FE Next.js konsumsi BE, deploy final, audit security & performance, demo end-to-end |

### Studi Kasus: DevNotes

Aplikasi yang Anda bangun adalah **DevNotes** — tempat developer mencatat pembelajaran teknis (debugging story, decision record, learning log) dan bisa membagikannya secara publik atau menjaganya privat.

Detail bisnis & teknis lengkap (Functional Requirements, model data, mockup UI, process flow) ada di [`project-brd.md`](./project-brd.md). **Minimal baca Section 1 (Latar Belakang), Section 4 (Ruang Lingkup), dan Section 11 (Mockup)** sebelum mulai Hari 1.

### Filosofi Pelatihan

- **Project-driven**: setiap latihan menambah artefak nyata ke project Anda, bukan latihan terpisah.
- **Cursor sebagai kolaborator**: AI bukan generator yang Anda terima begitu saja; Anda tetap *reviewer-first*.
- **Belajar dengan tangan**: lebih banyak praktik daripada teori. Materi tipis, latihan tebal.
- **Hasilnya milik Anda**: di akhir Hari 3, repo `devnotes/` di GitHub Anda berisi aplikasi yang bisa Anda demo, lanjutkan, atau adaptasi untuk pekerjaan.

---

## 2. Prasyarat

### Skill yang Diharapkan

Anda **tidak perlu** ahli di semua hal di bawah ini, tapi minimal familiar:

- Salah satu bahasa pemrograman modern (JavaScript/TypeScript paling membantu, tapi tidak wajib).
- **Git basic**: clone, add, commit, push, branch.
- **Terminal/CLI basic**: navigasi folder, menjalankan perintah.
- **HTML, CSS, JavaScript dasar**: tahu apa itu `<div>`, selektor CSS, event listener.
- **Konsep web**: HTTP request, JSON, query string.

### Yang Akan Anda Pelajari Sambil Jalan

Hal-hal ini boleh **belum** Anda kuasai — pelatihan akan memandu:

- Next.js (App Router) — diperkenalkan Hari 2 Sesi 7.
- Supabase (Postgres, RLS, Auth) — diperkenalkan Hari 2 Sesi 8.
- Vercel deployment — dipraktikkan Hari 3 Sesi 9.
- Markdown rendering, ISR/SSR, CI/CD dasar.

### Perangkat & Akun

| Kategori    | Yang dibutuhkan                                                                                       |
| ----------- | ----------------------------------------------------------------------------------------------------- |
| Laptop      | RAM minimum 8 GB, disk kosong ≥ 5 GB, internet stabil                                                 |
| OS          | macOS, Windows 10/11, atau Linux modern                                                               |
| Akun GitHub | Aktif, sudah login dari laptop Anda (bisa lewat browser atau GitHub CLI)                              |
| Akun email  | Aktif (untuk login Cursor & Supabase magic link)                                                      |
| Akun Vercel | Dibuat di Hari 3 (gratis, login pakai GitHub)                                                         |
| Akun Supabase | Dibuat di Hari 2 (gratis, login pakai GitHub atau email)                                            |
| Browser     | Chrome / Edge / Firefox versi terbaru (untuk DevTools & Lighthouse)                                   |

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

### 3.4 Siapkan Folder Kerja

Buat folder kosong di laptop Anda untuk project:

```bash
mkdir ~/devnotes-workshop
cd ~/devnotes-workshop
```

Di Hari 1 Sesi 2 Anda akan `git init` di sini.

### 3.5 Akses Repo Pelatihan

Repo ini ([github.com/githubna-ilham/AI_Cursor](https://github.com/githubna-ilham/AI_Cursor)) berisi semua materi + brief latihan. Anda boleh:

- **Browse online** di GitHub langsung, atau
- **Clone** ke laptop supaya bisa dibaca offline:

  ```bash
  git clone https://github.com/githubna-ilham/AI_Cursor.git
  ```

Anda **tidak** perlu menulis kode di repo ini — kode aplikasi DevNotes ada di folder kerja Anda sendiri (langkah 3.4).

### 3.6 Baca BRD

Buka [`project-brd.md`](./project-brd.md). Minimal pahami:

- **Section 1** — Latar Belakang DevNotes (kenapa aplikasi ini ada).
- **Section 4** — Ruang Lingkup (apa yang akan & tidak akan dibangun).
- **Section 11** — Mockup (tampilan setiap halaman).

Total waktu baca ~15 menit.

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

Yang penting: **tidak ada nilai akhir**. Tujuan Anda adalah keluar dari pelatihan dengan satu aplikasi DevNotes yang berjalan + skill baru yang nyata. Bukan medali sempurna di setiap latihan.

---

Selamat belajar. Sampai jumpa di Sesi 1.
