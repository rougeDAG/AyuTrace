import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/usecases/send_message_usecase.dart';
import '../../domain/usecases/get_chat_history_usecase.dart';
import '../../domain/repositories/chat_repository.dart';

// States
abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<ChatMessage> messages;
  final bool isSending;

  const ChatLoaded({required this.messages, this.isSending = false});

  ChatLoaded copyWith({List<ChatMessage>? messages, bool? isSending}) {
    return ChatLoaded(
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
    );
  }

  @override
  List<Object?> get props => [messages, isSending];
}

class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class ChatCubit extends Cubit<ChatState> {
  final SendMessageUseCase _sendMessageUseCase;
  final GetChatHistoryUseCase _getChatHistoryUseCase;
  final ChatRepository _chatRepository;
  final String productId;
  final String productContext;
  final _uuid = const Uuid();

  ChatCubit({
    required SendMessageUseCase sendMessageUseCase,
    required GetChatHistoryUseCase getChatHistoryUseCase,
    required ChatRepository chatRepository,
    required this.productId,
    required this.productContext,
  }) : _sendMessageUseCase = sendMessageUseCase,
       _getChatHistoryUseCase = getChatHistoryUseCase,
       _chatRepository = chatRepository,
       super(ChatLoading());

  Future<void> loadHistory() async {
    try {
      final messages = await _getChatHistoryUseCase(productId);
      emit(ChatLoaded(messages: messages));
    } catch (e) {
      emit(ChatLoaded(messages: []));
    }
  }

  Future<void> sendMessage(String text) async {
    final currentState = state;
    if (currentState is! ChatLoaded) return;

    final userMessage = ChatMessage(
      id: _uuid.v4(),
      content: text,
      role: 'user',
      timestamp: DateTime.now(),
      productId: productId,
    );

    final updatedMessages = [...currentState.messages, userMessage];
    emit(ChatLoaded(messages: updatedMessages, isSending: true));

    // Save user message
    await _chatRepository.saveChatMessage(userMessage);

    try {
      final response = await _sendMessageUseCase(
        productContext: productContext,
        userMessage: text,
      );

      final assistantMessage = ChatMessage(
        id: _uuid.v4(),
        content: response,
        role: 'assistant',
        timestamp: DateTime.now(),
        productId: productId,
      );

      // Save assistant message
      await _chatRepository.saveChatMessage(assistantMessage);

      emit(
        ChatLoaded(
          messages: [...updatedMessages, assistantMessage],
          isSending: false,
        ),
      );
    } catch (e) {
      emit(ChatLoaded(messages: updatedMessages, isSending: false));
    }
  }
}
