import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../services/preferences_service.dart';
import '../models/weekly_schedule.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService _dbService = DatabaseService();
  final PreferencesService _prefService = PreferencesService();
  
  final List<String> _days = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  late String _selectedDay;

  @override
  void initState() {
    super.initState();
    // Set selected day to current day when app opens
    _selectedDay = _getCurrentDay();
  }

  String _getCurrentDay() {
    final now = DateTime.now();
    final dayOfWeek = now.weekday; // 1 = Senin, 7 = Minggu
    return _days[dayOfWeek - 1];
  }

  List<WeeklySchedule> _sortSchedulesByTime(List<WeeklySchedule> schedules) {
    schedules.sort((a, b) {
      return a.startTime.compareTo(b.startTime);
    });
    return schedules;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            _buildWelcomeSection(),
            const SizedBox(height: 24),

            // Quick Stats
            _buildStatsSection(),
            const SizedBox(height: 24),

            // Day Filter
            const Text(
              'Filter Jadwal Harian',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildDayFilter(),
            const SizedBox(height: 24),

            // Scheduled Activities for Selected Day
            Text(
              'Jadwal - $_selectedDay',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildScheduleList(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    final userName = _prefService.loadUserName() ?? 'User';
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selamat datang, $userName!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Kelola jadwal dan aktivitas Anda dengan efisien',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return FutureBuilder(
      future: Future.wait([
        _dbService.getWeeklySchedules(),
        _dbService.getRooms(),
      ]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final schedules = snapshot.data?[0] as List?;
        final rooms = snapshot.data?[1] as List?;

        return GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildStatCard(
              'Jadwal Mingguan',
              (schedules?.length ?? 0).toString(),
              Icons.calendar_today,
            ),
            _buildStatCard(
              'Ruangan',
              (rooms?.length ?? 0).toString(),
              Icons.room_preferences,
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(String title, String count, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              count,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayFilter() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _days.length,
        itemBuilder: (context, index) {
          final day = _days[index];
          final isSelected = _selectedDay == day;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text(day),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedDay = day;
                });
              },
              backgroundColor: Colors.grey[200],
              selectedColor: Theme.of(context).colorScheme.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildScheduleList() {
    return FutureBuilder<List<WeeklySchedule>>(
      future: _dbService.getWeeklySchedulesByDay(_selectedDay),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                'Tidak ada jadwal untuk hari ini',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        // Sort schedules by time
        final sortedSchedules = _sortSchedulesByTime(snapshot.data!);

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sortedSchedules.length,
          itemBuilder: (context, index) {
            final schedule = sortedSchedules[index];
            final isActive = schedule.isActive == 1;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Container(
                  width: 8,
                  decoration: BoxDecoration(
                    color: isActive ? Colors.green : Colors.grey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                title: Text(
                  schedule.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    decoration: isActive
                        ? TextDecoration.none
                        : TextDecoration.lineThrough,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      '${schedule.startTime} - ${schedule.endTime}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    if (schedule.description.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          schedule.description,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                  ],
                ),
                trailing: Chip(
                  label: Text(isActive ? 'Aktif' : 'Nonaktif'),
                  backgroundColor:
                      isActive ? Colors.green[100] : Colors.grey[300],
                  labelStyle: TextStyle(
                    color: isActive ? Colors.green[900] : Colors.grey[900],
                    fontSize: 12,
                  ),
                ),
                onTap: () {
                  _showScheduleDetail(context, schedule);
                },
              ),
            );
          },
        );
      },
    );
  }

  void _showScheduleDetail(
      BuildContext context, WeeklySchedule schedule) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                schedule.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildDetailRow('Hari', schedule.dayOfWeek),
              _buildDetailRow('Jam Mulai', schedule.startTime),
              _buildDetailRow('Jam Selesai', schedule.endTime),
              _buildDetailRow(
                'Status',
                schedule.isActive == 1 ? 'Aktif' : 'Nonaktif',
              ),
              if (schedule.description.isNotEmpty)
                _buildDetailRow('Deskripsi', schedule.description),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Tutup'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
