# 📖 Panduan Penggunaan TimeManagerApp

## 🎯 Memulai Aplikasi

Setelah membuka TimeManagerApp untuk pertama kali, ikuti langkah-langkah ini:

### 1. Setup Profil Pengguna
- Buka **Settings** dari drawer menu (hamburger icon)
- Masukkan nama Anda di field "Nama Pengguna"
- Klik **Simpan Nama**
- Nama Anda akan ditampilkan di halaman Home dan User Menu

### 2. Pilih Tema (Opsional)
- Di Settings, toggle switch **Mode Gelap/Terang**
- Pilihan tema akan tersimpan otomatis
- Tema akan tetap sesuai pilihan Anda saat app restart

---

## 📑 Panduan Per Fitur

### 🏠 HOME PAGE
**Fungsi:** Overview aplikasi dan statistik cepat

**Fitur:**
- Salam personal dengan nama pengguna
- Statistik: Total Jadwal Mingguan dan Total Ruangan
- Daftar 5 Aktivitas Terbaru
- Akses cepat ke semua fitur utama

**Cara Menggunakan:**
1. Lihat statistik cepat
2. Klik aktivitas untuk melihat detail
3. Gunakan Bottom Navigation untuk navigasi ke fitur lain

---

### 📅 JADWAL MINGGUAN (Weekly Schedule)
**Fungsi:** Kelola jadwal harian yang berulang setiap minggu

**Operasi CRUD:**

#### ➕ Tambah Jadwal
1. Klik tombol **+** (floating action button)
2. Isi form:
   - **Judul**: Nama aktivitas (contoh: "Rapat Pagi")
   - **Hari**: Pilih hari dalam seminggu (Senin-Minggu)
   - **Waktu Mulai**: Masukkan waktu (format HH:mm, contoh: 09:00)
   - **Waktu Selesai**: Masukkan waktu (format HH:mm)
   - **Deskripsi**: Detail tambahan (opsional)
3. Klik **Simpan**

#### 👁️ Lihat Detail Jadwal
1. Klik pada item jadwal di list
2. Bottom sheet akan menampilkan semua detail
3. Lihat deskripsi lengkap

#### ✏️ Edit Jadwal
1. Klik icon **Pensil** di sisi kanan item
2. Ubah field yang diinginkan
3. Klik **Simpan**

#### ❌ Hapus Jadwal
1. Klik icon **Tempat Sampah** di sisi kanan item
2. Konfirmasi penghapusan
3. Jadwal akan dihapus

---

### 📆 AGENDA HARI INI (Daily Agenda)
**Fungsi:** Lihat jadwal spesifik untuk hari ini, diambil dari Weekly Schedule

**Fitur:**
- Otomatis menampilkan jadwal untuk hari saat ini
- Jadwal diurutkan berdasarkan waktu mulai
- Tampilan warna-warni untuk setiap jadwal
- Status "Aktif" atau "Nonaktif" terlihat

**Cara Menggunakan:**
1. Buka tab **Agenda**
2. Lihat semua jadwal hari ini
3. Periksa waktu dan deskripsi
4. Jika tidak ada jadwal: nikmati hari dengan santai!
5. Klik item untuk melihat detail lengkap

**Catatan:**
- Jadwal hanya ditampilkan jika `is_active = 1` dan cocok dengan hari saat ini
- Update otomatis saat app dibuka

---

### 🏢 MANAJEMEN RUANGAN (Room Management)
**Fungsi:** Membuat ruangan untuk mengelompokkan aktivitas dan mengundang member

#### ➕ Tambah Ruangan
1. Klik tombol **+**
2. Isi form:
   - **Nama Ruangan**: Nama unik (contoh: "Tim IT", "Divisi Marketing")
   - **Deskripsi**: Penjelasan (opsional)
3. Klik **Simpan**

#### ✏️ Edit Ruangan
1. Klik icon **Pensil** pada kartu ruangan
2. Ubah informasi
3. Klik **Simpan**

#### ❌ Hapus Ruangan
1. Klik icon **Tempat Sampah**
2. Konfirmasi penghapusan
3. *Catatan: Semua aktivitas dalam ruangan juga akan dihapus*

#### 👥 Kelola Undangan Member

**Tambah Undangan:**
1. Cari ruangan yang dituju
2. Klik tombol **Tambah Undangan** di bawah nama ruangan
3. Masukkan email member (contoh: john.doe@email.com)
4. Klik **Tambah**
5. Email akan muncul sebagai Chip

