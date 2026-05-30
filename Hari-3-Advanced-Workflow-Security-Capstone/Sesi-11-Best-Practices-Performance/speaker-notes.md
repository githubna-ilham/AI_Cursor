# Speaker Notes — Sesi 11: Best Practices & Performance

**Durasi total**: 90 menit
**Persiapan fasilitator**:
- Repo `slow-dashboard` siap dengan bottleneck N+1 dan rendering berat.
- Load test tool (k6 / autocannon) terpasang.
- Flamegraph contoh siap ditampilkan.
- Stopwatch untuk benchmark live.

---

## Alokasi Waktu

| Menit | Aktivitas | Catatan |
|-------|-----------|---------|
| 0–5 | Opening + recap sesi 10 | Jembatani: setelah aman, sekarang cepat |
| 5–20 | Konsep 2.1–2.3 (filosofi + anti-pattern + prompt) | Tekankan "measure first" |
| 20–40 | Konsep 2.4–2.8 (pola optimasi + studi kasus) | Pakai 1 studi kasus saja kalau mepet |
| 40–65 | **Demo Live** | Bagian paling berkesan — pastikan flamegraph terbaca |
| 65–85 | **Mini-Lab** | Beri target konkret: minimal 1 perbaikan terverifikasi |
| 85–90 | Wrap-up + transisi ke Capstone | Set ekspektasi capstone |

---

## Cue Fasilitator

### Pembuka
> "Performance is a feature. Tapi 'performance' tanpa angka adalah opini. Hari ini kita pakai AI bukan untuk tebak-tebakan, tapi untuk mempercepat siklus measure-hypothesize-change-verify."

### Saat anti-pattern
> "Saya pernah lihat tim refactor 3 minggu untuk 'optimasi' jalur yang dipanggil 12 kali sehari. Itu bukan engineering, itu hobi mahal."

### Saat demo
> "Saya akan biarkan kalian *menebak* bottleneck dari kode. Catat tebakan. Lalu kita lihat flamegraph. Sering kali tebakan kita salah — itulah alasan kita measure."

---

## Jawaban Kunci

**1. Mengapa measure first wajib?**
- 80% tebakan bottleneck dari developer salah (Knuth, Gregg).
- AI mewarisi bias data training, bisa fokus pada masalah umum yang bukan masalah Anda.
- Tanpa baseline, tidak ada cara membuktikan perbaikan.

**2. Risiko caching yang sering dilupakan?**
- Invalidation (Phil Karlton: "two hard things").
- Stampede saat cache expire bersamaan.
- Memory pressure di node.
- Inconsistency lintas region.

**3. Validasi Big-O klaim AI?**
- Baca kodenya sendiri.
- Tes empiris dengan input bertingkat (n=10, 100, 1k, 10k) dan plot.
- AI bisa salah, terutama untuk algoritma rekursif kompleks.

**4. Kapan optimasi cukup?**
- Saat SLO tercapai dengan margin sehat.
- Saat biaya perbaikan > dampak bisnis.
- Saat risiko regresi > potensi gain.

**5. Metrik reliability favorit?**
- SLO-based (error budget burn rate).
- p99 latency (bukan rata-rata).
- MTTR (recovery, bukan cuma uptime).

---

## Anekdot

- Tim yang habiskan 2 sprint mengoptimasi route yang ternyata 0.4% dari total traffic.
- Tim lain temukan satu baris `.toList()` yang menyebabkan 60% latency hanya dalam 15 menit dengan AI bantu baca flamegraph.
- Kasus circuit breaker yang terlalu agresif → outage downstream karena retry storm hilang lalu balik bersamaan.

---

## Common Pitfall

1. **Demo flamegraph tanpa konteks**. Peserta tidak terbiasa baca. Sediakan legend.
2. **Lab tanpa baseline**. Peserta langsung optimasi tanpa ukur dulu — paksakan urutan.
3. **Caching dipasang tanpa TTL** — diskusi 2 menit invalidation.
4. **Mengejar p99 tanpa SLO** — pertanyaan "cukup berapa?" harus dijawab bisnis dulu.
5. **Lupa side effect**: optimasi CPU sering naikkan memory, atau sebaliknya.

---

## Transisi ke Sesi 12

> "Tiga sesi tadi: workflow, security, performance. Sekarang saatnya membuktikan. Capstone bukan ujian — ini latihan terkontrol untuk situasi nyata yang akan kalian hadapi minggu depan."
