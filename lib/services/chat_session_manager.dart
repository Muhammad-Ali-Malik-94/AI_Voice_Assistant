import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../repositories/chat_repository.dart';
import '../models/chat_session.dart';
import 'api_service.dart';

class ChatSessionManager extends ChangeNotifier {
  final ChatRepository _repository = ChatRepository();
  late ApiService _apiService;
  User? _currentUser;
  ChatSession? _currentSession;

  List<ChatSession> _sessions = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  ChatSession? get currentSession => _currentSession;
  List<ChatSession> get sessions => List.unmodifiable(_sessions);
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Update user and initialize services
  void updateUser(User? user) {
    _currentUser = user;
    if (user != null) {
      _apiService = ApiService(user.uid);
      _loadChats();
    } else {
      _sessions.clear();
      _currentSession = null;
      notifyListeners();
    }
  }

  // Load user's chats
  Future<void> _loadChats() async {
    if (_currentUser == null) return;

    _setLoading(true);
    try {
      _repository.getUserChats(_currentUser!.uid).listen(
            (chats) {
          _sessions = chats;
          if (_currentSession != null) {
            _currentSession = _sessions.firstWhere(
                  (s) => s.id == _currentSession!.id,
              orElse: () => _sessions.first,
            );
          }
          notifyListeners();
        },
        onError: (e) => _setError('Failed to load chats: $e'),
      );
    } finally {
      _setLoading(false);
    }
  }

  // Create new chat session
  Future<void> createNewSession(String name) async {
    if (_currentUser == null) return;

    _setLoading(true);
    try {
      final session = ChatSession(name: name);
      final chatId = await _repository.createChat(_currentUser!.uid, session);
      session.id = chatId;
      _currentSession = session;
      notifyListeners();
    } catch (e) {
      _setError('Failed to create chat: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Send message and get AI response
  Future<void> sendMessage(String text) async {
    if (_currentUser == null || _currentSession == null) return;

    _setLoading(true);
    try {
      // Add user message
      await _repository.addMessage(
        _currentUser!.uid,
        _currentSession!.id!,
        Message(text: text, isUser: true),
      );

      // Get AI response
      final response = await _apiService.getChatResponse(
        text,
        _currentSession!.toJson(),
      );

      // Add AI response
      await _repository.addMessage(
        _currentUser!.uid,
        _currentSession!.id!,
        Message(text: response, isUser: false),
      );
    } catch (e) {
      _setError('Failed to send message: $e');
      // Add error message to chat
      await _repository.addMessage(
        _currentUser!.uid,
        _currentSession!.id!,
        Message(
          text: 'Error: Failed to get response',
          isUser: false,
          isSystemMessage: true,
        ),
      );
    } finally {
      _setLoading(false);
    }
  }

  // Helper methods for state management
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _error = message;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}