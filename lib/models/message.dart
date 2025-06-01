class Message {
  final String content;
  final String role;
  final DateTime timestamp;
  final String userId;

  Message({
    required this.content,
    required this.role,
    required this.timestamp,
    required this.userId,
  });

  Map<String, dynamic> toJson() => {
    'content': content,
    'role': role,
    'timestamp': timestamp.toIso8601String(),
    'userId': userId,
  };

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    content: json['content'] as String,
    role: json['role'] as String,
    timestamp: DateTime.parse(json['timestamp'] as String),
    userId: json['userId'] as String,
  );
}