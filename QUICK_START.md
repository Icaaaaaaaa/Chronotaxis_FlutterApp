# 🚀 QUICK START GUIDE

Panduan cepat untuk memulai TimeManagerApp.

---

## ⚡ 5 LANGKAH QUICK START

### 1️⃣ Install Dependencies
```bash
cd chronotaxis_flutterapp
flutter pub get
```

### 2️⃣ Run Aplikasi
```bash
# Windows Desktop
flutter run -d windows

# Android
flutter run -d emulator-5554

# iOS
flutter run -d iPhone-simulator
```

### 3️⃣ Setup Profil
- Buka Settings (drawer menu)
- Masukkan nama Anda
- Pilih tema (light/dark)
- Klik Simpan

### 4️⃣ Buat Data Pertama
- **Jadwal**: Jadwal Mingguan tab → (+) button
- **Ruangan**: Ruangan tab → (+) button
- **Aktivitas**: Aktivitas tab → (+) button
- **Progress**: Progress tab → Check activities

### 5️⃣ Lihat Hasilnya
- Home: Dashboard overview
- Agenda: Lihat jadwal hari ini
- Settings: Backup data

---

## 📋 Menu Utama

```
┌─────────────────────────────────────┐
│  TimeManagerApp                      │
├─────────────────────────────────────┤
│ [Home] [Jadwal] [Agenda] [Room] ... │
├─────────────────────────────────────┤
│ ≡ Menu (Drawer)                     │
│ • Home                              │
│ • Jadwal Mingguan                   │
│ • Agenda Hari Ini                   │
│ • Manajemen Ruangan                 │
│ • Manajemen Aktivitas               │
│ • Progress Tracker                  │
│ ─────────────────────────────────── │
│ • Pengaturan                        │
└─────────────────────────────────────┘
```

---

## 🔑 FITUR KUNCI

| Fitur | Lokasi | Shortcut |
|-------|--------|----------|
| Tambah Jadwal | Jadwal Tab | FAB (+) |
| Lihat Agenda | Agenda Tab | - |
| Buat Ruangan | Ruangan Tab | FAB (+) |
| Add Activity | Aktivitas Tab | FAB (+) |
| Track Progress | Progress Tab | Checkbox |
| Settings | Drawer Menu | ⚙️ |

---

## 💾 DATABASE

Semua data tersimpan **lokal** di device:
- Database: SQLite (timemanager.db)
- Preferences: SharedPreferences
- Backup: Documents folder

---

## 🔔 NOTIFIKASI

Notifikasi otomatis:
- ⏰ 10 menit sebelum aktivitas
- 📱 Sound + vibration
- 🔕 Dapat diatur di device settings

---

## 🎨 TEMA

| Mode | Colors |
|------|--------|
| Light | Purple primary + Cyan accent |
| Dark | Light purple primary + Cyan accent |

Toggle di: **Settings → Tampilan**

---

## 📱 SHORTCUTS CEPAT

- **Tambah Item**: Tekan FAB (+) di mana saja
- **Edit Item**: Tekan icon pensil (✏️)
- **Hapus Item**: Tekan icon tempat sampah (🗑️)
- **Detail View**: Klik item di list
- **Refresh**: Swipe down di list

---

## 🆘 TROUBLESHOOTING CEPAT

| Problem | Solusi |
|---------|--------|
| Notifikasi tidak masuk | Izinkan di device settings |
| Data tidak tersimpan | Restart app |
| Tema tidak berubah | Settings → Tampilan → Toggle |
| List kosong | Tambah data dulu dengan FAB |
| Backup gagal | Check device storage |

---

## 📚 FILE PENTING

```
📂 Project Root
├── 📄 README.md - Dokumentasi lengkap
├── 📄 USER_GUIDE.md - Panduan penggunaan
├── 📄 TECHNICAL_DOCUMENTATION.md - Teknis detail
├── 📄 IMPLEMENTATION_SUMMARY.md - Ringkasan implementasi
├── 📄 COMPLETION_CHECKLIST.md - Verifikasi lengkap
├── 📂 lib/
│   ├── main.dart - Entry point
│   ├── models/ - Data structures
│   ├── services/ - Business logic
│   ├── pages/ - UI screens
│   └── theme/ - Theme configuration
└── 📄 pubspec.yaml - Dependencies
```

---

## 🎯 FIRST TIME SETUP

### Langkah demi Langkah:

1. **Launch App**
   ```
   Lihat: Home Page dengan sambutan
   ```

2. **Set Profile**
   ```
   Buka: Drawer → Pengaturan
   Isi: Nama Pengguna
   Pilih: Light/Dark Theme
   ```

3. **Create Weekly Schedule**
   ```
   Tab: Jadwal Mingguan
   Klik: Tombol (+)
   Isi: Judul, Hari, Waktu
   Simpan: Data akan tersimpan
   ```

4. **Create Room**
   ```
   Tab: Ruangan
   Klik: Tombol (+)
   Isi: Nama Ruangan
   Simpan: Ruangan siap digunakan
   ```

5. **Add Activities**
   ```
   Tab: Aktivitas
   Klik: Tombol (+)
   Isi: Ruangan, Judul, Waktu
   Simpan: Activity tersimpan
   ```

6. **Check Today's Agenda**
   ```
   Tab: Agenda
   Lihat: Jadwal hari ini
   Notifikasi: Akan muncul 10 menit sebelum
   ```

7. **Track Progress**
   ```
   Tab: Progress
   Pilih: Tanggal
   Check: Aktivitas yang selesai
   Saved: Otomatis tersimpan
   ```

---

## 🔐 DATA BACKUP

### Manual Backup:
```
1. Settings → Backup & Restore
2. Klik: Export
3. File tersimpan dengan timestamp
4. Lokasi: Device Documents folder
```

### Restore:
```
1. Settings → Lihat File Backup
2. Pilih: File untuk restore
3. (File picker - coming soon)
```

---

## ⚙️ SETTINGS COMPLETE

| Setting | Default | Options |
|---------|---------|---------|
| Nama Pengguna | "User" | Custom text |
| Mode Tema | Light | Light/Dark |
| Auto-backup | Manual | Manual only |
| Notifikasi | Enabled | On/Off device |

---

## 🎓 TUTORIAL VIDEO (Suggested)

1. Opening app & first setup (1 min)
2. Creating weekly schedule (2 min)
3. Managing rooms & activities (2 min)
4. Daily agenda workflow (1 min)
5. Progress tracking (1 min)
6. Backup & settings (1 min)

Total: ~8 minutes

---

## 🔗 RESOURCES

- **Flutter Docs**: https://flutter.dev/docs
- **SQLite**: https://pub.dev/packages/sqflite
- **Shared Preferences**: https://pub.dev/packages/shared_preferences
- **Local Notifications**: https://pub.dev/packages/flutter_local_notifications

---

## ✅ PRE-LAUNCH CHECKLIST

- [ ] App installed
- [ ] Dependencies resolved
- [ ] App running without errors
- [ ] Profile setup complete
- [ ] First data created
- [ ] Theme toggle working
- [ ] Notification permission granted
- [ ] Backup feature tested

---

## 🎉 YOU'RE READY!

Aplikasi TimeManagerApp sudah siap digunakan. Nikmati fitur-fiturnya dan tingkatkan produktivitas Anda!

---

**Version**: 1.0.0
**Last Updated**: November 2025
**Status**: Ready to Use ✅
