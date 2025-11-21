class Activity {
  final int? id;
  final int roomId;
  final String title;
  final String time;
  final String note;

  Activity({
    this.id,
    required this.roomId,
    required this.title,
    required this.time,
    required this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'room_id': roomId,
      'title': title,
      'time': time,
      'note': note,
    };
  }

  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      id: map['id'] as int?,
      roomId: map['room_id'] as int,
      title: map['title'] as String,
      time: map['time'] as String,
      note: map['note'] as String,
    );
  }

  Activity copyWith({
    int? id,
    int? roomId,
    String? title,
    String? time,
    String? note,
  }) {
    return Activity(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      title: title ?? this.title,
      time: time ?? this.time,
      note: note ?? this.note,
    );
  }
}
