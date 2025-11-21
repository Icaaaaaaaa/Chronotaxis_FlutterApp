import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/activity.dart';
import '../models/room.dart';
import '../models/progress.dart';
import '../services/database_service.dart';

class ProgressTrackerPage extends StatefulWidget {
  const ProgressTrackerPage({super.key});

  @override
  State<ProgressTrackerPage> createState() => _ProgressTrackerPageState();
}

class _ProgressTrackerPageState extends State<ProgressTrackerPage> {
  final DatabaseService _dbService = DatabaseService();
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: () {
              setState(() {
                _selectedDate = DateTime.now();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Date Picker
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: _selectDate,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('dd MMMM yyyy', 'id').format(_selectedDate),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Activities List
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: _buildProgressList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _markActivityComplete,
        tooltip: 'Tandai Selesai',
        child: const Icon(Icons.check),
      ),
    );
  }

  Widget _buildProgressList() {
    return FutureBuilder(
      future: _dbService.getActivities(),
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
                  Icons.task_alt,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Belum ada aktivitas',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        final activities = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: activities.length,
          itemBuilder: (context, index) {
            final activity = activities[index];
            return _buildActivityProgressCard(activity);
          },
        );
      },
    );
  }

  Widget _buildActivityProgressCard(Activity activity) {
    final dateString = DateFormat('yyyy-MM-dd').format(_selectedDate);

    return FutureBuilder(
      future: Future.wait([
        _dbService.getRoomById(activity.roomId),
        _dbService.getProgressByActivity(activity.id!),
      ]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final room = snapshot.data?[0] as Room?;
        final progressList = snapshot.data?[1] as List<Progress>?;
        
        final todayProgress = progressList?.firstWhere(
          (p) => p.date == dateString,
          orElse: () => Progress(
            activityId: activity.id!,
            date: dateString,
            status: false,
          ),
        );

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: Checkbox(
              value: todayProgress?.status ?? false,
              onChanged: (value) async {
                await _toggleActivityProgress(
                  activity,
                  value ?? false,
                );
              },
            ),
            title: Text(
              activity.title,
              style: TextStyle(
                decoration: (todayProgress?.status ?? false)
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(room?.name ?? 'Ruangan Tidak Diketahui'),
                Text(
                  'Waktu: ${activity.time}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            trailing: Icon(
              todayProgress?.status ?? false
                  ? Icons.check_circle
                  : Icons.circle_outlined,
              color: (todayProgress?.status ?? false)
                  ? Colors.green
                  : Colors.grey,
            ),
          ),
        );
      },
    );
  }

  Future<void> _toggleActivityProgress(Activity activity, bool isCompleted) async {
    final dateString = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final progressList = await _dbService.getProgressByActivity(activity.id!);
    
    final existingProgress = progressList.firstWhere(
      (p) => p.date == dateString,
      orElse: () => Progress(
        activityId: activity.id!,
        date: dateString,
        status: false,
      ),
    );

    if (existingProgress.id == null) {
      // Create new progress
      await _dbService.insertProgress(
        Progress(
          activityId: activity.id!,
          date: dateString,
          status: isCompleted,
        ),
      );
    } else {
      // Update existing progress
      await _dbService.updateProgress(
        existingProgress.copyWith(status: isCompleted),
      );
    }

    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isCompleted ? 'Aktivitas ditandai selesai' : 'Aktivitas ditandai belum selesai',
        ),
      ),
    );
  }

  void _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2099),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _markActivityComplete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tandai Aktivitas Selesai'),
        content: const Text('Pilih aktivitas yang ingin ditandai selesai'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
        ],
      ),
    );
  }
}
