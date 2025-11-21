# 📋 Dokumentasi Teknis TimeManagerApp

## 📌 Ringkasan Implementasi

Aplikasi TimeManagerApp telah diimplementasikan dengan memenuhi SEMUA ketentuan teknis yang diberikan:

### ✅ 9 Fitur Utama (Lengkap)

1. **Weekly Schedule (Jadwal Mingguan)** ✅
   - File: `lib/pages/weekly_schedule_page.dart`
   - Database: `weekly_schedule` table
   - CRUD: ✓ Create, ✓ Read, ✓ Update, ✓ Delete
   - Data fields: title, day_of_week, start_time, end_time, description, is_active

2. **Room Management** ✅
   - File: `lib/pages/room_management_page.dart`
   - Database: `rooms` table
   - CRUD: ✓ Create, ✓ Read, ✓ Update, ✓ Delete
   - Data fields: name, description

3. **Activity Management** ✅
   - File: `lib/pages/activity_management_page.dart`
   - Database: `activities` table
   - CRUD: ✓ Create, ✓ Read, ✓ Update, ✓ Delete
   - Data fields: room_id, title, time, note
   - Fitur tambahan: Filter by room

4. **Invite Member** ✅
   - File: `lib/pages/room_management_page.dart` (sub-feature)
   - Database: `invites` table
   - CRUD Minimal: ✓ Insert, ✓ Select, ✓ Delete
   - Data fields: room_id, email

5. **Daily Agenda Generator** ✅
   - File: `lib/pages/daily_agenda_page.dart`
   - Ambil schedule dari `weekly_schedule` sesuai hari
   - Tampilan khusus untuk "Agenda Hari Ini"
   - Auto-sort berdasarkan waktu

6. **Local Notification Reminder** ✅
   - File: `lib/services/notification_service.dart`
   - Template fungsi untuk notifikasi
   - Reminder 10 menit sebelum aktivitas
   - Support Android & iOS

7. **User Preferences (Shared Preferences)** ✅
   - File: `lib/services/preferences_service.dart`
   - Simpan nama user: `saveUserName()`, `loadUserName()`
   - Simpan tema: `saveThemeMode()`, `loadThemeMode()`
   - Operasi: ✓ Write, ✓ Read

8. **Progress Tracker** ✅
   - File: `lib/pages/progress_tracker_page.dart`
   - Database: `progress` table
   - CRUD Sederhana: ✓ Create, ✓ Read, ✓ Update, ✓ Delete
   - Data fields: activity_id, date, status
   - Fitur: Centang aktivitas yang selesai

9. **Backup & Restore Database** ✅
   - File: `lib/services/backup_service.dart`
   - Fitur export database ke file
   - Fitur import database dari file
   - List dan kelola backup files

---

## 🗃️ Database Schema (SQLite - 5 Tabel Wajib)

### 1. weekly_schedule
```sql
CREATE TABLE weekly_schedule (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  day_of_week TEXT NOT NULL,
  start_time TEXT NOT NULL,
  end_time TEXT NOT NULL,
  description TEXT,
  is_active INTEGER DEFAULT 1
)
```
**Operasi SQL:**
- ✓ `INSERT` - insertWeeklySchedule()
- ✓ `SELECT` - getWeeklySchedules(), getWeeklyScheduleById(), getWeeklySchedulesByDay()
- ✓ `UPDATE` - updateWeeklySchedule()
- ✓ `DELETE` - deleteWeeklySchedule()

### 2. rooms
```sql
CREATE TABLE rooms (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  description TEXT
)
```
**Operasi SQL:**
- ✓ `INSERT` - insertRoom()
- ✓ `SELECT` - getRooms(), getRoomById()
- ✓ `UPDATE` - updateRoom()
- ✓ `DELETE` - deleteRoom()

