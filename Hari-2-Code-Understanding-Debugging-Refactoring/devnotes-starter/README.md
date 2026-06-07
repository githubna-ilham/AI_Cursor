# DevNotes Starter

> Codebase awal untuk pelatihan **AI Cursor — Hari 2**. Anda akan memakai project ini sebagai *bahan eksplorasi* di 4 sesi: Code Understanding, Debugging, Refactoring, Testing.

---

## Apa Ini?

**DevNotes** adalah aplikasi catatan teknis sederhana (mirip Notion + GitHub Gist) yang memungkinkan developer:

- Menyimpan catatan teknis (debugging story, decision record, learning log).
- Menandai note `public` atau `private`.
- Browse feed publik dari semua user.

Project ini sudah **berjalan** di lokal Anda begitu di-setup. Pekerjaan Anda di Hari 2 **bukan membangun dari nol**, tapi:

1. **Memahami** codebase ini (Sesi 5).
2. **Debug** bug yang dilaporkan (Sesi 6).
3. **Refactor** bagian yang smell (Sesi 7).
4. **Tulis test** yang selama ini absen (Sesi 8).

Ini mensimulasikan kondisi nyata developer: **join codebase yang sudah ada**, bukan greenfield project.

---

## Stack

- **Next.js 14** (App Router)
- **TypeScript**
- **Supabase** (Postgres + Auth + RLS)
- **Tailwind CSS**
- **Vitest** (siap pakai, tapi belum ada test — itu tugas Sesi 8)

---

## Setup (5 menit)

### 1. Prasyarat

- Node 20 LTS, pnpm 9 (atau npm).
- Akun Supabase aktif (dari pendahuluan pelatihan).

### 2. Install Dependencies

```bash
cd devnotes-starter
pnpm install     # atau: npm install
```

### 3. Setup Supabase Project

1. Login ke <https://supabase.com> → New Project (free tier cukup).
2. Tunggu provisioning (~1 menit).
3. Di Supabase dashboard → **Project Settings → API**:
   - Copy `URL` (terlihat seperti `https://xxx.supabase.co`)
   - Copy `anon public` key

### 4. Konfigurasi Environment

```bash
cp .env.example .env.local
```

Edit `.env.local`:

```
NEXT_PUBLIC_SUPABASE_URL=https://xxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOi...
```

### 5. Run Migration

Di Supabase dashboard → **SQL Editor** → New query → copy-paste seluruh isi `supabase/migrations/0001_init_notes.sql` → Run.

Atau pakai Supabase CLI:

```bash
supabase db push
```

### 6. Jalankan

```bash
pnpm dev    # atau: npm run dev
```

Buka <http://localhost:3000>.

### 7. Smoke Test

- Halaman landing muncul → klik **Sign In**.
- Isi email → cek inbox → klik magic link → ter-redirect ke `/notes`.
- Klik **New Note** → isi title + content → save → muncul di list.
- Buka `/public` → kosong (belum ada yang publish).

Kalau 7 langkah di atas lulus, Anda siap untuk Sesi 5.

---

## Struktur Folder

```
devnotes-starter/
├── src/
│   ├── app/                  # Next.js App Router (page + API)
│   │   ├── api/notes/        # CRUD endpoint
│   │   ├── notes/            # halaman user (protected)
│   │   ├── public/           # feed publik
│   │   └── login/            # auth magic link
│   ├── lib/
│   │   ├── supabase/         # client browser + server
│   │   ├── validate.ts       # validasi input
│   │   ├── response.ts       # helper response JSON
│   │   └── date.ts           # format tanggal
│   └── components/           # UI components
├── supabase/migrations/      # schema + RLS
├── public/
└── package.json
```

> 📖 **Belum tahu mau mulai dari mana?** Itu yang akan diajarkan di **Sesi 5** — cara navigasi codebase asing dengan bantuan AI. Tidak perlu paham dulu sebelum sesi.

---

## Perintah Berguna

```bash
pnpm dev          # development server
pnpm build        # production build
pnpm lint         # ESLint
pnpm test         # Vitest (akan exit 0 karena belum ada test — itu tugas Sesi 8)
```

---

## Troubleshooting

| Masalah | Solusi |
|---------|--------|
| `Error: Invalid API key` | Cek `.env.local` — pastikan key Supabase ter-copy lengkap (tidak terpotong) |
| Magic link tidak masuk inbox | Cek folder spam; pastikan Supabase project URL & key dari project yang sama |
| `/notes` redirect ke `/login` terus | Cookie session belum ter-set; cek SUPABASE_URL match dengan project yang dipakai |
| `relation "notes" does not exist` | Migration belum dijalankan — kembali ke setup langkah 5 |

Kalau stuck > 10 menit di setup, angkat tangan — bukan ide yang baik debug environment di sesi yang bahas codebase.
