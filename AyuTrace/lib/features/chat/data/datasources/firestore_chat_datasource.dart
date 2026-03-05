import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/chat_message.dart';

class FirestoreChatDatasource {
  final FirebaseFirestore _firestore;

  FirestoreChatDatasource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<ChatMessage>> getChatHistory({
    required String userId,
    required String productId,
  }) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('chats')
        .doc(productId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return ChatMessage(
        id: doc.id,
        content: data['content'] ?? '',
        role: data['role'] ?? 'user',
        timestamp:
            (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
        productId: productId,
      );
    }).toList();
  }

  Future<void> saveMessage({
    required String userId,
    required ChatMessage message,
  }) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('chats')
        .doc(message.productId)
        .collection('messages')
        .doc(message.id)
        .set({
          'content': message.content,
          'role': message.role,
          'timestamp': Timestamp.fromDate(message.timestamp),
          'productId': message.productId,
        });
  }
}
