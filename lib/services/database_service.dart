import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/weekly_schedule.dart';
import '../models/room.dart';
import '../models/activity.dart';
import '../models/invite.dart';
import '../models/progress.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'timemanager.db');
    
    return openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    // users table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // weekly_schedule table
    await db.execute('''
      CREATE TABLE weekly_schedule (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        day_of_week TEXT NOT NULL,
        start_time TEXT NOT NULL,
        end_time TEXT NOT NULL,
        description TEXT,
        is_active INTEGER DEFAULT 1
      )
    ''');

    // rooms table
    await db.execute('''
      CREATE TABLE rooms (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT
      )
    ''');

    // activities table
    await db.execute('''
      CREATE TABLE activities (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        room_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        time TEXT NOT NULL,
        note TEXT,
        FOREIGN KEY(room_id) REFERENCES rooms(id) ON DELETE CASCADE
      )
    ''');

    // invites table
    await db.execute('''
      CREATE TABLE invites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        room_id INTEGER NOT NULL,
        email TEXT NOT NULL,
        FOREIGN KEY(room_id) REFERENCES rooms(id) ON DELETE CASCADE
      )
    ''');

    // progress table
    await db.execute('''
      CREATE TABLE progress (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        activity_id INTEGER NOT NULL,
        date TEXT NOT NULL,
        status INTEGER DEFAULT 0,
        FOREIGN KEY(activity_id) REFERENCES activities(id) ON DELETE CASCADE
      )
    ''');
  }

  // ========== User Operations ==========
  Future<int> insertUser(String email, String password) async {
    final db = await database;
    return await db.insert('users', {
      'email': email,
      'password': password,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<bool> emailExists(String email) async {
    final user = await getUserByEmail(email);
    return user != null;
  }

  // ========== Weekly Schedule Operations ==========
  Future<int> insertWeeklySchedule(WeeklySchedule schedule) async {
    final db = await database;
    return await db.insert('weekly_schedule', schedule.toMap());
  }

  Future<List<WeeklySchedule>> getWeeklySchedules() async {
    final db = await database;
    final result = await db.query('weekly_schedule');
    return result.map((e) => WeeklySchedule.fromMap(e)).toList();
  }

  Future<WeeklySchedule?> getWeeklyScheduleById(int id) async {
    final db = await database;
    final result = await db.query(
      'weekly_schedule',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? WeeklySchedule.fromMap(result.first) : null;
  }

  Future<List<WeeklySchedule>> getWeeklySchedulesByDay(String dayOfWeek) async {
    final db = await database;
    final result = await db.query(
      'weekly_schedule',
      where: 'day_of_week = ?',
      whereArgs: [dayOfWeek],
    );
    return result.map((e) => WeeklySchedule.fromMap(e)).toList();
  }

  Future<int> updateWeeklySchedule(WeeklySchedule schedule) async {
    final db = await database;
    return await db.update(
      'weekly_schedule',
      schedule.toMap(),
      where: 'id = ?',
      whereArgs: [schedule.id],
    );
  }

  Future<int> deleteWeeklySchedule(int id) async {
    final db = await database;
    return await db.delete(
      'weekly_schedule',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ========== Room Operations ==========
  Future<int> insertRoom(Room room) async {
    final db = await database;
    return await db.insert('rooms', room.toMap());
  }

  Future<List<Room>> getRooms() async {
    final db = await database;
    final result = await db.query('rooms');
    return result.map((e) => Room.fromMap(e)).toList();
  }

  Future<Room?> getRoomById(int id) async {
    final db = await database;
    final result = await db.query(
      'rooms',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? Room.fromMap(result.first) : null;
  }

  Future<int> updateRoom(Room room) async {
    final db = await database;
    return await db.update(
      'rooms',
      room.toMap(),
      where: 'id = ?',
      whereArgs: [room.id],
    );
  }

  Future<int> deleteRoom(int id) async {
    final db = await database;
    return await db.delete(
      'rooms',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ========== Activity Operations ==========
  Future<int> insertActivity(Activity activity) async {
    final db = await database;
    return await db.insert('activities', activity.toMap());
  }

  Future<List<Activity>> getActivities() async {
    final db = await database;
    final result = await db.query('activities');
    return result.map((e) => Activity.fromMap(e)).toList();
  }

  Future<Activity?> getActivityById(int id) async {
    final db = await database;
    final result = await db.query(
      'activities',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? Activity.fromMap(result.first) : null;
  }

  Future<List<Activity>> getActivitiesByRoom(int roomId) async {
    final db = await database;
    final result = await db.query(
      'activities',
      where: 'room_id = ?',
      whereArgs: [roomId],
    );
    return result.map((e) => Activity.fromMap(e)).toList();
  }

  Future<int> updateActivity(Activity activity) async {
    final db = await database;
    return await db.update(
      'activities',
      activity.toMap(),
      where: 'id = ?',
      whereArgs: [activity.id],
    );
  }

  Future<int> deleteActivity(int id) async {
    final db = await database;
    return await db.delete(
      'activities',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ========== Invite Operations ==========
  Future<int> insertInvite(Invite invite) async {
    final db = await database;
    return await db.insert('invites', invite.toMap());
  }

  Future<List<Invite>> getInvites() async {
    final db = await database;
    final result = await db.query('invites');
    return result.map((e) => Invite.fromMap(e)).toList();
  }

  Future<Invite?> getInviteById(int id) async {
    final db = await database;
    final result = await db.query(
      'invites',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? Invite.fromMap(result.first) : null;
  }

  Future<List<Invite>> getInvitesByRoom(int roomId) async {
    final db = await database;
    final result = await db.query(
      'invites',
      where: 'room_id = ?',
      whereArgs: [roomId],
    );
    return result.map((e) => Invite.fromMap(e)).toList();
  }

  Future<int> deleteInvite(int id) async {
    final db = await database;
    return await db.delete(
      'invites',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ========== Progress Operations ==========
  Future<int> insertProgress(Progress progress) async {
    final db = await database;
    return await db.insert('progress', progress.toMap());
  }

  Future<List<Progress>> getProgress() async {
    final db = await database;
    final result = await db.query('progress');
    return result.map((e) => Progress.fromMap(e)).toList();
  }

  Future<Progress?> getProgressById(int id) async {
    final db = await database;
    final result = await db.query(
      'progress',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? Progress.fromMap(result.first) : null;
  }

  Future<List<Progress>> getProgressByActivity(int activityId) async {
    final db = await database;
    final result = await db.query(
      'progress',
      where: 'activity_id = ?',
      whereArgs: [activityId],
    );
    return result.map((e) => Progress.fromMap(e)).toList();
  }

  Future<int> updateProgress(Progress progress) async {
    final db = await database;
    return await db.update(
      'progress',
      progress.toMap(),
      where: 'id = ?',
      whereArgs: [progress.id],
    );
  }

  Future<int> deleteProgress(int id) async {
    final db = await database;
    return await db.delete(
      'progress',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
