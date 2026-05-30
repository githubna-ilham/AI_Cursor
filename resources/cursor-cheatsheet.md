# Cursor Cheatsheet

Ringkasan shortcut, mode, dan fitur Cursor untuk dipegang peserta selama pelatihan.

> Shortcut di bawah memakai notasi Mac. Pengguna Windows/Linux ganti `Cmd` → `Ctrl`.

---

## Mode Interaksi Utama

| Mode            | Shortcut         | Kapan dipakai                                              |
| --------------- | ---------------- | ---------------------------------------------------------- |
| **Tab / Autocomplete** | langsung mengetik | Saran multi-baris kontekstual, dasar produktivitas         |
| **Inline Edit (⌘K)**  | `Cmd + K`         | Edit/buat kode dalam file aktif, cepat & terlokalisasi     |
| **Chat (⌘L)**         | `Cmd + L`         | Tanya jawab, eksplorasi, brainstorm desain                 |
| **Agent / Composer**  | `Cmd + I`         | Tugas multi-file, refactor lintas modul, scaffold fitur    |
| **Terminal Inline**   | `Cmd + K` di terminal | Generate perintah shell dari deskripsi natural language |

## Context Mentions

Gunakan `@` di chat / Cmd+K untuk mengikat konteks:

| Mention       | Fungsi                                                  |
| ------------- | ------------------------------------------------------- |
| `@<file>`     | Tarik isi file spesifik                                 |
| `@Folders`    | Indeks satu folder ke konteks                           |
| `@Code`       | Tunjuk simbol/fungsi dari index                         |
| `@Docs`       | Akses dokumentasi library yang ter-index                |
| `@Web`        | Pencarian web on-demand                                 |
| `@Git`        | Diff, commit, history                                   |
| `@Definitions`| Definisi simbol untuk akurasi                           |
| `@Recent Changes` | Konteks dari edit terbaru                            |
| `@Linter Errors` | Tarik error linter ke chat                           |

## Shortcut Sehari-hari

| Aksi                            | Shortcut          |
| ------------------------------- | ----------------- |
| Buka Command Palette            | `Cmd + Shift + P` |
| Quick Open file                 | `Cmd + P`         |
| Toggle sidebar                  | `Cmd + B`         |
| Toggle terminal                 | `Ctrl + ``        |
| Accept suggestion (Tab)         | `Tab`             |
| Reject suggestion               | `Esc`             |
| Trigger inline edit             | `Cmd + K`         |
| Open Chat                       | `Cmd + L`         |
| New Chat session                | `Cmd + N` di chat |
| Open Composer                   | `Cmd + I`         |
| Add file ke chat                | drag-drop atau `@` |
| Apply patch dari chat           | tombol Apply pada blok kode |
| Revert AI edit                  | `Cmd + Z`         |
| Toggle suggestion mode          | `Cmd + Shift + L` |

## Pilihan Model

Cursor mendukung beberapa model. Pilih berdasarkan task:

| Model class          | Cocok untuk                                    |
| -------------------- | ---------------------------------------------- |
| Frontier (Sonnet/Opus, GPT-5, Gemini) | Reasoning kompleks, refactor besar, debugging non-trivial |
| Fast (Haiku, mini)   | Edit cepat, autocomplete, tanya-jawab ringan  |
| Local/Free fallback  | Saat offline / privacy concern                |

## `.cursorrules` (Project Rules)

File `.cursorrules` di root proyek menetapkan instruksi global ke AI untuk konteks repo tersebut.

Contoh isi:

```text
- Selalu gunakan TypeScript strict mode.
- Hindari any. Gunakan unknown bila perlu.
- Test framework: Vitest. Setiap fungsi public wajib ada test.
- Naming: camelCase untuk variabel, PascalCase untuk type.
- Hindari komentar yang menjelaskan WHAT — beri komentar hanya untuk WHY non-obvious.
```

Lihat folder `rules-template/` untuk contoh per stack.

## Indexing Codebase

- Settings → Codebase Indexing → Enable
- Cek status indexing di status bar
- Re-index bila ada perubahan dependency besar (`@Codebase` jadi lebih akurat)

## Privacy Mode

Settings → Privacy Mode = **ON** wajib untuk repo enterprise / regulated. Pastikan storage prompt off.

## Troubleshooting Singkat

| Gejala                         | Solusi cepat                                          |
| ------------------------------ | ----------------------------------------------------- |
| Autocomplete lambat            | Tutup file besar yang tidak perlu, restart Cursor     |
| AI tidak "lihat" file lain     | Pakai `@file` eksplisit atau enable `@Codebase`       |
| Hasil kode tidak konsisten     | Tambahkan rules di `.cursorrules`                     |
| Token terlalu banyak terpakai  | Hindari `@Folders` luas; pakai `@file` spesifik       |
| Apply patch error              | Cek konflik manual, refresh chat, mulai sesi baru     |