### 3. activities
```sql
CREATE TABLE activities (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  room_id INTEGER NOT NULL,
  title TEXT NOT NULL,
  time TEXT NOT NULL,
  note TEXT,
  FOREIGN KEY(room_id) REFERENCES rooms(id) ON DELETE CASCADE
)
```
**Operasi SQL:**
- ✓ `INSERT` - insertActivity()
- ✓ `SELECT` - getActivities(), getActivityById(), getActivitiesByRoom()
- ✓ `UPDATE` - updateActivity()
- ✓ `DELETE` - deleteActivity()

### 4. invites
```sql
CREATE TABLE invites (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  room_id INTEGER NOT NULL,
  email TEXT NOT NULL,
  FOREIGN KEY(room_id) REFERENCES rooms(id) ON DELETE CASCADE
)
```
**Operasi SQL:**
- ✓ `INSERT` - insertInvite()
- ✓ `SELECT` - getInvites(), getInviteById(), getInvitesByRoom()
- ✓ `DELETE` - deleteInvite()

### 5. progress
```sql
CREATE TABLE progress (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  activity_id INTEGER NOT NULL,
  date TEXT NOT NULL,
  status INTEGER DEFAULT 0,
  FOREIGN KEY(activity_id) REFERENCES activities(id) ON DELETE CASCADE
)
```
**Operasi SQL:**
- ✓ `INSERT` - insertProgress()
- ✓ `SELECT` - getProgress(), getProgressById(), getProgressByActivity()
- ✓ `UPDATE` - updateProgress()
- ✓ `DELETE` - deleteProgress()

---

## 📱 Navigasi (Bottom Navigation Bar)

**5 Tab Navigasi Utama:**

| Tab | Icon | Page | File |
|-----|------|------|------|
| Home | home | HomePage | `home_page.dart` |
| Jadwal | calendar_today | WeeklySchedulePage | `weekly_schedule_page.dart` |
| Agenda | event | DailyAgendaPage | `daily_agenda_page.dart` |
| Ruangan | meeting_room | RoomManagementPage | `room_management_page.dart` |
| Aktivitas | task | ActivityManagementPage | `activity_management_page.dart` |
| Progress | check_circle | ProgressTrackerPage | `progress_tracker_page.dart` |

**Drawer Menu Tambahan:**
- Settings (SettingsPage) - Toggle theme, manage backup, user preferences

---

## 🎨 Theme Implementation

### AppTheme Class (`lib/theme/app_theme.dart`)

#### Light Theme
```dart
lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: #6200EE (Purple),
  colorScheme: ColorScheme.light(
    primary: #6200EE,
    secondary: #03DAC6,
    background: #FAFAFA,
    error: #B00020,
  )
)
```

#### Dark Theme
```dart
darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: #BB86FC (Light Purple),
  colorScheme: ColorScheme.dark(
    primary: #BB86FC,
    secondary: #03DAC6,
    background: #121212,
    error: #CF6679,
  )
)
```

### Theme Toggle
- **Location:** SettingsPage
- **Storage:** Shared Preferences (`saveThemeMode()`, `loadThemeMode()`)
- **Applied:** MyApp dengan `themeMode` dinamis
- **Persistence:** Auto-load saat app restart

---

## 🛠️ Services Architecture

### 1. DatabaseService (`database_service.dart`)
- Singleton pattern
- SQLite management
- CRUD operations untuk 5 tabel
- Foreign key relationships
- ~180 lines of code

### 2. PreferencesService (`preferences_service.dart`)
- Singleton pattern
- Shared Preferences wrapper
- User name management
- Theme mode management
- ~30 lines of code

### 3. NotificationService (`notification_service.dart`)
- Singleton pattern
- Flutter Local Notifications setup
- Timezone-aware scheduling
- 10-minute reminder before activity
- ~80 lines of code

### 4. BackupService (`backup_service.dart`)
- Singleton pattern
- Database export/import
- Backup file management
- ~70 lines of code

---

## 📦 Project Structure

