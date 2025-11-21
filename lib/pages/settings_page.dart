import 'package:flutter/material.dart';
import '../services/preferences_service.dart';
import '../services/backup_service.dart';

class SettingsPage extends StatefulWidget {
  final ValueChanged<bool> onThemeChanged;

  const SettingsPage({
    super.key,
    required this.onThemeChanged,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final PreferencesService _prefService = PreferencesService();
  final BackupService _backupService = BackupService();

  late TextEditingController _userNameController;
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = _prefService.loadThemeMode();
    _userNameController = TextEditingController(
      text: _prefService.loadUserName() ?? '',
    );
  }

  @override
  void dispose() {
    _userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // User Profile Section
          _buildSectionTitle('Profil Pengguna'),
          const SizedBox(height: 12),
          _buildUserNameSection(),
          const SizedBox(height: 24),

          // Theme Section
          _buildSectionTitle('Tampilan'),
          const SizedBox(height: 12),
          _buildThemeToggleSection(),
          const SizedBox(height: 24),

          // Backup Section
          _buildSectionTitle('Backup & Restore'),
          const SizedBox(height: 12),
          _buildBackupSection(),
          const SizedBox(height: 24),

          // About Section
          _buildSectionTitle('Tentang Aplikasi'),
          const SizedBox(height: 12),
          _buildAboutSection(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildUserNameSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _userNameController,
              decoration: InputDecoration(
                labelText: 'Nama Pengguna',
                hintText: 'Masukkan nama Anda',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _saveUserName,
              icon: const Icon(Icons.save),
              label: const Text('Simpan Nama'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeToggleSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      _isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _isDarkMode ? 'Mode Gelap' : 'Mode Terang',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Switch(
                  value: _isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      _isDarkMode = value;
                    });
                    _prefService.saveThemeMode(value);
                    widget.onThemeChanged(value);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackupSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Backup dan restore data aplikasi Anda',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _backupDatabase,
                    icon: const Icon(Icons.backup),
                    label: const Text('Export'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _restoreDatabase,
                    icon: const Icon(Icons.restore),
                    label: const Text('Import'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _showBackupFiles,
              icon: const Icon(Icons.folder_open),
              label: const Text('Lihat File Backup'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TimeManagerApp',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Versi 1.0.0',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Aplikasi manajemen waktu yang membantu Anda mengelola jadwal harian dengan efisien.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  void _saveUserName() {
    if (_userNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama tidak boleh kosong')),
      );
      return;
    }

    _prefService.saveUserName(_userNameController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Nama pengguna tersimpan')),
    );
  }

  void _backupDatabase() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    final backupFile = await _backupService.exportDatabase();
    Navigator.pop(context);

    if (backupFile != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Backup tersimpan: ${backupFile.path}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal membuat backup')),
      );
    }
  }

  void _restoreDatabase() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fitur restore akan diimplementasikan dengan file picker'),
      ),
    );
  }

  void _showBackupFiles() async {
    final backupFiles = await _backupService.getBackupFiles();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('File Backup'),
        content: backupFiles.isEmpty
            ? const Text('Tidak ada file backup')
            : SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  itemCount: backupFiles.length,
                  itemBuilder: (context, index) {
                    final file = backupFiles[index];
                    final fileName = file.path.split('/').last;
                    return ListTile(
                      title: Text(fileName),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await _backupService.deleteBackupFile(file.path);
                          Navigator.pop(context);
                          _showBackupFiles();
                        },
                      ),
                    );
                  },
                ),
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
