class Invite {
  final int? id;
  final int roomId;
  final String email;

  Invite({
    this.id,
    required this.roomId,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'room_id': roomId,
      'email': email,
    };
  }

  factory Invite.fromMap(Map<String, dynamic> map) {
    return Invite(
      id: map['id'] as int?,
      roomId: map['room_id'] as int,
      email: map['email'] as String,
    );
  }

  Invite copyWith({
    int? id,
    int? roomId,
    String? email,
  }) {
    return Invite(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      email: email ?? this.email,
    );
  }
}
