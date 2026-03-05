import '../entities/chat_message.dart';

abstract class ChatRepository {
  Future<String> sendMessage({
    required String productContext,
    required String userMessage,
  });
  Future<List<ChatMessage>> getChatHistory(String productId);
  Future<void> saveChatMessage(ChatMessage message);
}
