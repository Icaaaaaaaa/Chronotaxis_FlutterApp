class Progress {
  final int? id;
  final int activityId;
  final String date;
  final bool status;

  Progress({
    this.id,
    required this.activityId,
    required this.date,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'activity_id': activityId,
      'date': date,
      'status': status ? 1 : 0,
    };
  }

  factory Progress.fromMap(Map<String, dynamic> map) {
    return Progress(
      id: map['id'] as int?,
      activityId: map['activity_id'] as int,
      date: map['date'] as String,
      status: (map['status'] as int?) == 1,
    );
  }

  Progress copyWith({
    int? id,
    int? activityId,
    String? date,
    bool? status,
  }) {
    return Progress(
      id: id ?? this.id,
      activityId: activityId ?? this.activityId,
      date: date ?? this.date,
      status: status ?? this.status,
    );
  }
}
