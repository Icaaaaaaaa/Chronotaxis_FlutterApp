import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'database_service.dart';

class BackupService {
  static final BackupService _instance = BackupService._internal();

  factory BackupService() {
    return _instance;
  }

  BackupService._internal();

  // Export database to file
  Future<File?> exportDatabase() async {
    try {
      final db = await DatabaseService().database;
      final dbPath = db.path;
      final backupDir = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final backupPath = '${backupDir.path}/timemanager_backup_$timestamp.db';

      final backupFile = await File(dbPath).copy(backupPath);
      return backupFile;
    } catch (e) {
      print('Error exporting database: $e');
      return null;
    }
  }

  // Import database from file
  Future<bool> importDatabase(File backupFile) async {
    try {
      final db = await DatabaseService().database;
      await db.close();

      final dbPath = db.path;
      await backupFile.copy(dbPath);

      // Reopen database
      await DatabaseService().database;

      return true;
    } catch (e) {
      print('Error importing database: $e');
      return false;
    }
  }

  // Get backup files
  Future<List<FileSystemEntity>> getBackupFiles() async {
    try {
      final backupDir = await getApplicationDocumentsDirectory();
      final dir = Directory(backupDir.path);
      final files = dir.listSync();
      
      // Filter only backup files
      final backupFiles = files
          .where((file) =>
              file.path.contains('timemanager_backup_') &&
              file.path.endsWith('.db'))
          .toList();
      
      return backupFiles;
    } catch (e) {
      print('Error getting backup files: $e');
      return [];
    }
  }

  // Delete backup file
  Future<bool> deleteBackupFile(String filePath) async {
    try {
      final file = File(filePath);
      await file.delete();
      return true;
    } catch (e) {
      print('Error deleting backup file: $e');
      return false;
    }
  }
}
