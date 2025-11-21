import 'package:flutter/material.dart';
import '../models/activity.dart';
import '../models/room.dart';
import '../services/database_service.dart';

class ActivityManagementPage extends StatefulWidget {
  const ActivityManagementPage({super.key});

  @override
  State<ActivityManagementPage> createState() => _ActivityManagementPageState();
}

class _ActivityManagementPageState extends State<ActivityManagementPage> {
  final DatabaseService _dbService = DatabaseService();
  int? _selectedRoomId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Aktivitas'),
      ),
      body: Column(
        children: [
          // Room Filter
          FutureBuilder(
            future: _dbService.getRooms(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox.shrink();
              }

              final rooms = snapshot.data as List<Room>;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChip(
                        label: const Text('Semua'),
                        selected: _selectedRoomId == null,
                        onSelected: (selected) {
                          setState(() {
                            _selectedRoomId = null;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      ...rooms.map((room) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: FilterChip(
                            label: Text(room.name),
                            selected: _selectedRoomId == room.id,
                            onSelected: (selected) {
                              setState(() {
                                _selectedRoomId = selected ? room.id : null;
                              });
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              );
            },
          ),
          // Activities List
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: _buildActivitiesList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addActivity,
        tooltip: 'Tambah Aktivitas',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildActivitiesList() {
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
                  Icons.task,
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

        var activities = snapshot.data!;
        if (_selectedRoomId != null) {
          activities =
              activities.where((a) => a.roomId == _selectedRoomId).toList();
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: activities.length,
          itemBuilder: (context, index) {
            final activity = activities[index];
            return _buildActivityCard(activity);
          },
        );
      },
    );
  }

  Widget _buildActivityCard(Activity activity) {
    return FutureBuilder(
      future: _dbService.getRoomById(activity.roomId),
      builder: (context, snapshot) {
        final room = snapshot.data;
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: const Icon(Icons.task_alt),
            title: Text(activity.title),
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
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: const Text('Edit'),
                  onTap: () => _editActivity(activity),
                ),
                PopupMenuItem(
                  child: const Text('Hapus'),
                  onTap: () => _deleteActivity(activity.id!),
                ),
              ],
            ),
            onTap: () => _showActivityDetails(activity, room),
          ),
        );
      },
    );
  }

  void _addActivity() {
    _showActivityDialog();
  }

  void _editActivity(Activity activity) {
    _showActivityDialog(activity: activity);
  }

  void _deleteActivity(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Aktivitas'),
        content: const Text('Apakah Anda yakin ingin menghapus aktivitas ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              await _dbService.deleteActivity(id);
              Navigator.pop(context);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Aktivitas dihapus')),
              );
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showActivityDialog({Activity? activity}) {
    final titleController = TextEditingController(text: activity?.title ?? '');
    final timeController = TextEditingController(text: activity?.time ?? '');
    final noteController = TextEditingController(text: activity?.note ?? '');
    int? selectedRoomId = activity?.roomId;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(activity == null ? 'Tambah Aktivitas' : 'Edit Aktivitas'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FutureBuilder(
                future: _dbService.getRooms(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Text('Loading ruangan...');
                  }

                  final rooms = snapshot.data as List<Room>;
                  return DropdownButtonFormField<int>(
                    value: selectedRoomId,
                    hint: const Text('Pilih Ruangan'),
                    items: rooms.map((room) {
                      return DropdownMenuItem(
                        value: room.id,
                        child: Text(room.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      selectedRoomId = value;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Ruangan',
                      border: OutlineInputBorder(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul Aktivitas',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: timeController,
                decoration: const InputDecoration(
                  labelText: 'Waktu',
                  border: OutlineInputBorder(),
                  hintText: 'HH:mm',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: noteController,
                decoration: const InputDecoration(
                  labelText: 'Catatan',
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
              if (titleController.text.isEmpty ||
                  selectedRoomId == null ||
                  timeController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Isi semua field yang diperlukan')),
                );
                return;
              }

              final newActivity = Activity(
                id: activity?.id,
                roomId: selectedRoomId!,
                title: titleController.text,
                time: timeController.text,
                note: noteController.text,
              );

              if (activity == null) {
                await _dbService.insertActivity(newActivity);
              } else {
                await _dbService.updateActivity(newActivity);
              }

              Navigator.pop(context);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    activity == null ? 'Aktivitas ditambah' : 'Aktivitas diperbarui',
                  ),
                ),
              );
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showActivityDetails(Activity activity, Room? room) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              activity.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text('Ruangan: ${room?.name ?? "Tidak Diketahui"}'),
            Text('Waktu: ${activity.time}'),
            if (activity.note.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Catatan:',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Text(activity.note),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _editActivity(activity);
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _deleteActivity(activity.id!);
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
