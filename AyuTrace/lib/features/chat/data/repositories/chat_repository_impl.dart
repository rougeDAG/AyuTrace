import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/ai_model_datasource.dart';
import '../datasources/firestore_chat_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final AiModelDatasource _aiDatasource;
  final FirestoreChatDatasource _chatDatasource;
  final FirebaseAuth _auth;

  ChatRepositoryImpl({
    required AiModelDatasource aiDatasource,
    required FirestoreChatDatasource chatDatasource,
    FirebaseAuth? auth,
  }) : _aiDatasource = aiDatasource,
       _chatDatasource = chatDatasource,
       _auth = auth ?? FirebaseAuth.instance;

  @override
  Future<String> sendMessage({
    required String productContext,
    required String userMessage,
  }) {
    return _aiDatasource.generateResponse(
      systemPrompt: productContext,
      userMessage: userMessage,
    );
  }

  @override
  Future<List<ChatMessage>> getChatHistory(String productId) {
    final userId = _auth.currentUser?.uid ?? 'anonymous';
    return _chatDatasource.getChatHistory(userId: userId, productId: productId);
  }

  @override
  Future<void> saveChatMessage(ChatMessage message) {
    final userId = _auth.currentUser?.uid ?? 'anonymous';
    return _chatDatasource.saveMessage(userId: userId, message: message);
  }
}
