# Starter `devnotes-starter` — Spec Fasilitator

> ⚠️ **JANGAN dishare ke peserta.** File ini berisi daftar bug & code smell yang sengaja disisipkan, kunci jawaban untuk Sesi 6 & 7.

---

## 1. Tujuan & Filosofi

Starter ini adalah **satu codebase** yang dipakai di **4 sesi Hari 2**, dengan "lensa berbeda" tiap sesi:

| Sesi | Lensa | Output peserta |
|------|-------|----------------|
| **5 — Code Understanding** | "Saya baru join project ini" | Dokumentasi arsitektur + ERD + flow diagram |
| **6 — Debugging** | "Ada 4 bug, temukan dan fix" | Bug report + fix commit + characterization test |
| **7 — Refactoring** | "Code ini smell, tapi behaviour benar" | Refactor commit + before/after metric |
| **8 — Testing** | "Project ini tidak punya test sama sekali" | Suite test minimum (unit + integration) |

**Prinsip**: starter adalah **mini DevNotes BE** (sesuai `project-brd.md`), bukan fitur lengkap. Cukup untuk eksplorasi 4 sesi, tidak boleh terlalu besar (peserta nyasar di Sesi 5).

---

## 2. Stack & Versi (lock)

```
- Next.js 14.x (App Router)
- React 18.x
- TypeScript 5.x
- Supabase JS Client 2.x (auth + Postgres)
- Tailwind CSS 3.x
- Node 20 LTS
- pnpm 9.x (atau npm; sebut keduanya di README peserta)
```

Lock di `package.json` (pakai `~` bukan `^`) supaya 6 bulan ke depan tetap behavior sama.

---

## 3. Fitur (Minimum Viable Project)

### 3.1 Auth
- Magic link via Supabase Auth.
- Sign in dengan email → email berisi link → redirect ke `/notes`.
- Protected routes: `/notes/*`, semua `/api/notes/*` kecuali `/api/notes/public`.

### 3.2 CRUD Notes
- `GET /api/notes` — list note milik user (auth required)
- `GET /api/notes/[id]` — detail note
- `POST /api/notes` — create
- `PATCH /api/notes/[id]` — update
- `DELETE /api/notes/[id]` — delete
- `GET /api/notes/public` — feed note yang `is_public = true` (no auth)

### 3.3 UI Pages
- `/` — landing (hero + link ke `/login`)
- `/login` — magic link form
- `/notes` — list user (server component, paginated)
- `/notes/new` — create form (client component)
- `/notes/[id]` — detail + edit/delete
- `/public` — public feed

### 3.4 Database
- 1 tabel: `notes`
- 1 storage: tidak ada (text-only)

---

## 4. Database Schema + RLS

```sql
-- Table
create table notes (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null check (char_length(title) between 1 and 200),
  content text not null default '',
  tags text[] default '{}',
  is_public boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index notes_user_idx on notes(user_id);
create index notes_public_idx on notes(is_public) where is_public = true;

-- RLS
alter table notes enable row level security;

create policy "users read own notes"
  on notes for select
  using (auth.uid() = user_id);

create policy "users read public notes"
  on notes for select
  using (is_public = true);

create policy "users insert own notes"
  on notes for insert
  with check (auth.uid() = user_id);

create policy "users update own notes"
  on notes for update
  using (auth.uid() = user_id);

create policy "users delete own notes"
  on notes for delete
  using (auth.uid() = user_id);

-- Trigger updated_at
create function set_updated_at() returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger notes_updated_at
  before update on notes
  for each row execute function set_updated_at();
```

Migration file: `supabase/migrations/0001_init_notes.sql`.

---

## 5. Struktur Folder