**Hapus Undangan:**
1. Klik **×** pada Chip email
2. Email akan dihapus dari daftar undangan

**Lihat Detail Ruangan:**
1. Klik kartu ruangan
2. Bottom sheet menampilkan info lengkap
3. Edit atau hapus dari sini

---

### 📋 MANAJEMEN AKTIVITAS (Activity Management)
**Fungsi:** Buat aktivitas spesifik yang terikat pada ruangan

**Filter by Room:**
- Gunakan Chip filter di atas untuk memfilter aktivitas
- "Semua" untuk melihat semua aktivitas
- Klik nama ruangan untuk filter spesifik

#### ➕ Tambah Aktivitas
1. Klik tombol **+**
2. Isi form:
   - **Ruangan**: Pilih ruangan dari dropdown
   - **Judul Aktivitas**: Nama aktivitas
   - **Waktu**: Waktu aktivitas (HH:mm)
   - **Catatan**: Detail tambahan
3. Klik **Simpan**

#### ✏️ Edit Aktivitas
1. Klik icon **Pensil** pada item
2. Ubah field
3. Klik **Simpan**

#### ❌ Hapus Aktivitas
1. Klik icon **Tempat Sampah**
2. Konfirmasi penghapusan
3. Aktivitas akan dihapus beserta progress-nya

#### 👁️ Lihat Detail Aktivitas
1. Klik item aktivitas
2. Bottom sheet menampilkan:
   - Nama ruangan
   - Waktu aktivitas
   - Catatan lengkap
3. Edit atau hapus dari sini

---

### ✅ PROGRESS TRACKER
**Fungsi:** Tandai aktivitas yang sudah selesai untuk tracking progres harian

#### 📅 Pilih Tanggal
1. Klik kotak tanggal di atas list
2. Picker akan muncul
3. Pilih tanggal yang diinginkan
4. Atau klik **Hari Ini** untuk kembali ke tanggal saat ini

#### ✔️ Tandai Aktivitas Selesai
1. Centang checkbox di sebelah kiri nama aktivitas
2. Status berubah menjadi ✓ (hijau)
3. Teks aktivitas akan tercoret
4. Progress disimpan di database

#### ↩️ Batal Penandaan
1. Klik checkbox lagi untuk unchecked
2. Status kembali normal
3. Perubahan disimpan otomatis

#### 📊 View Progress
- Aktivitas dengan ✓ hijau = sudah selesai
- Aktivitas dengan ○ abu = belum selesai
- Setiap tanggal memiliki progress tersendiri

---

### ⚙️ SETTINGS
**Fungsi:** Kelola preferensi pengguna dan database

#### 👤 Profil Pengguna
- **Nama Pengguna**: Edit nama Anda
- Klik **Simpan Nama** untuk menyimpan
- Nama akan ditampilkan di Home dan User Menu

#### 🌙 Tampilan (Theme)
- **Toggle Switch**: Pilih Dark Mode atau Light Mode
- Pilihan tersimpan otomatis di Shared Preferences
- Tema akan tetap sama saat app restart

#### 💾 Backup & Restore

**Export Database:**
1. Klik **Export** (tombol backup)
2. Loading bar akan ditampilkan
3. Setelah selesai: "Backup tersimpan: [path]"
4. File tersimpan di device Documents folder

**Lihat File Backup:**
1. Klik **Lihat File Backup**
2. Dialog akan menampilkan daftar backup files
3. Klik **×** pada setiap file untuk menghapus backup
4. Klik **Tutup** untuk menutup dialog

**Import Database:**
1. Klik **Import** (tombol restore)
2. Fitur file picker akan diimplementasikan lebih lanjut
3. Untuk sekarang: gunakan file manager untuk copy file ke Documents

#### 📖 Tentang Aplikasi
- **Nama**: TimeManagerApp
- **Versi**: 1.0.0
- **Deskripsi**: Aplikasi manajemen waktu untuk produktivitas

---

## 🔔 Notifikasi Reminder

### Cara Kerja
- Aplikasi mengirim notifikasi **10 menit sebelum aktivitas dimulai**
- Notifikasi ditampilkan di notification panel device
- Support Android dan iOS

