class WeeklySchedule {
  final int? id;
  final String title;
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final String description;
  final bool isActive;

  WeeklySchedule({
    this.id,
    required this.title,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.description,
    required this.isActive,
  });

  // Convert to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'day_of_week': dayOfWeek,
      'start_time': startTime,
      'end_time': endTime,
      'description': description,
      'is_active': isActive ? 1 : 0,
    };
  }

  // Create from Map
  factory WeeklySchedule.fromMap(Map<String, dynamic> map) {
    return WeeklySchedule(
      id: map['id'] as int?,
      title: map['title'] as String,
      dayOfWeek: map['day_of_week'] as String,
      startTime: map['start_time'] as String,
      endTime: map['end_time'] as String,
      description: map['description'] as String,
      isActive: (map['is_active'] as int?) == 1,
    );
  }

  WeeklySchedule copyWith({
    int? id,
    String? title,
    String? dayOfWeek,
    String? startTime,
    String? endTime,
    String? description,
    bool? isActive,
  }) {
    return WeeklySchedule(
      id: id ?? this.id,
      title: title ?? this.title,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
    );
  }
}