```
devnotes-starter/
├── README.md                     # untuk peserta (cara run)
├── SPEC-FASILITATOR.md           # file ini (JANGAN dishare)
├── package.json                  # versi locked
├── tsconfig.json
├── next.config.js
├── tailwind.config.ts
├── .env.example                  # template env (NEXT_PUBLIC_SUPABASE_URL, anon key)
├── .gitignore                    # standar Next + .env.local
├── supabase/
│   └── migrations/
│       └── 0001_init_notes.sql
├── src/
│   ├── app/
│   │   ├── layout.tsx
│   │   ├── page.tsx              # landing
│   │   ├── login/page.tsx
│   │   ├── notes/
│   │   │   ├── page.tsx          # list (server)
│   │   │   ├── new/page.tsx      # create (client)
│   │   │   └── [id]/page.tsx     # detail (server + client edit)
│   │   ├── public/page.tsx
│   │   └── api/
│   │       └── notes/
│   │           ├── route.ts                  # GET, POST
│   │           ├── [id]/route.ts             # GET, PATCH, DELETE
│   │           └── public/route.ts           # GET public
│   ├── lib/
│   │   ├── supabase/
│   │   │   ├── client.ts         # browser client
│   │   │   └── server.ts         # server client
│   │   ├── validate.ts           # validasi note input
│   │   ├── response.ts           # helper response
│   │   └── date.ts               # helper format tanggal (bug timezone ada di sini)
│   └── components/
│       ├── NoteCard.tsx
│       ├── NoteForm.tsx
│       └── TagPill.tsx
└── public/
    └── favicon.ico
```

---

## 6. 🐛 SEEDED BUGS (Sesi 6 Debugging)

> **Hidden dari peserta.** Hint untuk fasilitator: tiap bug ada di file & line yang jelas, bisa direproduksi dengan langkah konkret.

### Bug-1: Timezone — `created_at` ter-render dengan offset salah
- **File**: `src/lib/date.ts`
- **Sebab**: `formatDate(iso)` pakai `new Date(iso).toLocaleString()` tanpa `timeZone` option → ikut timezone browser, padahal disimpan UTC. Lebih parah lagi, ada hardcode `+ 7 * 3600 * 1000` (asumsi user di WIB) yang membuat user di luar WIB lihat waktu offset ganda.
- **Reproduksi**: ubah system timezone laptop ke "Europe/London" → buka `/notes` → waktu di card "ngacaur" (+7h dari yang diharapkan).
- **Fix yang diharapkan**: hapus hardcode offset; biarkan `Intl.DateTimeFormat` handle timezone, atau pakai utility yang explicit.

### Bug-2: RLS bocor — endpoint `/api/notes/[id]` lupa cek ownership
- **File**: `src/app/api/notes/[id]/route.ts`
- **Sebab**: handler GET pakai `supabase.from('notes').select().eq('id', id).single()` — RLS policy memang membatasi, tapi handler tidak validasi user. Bug **manifest** karena ada policy `"users read public notes"` yang membuat note PRIVATE bisa di-fetch by ID kalau user tahu UUID-nya (oleh user lain).
- Plus: handler `PATCH` tidak validasi `user_id` di body → user A bisa kirim `user_id: <userB>` (walau RLS akan block, tetap error 500 alih-alih 400).
- **Reproduksi**: login sebagai user A, buat note privat, copy ID. Logout, login user B, `curl /api/notes/<id>` → masih dapat 200 dengan content.
- **Fix yang diharapkan**: cek `note.user_id === session.user.id` di handler GET, atau RLS policy yang lebih ketat (no public read jika tidak punya `is_public`).

### Bug-3: Race condition di toggle is_public
- **File**: `src/app/notes/[id]/page.tsx` (client component edit)
- **Sebab**: button "Make Public" memanggil 2 request berurutan: `PATCH /api/notes/[id]` lalu re-fetch. Kalau user klik 2x cepat, dua request `PATCH` race, response kedua di-`setState` duluan → UI tampil status lama padahal DB sudah berubah lagi.
- **Reproduksi**: klik toggle 2x dalam <500ms → tab DB di Supabase Studio dan UI mismatch.
- **Fix yang diharapkan**: disable button selama in-flight, atau pakai optimistic update dengan abort controller.

### Bug-4: Memory leak — event listener tidak di-clean
- **File**: `src/components/NoteForm.tsx`
- **Sebab**: `useEffect` add `window.addEventListener('beforeunload', ...)` tanpa return cleanup. Setelah navigasi antar `/notes/new` → `/notes` → `/notes/new` beberapa kali, listener menumpuk.
- **Reproduksi**: buka DevTools Memory → Heap snapshot → navigate 10x → snapshot ulang → listener count naik.
- **Fix yang diharapkan**: return cleanup function di `useEffect`.

---

## 7. 🧹 SEEDED CODE SMELLS (Sesi 7 Refactoring)

> **Hidden dari peserta.** Behavior benar, tapi struktur jelek.

