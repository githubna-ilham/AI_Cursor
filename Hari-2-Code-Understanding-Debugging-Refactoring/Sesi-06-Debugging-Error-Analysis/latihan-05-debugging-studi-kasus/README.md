# Latihan 05 — Debugging Studi Kasus: 5 Buggy SQL Queries

> 🗺️ **Tahap 13–15 dari 20** | Sebelumnya: Sesi 5 Code Understanding | Setelah ini: Sesi 7 Refactoring

**Durasi**: 90 menit
**Tipe**: Hands-on individual (diskusi dengan peserta lain diperbolehkan)

---

## Konteks

5 query di `sql-playground/queries/sesi-06-debug/` adalah query production yang **dilaporkan oleh QA atau product owner**:

- Hasil tidak sesuai ekspektasi
- Baris yang seharusnya muncul tidak tampil
- Angka yang tidak masuk akal
- Filter yang tidak bekerja sebagaimana mestinya

Tugas Anda: gunakan AI sebagai **mitra debugging** untuk mendiagnosis dan memperbaiki tanpa menulis ulang query secara total.

---

## Tujuan

Setelah latihan, peserta mampu:

1. Membedakan symptom dari penyebab — banyak bug tampak serupa padahal root cause-nya berbeda.
2. Menggunakan AI untuk mendiagnosis terlebih dahulu, bukan langsung meminta perbaikan.
3. Memverifikasi hipotesis dengan query investigatif yang minimal.
4. Menulis perbaikan minimal yang menyelesaikan bug tanpa mengubah perilaku lainnya.

---

## Prasyarat

- Latihan 04 selesai (familiar dengan schema 9 tabel).
- Database `latihan_sql` sudah terisi data — apabila ragu, jalankan ulang `00_schema.sql` + `01_sample_data.sql`.

---

## Langkah Per Bug

Untuk setiap query (minimal 3, idealnya semua 5), ikuti loop berikut:

### A. Reproduce (3')

1. Buka file query (contoh: `01_inflated_revenue.sql`).
2. **Baca bagian `LAPORAN BUG`** di header — itulah symptom yang perlu Anda reproduce.
3. Jalankan query apa adanya di MySQL. Catat hasil aktual.

### B. Diagnosis dengan AI (5')

Gunakan prompt **diagnosis dulu, bukan perbaikan langsung**:

```
Query berikut hasilnya salah. Gejala:
<paste isi header LAPORAN BUG>

Query:
<paste isi query>

Tolong lakukan hal berikut:
1. Tentukan kemungkinan penyebab (1-2 kalimat)
2. Berikan query SELECT singkat untuk membuktikan dugaan tersebut
3. JANGAN berikan perbaikan dulu

Saya akan meminta perbaikan di prompt berikutnya setelah yakin diagnosis benar.
```

### C. Verifikasi Diagnosis (3')

Jalankan query investigatif yang disarankan AI di poin 2. Pastikan hasilnya **konsisten** dengan hipotesis.

> Apabila hipotesis AI tidak terbukti, jangan langsung meminta perbaikan — minta AI mendiagnosis ulang dengan data baru yang Anda temukan.

### D. Perbaikan (5')

Setelah diagnosis terverifikasi, minta perbaikan:

```
Hipotesis Anda benar (output investigatif sudah saya verifikasi). Sekarang:

1. Berikan query perbaikan — ubah sesedikit mungkin, jangan tulis ulang secara total
2. Tambahkan komentar 1 baris di atas baris yang diubah, dengan format:
   -- FIX: <apa yang diubah & mengapa>
3. Sertakan query SELECT untuk membandingkan hasil sebelum dan sesudah perbaikan
```

Ulangi A–D untuk setiap bug.

---

## Anti-Pattern yang Perlu Dihindari

| ❌ Tidak Disarankan | ✅ Praktik yang Tepat |
|---------------------|----------------------|
| "Fix query ini" | "Diagnosis dulu, baru perbaiki" |
| Menerapkan perbaikan tanpa verifikasi | Jalankan query sebelum dan sesudah, bandingkan output |
| Menulis ulang query secara total | Perbaikan minimal — ubah hanya baris yang bermasalah |
| Hanya menguji kondisi normal | Uji edge case lain (kosong, NULL, banyak baris) |
| Tidak menyimpan query asli | Gunakan `git diff` atau backup file sebelum diedit |

---

## Common Issues

| Issue | Solusi |
|-------|--------|
| AI memberikan perbaikan yang benar tetapi `COUNT(*)` baseline tidak cocok | Kemungkinan AI mengubah lebih dari yang seharusnya — baca diff baris per baris |
| Perbaikan berhasil di data sample tetapi gagal di edge case | Buat test case sendiri (contoh: order dengan total = NULL) |
| Bug muncul kembali setelah data sample direset | Hal ini wajar — perbaikan dilakukan di query, bukan di data |
