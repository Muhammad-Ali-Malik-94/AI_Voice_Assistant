import 'package:uuid/uuid.dart';
import 'message.dart';

class ChatSession {
  String? id;
  final String name;
  final DateTime createdAt;
  final bool isShortMode;
  List<Message> messages;
  PersonaSettings? activePersona;

  ChatSession({
    this.id,
    required this.name,
    DateTime? createdAt,
    this.isShortMode = false,
    this.activePersona,
    List<Message>? messages,
  })  : createdAt = createdAt ?? DateTime.now(),
        messages = messages ?? [],
        id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'createdAt': createdAt.toIso8601String(),
    'isShortMode': isShortMode,
    'persona': activePersona?.toJson(),
    'messages': messages.map((m) => m.toJson()).toList(),
  };

  factory ChatSession.fromJson(Map<String, dynamic> json) => ChatSession(
    id: json['id'] as String?,
    name: json['name'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    isShortMode: json['isShortMode'] as bool? ?? false,
    activePersona: json['persona'] == null
        ? null
        : PersonaSettings.fromJson(json['persona'] as Map<String, dynamic>),
    messages: (json['messages'] as List?)
        ?.map((m) => Message.fromJson(m as Map<String, dynamic>))
        .toList() ??
        [],
  );
}

class PersonaSettings {
  final String name;
  final String description;
  final double temperatureLevel;
  final Map<String, dynamic>? additionalSettings;

  PersonaSettings({
    required this.name,
    required this.description,
    this.temperatureLevel = 1.0,
    this.additionalSettings,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'temperatureLevel': temperatureLevel,
    if (additionalSettings != null) 'settings': additionalSettings,
  };

  factory PersonaSettings.fromJson(Map<String, dynamic> json) => PersonaSettings(
    name: json['name'] as String,
    description: json['description'] as String,
    temperatureLevel: (json['temperatureLevel'] as num).toDouble(),
    additionalSettings: json['settings'] as Map<String, dynamic>?,
  );
}