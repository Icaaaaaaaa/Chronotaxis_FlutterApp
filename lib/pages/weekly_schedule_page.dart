import 'package:flutter/material.dart';
import '../models/weekly_schedule.dart';
import '../services/database_service.dart';

class WeeklySchedulePage extends StatefulWidget {
  const WeeklySchedulePage({Key? key}) : super(key: key);

  @override
  State<WeeklySchedulePage> createState() => _WeeklySchedulePageState();
}

class _WeeklySchedulePageState extends State<WeeklySchedulePage> {
  final DatabaseService _dbService = DatabaseService();
  final List<String> days = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal Mingguan'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: _buildScheduleList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSchedule,
        tooltip: 'Tambah Jadwal',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildScheduleList() {
    return FutureBuilder(
      future: _dbService.getWeeklySchedules(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.schedule,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Belum ada jadwal',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tekan tombol + untuk menambah jadwal',
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ],
            ),
          );
        }

        final schedules = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: schedules.length,
          itemBuilder: (context, index) {
            final schedule = schedules[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                title: Text(schedule.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text('${schedule.dayOfWeek}'),
                    Text(
                      '${schedule.startTime} - ${schedule.endTime}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editSchedule(schedule),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteSchedule(schedule.id!),
                    ),
                  ],
                ),
                onTap: () => _showScheduleDetails(schedule),
              ),
            );
          },
        );
      },
    );
  }

  void _addSchedule() {
    _showScheduleDialog();
  }

  void _editSchedule(WeeklySchedule schedule) {
    _showScheduleDialog(schedule: schedule);
  }

  void _deleteSchedule(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Jadwal'),
        content: const Text('Apakah Anda yakin ingin menghapus jadwal ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              await _dbService.deleteWeeklySchedule(id);
              Navigator.pop(context);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Jadwal dihapus')),
              );
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showScheduleDialog({WeeklySchedule? schedule}) {
    final titleController = TextEditingController(text: schedule?.title ?? '');
    final startTimeController =
        TextEditingController(text: schedule?.startTime ?? '');
    final endTimeController =
        TextEditingController(text: schedule?.endTime ?? '');
    final descriptionController =
        TextEditingController(text: schedule?.description ?? '');
    String selectedDay = schedule?.dayOfWeek ?? 'Senin';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(schedule == null ? 'Tambah Jadwal' : 'Edit Jadwal'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedDay,
                items: days.map((day) {
                  return DropdownMenuItem(value: day, child: Text(day));
                }).toList(),
                onChanged: (value) {
                  selectedDay = value ?? 'Senin';
                },
                decoration: const InputDecoration(
                  labelText: 'Hari',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: startTimeController,
                decoration: const InputDecoration(
                  labelText: 'Waktu Mulai (HH:mm)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: endTimeController,
                decoration: const InputDecoration(
                  labelText: 'Waktu Selesai (HH:mm)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              if (titleController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Judul tidak boleh kosong')),
                );
                return;
              }

              final newSchedule = WeeklySchedule(
                id: schedule?.id,
                title: titleController.text,
                dayOfWeek: selectedDay,
                startTime: startTimeController.text,
                endTime: endTimeController.text,
                description: descriptionController.text,
                isActive: schedule?.isActive ?? true,
              );

              if (schedule == null) {
                await _dbService.insertWeeklySchedule(newSchedule);
              } else {
                await _dbService.updateWeeklySchedule(newSchedule);
              }

              Navigator.pop(context);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(schedule == null ? 'Jadwal ditambah' : 'Jadwal diperbarui'),
                ),
              );
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showScheduleDetails(WeeklySchedule schedule) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              schedule.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text('Hari: ${schedule.dayOfWeek}'),
            Text('Waktu: ${schedule.startTime} - ${schedule.endTime}'),
            const SizedBox(height: 12),
            Text(
              'Deskripsi:',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Text(schedule.description),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _editSchedule(schedule);
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _deleteSchedule(schedule.id!);
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Hapus'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