### Smell-1: Long Method — `POST /api/notes` handler 90+ baris
- **File**: `src/app/api/notes/route.ts`
- **Bentuk**: 1 fungsi handler punya: parse JSON → validasi 5 field manual → sanitize HTML → cek quota user → insert ke DB → log audit ke console → format response.
- **Refactor target**: pecah jadi 4 fungsi (`parseAndValidate`, `sanitizeContent`, `insertNote`, `formatResponse`) di `src/lib/notes/`. Handler tinggal 15 baris.

### Smell-2: Duplicate Code — validasi sama di POST & PATCH
- **File**: `src/app/api/notes/route.ts` + `src/app/api/notes/[id]/route.ts`
- **Bentuk**: validasi title (length 1-200), tags (max 10), content (max 50000) di-copy paste di 2 handler.
- **Refactor target**: extract ke `src/lib/validate.ts` (validateNoteInput()), keduanya consume.

### Smell-3: Magic Numbers/Strings — limit & status hardcoded
- **File**: tersebar — `route.ts`, `NoteForm.tsx`
- **Bentuk**: `if (tags.length > 10)`, `if (title.length > 200)`, `if (notes.length >= 50)` (quota user). Status string `'public'`, `'private'`, `'draft'` hardcoded.
- **Refactor target**: bikin `src/lib/notes/constants.ts` dengan `MAX_TAGS`, `MAX_TITLE_LENGTH`, `MAX_NOTES_PER_USER`, dan const enum `NoteStatus`.

### Smell-4: God Component — `NoteForm.tsx` 250+ baris
- **File**: `src/components/NoteForm.tsx`
- **Bentuk**: 1 komponen punya: state form (5 fields), validasi inline, tag input dengan autocomplete, markdown preview toggle, submit handler, error toast, dirty check beforeunload.
- **Refactor target**: pecah jadi `NoteForm` (container), `TagInput`, `MarkdownPreview`, `useDirtyCheck` hook.

---

## 8. 🧪 TEST GAP (Sesi 8 Testing)

Starter sengaja **tidak punya test sama sekali**. Hanya ada:
- `vitest.config.ts` siap pakai (tapi tidak ada test file)
- `__tests__/` folder kosong dengan `.gitkeep`
- `package.json` punya `"test": "vitest"` tapi exit 0 karena no test

Peserta di Sesi 8 menambahkan:
- **Characterization test** untuk `POST /api/notes` (lock behavior sebelum refactor di Sesi 7)
- **Unit test** untuk `validateNoteInput()` setelah di-extract
- **Integration test** untuk happy path login → create → list note
- **Code review** PR teman pakai checklist Sesi 8

---

## 9. Mapping Tahap ↔ Sesi

| Tahap | Sesi | Aktivitas peserta |
|-------|------|-------------------|
| 11 | 5 | Clone starter, run, jelajahi struktur folder |
| 12 | 5 | Generate `docs/architecture.md` + ERD dengan AI |
| 13 | 6 | Debug Bug-1 (timezone) + characterization test |
| 14 | 6 | Debug Bug-2 (RLS bocor) — paling berbahaya |
| 15 | 6 | Debug Bug-3 (race) atau Bug-4 (leak), pilih 1 |
| 16 | 7 | Refactor Smell-1 (long method) + Smell-2 (duplicate) |
| 17 | 7 | Refactor Smell-3 (magic) atau Smell-4 (god component) |
| 18 | 8 | Tulis characterization test (untuk refactor di Sesi 7) |
| 19 | 8 | Tulis unit test untuk yang sudah di-extract |
| 20 | 8 | Code review PR teman + simulasi merge |

`perjalanan-project.md` Hari 2 akan direstruktur mengikuti mapping ini.

---

## 10. TODO Build (untuk fasilitator yang membangun starter)

- [ ] Scaffold Next.js 14 + TS + Tailwind + Supabase JS
- [ ] Implement auth magic link
- [ ] Implement 6 endpoint CRUD + 1 public
- [ ] Implement 5 page (landing/login/notes/new/[id]/public)
- [ ] Implement 4 bug sesuai Section 6 (jangan komentari "BUG: ..." — biar terselip natural)
- [ ] Implement 4 smell sesuai Section 7
- [ ] Tulis `README.md` peserta (no bug/smell hints)
- [ ] Setup vitest config (no test file)
- [ ] Test manual: full flow login → create → public → debug 1 bug
- [ ] Lock versi di package.json
- [ ] Buat 1 seed user dummy untuk smoke test

Estimasi: 1–2 hari kerja kalau dilakukan dengan Cursor Agent + review per fitur.
