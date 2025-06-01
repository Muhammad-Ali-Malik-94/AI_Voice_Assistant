import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_session.dart';
import '../models/message.dart';

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get user's chats
  Stream<List<ChatSession>> getUserChats(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('chats')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ChatSession.fromJson({
      ...doc.data(),
      'id': doc.id,
    }))
        .toList());
  }

  // Create new chat
  Future<String> createChat(String userId, ChatSession chat) async {
    final docRef = await _firestore
        .collection('users')
        .doc(userId)
        .collection('chats')
        .add(chat.toJson());
    return docRef.id;
  }

  // Add message to chat
  Future<void> addMessage(
      String userId,
      String chatId,
      Message message,
      ) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(message.toJson());

    // Update chat's last message
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('chats')
        .doc(chatId)
        .update({
      'lastMessage': message.toJson(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Get chat messages
  Stream<List<Message>> getChatMessages(String userId, String chatId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Message.fromJson(doc.data()))
        .toList());
  }

  // Delete chat
  Future<void> deleteChat(String userId, String chatId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('chats')
        .doc(chatId)
        .delete();
  }
}