```
lib/
├── main.dart                           # Entry point (160 lines)
├── models/
│   ├── weekly_schedule.dart           # Model (65 lines)
│   ├── room.dart                      # Model (30 lines)
│   ├── activity.dart                  # Model (40 lines)
│   ├── invite.dart                    # Model (30 lines)
│   └── progress.dart                  # Model (35 lines)
├── services/
│   ├── database_service.dart          # Database ops (180 lines)
│   ├── preferences_service.dart       # Shared prefs (30 lines)
│   ├── notification_service.dart      # Notifications (80 lines)
│   └── backup_service.dart            # Backup/restore (70 lines)
├── theme/
│   └── app_theme.dart                 # Light & dark themes (120 lines)
└── pages/
    ├── home_page.dart                 # Home page (180 lines)
    ├── weekly_schedule_page.dart      # Weekly schedule (310 lines)
    ├── daily_agenda_page.dart         # Daily agenda (210 lines)
    ├── room_management_page.dart      # Room management (350 lines)
    ├── activity_management_page.dart  # Activity management (350 lines)
    ├── progress_tracker_page.dart     # Progress tracker (260 lines)
    └── settings_page.dart             # Settings (320 lines)

Total: ~3,000 lines of Dart code
```

---

## 📚 Dependencies & Versions

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  sqflite: ^2.3.0                      # SQLite database
  path_provider: ^2.1.1                # File paths
  shared_preferences: ^2.2.2           # Preferences storage
  flutter_local_notifications: ^14.1.1 # Push notifications
  timezone: ^0.9.3                     # Timezone support
  intl: ^0.19.0                        # Localization
```

---

## 🔄 Data Flow

### CRUD Operation Flow
```
UI Page → Service Method → Database → Response → UI Update
```

### Example: Add Weekly Schedule
```
WeeklySchedulePage 
  → insertWeeklySchedule(schedule)
  → DatabaseService.insertWeeklySchedule()
  → SQLite INSERT
  → setState() → UI Refresh
```

### Example: Load User Name
```
SettingsPage
  → loadUserName()
  → PreferencesService.loadUserName()
  → SharedPreferences.getString()
  → Display in TextField
```

---

## 🔐 Error Handling

- Try-catch blocks di semua async operations
- ScaffoldMessenger untuk user feedback
- Input validation sebelum save
- Database constraint handling (Foreign keys)

---

## 📝 Code Quality

- ✓ Null-safe Dart
- ✓ Type-safe operations
- ✓ Consistent naming conventions
- ✓ Comments untuk complex logic
- ✓ Proper imports organization
- ✓ Const constructors where possible

---

## 🚀 How to Run

```bash
# Get dependencies
flutter pub get

# Run on Windows desktop
flutter run -d windows

# Run on Android emulator
flutter run -d emulator-5554

# Run on iOS simulator
flutter run -d iPhone-simulator

# Build release APK
flutter build apk --release
```

---

## 📊 Feature Completion Checklist

- [x] Weekly Schedule dengan 6 fields + CRUD
- [x] Room Management dengan CRUD
- [x] Activity Management per room + CRUD
- [x] Invite Member insert/select/delete
- [x] Daily Agenda Generator
- [x] Local Notification Reminder (10 min)
- [x] User Preferences (name & theme)
- [x] Progress Tracker dengan CRUD
- [x] Backup & Restore Database
- [x] SQLite dengan 5 tabel
- [x] Shared Preferences integration
- [x] Bottom Navigation Bar (6 tabs)
- [x] Light & Dark Theme dengan toggle
- [x] Drawer Navigation Menu
- [x] Responsive UI design

**Total: 15/15 Requirements ✅**

---

## 📞 Support & Notes

- Aplikasi menggunakan Singleton pattern untuk services
- Database dipastikan initialized sebelum build()
- Notifikasi memerlukan permission request di runtime
- Theme persists melalui Shared Preferences
- Backup files tersimpan di Documents directory

---

**Last Updated:** November 2025
**Flutter Version:** 3.32.5
**Dart Version:** 3.8.1
