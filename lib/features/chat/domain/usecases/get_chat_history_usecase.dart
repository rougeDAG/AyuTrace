import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

class GetChatHistoryUseCase {
  final ChatRepository _repository;

  GetChatHistoryUseCase(this._repository);

  Future<List<ChatMessage>> call(String productId) {
    return _repository.getChatHistory(productId);
  }
}
