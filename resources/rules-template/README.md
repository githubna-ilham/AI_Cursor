# `.cursorrules` Template Library

Koleksi template `.cursorrules` per stack. Salin isi file yang sesuai ke **root proyek** dengan nama `.cursorrules` (atau `.cursor/rules/*.mdc` untuk format baru Cursor Rules).

| Stack                 | File                                       |
| --------------------- | ------------------------------------------ |
| TypeScript / Node.js  | [`cursorrules-typescript-node.md`](./cursorrules-typescript-node.md)   |
| React / Next.js       | [`cursorrules-react-next.md`](./cursorrules-react-next.md)             |
| Python / FastAPI      | [`cursorrules-python-fastapi.md`](./cursorrules-python-fastapi.md)     |
| Laravel / PHP         | [`cursorrules-laravel.md`](./cursorrules-laravel.md)                   |
| Java / Spring Boot    | [`cursorrules-spring-boot.md`](./cursorrules-spring-boot.md)           |
| Go                    | [`cursorrules-go.md`](./cursorrules-go.md)                             |
| Data Engineering      | [`cursorrules-data-eng.md`](./cursorrules-data-eng.md)                 |

## Cara Pakai

1. Pilih file sesuai stack utama proyek Anda.
2. Salin **hanya isi blok teks** (bukan judul/penjelasan markdown) ke `.cursorrules` di root proyek.
3. Sesuaikan baris yang ditandai `# TODO:` dengan konvensi tim Anda.
4. Commit `.cursorrules` ke repo agar seluruh tim mendapat instruksi yang sama.

## Prinsip Penyusunan Rules

- **Spesifik > umum**. "Gunakan TypeScript strict" lebih berguna daripada "tulis kode bersih".
- **Sebut framework/lib yang dipakai** agar AI tidak menebak versi.
- **Larangan eksplisit** lebih efektif daripada anjuran (mis. "JANGAN pakai `any`").
- **Maksimal ~30 baris**. Rules terlalu panjang justru sering diabaikan model.
- **Iterasi**. Tambah rule baru saat menemukan kesalahan AI yang berulang.
