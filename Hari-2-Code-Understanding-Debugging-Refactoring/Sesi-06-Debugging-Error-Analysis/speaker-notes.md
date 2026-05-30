# Speaker Notes — Sesi 6: Debugging & Error Analysis

## Alokasi Waktu (90 menit)

| Menit | Bagian | Catatan |
|-------|--------|---------|
| 0–5   | Recap Sesi 5 & hook | "Siapa yg pernah debug 4 jam ternyata typo?" |
| 5–25  | Konsep 1–4 | Tekankan EARTH dan klasifikasi bug |
| 25–35 | Konsep 5–8 | Anti-pattern + workflow + kapan tidak pakai AI |
| 35–50 | Demo live | Bug pagination off-by-one |
| 50–82 | Lab 05 | 3 skenario, min. 2 wajib selesai |
| 82–88 | Debrief | 1 pair tiap skenario |
| 88–90 | Wrap-up | — |

## Cue Fasilitator

### Hook Pembuka

Cerita 30 detik: "Saya pernah debug bug production 6 jam, ternyata `>` seharusnya `>=`. AI menemukannya dalam 4 menit *setelah* saya kasih reproducible test. Tanpa reproducible test, AI menebak 1 jam pertama."

### Saat EARTH Framework

Sebutkan EARTH pelan-pelan, tulis di whiteboard/slide. Minta peserta menghapal — ini akan dipakai di Lab 05.

### Saat 3 Bug Killer

- **Off-by-one**: tunjukkan trik "tulis tabel n=0,1,2,3 dan trace manual". AI bagus disuruh menuliskan ini.
- **Race condition**: ingatkan AI tidak bisa "merasakan" timing. Sering kasih jawaban deterministik untuk masalah non-deterministik.
- **Null reference**: contoh real `user?.profile?.address?.city` — sumber null bisa di mana saja.

### Saat Demo

<!-- STACK-PLACEHOLDER: kode demo off-by-one disiapkan dalam stack mayoritas peserta -->

Template demo (JS):
```js
function paginate(items, page, perPage) {
  const start = page * perPage;
  const end = start + perPage - 1;  // BUG: harusnya start + perPage
  return items.slice(start, end);
}
```

Tunjukkan: `paginate([1,2,3,4,5], 0, 2)` → `[1]` (expected `[1,2]`).

## Jawaban Kunci

1. Diagnosis baik: menyebut invariant yang dilanggar + akar masalah. Symptom fix: ganti `<` jadi `<=` tanpa tahu kenapa.
2. Prompt untuk intermittent: minta AI menganalisis shared state & timing dependency, JANGAN minta solusi langsung. Pasangkan dengan logging.
3. Saat: (a) bug intermittent, (b) bug di binary/native, (c) bug di sistem terdistribusi, (d) data sensitif.
4. Over-confidence sering menyertai hallucination karena model dilatih untuk fluent, bukan kalibrasi.
5. Regression test mencegah bug yang sama muncul lagi, juga sebagai dokumentasi bug.

## Common Pitfall

| Pitfall | Koreksi |
|---------|---------|
| Paste error tanpa kode | Minta sertakan minimal reproducible example |
| Terima fix pertama dari AI | Wajibkan tulis regression test dulu |
| Tidak verifikasi tingkat keyakinan AI | Sisipkan instruksi kalibrasi |
| Debug bug intermittent dengan AI saja | Arahkan ke debugger |

## Anekdot

- "AI yakin 95% solusinya benar — ternyata solusinya untuk versi library 2 major berbeda." Tekankan: cek versi.
- "AI fix null reference dengan `if (x) ...` padahal `x` adalah `0` valid." Tekankan: hati-hati JS truthy.

## Transisi ke Sesi 7

"Anda sudah bisa memahami dan memperbaiki bug. Tapi kadang bug bukan satu baris — kadang seluruh fungsi memang busuk. Sesi 7: refactoring."
