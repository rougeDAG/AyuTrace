import '../repositories/chat_repository.dart';

class SendMessageUseCase {
  final ChatRepository _repository;

  SendMessageUseCase(this._repository);

  Future<String> call({
    required String productContext,
    required String userMessage,
  }) {
    return _repository.sendMessage(
      productContext: productContext,
      userMessage: userMessage,
    );
  }
}