### Konfigurasi Notifikasi
- Pastikan notifikasi diizinkan di setting device
- Android: Settings > Apps > TimeManagerApp > Notifications > Allow
- iOS: Settings > Notifications > TimeManagerApp > Allow

---

## 📊 Statistik & Data

### Home Page Statistics
- **Total Jadwal Mingguan**: Jumlah semua jadwal yang dibuat
- **Total Ruangan**: Jumlah semua ruangan yang dibuat

### Aktivitas Terbaru
- Menampilkan 5 aktivitas terakhir yang ditambahkan
- Klik untuk melihat detail atau lihat di Activity Management

---

## 💡 Tips & Trik

### Manajemen Waktu Efektif
1. Buat Weekly Schedule terlebih dahulu
2. Kelompokkan aktivitas dalam Room sesuai kategori
3. Gunakan Progress Tracker untuk tracking harian
4. Lihat Daily Agenda setiap pagi

### Backup Rutin
1. Buka Settings setiap minggu
2. Klik **Export** untuk membuat backup
3. Backup files akan tersimpan dengan timestamp
4. Jika terjadi masalah, bisa restore dari backup

### Notifikasi Efektif
- Pastikan sound/vibration enabled di device
- Jangan abaikan reminder 10 menit
- Volume device tidak muted

### Tema Dark Mode
- Gunakan untuk mengurangi kelelahan mata di malam hari
- Tema terang lebih baik untuk siang hari
- Toggle kapan saja sesuai kebutuhan

---

## 🐛 Troubleshooting

### Aktivitas tidak muncul di Daily Agenda
- Periksa apakah jadwal sudah dibuat di Weekly Schedule
- Pastikan hari yang dipilih sesuai hari saat ini
- Pastikan jadwal dalam status "Aktif" (is_active = 1)

### Notifikasi tidak masuk
- Izinkan notifikasi di setting device
- Pastikan app tidak dalam mode "Do Not Disturb"
- Volume device tidak muted
- Pastikan jam device akurat

### Data tidak tersimpan
- Pastikan ada koneksi atau database bisa diakses
- Lihat snackbar message untuk error details
- Coba refresh atau buka halaman lain

### Tema tidak berubah setelah restart
- Buka Settings
- Toggle theme switch
- Force close app dan buka ulang

---

## 📱 Interface Overview

### Bottom Navigation Bar (6 Tabs)
```
[Home] [Jadwal] [Agenda] [Ruangan] [Aktivitas] [Progress]
```

### Drawer Menu
- Home
- Jadwal Mingguan
- Agenda Hari Ini
- Manajemen Ruangan
- Manajemen Aktivitas
- Progress Tracker
- ---
- Pengaturan

---

## 🎓 Use Case Examples

### Scenario 1: Manajemen Rapat Mingguan
1. Buat Room "Rapat Pagi"
2. Buat Weekly Schedule: Senin-Jumat 09:00-10:00 "Standup Meeting"
3. Setiap hari, cek Daily Agenda untuk reminders
4. Tandai di Progress Tracker setelah selesai

### Scenario 2: Project Management
1. Buat Room "Project A", "Project B"
2. Tambah beberapa Activities di setiap room
3. Lihat Activities untuk melihat semua tasks
4. Track progress per aktivitas setiap hari

### Scenario 3: Personal Productivity
1. Buat room untuk berbagai kategori (Kerja, Hobi, Keluarga)
2. Buat jadwal mingguan untuk routine tasks
3. Check Daily Agenda setiap pagi
4. Update Progress untuk motivasi diri sendiri

---

## 📞 FAQ

**Q: Apakah data saya aman?**
A: Ya, semua data disimpan lokal di device dalam database SQLite.

**Q: Bisakah saya share jadwal dengan orang lain?**
A: Fitur sharing akan diimplementasikan di versi mendatang. Untuk sekarang, gunakan fitur Invite untuk mencatat email member.

**Q: Bagaimana jika saya lupa backup?**
A: Data tersimpan lokal. Backup adalah untuk backup data. Jika ingin aman, lakukan export setiap minggu.

**Q: Apakah aplikasi bekerja offline?**
A: Ya, semua fitur bekerja offline karena menggunakan database lokal.

**Q: Berapa banyak jadwal yang bisa dibuat?**
A: Tidak ada batasan, selama device storage mencukupi.

---

**Version:** 1.0.0
**Last Updated:** November 2025
**Language:** Indonesian (Bahasa Indonesia)
