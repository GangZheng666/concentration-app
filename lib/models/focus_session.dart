import 'dart:convert';

class FocusSession {
  final String id;
  final String userId;
  final DateTime startTime;
  final DateTime endTime;
  final int durationMinutes;
  final String? category;
  final bool completed;

  FocusSession({
    required this.id,
    required this.userId,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    this.category,
    this.completed = true,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime.toIso8601String(),
    'durationMinutes': durationMinutes,
    'category': category,
    'completed': completed,
  };

  factory FocusSession.fromJson(Map<String, dynamic> json) => FocusSession(
    id: json['id'],
    userId: json['userId'],
    startTime: DateTime.parse(json['startTime']),
    endTime: DateTime.parse(json['endTime']),
    durationMinutes: json['durationMinutes'],
    category: json['category'],
    completed: json['completed'] ?? true,
  );

  String toJsonString() => jsonEncode(toJson());

  factory FocusSession.fromJsonString(String jsonString) => 
      FocusSession.fromJson(jsonDecode(jsonString));
}
