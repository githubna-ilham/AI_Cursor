# Lab 05 — Debugging Studi Kasus

## Tujuan

Peserta mampu mendiagnosis dan memperbaiki 3 kelas bug umum (off-by-one, race condition, null reference) dengan AI sebagai partner, sambil menulis regression test sebelum fix.

## Durasi

35 menit (≈10 menit per skenario + 5 menit debrief)

## Prasyarat

- Cursor aktif
- Runtime stack peserta (Node/Python/Go/Java) terinstall
- Test runner terpasang (Jest/Pytest/Go test/JUnit)
- Telah memahami EARTH framework dari Sesi 6

## Aturan Main

1. **Wajib** menulis test yang reproduksi bug SEBELUM bertanya ke AI untuk fix.
2. **Wajib** pakai EARTH di setiap prompt.
3. **Wajib** menulis kalimat akar masalah (root cause) dalam 1 baris sebelum apply fix.
4. Minimal selesai **2 dari 3** skenario.

## Skenario 1 — Off-by-One pada Pagination

<!-- STACK-PLACEHOLDER: ganti dengan kode fungsi pagination pada stack peserta -->

Kode contoh (PLACEHOLDER):

```
// File: src/utils/pagination.ext
function paginate(items, page, perPage) {
    start = page * perPage
    end = start + perPage - 1
    return items.slice(start, end)
}
```

Expected: `paginate([1,2,3,4,5], 0, 2) === [1,2]`
Actual: `[1]`

Langkah:

1. Tulis test yang assert expected.
2. Jalankan test → red.
3. Prompt AI dengan EARTH, minta 3 hipotesis + tingkat keyakinan.
4. Verifikasi hipotesis dengan trace manual untuk `n=0,1,2`.
5. Tulis root cause 1 baris.
6. Apply fix → test green.

## Skenario 2 — Race Condition pada Counter

<!-- STACK-PLACEHOLDER: implementasi counter concurrent sesuai stack peserta -->

Kode contoh (PLACEHOLDER, gaya pseudocode):

```
counter = 0
function increment():
    temp = counter
    sleep(random ms)
    counter = temp + 1

# 100 goroutine/thread/promise parallel memanggil increment()
# Expected: counter == 100
# Actual: counter < 100 (non-deterministik)
```

Langkah:

1. Reproduksi dengan test yang menjalankan 100 increment concurrent.
2. Prompt AI: "Identifikasi shared state dan window race condition. Jangan beri fix dulu."
3. Tulis root cause: read-modify-write tidak atomic.
4. Diskusikan 2 solusi (mutex vs atomic op), pilih satu, justifikasi.
5. Apply fix → test green stabil setelah 5 run.

## Skenario 3 — Null Reference pada Optional Chain

<!-- STACK-PLACEHOLDER: ganti dengan domain object yang sering muncul di stack peserta -->

Kode contoh (PLACEHOLDER):

```
function getUserCity(user) {
    return user.profile.address.city.toUpperCase()
}
```

Input yang menyebabkan crash:
- `getUserCity(null)`
- `getUserCity({profile: null})`
- `getUserCity({profile: {address: null}})`
- `getUserCity({profile: {address: {city: null}}})`

Langkah:

1. Tulis 4 test case di atas + 1 happy path.
2. Prompt AI: "Petakan sumber null untuk tiap node. Tentukan invariant yang benar: mana yang boleh null, mana yang harus throw."
3. Tulis kontrak fungsi yang jelas (return default? throw? Option/Result?).
4. Apply fix sesuai kontrak.
5. Semua test green.

## Deliverable

Folder `output-lab-05/` berisi:

- `skenario-1/` — test, fix, root-cause.md
- `skenario-2/` — test, fix, root-cause.md
- `skenario-3/` — test, fix, root-cause.md (opsional)
- `refleksi.md` — 1 paragraf: di skenario mana AI paling membantu, di mana paling menyesatkan

## Kriteria Selesai / Rubrik

| Kriteria | Bobot |
|----------|-------|
| Test reproduksi ditulis sebelum fix | 25% |
| EARTH dipakai konsisten | 15% |
| Root cause akurat (bukan symptom) | 25% |
| Fix tidak break test lain | 20% |
| Refleksi tajam & jujur | 15% |

## Debrief

3 pair (1 per skenario) bagikan: 1 hal mengejutkan + 1 prompt yang paling efektif.
